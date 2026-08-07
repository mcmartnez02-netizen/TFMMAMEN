import QtQuick
import QtQuick.Shapes

Rectangle {
    id: splash

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

            Image {
                id: fondo

                source: Qt.resolvedUrl("assets/fondo.png")
            }
            Text {
                id: instalacion

                x: 629
                y: 930

                height: 58
                width: 662

                color: "#696869"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "Instalación interactiva"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            Rectangle {
                id: corazonframe

                x: 836
                y: 344

                height: 247
                width: 247

                clip: true
                color: "transparent"

                Shape {
                    id: vectorillust

                    x: 19.76
                    y: 29.64

                    height: 177.84
                    width: 207.48

                    ShapePath {
                        id: vectorillust_ShapePath0

                        fillColor: "#e59aa8"
                        fillRule: ShapePath.WindingFill
                        joinStyle: ShapePath.MiterJoin
                        strokeColor: "#00000000"
                        strokeStyle: ShapePath.SolidLine
                        strokeWidth: 1.70

                        PathSvg {
                            id: vectorillust_ShapePath0_PathSvg0

                            path: "M 103.74000549316406 177.83999633789062 C 29.640001569475444 125.96999740600586 0 83.97999827067056 0 51.869998931884766 C 0 19.75999959309896 24.700001307896205 0 54.34000287737165 0 C 76.57000405447823 0 93.86000497000558 12.349999745686848 103.74000549316406 32.109999338785805 C 113.62000601632255 12.349999745686848 130.91000693184992 0 153.1400081089565 0 C 182.78000967843195 0 207.48001098632812 19.75999959309896 207.48001098632812 51.869998931884766 C 207.48001098632812 83.97999827067056 177.8400094168527 125.96999740600586 103.74000549316406 177.83999633789062 Z"
                        }
                    }
                }
            }
            Text {
                id: titulo_proyecti

                x: 629
                y: 872

                height: 58
                width: 662

                color: "#696869"
                font.family: "Inter"
                font.pixelSize: 32
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "TÍTULO PROYECTO"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            Text {
                id: pulsa_para_iniciar

                x: 629
                y: 623

                height: 58
                width: 662

                color: "#696869"
                font.family: "Inter"
                font.pixelSize: 32
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "PULSA PARA INICIAR"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
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

            Image {
                id: fondo_1

                source: Qt.resolvedUrl("assets/fondo_1.png")
            }
            Text {
                id: instalacion_1

                x: -66
                y: 918

                height: 58
                width: 662

                color: "#696869"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "Instalación interactiva"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            Rectangle {
                id: corazonframe_1

                x: 188
                y: 370

                height: 170
                width: 170

                clip: true
                color: "transparent"

                Shape {
                    id: vectorillust_1

                    x: 13.60
                    y: 20.40

                    height: 122.40
                    width: 142.80

                    ShapePath {
                        id: vectorillust_1_ShapePath0

                        fillColor: "#dd7c93"
                        fillRule: ShapePath.WindingFill
                        joinStyle: ShapePath.MiterJoin
                        strokeColor: "#00000000"
                        strokeStyle: ShapePath.SolidLine
                        strokeWidth: 1.70

                        PathSvg {
                            id: vectorillust_1_ShapePath0_PathSvg0

                            path: "M 71.4000015258789 122.4000015258789 C 20.400000435965403 86.7000010808309 0 57.800000720553925 0 35.70000044504801 C 0 13.6000001695421 17.0000003633045 0 37.400000799269904 0 C 52.700001126243954 0 64.6000013805571 8.500000105963812 71.4000015258789 22.100000275505913 C 78.20000167120071 8.500000105963812 90.10000192551385 0 105.40000225248791 0 C 125.8000026884533 0 142.8000030517578 13.6000001695421 142.8000030517578 35.70000044504801 C 142.8000030517578 57.800000720553925 122.4000026157924 86.7000010808309 71.4000015258789 122.4000015258789 Z"
                        }
                    }
                }
            }
            Text {
                id: titulo_proyecti_1

                x: -58
                y: 880

                height: 58
                width: 662

                color: "#696869"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "TÍTULO PROYECTO"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
            Text {
                id: pulsa_para_iniciar_1

                x: 51
                y: 583

                height: 58
                width: 445

                color: "#696869"
                font.family: "Inter"
                font.pixelSize: 24
                font.weight: Font.Normal
                horizontalAlignment: Text.AlignHCenter
                text: "PULSA PARA INICIAR"
                textFormat: Text.PlainText
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
            }
        }
    }
}