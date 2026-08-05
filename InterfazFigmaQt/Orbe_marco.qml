import QtQuick

Rectangle {
    id: orbe_marco

    height: 2029.35
    width: 1331.60

    clip: true
    color: "transparent"

    Rectangle {
        id: affectiveOrb

        x: 905

        height: 130
        width: 130

        color: "transparent"

        Rectangle {
            id: container_transform

            x: 9
            y: 9

            height: 112
            width: 112

            color: "transparent"

            Image {
                id: container

                x: -67.83
                y: -67.83

                source: Qt.resolvedUrl("assets/container_4.png")
            }
        }
        Image {
            id: container_1

            source: Qt.resolvedUrl("assets/container_5.png")
        }
    }
    Rectangle {
        id: presenceControl

        x: 99
        y: 171

        height: 72.35
        width: 1097.60

        color: "transparent"

        Rectangle {
            id: paragraph

            height: 20
            width: 1097.60

            color: "transparent"

            Text {
                id: sIMULACI_N_DE_PROXIMIDAD

                height: 20
                width: 190

                color: "#660d0e0f"
                font.family: "Manrope"
                font.letterSpacing: 0.52
                font.pixelSize: 13
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignLeft
                lineHeight: 19.50
                lineHeightMode: Text.FixedHeight
                text: "SIMULACIÓN DE PROXIMIDAD"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignTop
            }
        }
        Rectangle {
            id: container_2

            y: 28

            height: 44.35
            width: 1097.60

            border.color: "#170d0e0f"
            border.width: 0.80
            color: "#a8ffffff"
            radius: 26843500

            Rectangle {
                id: button

                x: 4.80
                y: 4.80

                height: 34.75
                width: 214.40

                color: "transparent"
                radius: 26843500

                Text {
                    id: sin_presencia

                    x: 68.70
                    y: 7.88

                    height: 19
                    width: 78

                    color: "#990d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 18.75
                    lineHeightMode: Text.FixedHeight
                    text: "Sin presencia"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_1

                x: 223.20
                y: 4.80

                height: 34.75
                width: 214.40

                color: "#e59aa8"
                radius: 26843500

                Text {
                    id: presencia_distante

                    x: 52.70
                    y: 7.88

                    height: 19
                    width: 110

                    color: "#ffffff"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 18.75
                    lineHeightMode: Text.FixedHeight
                    text: "Presencia distante"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_2

                x: 441.60
                y: 4.80

                height: 34.75
                width: 214.40

                color: "transparent"
                radius: 26843500

                Text {
                    id: acercamiento

                    x: 66.70
                    y: 7.88

                    height: 19
                    width: 82

                    color: "#990d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 18.75
                    lineHeightMode: Text.FixedHeight
                    text: "Acercamiento"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_3

                x: 660
                y: 4.80

                height: 34.75
                width: 214.40

                color: "transparent"
                radius: 26843500

                Text {
                    id: presencia_cercana

                    x: 54.20
                    y: 7.88

                    height: 19
                    width: 107

                    color: "#990d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 18.75
                    lineHeightMode: Text.FixedHeight
                    text: "Presencia cercana"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_4

                x: 878.40
                y: 4.80

                height: 34.75
                width: 214.40

                color: "transparent"
                radius: 26843500

                Text {
                    id: recuperaci_n

                    x: 67.20
                    y: 7.88

                    height: 19
                    width: 81

                    color: "#990d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 18.75
                    lineHeightMode: Text.FixedHeight
                    text: "Recuperación"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
    Rectangle {
        id: affectiveOrb_1

        x: 520
        y: 452

        height: 130
        width: 130

        color: "transparent"

        Rectangle {
            id: container_transform_1

            x: 4.50
            y: 4.50

            height: 121
            width: 121

            color: "transparent"

            Image {
                id: container_3

                x: -77.71
                y: -77.71

                source: Qt.resolvedUrl("assets/container_6.png")
            }
        }
        Image {
            id: container_4

            source: Qt.resolvedUrl("assets/container_7.png")
        }
    }
    Rectangle {
        id: dashboard_margin

        x: 78.80
        y: 784.20

        height: 92.35
        width: 1097.60

        color: "transparent"

        Rectangle {
            id: presenceControl_1

            y: 20

            height: 72.35
            width: 1097.60

            color: "transparent"

            Rectangle {
                id: paragraph_1

                height: 20
                width: 1097.60

                color: "transparent"

                Text {
                    id: sIMULACI_N_DE_PROXIMIDAD_1

                    height: 20
                    width: 190

                    color: "#660d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: 0.52
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 19.50
                    lineHeightMode: Text.FixedHeight
                    text: "SIMULACIÓN DE PROXIMIDAD"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: container_5

                y: 28

                height: 44.35
                width: 1097.60

                border.color: "#170d0e0f"
                border.width: 0.80
                color: "#a8ffffff"
                radius: 26843500

                Rectangle {
                    id: button_5

                    x: 4.80
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: sin_presencia_1

                        x: 68.70
                        y: 7.88

                        height: 19
                        width: 78

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Sin presencia"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_6

                    x: 223.20
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: presencia_distante_1

                        x: 53.70
                        y: 7.88

                        height: 19
                        width: 108

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Presencia distante"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_7

                    x: 441.60
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "#e59aa8"
                    radius: 26843500

                    Text {
                        id: acercamiento_1

                        x: 66.20
                        y: 7.88

                        height: 19
                        width: 83

                        color: "#ffffff"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Acercamiento"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_8

                    x: 660
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: presencia_cercana_1

                        x: 54.20
                        y: 7.88

                        height: 19
                        width: 107

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Presencia cercana"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_9

                    x: 878.40
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: recuperaci_n_1

                        x: 67.20
                        y: 7.88

                        height: 19
                        width: 81

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Recuperación"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
    }
    Rectangle {
        id: dashboard_margin_1

        y: 1249

        height: 92.35
        width: 1097.60

        color: "transparent"

        Rectangle {
            id: presenceControl_2

            y: 20

            height: 72.35
            width: 1097.60

            color: "transparent"

            Rectangle {
                id: paragraph_2

                height: 20
                width: 1097.60

                color: "transparent"

                Text {
                    id: sIMULACI_N_DE_PROXIMIDAD_2

                    height: 20
                    width: 190

                    color: "#660d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: 0.52
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 19.50
                    lineHeightMode: Text.FixedHeight
                    text: "SIMULACIÓN DE PROXIMIDAD"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: container_6

                y: 28

                height: 44.35
                width: 1097.60

                border.color: "#170d0e0f"
                border.width: 0.80
                color: "#a8ffffff"
                radius: 26843500

                Rectangle {
                    id: button_10

                    x: 4.80
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: sin_presencia_2

                        x: 68.70
                        y: 7.88

                        height: 19
                        width: 78

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Sin presencia"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_11

                    x: 223.20
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: presencia_distante_2

                        x: 53.70
                        y: 7.88

                        height: 19
                        width: 108

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Presencia distante"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_12

                    x: 441.60
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: acercamiento_2

                        x: 66.70
                        y: 7.88

                        height: 19
                        width: 82

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Acercamiento"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_13

                    x: 660
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "#e59aa8"
                    radius: 26843500

                    Text {
                        id: presencia_cercana_2

                        x: 53.70
                        y: 7.88

                        height: 19
                        width: 108

                        color: "#ffffff"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Presencia cercana"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_14

                    x: 878.40
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: recuperaci_n_2

                        x: 67.20
                        y: 7.88

                        height: 19
                        width: 81

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Recuperación"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
    }
    Rectangle {
        id: affectiveOrb_2

        x: 563
        y: 998

        height: 130
        width: 130

        color: "transparent"

        Rectangle {
            id: container_transform_2

            y: -3

            height: 136
            width: 130

            color: "transparent"

            Image {
                id: container_7

                x: -86.18
                y: -86.24

                source: Qt.resolvedUrl("assets/container_8.png")
            }
        }
        Image {
            id: container_8

            source: Qt.resolvedUrl("assets/container_9.png")
        }
    }
    Rectangle {
        id: dashboard_margin_2

        x: 234
        y: 1937

        height: 92.35
        width: 1097.60

        color: "transparent"

        Rectangle {
            id: presenceControl_3

            y: 20

            height: 72.35
            width: 1097.60

            color: "transparent"

            Rectangle {
                id: paragraph_3

                height: 20
                width: 1097.60

                color: "transparent"

                Text {
                    id: sIMULACI_N_DE_PROXIMIDAD_3

                    height: 20
                    width: 190

                    color: "#660d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: 0.52
                    font.pixelSize: 13
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignLeft
                    lineHeight: 19.50
                    lineHeightMode: Text.FixedHeight
                    text: "SIMULACIÓN DE PROXIMIDAD"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: container_9

                y: 28

                height: 44.35
                width: 1097.60

                border.color: "#170d0e0f"
                border.width: 0.80
                color: "#a8ffffff"
                radius: 26843500

                Rectangle {
                    id: button_15

                    x: 4.80
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: sin_presencia_3

                        x: 68.70
                        y: 7.88

                        height: 19
                        width: 78

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Sin presencia"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_16

                    x: 223.20
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: presencia_distante_3

                        x: 53.70
                        y: 7.88

                        height: 19
                        width: 108

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Presencia distante"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_17

                    x: 441.60
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: acercamiento_3

                        x: 66.70
                        y: 7.88

                        height: 19
                        width: 82

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Acercamiento"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_18

                    x: 660
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "transparent"
                    radius: 26843500

                    Text {
                        id: presencia_cercana_3

                        x: 54.20
                        y: 7.88

                        height: 19
                        width: 107

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Presencia cercana"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: button_19

                    x: 878.40
                    y: 4.80

                    height: 34.75
                    width: 214.40

                    color: "#e59aa8"
                    radius: 26843500

                    Text {
                        id: recuperaci_n_3

                        x: 66.70
                        y: 7.88

                        height: 19
                        width: 82

                        color: "#ffffff"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 18.75
                        lineHeightMode: Text.FixedHeight
                        text: "Recuperación"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
    }
    Rectangle {
        id: affectiveOrb_3

        x: 550
        y: 1544

        height: 130
        width: 130

        color: "transparent"

        Rectangle {
            id: container_transform_3

            x: 7.50
            y: 7.50

            height: 115
            width: 115

            color: "transparent"

            Image {
                id: container_10

                x: -63.89
                y: -63.89

                source: Qt.resolvedUrl("assets/container_10.png")
            }
        }
        Image {
            id: container_11

            source: Qt.resolvedUrl("assets/container_11.png")
        }
    }
}