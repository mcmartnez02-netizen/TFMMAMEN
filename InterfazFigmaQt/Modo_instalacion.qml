import QtQuick

Rectangle {
    id: modo_instalacion

    height: 1244
    width: 2657

    clip: true
    color: "#0cffffff"

    Rectangle {
        id: desktop

        x: 64
        y: 100

        height: 1080
        width: 1920

        clip: true
        color: "#f2f1f0"

        Rectangle {
            id: principal

            height: 1081
            width: 1920

            clip: true
            color: "#f2f1f0"

            Rectangle {
                id: contenido

                height: 1081
                width: 1920

                clip: true
                color: "transparent"

                Image {
                    id: graphsview

                    x: -24
                    y: -16

                    source: Qt.resolvedUrl("assets/graphsview.png")
                }
                Rectangle {
                    id: grupo_pulsaciones

                    x: 84
                    y: 179

                    height: 133
                    width: 1810

                    color: "transparent"

                    Rectangle {
                        id: gruponpulsac

                        x: 678
                        y: 29

                        height: 133
                        width: 484.30

                        color: "transparent"

                        Text {
                            id: element

                            height: 133
                            width: 247

                            color: "#000000"
                            font.family: "Poppins"
                            font.pixelSize: 200
                            font.weight: Font.Light
                            horizontalAlignment: Text.AlignLeft
                            text: "48"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            id: textolpm

                            x: 265
                            y: 43

                            height: 94
                            width: 220

                            color: "#696869"
                            font.family: "Manrope"
                            font.pixelSize: 70
                            font.weight: Font.Light
                            horizontalAlignment: Text.AlignLeft
                            text: "LPS"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                Rectangle {
                    id: grupo_bola

                    x: 55
                    y: 731

                    height: 191
                    width: 1810

                    color: "transparent"

                    Rectangle {
                        id: bolaestado

                        x: 752

                        height: 191
                        width: 306

                        color: "transparent"

                        Rectangle {
                            id: bola

                            x: 98

                            height: 110
                            width: 110

                            color: "transparent"

                            Rectangle {
                                id: container_transform

                                x: 10.50
                                y: 10.50

                                height: 89
                                width: 89

                                color: "transparent"

                                Image {
                                    id: container

                                    x: -61.40
                                    y: -61.40

                                    source: Qt.resolvedUrl("assets/container.png")
                                }
                            }
                            Image {
                                id: container_1

                                source: Qt.resolvedUrl("assets/container_1.png")
                            }
                        }
                        Text {
                            id: sereno

                            x: 107.50
                            y: 118

                            height: 42
                            width: 92

                            color: "#e59aa8"
                            font.family: "Manrope"
                            font.letterSpacing: -0.16
                            font.pixelSize: 28
                            font.weight: Font.Light
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 42
                            lineHeightMode: Text.FixedHeight
                            text: "Sereno"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignTop
                        }
                        Text {
                            id: ritmo_estable_Se_detecta_presencia_cercana_

                            y: 168

                            height: 23
                            width: 307

                            color: "#990d0e0f"
                            font.family: "Manrope"
                            font.letterSpacing: -0.16
                            font.pixelSize: 15
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 22.50
                            lineHeightMode: Text.FixedHeight
                            text: "Ritmo estable. Se detecta presencia cercana."
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignTop
                        }
                    }
                }
                Rectangle {
                    id: grupo_exit

                    x: 55
                    y: 65.99

                    height: 40.69
                    width: 1810

                    color: "transparent"

                    transform: Scale {
                        origin.x: grupo_exit.width / 2
                        origin.y: grupo_exit.height / 2
                        xScale: -1
                    }

                    Multiply {
                        id: multiply

                        x: -0.01

                        clip: true
                        opacity: 0.25
                    }
                }
            }
        }
    }
    Rectangle {
        id: mobile

        x: 2048
        y: 100

        height: 1080
        width: 545

        clip: true
        color: "#ffffff"

        Rectangle {
            id: principal_1

            height: 1080
            width: 545

            color: "#f2f1f0"

            Rectangle {
                id: contenido_1

                height: 1080
                width: 545

                clip: true
                color: "transparent"

                Image {
                    id: graphsview_1

                    y: 305

                    source: Qt.resolvedUrl("assets/graphsview_1.png")
                }
                Rectangle {
                    id: grupo_pulsaciones_1

                    x: 33
                    y: 171

                    height: 131
                    width: 488

                    color: "transparent"

                    Rectangle {
                        id: gruponpulsac_1

                        x: 152

                        height: 131
                        width: 225

                        color: "transparent"

                        Text {
                            id: element_1

                            height: 131
                            width: 327

                            color: "#000000"
                            font.family: "Manrope"
                            font.pixelSize: 96
                            font.weight: Font.Light
                            horizontalAlignment: Text.AlignLeft
                            text: "48"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                        Text {
                            id: textolpm_1

                            x: 120
                            y: 63

                            height: 39
                            width: 87

                            color: "#696869"
                            font.family: "Inter"
                            font.pixelSize: 32
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignLeft
                            text: "LPS"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                    }
                }
                Rectangle {
                    id: grupo_bola_1

                    x: 55
                    y: 751

                    height: 191
                    width: 466

                    color: "transparent"

                    Rectangle {
                        id: bolaestado_1

                        x: 80

                        height: 191
                        width: 306

                        color: "transparent"

                        Rectangle {
                            id: bola_1

                            x: 98

                            height: 110
                            width: 110

                            color: "transparent"

                            Rectangle {
                                id: container_transform_1

                                x: 10.50
                                y: 10.50

                                height: 89
                                width: 89

                                color: "transparent"

                                Image {
                                    id: container_2

                                    x: -61.40
                                    y: -61.40

                                    source: Qt.resolvedUrl("assets/container_2.png")
                                }
                            }
                            Image {
                                id: container_3

                                source: Qt.resolvedUrl("assets/container_3.png")
                            }
                        }
                        Text {
                            id: sereno_1

                            x: 107.50
                            y: 118

                            height: 42
                            width: 92

                            color: "#e59aa8"
                            font.family: "Manrope"
                            font.letterSpacing: -0.16
                            font.pixelSize: 28
                            font.weight: Font.Light
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 42
                            lineHeightMode: Text.FixedHeight
                            text: "Sereno"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignTop
                        }
                        Text {
                            id: ritmo_estable_Se_detecta_presencia_cercana_1

                            y: 168

                            height: 23
                            width: 307

                            color: "#990d0e0f"
                            font.family: "Manrope"
                            font.letterSpacing: -0.16
                            font.pixelSize: 15
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 22.50
                            lineHeightMode: Text.FixedHeight
                            text: "Ritmo estable. Se detecta presencia cercana."
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignTop
                        }
                    }
                }
                Rectangle {
                    id: grupo_exit_1

                    x: 33
                    y: 58

                    height: 40.68
                    width: 471

                    color: "transparent"

                    transform: Scale {
                        origin.x: grupo_exit_1.width / 2
                        origin.y: grupo_exit_1.height / 2
                        xScale: -1
                    }

                    Multiply {
                        id: multiply_1

                        clip: true
                        opacity: 0.25
                    }
                }
            }
        }
    }
}