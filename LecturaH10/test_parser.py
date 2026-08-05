"""Parser tests for the 0x2A37 payload layout. No hardware needed."""

import pytest

from h10_logger import parse_hr_measurement


def approx_rr(raw_units):
    return pytest.approx(raw_units * 1000.0 / 1024.0, abs=0.01)


def test_uint8_hr_no_rr():
    # flags 0x06: uint8 HR, contact supported + detected, no RRs
    bpm, contact, rr = parse_hr_measurement(bytes([0x06, 60]))
    assert (bpm, contact, rr) == (60, True, [])


def test_uint8_hr_with_two_rr():
    # flags 0x16: uint8 HR, contact, RRs present. 0x03C8 = 968, 0x03D0 = 976
    bpm, contact, rr = parse_hr_measurement(
        bytes([0x16, 60, 0xC8, 0x03, 0xD0, 0x03])
    )
    assert bpm == 60
    assert contact is True
    assert rr == [approx_rr(0x03C8), approx_rr(0x03D0)]


def test_uint16_hr_with_rr():
    # flags 0x11: uint16 HR (300 = 0x012C), RRs present
    bpm, contact, rr = parse_hr_measurement(
        bytes([0x11, 0x2C, 0x01, 0xC8, 0x03])
    )
    assert bpm == 300
    assert contact is None  # bit 2 clear: contact not supported
    assert rr == [approx_rr(0x03C8)]


def test_energy_expended_is_skipped_before_rr():
    # flags 0x1E: uint8 HR, contact, energy expended (0x0064) present, RRs.
    # The energy field must be skipped or the RR reads land on the wrong bytes.
    bpm, contact, rr = parse_hr_measurement(
        bytes([0x1E, 60, 0x64, 0x00, 0xC8, 0x03])
    )
    assert bpm == 60
    assert contact is True
    assert rr == [approx_rr(0x03C8)]


def test_uint16_hr_and_energy_expended_and_rr():
    # flags 0x1F: every optional field at once, the worst case for offsets.
    bpm, contact, rr = parse_hr_measurement(
        bytes([0x1F, 0x2C, 0x01, 0x64, 0x00, 0xC8, 0x03, 0xD0, 0x03])
    )
    assert bpm == 300
    assert contact is True
    assert rr == [approx_rr(0x03C8), approx_rr(0x03D0)]


def test_contact_supported_but_not_detected():
    # flags 0x04: contact supported, bit 1 clear -> not detected
    _bpm, contact, _rr = parse_hr_measurement(bytes([0x04, 0]))
    assert contact is False


def test_rr_flag_set_but_no_rr_bytes():
    # A real packet during contact loss: RR flag set, nothing to read.
    bpm, _contact, rr = parse_hr_measurement(bytes([0x16, 60]))
    assert (bpm, rr) == (60, [])


def test_rr_values_are_ordered_oldest_first():
    _bpm, _contact, rr = parse_hr_measurement(
        bytes([0x10, 60, 0x00, 0x04, 0x00, 0x02])
    )
    assert rr == [approx_rr(1024), approx_rr(512)]


def test_empty_payload_rejected():
    with pytest.raises(ValueError):
        parse_hr_measurement(b"")
