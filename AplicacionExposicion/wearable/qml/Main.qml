import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs

ApplicationWindow {
    id: window

    width: 880
    height: 520
    visible: true
    title: qsTr("Wearable Heart Rate Monitor")

    readonly property color surface: "#1a1a19"
    readonly property color textPrimary: "#ffffff"
    readonly property color textSecondary: "#c3c2b7"
    readonly property color gridColor: "#3a3a37"
    readonly property color trailColor: "#3987e5"
    readonly property color markerCalm: "#3987e5"
    readonly property color markerExcited: "#d95926"

    color: surface

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: controller.bpm > 0 ? controller.bpm : "--"
                color: window.textPrimary
                font.pointSize: 44
                font.bold: true
            }

            Text {
                text: qsTr("bpm")
                color: window.textSecondary
                font.pointSize: 12
                Layout.alignment: Qt.AlignBottom
                Layout.bottomMargin: 12
            }

            Text {
                text: controller.stateText
                color: window.textSecondary
                font.pointSize: 11
                Layout.leftMargin: 16
            }

            Item { Layout.fillWidth: true }

            Button {
                id: exciteButton
                objectName: "exciteButton"
                text: qsTr("Excitar")
                enabled: controller.exciteEnabled
                onClicked: controller.excite()

                contentItem: Text {
                    text: exciteButton.text
                    color: exciteButton.enabled ? window.textPrimary : "#6b6a65"
                    font.pointSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 96
                    implicitHeight: 38
                    radius: 6
                    color: !exciteButton.enabled
                           ? "#262523"
                           : (exciteButton.hovered ? "#414039" : "#33322f")
                    border.color: exciteButton.enabled ? "#4a4945" : "#33322f"
                    border.width: 1
                }
            }
        }

        // A single series names itself in the title; no legend needed.
        Text {
            Layout.fillWidth: true
            Layout.topMargin: 8
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Heart rate — last %1 seconds").arg(controller.windowSize)
            color: window.textSecondary
            font.pointSize: 10
        }

        GraphsView {
            id: chart

            Layout.fillWidth: true
            Layout.fillHeight: true
            antialiasing: true

            // The newest marker sits exactly on x=0; without this it is
            // clipped in half by the plot-area edge.
            clipPlotArea: false
            marginRight: 12

            theme: GraphsTheme {
                colorScheme: GraphsTheme.ColorScheme.Dark
                backgroundVisible: false
                plotAreaBackgroundVisible: false
                gridVisible: true
                axisXLabelFont.pointSize: 9
                axisYLabelFont.pointSize: 9
                labelTextColor: window.textSecondary

                grid.mainColor: window.gridColor
                grid.subColor: window.gridColor
                grid.mainWidth: 1

                axisX.mainColor: window.gridColor
                axisX.subColor: window.gridColor
                axisX.labelTextColor: window.textSecondary

                axisY.mainColor: window.gridColor
                axisY.subColor: window.gridColor
                axisY.labelTextColor: window.textSecondary
            }

            // QtGraphs formats labels from a double: %d is undefined here.
            axisX: ValueAxis {
                id: axisX
                min: -(controller.windowSize - 1)
                max: 0
                tickAnchor: 0
                tickInterval: 10
                subTickCount: 0
                subGridVisible: false
                labelFormat: "%.0fs"
            }

            axisY: ValueAxis {
                id: axisY
                min: controller.yMin
                max: controller.yMax
                tickAnchor: 0
                tickInterval: 10
                subTickCount: 0
                subGridVisible: false
                labelFormat: "%.0f"
            }

            LineSeries {
                id: trail
                width: 2
                color: window.trailColor
            }

            // Marks the newest reading; the trail alone would not single it out.
            // Only this point is tinted by state, so past resting samples are
            // never repainted as excited ones.
            ScatterSeries {
                id: latest
                pointDelegate: Component {
                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: controller.excited ? window.markerExcited
                                                  : window.markerCalm
                        border.color: window.surface
                        border.width: 2
                    }
                }
            }
        }
    }

    function redraw() {
        var pts = controller.points;
        trail.clear();
        latest.clear();
        for (var i = 0; i < pts.length; ++i)
            trail.append(pts[i].x, pts[i].y);
        if (pts.length > 0)
            latest.append(0, pts[0].y);
    }

    Connections {
        target: controller
        function onPointsChanged() { window.redraw() }
    }
}
