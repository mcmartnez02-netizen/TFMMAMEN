import QtQuick

Rectangle {
    id: salir_modo_instalacion

    height: 181.60
    width: 311.56

    clip: true
    color: "#faf7f6"

    Rectangle {
        id: titulosalir

        x: 28
        y: 28

        height: 30
        width: 255.56

        color: "transparent"

        Text {
            id: salir_del_modo_instalaci_n_

            x: -0.22

            height: 30
            width: 257

            color: "#0a0a0a"
            font.family: "Manrope"
            font.letterSpacing: -0.16
            font.pixelSize: 20
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 30
            lineHeightMode: Text.FixedHeight
            text: "¿Salir del modo instalación?"
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
    }
    Rectangle {
        id: explisalir

        x: 28
        y: 58

        height: 29
        width: 255.56

        color: "transparent"

        Text {
            id: se_volver_a_la_interfaz_de_control_

            x: 22.78
            y: 8

            height: 21
            width: 211

            color: "#990d0e0f"
            font.family: "Manrope"
            font.letterSpacing: -0.16
            font.pixelSize: 14
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 21
            lineHeightMode: Text.FixedHeight
            text: "Se volverá a la interfaz de control."
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignTop
        }
    }
    Rectangle {
        id: opciones

        x: 28
        y: 87

        height: 66.60
        width: 255.56

        color: "transparent"

        Rectangle {
            id: container

            y: 24

            height: 42.60
            width: 255.56

            color: "transparent"

            Rectangle {
                id: button

                x: 37.48

                height: 42.60
                width: 99.60

                border.color: "#170d0e0f"
                border.width: 0.80
                color: "transparent"
                radius: 26843500

                Text {
                    id: cancelar

                    x: 20.80
                    y: 10.80

                    height: 21
                    width: 59

                    color: "#0a0a0a"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 21
                    lineHeightMode: Text.FixedHeight
                    text: "Cancelar"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
            Rectangle {
                id: button_1

                x: 149.08

                height: 42.60
                width: 69

                color: "#e59aa8"
                radius: 26843500

                Text {
                    id: salir

                    x: 20
                    y: 10.80

                    height: 21
                    width: 30

                    color: "#ffffff"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 21
                    lineHeightMode: Text.FixedHeight
                    text: "Salir"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignTop
                }
            }
        }
    }
}