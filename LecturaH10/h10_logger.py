"""Log every heartbeat from a Polar H10 to a CSV file.

Subscribes to the standard BLE Heart Rate Measurement characteristic and
expands each notification's RR-intervals into one row per beat.
"""

import argparse
import asyncio
import csv
import struct
import sys
from datetime import datetime, timedelta

from bleak import BleakClient, BleakScanner

HR_MEASUREMENT_UUID = "00002a37-0000-1000-8000-00805f9b34fb"
DEFAULT_ADDRESS = "24:AC:AC:1C:55:F2"
NAME_PREFIX = "Polar H10"


def parse_hr_measurement(data):
    """Parse a 0x2A37 payload into (bpm, contact, rr_ms_list).

    The layout is variable and driven by the flags byte:
        bit 0  HR format: 0 = uint8, 1 = uint16 little-endian
        bit 1  sensor contact detected
        bit 2  sensor contact supported
        bit 3  energy expended field present (uint16 LE)
        bit 4  RR-intervals present

    `contact` is None when the sensor does not support contact detection.
    RR-intervals arrive in 1/1024 s units, oldest first.
    """
    if not data:
        raise ValueError("empty heart rate measurement payload")

    flags = data[0]
    offset = 1

    if flags & 0x01:
        (bpm,) = struct.unpack_from("<H", data, offset)
        offset += 2
    else:
        bpm = data[offset]
        offset += 1

    contact = bool(flags & 0x02) if flags & 0x04 else None

    # Must be skipped before reading RRs, or every interval below is garbage.
    if flags & 0x08:
        offset += 2

    rr_ms = []
    if flags & 0x10:
        while offset + 1 < len(data):
            (raw,) = struct.unpack_from("<H", data, offset)
            offset += 2
            rr_ms.append(raw * 1000.0 / 1024.0)

    return bpm, contact, rr_ms


class BeatWriter:
    """Turns notifications into beat rows, timestamped by cumulative RR sum."""

    def __init__(self, writer, handle):
        self._writer = writer
        self._handle = handle
        self._anchor = None
        self.elapsed_s = 0.0
        self._warned_contact = False
        self.beats = 0

    def handle_notification(self, _sender, data):
        bpm, contact, rr_ms = parse_hr_measurement(data)

        if contact is False and not self._warned_contact:
            self._warned_contact = True
            print(
                "\nWarning: no skin contact — moisten the strap electrodes.\n"
                "The H10 emits no RR-intervals until contact is made.",
                file=sys.stderr,
            )

        if self._anchor is None:
            self._anchor = datetime.now()

        for rr in rr_ms:
            # Beat spacing comes from the RR sum, not packet arrival: the beats
            # already happened, and several can share one packet. Absolute
            # timestamps drift slowly against the wall clock as a result, which
            # is expected — resyncing to arrival times would corrupt the
            # intervals themselves.
            self.elapsed_s += rr / 1000.0
            timestamp = self._anchor + timedelta(seconds=self.elapsed_s)
            self._writer.writerow(
                [
                    timestamp.isoformat(timespec="milliseconds"),
                    f"{self.elapsed_s:.3f}",
                    f"{rr:.1f}",
                    f"{60000.0 / rr:.2f}",
                ]
            )
            self.beats += 1

        self._handle.flush()

        rr_text = f"{rr_ms[-1]:6.1f} ms" if rr_ms else "     — "
        print(
            f"\r  BPM {bpm:3d}   RR {rr_text}   beats: {self.beats:5d}",
            end="",
            flush=True,
        )


async def resolve_address(address):
    """Return `address` if reachable, else scan for an H10 by name."""
    if await BleakScanner.find_device_by_address(address, timeout=10.0):
        return address

    print(f"{address} not found; scanning for '{NAME_PREFIX}'...")
    device = await BleakScanner.find_device_by_filter(
        lambda d, _adv: bool(d.name and d.name.startswith(NAME_PREFIX)),
        timeout=15.0,
    )
    if device is None:
        raise SystemExit(
            "No Polar H10 found. Check the strap is worn (it sleeps when idle) "
            "and that no phone or Polar app holds the connection."
        )
    print(f"Found {device.name} at {device.address}")
    return device.address


async def record(address, out_path, holder):
    address = await resolve_address(address)

    with open(out_path, "w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["timestamp", "elapsed_s", "rr_ms", "bpm_inst"])

        # Published before connecting so main() can report progress even if
        # Ctrl-C unwinds this coroutine before it returns.
        beat_writer = BeatWriter(writer, handle)
        holder["beat_writer"] = beat_writer

        print(f"Connecting to {address}...")
        async with BleakClient(address) as client:
            await client.start_notify(
                HR_MEASUREMENT_UUID, beat_writer.handle_notification
            )
            print(f"Connected. Recording to {out_path} (Ctrl-C to stop)\n")
            # Disconnecting stops notifications, so cancellation needs no
            # explicit stop_notify — awaiting one here would likely re-raise.
            await asyncio.Event().wait()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--address", default=DEFAULT_ADDRESS, help="BLE address of the H10"
    )
    parser.add_argument("--out", help="output CSV path")
    args = parser.parse_args()

    out_path = args.out or f"h10_{datetime.now():%Y%m%d_%H%M%S}.csv"
    holder = {}

    try:
        asyncio.run(record(args.address, out_path, holder))
    except KeyboardInterrupt:
        pass

    beat_writer = holder.get("beat_writer")
    if beat_writer and beat_writer.beats:
        print(
            f"\n\nWrote {beat_writer.beats} beats "
            f"({beat_writer.elapsed_s:.1f}s) to {out_path}"
        )
    else:
        print("\nNo beats recorded.")


if __name__ == "__main__":
    main()
