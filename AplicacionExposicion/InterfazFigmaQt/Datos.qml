import QtQuick
import QtQuick.Shapes

Rectangle {
    id: datos

    height: 1510
    width: 2657

    clip: true
    color: "#0cffffff"

    Rectangle {
        id: desktop

        x: 64
        y: 100

        height: 1346
        width: 1920

        clip: true
        color: "#f2f1f0"

        Rectangle {
            id: principal

            height: 1346
            width: 1920

            clip: true
            color: "#f2f1f0"

            Rectangle {
                id: barralta

                height: 120
                width: 1920

                border.color: "#d7d6d5"
                border.width: 1
                clip: true
                color: "transparent"

                Rectangle {
                    id: tituloy_menu

                    x: 53
                    y: 23

                    height: 74
                    width: 466

                    color: "transparent"

                    Item {
                        id: titulospagina

                        x: 154

                        height: 79
                        width: 328

                        Text {
                            id: infousuario

                            height: 55
                            width: 323

                            color: "#000000"
                            font.family: "Manrope"
                            font.pixelSize: 40
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            text: "Datos y sesiones"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                        Text {
                            id: lectura_emocional

                            y: 55

                            height: 24
                            width: 329

                            color: "#696869"
                            font.family: "Inter"
                            font.pixelSize: 20
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignLeft
                            text: "Sesiones registradas e importadas"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        id: menu

                        y: 12

                        height: 44
                        width: 44

                        color: "transparent"
                        radius: 16

                        Rectangle {
                            id: icon

                            height: 44
                            width: 44

                            clip: true
                            color: "transparent"

                            Shape {
                                id: _vector

                                x: 7.33
                                y: 22

                                height: 0
                                width: 29.33

                                ShapePath {
                                    id: _vector_ShapePath0

                                    fillColor: "#00000000"
                                    strokeColor: "#990d0e0f"
                                    strokeWidth: 1.60

                                    PathSvg {
                                        id: _vector_ShapePath0_PathSvg0

                                        path: "M 0 0 L 29.33333396911621 0"
                                    }
                                }
                            }
                            Shape {
                                id: _vector_1

                                x: 7.33
                                y: 11

                                height: 0
                                width: 29.33

                                ShapePath {
                                    id: _vector_1_ShapePath0

                                    fillColor: "#00000000"
                                    strokeColor: "#990d0e0f"
                                    strokeWidth: 1.60

                                    PathSvg {
                                        id: _vector_1_ShapePath0_PathSvg0

                                        path: "M 0 0 L 29.33333396911621 0"
                                    }
                                }
                            }
                            Shape {
                                id: _vector_2

                                x: 7.33
                                y: 33

                                height: 0
                                width: 29.33

                                ShapePath {
                                    id: _vector_2_ShapePath0

                                    fillColor: "#00000000"
                                    strokeColor: "#990d0e0f"
                                    strokeWidth: 1.60

                                    PathSvg {
                                        id: _vector_2_ShapePath0_PathSvg0

                                        path: "M 0 0 L 29.33333396911621 0"
                                    }
                                }
                            }
                        }
                    }
                }
                Item {
                    id: grupo_2

                    x: 1319
                    y: 36

                    height: 48
                    width: 548

                    Book_open {
                        id: book_open

                        x: 342
                        y: 8

                        clip: true
                    }
                    Arrow_resize_diagonal {
                        id: arrow_resize_diagonal

                        x: 508
                        y: 8

                        clip: true
                    }
                    Rectangle {
                        id: boton_sensor

                        height: 48
                        width: 205

                        border.color: "#d7d6d5"
                        border.width: 1
                        color: "#ffffff"
                        radius: 20

                        Rectangle {
                            id: frame_1

                            x: 18

                            height: 48
                            width: 187

                            color: "transparent"

                            Image {
                                id: punto_s_activo

                                x: 17
                                y: 3.50

                                source: Qt.resolvedUrl("assets/punto_s_activo_8.png")
                                visible: false
                            }
                            Text {
                                id: sensor_conectado

                                x: 6
                                y: 12

                                height: 24
                                width: 176

                                color: "#696869"
                                font.family: "Inter"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                                horizontalAlignment: Text.AlignLeft
                                text: "Sensor conectado"
                                textFormat: Text.PlainText
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Image {
                            id: punto_s_activo_1

                            x: 10
                            y: 19

                            source: Qt.resolvedUrl("assets/punto_s_activo_9.png")
                        }
                    }
                }
            }
            Rectangle {
                id: contenido

                y: 120

                height: 1229
                width: 1920

                clip: true
                color: "transparent"

                Image {
                    id: fondo

                    y: -53

                    source: Qt.resolvedUrl("assets/fondo_4.png")
                }
                Rectangle {
                    id: main_Content

                    x: -1

                    height: 1238
                    width: 1922

                    clip: true
                    color: "transparent"

                    Rectangle {
                        id: container

                        x: 24
                        y: 20

                        height: 1209
                        width: 1874

                        color: "transparent"

                        Rectangle {
                            id: container_1

                            height: 471
                            width: 1874

                            color: "transparent"

                            Rectangle {
                                id: container_2

                                height: 45.60
                                width: 1874

                                color: "transparent"

                                Rectangle {
                                    id: container_3

                                    y: 1.50

                                    height: 42.60
                                    width: 1776.40

                                    border.color: "#170d0e0f"
                                    border.width: 0.80
                                    color: "#a8ffffff"
                                    radius: 26843500

                                    Rectangle {
                                        id: icon_1

                                        x: 16.80
                                        y: 12.80

                                        height: 17
                                        width: 16.59

                                        clip: true
                                        color: "transparent"

                                        Shape {
                                            id: _vector_3

                                            x: 2.07
                                            y: 2.28

                                            height: 11.06
                                            width: 11.06

                                            ShapePath {
                                                id: _vector_3_ShapePath0

                                                fillColor: "#00000000"
                                                strokeColor: "#660d0e0f"
                                                strokeWidth: 1.38

                                                PathSvg {
                                                    id: _vector_3_ShapePath0_PathSvg0

                                                    path: "M 11.058333396911621 5.5291666984558105 C 11.058333396911621 8.582841296417627 8.582841296417627 11.058333396911621 5.5291666984558105 11.058333396911621 C 2.4754921004939945 11.058333396911621 0 8.582841296417627 0 5.5291666984558105 C 0 2.4754921004939945 2.4754921004939945 0 5.5291666984558105 0 C 8.582841296417627 0 11.058333396911621 2.4754921004939945 11.058333396911621 5.5291666984558105 Z"
                                                }
                                            }
                                        }
                                        Shape {
                                            id: _vector_4

                                            x: 11.54
                                            y: 11.75

                                            height: 2.97
                                            width: 2.97

                                            ShapePath {
                                                id: _vector_4_ShapePath0

                                                fillColor: "#00000000"
                                                strokeColor: "#660d0e0f"
                                                strokeWidth: 1.38

                                                PathSvg {
                                                    id: _vector_4_ShapePath0_PathSvg0

                                                    path: "M 2.971926689147949 2.971926689147949 L 0 0"
                                                }
                                            }
                                        }
                                    }
                                    Rectangle {
                                        id: text_Input

                                        x: 41.39
                                        y: 10.80

                                        height: 21
                                        width: 991.41

                                        clip: true
                                        color: "transparent"

                                        Text {
                                            id: buscar_por_archivo_o_fecha_

                                            y: 1

                                            height: 19
                                            width: 993

                                            color: "#800d0e0f"
                                            font.family: "Manrope"
                                            font.letterSpacing: -0.16
                                            font.pixelSize: 14
                                            font.weight: Font.Normal
                                            horizontalAlignment: Text.AlignLeft
                                            text: "Buscar por archivo o fecha…"
                                            textFormat: Text.PlainText
                                            verticalAlignment: Text.AlignTop
                                            wrapMode: Text.Wrap
                                        }
                                    }
                                }
                                Rectangle {
                                    id: container_4

                                    x: 1788.40

                                    height: 45.60
                                    width: 85.60

                                    border.color: "#170d0e0f"
                                    border.width: 0.80
                                    color: "#a8ffffff"
                                    radius: 26843500

                                    Rectangle {
                                        id: viewBtn

                                        x: 4.80
                                        y: 4.80

                                        height: 36
                                        width: 36

                                        color: "#e59aa8"
                                        radius: 26843500

                                        Rectangle {
                                            id: icon_2

                                            x: 9.50
                                            y: 9.50

                                            height: 17
                                            width: 17

                                            clip: true
                                            color: "transparent"

                                            Shape {
                                                id: _vector_5

                                                x: 8.50
                                                y: 2.13

                                                height: 12.75
                                                width: 0

                                                ShapePath {
                                                    id: _vector_5_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_5_ShapePath0_PathSvg0

                                                        path: "M 0 0 L 0 12.75"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_6

                                                x: 2.13
                                                y: 2.13

                                                height: 12.75
                                                width: 12.75

                                                ShapePath {
                                                    id: _vector_6_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_6_ShapePath0_PathSvg0

                                                        path: "M 1.4166666666666667 0 L 11.333333333333334 0 C 12.11573676764965 0 12.75 0.6342632323503494 12.75 1.4166666666666667 L 12.75 11.333333333333334 C 12.75 12.11573676764965 12.11573676764965 12.75 11.333333333333334 12.75 L 1.4166666666666667 12.75 C 0.6342632323503494 12.75 0 12.11573676764965 0 11.333333333333334 L 0 1.4166666666666667 C 0 0.6342632323503494 0.6342632323503494 0 1.4166666666666667 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_7

                                                x: 2.13
                                                y: 6.38

                                                height: 0
                                                width: 12.75

                                                ShapePath {
                                                    id: _vector_7_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_7_ShapePath0_PathSvg0

                                                        path: "M 0 0 L 12.75 0"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_8

                                                x: 2.13
                                                y: 10.63

                                                height: 0
                                                width: 12.75

                                                ShapePath {
                                                    id: _vector_8_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_8_ShapePath0_PathSvg0

                                                        path: "M 0 0 L 12.75 0"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Rectangle {
                                        id: viewBtn_1

                                        x: 44.80
                                        y: 4.80

                                        height: 36
                                        width: 36

                                        color: "transparent"
                                        radius: 26843500

                                        Rectangle {
                                            id: icon_3

                                            x: 9.50
                                            y: 9.50

                                            height: 17
                                            width: 17

                                            clip: true
                                            color: "transparent"

                                            Shape {
                                                id: _vector_9

                                                x: 2.13
                                                y: 2.13

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_9_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_9_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_10

                                                x: 9.92
                                                y: 2.13

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_10_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_10_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_11

                                                x: 9.92
                                                y: 9.92

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_11_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_11_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_12

                                                x: 2.13
                                                y: 9.92

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_12_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_12_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Image {
                                id: glassCard

                                x: -20
                                y: 43.60

                                clip: true
                                source: Qt.resolvedUrl("assets/glassCard.png")
                            }
                        }
                        Image {
                            id: detallessescontenido

                            x: -20
                            y: 473

                            clip: true
                            source: Qt.resolvedUrl("assets/detallessescontenido.png")
                        }
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
                id: barralta_1

                height: 120
                width: 545

                border.color: "#d7d6d5"
                border.width: 1
                clip: true
                color: "transparent"

                Rectangle {
                    id: tituloy_menu_1

                    x: 53
                    y: 23

                    height: 74
                    width: 246

                    color: "transparent"

                    Item {
                        id: titulospagina_1

                        y: 13

                        height: 76
                        width: 242

                        Text {
                            id: infousuario_1

                            height: 27
                            width: 229

                            color: "#000000"
                            font.family: "Manrope"
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            text: " Información del usuario"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                        Text {
                            id: lectura_emocional_1

                            x: 3
                            y: 31

                            height: 45
                            width: 240

                            color: "#696869"
                            font.family: "Inter"
                            font.pixelSize: 12
                            font.weight: Font.Normal
                            horizontalAlignment: Text.AlignLeft
                            text: "Lectura emocional derivada de los \ndatos cardíacos y del sensor de presencia\n"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle {
                        id: menu_1

                        x: -38
                        y: 21

                        height: 30
                        width: 30

                        color: "transparent"
                        radius: 16

                        Rectangle {
                            id: icon_4

                            height: 30
                            width: 30

                            clip: true
                            color: "transparent"

                            Shape {
                                id: _vector_13

                                x: 5
                                y: 15

                                height: 0
                                width: 20

                                ShapePath {
                                    id: _vector_13_ShapePath0

                                    fillColor: "#00000000"
                                    strokeColor: "#990d0e0f"
                                    strokeWidth: 1.60

                                    PathSvg {
                                        id: _vector_13_ShapePath0_PathSvg0

                                        path: "M 0 0 L 20 0"
                                    }
                                }
                            }
                            Shape {
                                id: _vector_14

                                x: 5
                                y: 7.50

                                height: 0
                                width: 20

                                ShapePath {
                                    id: _vector_14_ShapePath0

                                    fillColor: "#00000000"
                                    strokeColor: "#990d0e0f"
                                    strokeWidth: 1.60

                                    PathSvg {
                                        id: _vector_14_ShapePath0_PathSvg0

                                        path: "M 0 0 L 20 0"
                                    }
                                }
                            }
                            Shape {
                                id: _vector_15

                                x: 5
                                y: 22.50

                                height: 0
                                width: 20

                                ShapePath {
                                    id: _vector_15_ShapePath0

                                    fillColor: "#00000000"
                                    strokeColor: "#990d0e0f"
                                    strokeWidth: 1.60

                                    PathSvg {
                                        id: _vector_15_ShapePath0_PathSvg0

                                        path: "M 0 0 L 20 0"
                                    }
                                }
                            }
                        }
                    }
                }
                Item {
                    id: grupo_3

                    x: 320
                    y: 44.06

                    height: 31.88
                    width: 211

                    Book_open {
                        id: book_open_1

                        x: 135
                        y: 0.94

                        height: 30
                        width: 30

                        arrow_resize_diagonalHeight: 25.28
                        arrow_resize_diagonalWidth: 25.03
                        arrow_resize_diagonalX: 2.48
                        arrow_resize_diagonalY: 2.34
                        arrow_resize_diagonal_ShapePath0_PathSvg0Path: "M 23.97908220793628 0.23750534351950453 C 23.08307696080284 0.08317201702154761 22.17577447389205 0.00373086694016349 21.26658237091024 0.000005437806452325286 C 18.16453909726418 -0.0025376669306045076 15.12719099691891 0.8869720326261246 12.516584396362305 2.5625054095115996 C 9.89926959169835 0.9089716583181511 6.862398328465873 0.04129395974324626 3.766584931698396 0.06250537460355132 C 2.8573928287165833 0.06623080373726249 1.9500903418057935 0.14567195270167352 1.0540850946723521 0.30000527919963044 C 0.7605933604933665 0.3506034394713397 0.4948111711055709 0.5043284587057408 0.3046017595102154 0.7334964169017762 C 0.11439234791485992 0.9626643750978117 0.01225565414334075 1.2522152052835278 0.0165852958372943 1.5500051103891535 L 0.0165852958372943 16.55000323367503 C 0.013908190434042693 16.733670872127398 0.051743029345324515 16.915672095222725 0.12739777282974993 17.08305587633613 C 0.20305251631417534 17.250439657449533 0.3146677630215092 17.39909264310249 0.4543017908382565 17.518437971251114 C 0.5939358186550039 17.637783299399736 0.7581567600999158 17.724888458995217 0.9352799359282784 17.773554176293132 C 1.112403111756641 17.822219893591047 1.2980751947064157 17.831250657832232 1.479085244929746 17.80000433146316 C 3.2703590258573705 17.48986013531409 5.105586906783864 17.541318143744558 6.876667083019682 17.951350049872953 C 8.6477472592555 18.36138195600135 10.318864644270686 19.121696922002975 11.791584560779498 20.187505152699185 L 11.941584403442205 20.27500476462816 L 12.079083961193158 20.27500476462816 C 12.21771126665553 20.332766145375977 12.366404817773041 20.362504376557137 12.516584396362305 20.362504376557137 C 12.666763974951568 20.362504376557137 12.815457526069082 20.332766145375977 12.954084831531453 20.27500476462816 L 13.091584389282406 20.27500476462816 L 13.241584231945113 20.187505152699185 C 14.704030692858893 19.097871233650213 16.37034945739185 18.31292468730636 18.141769827105325 17.8791950565373 C 19.9131901968188 17.445465425768237 21.753656878487263 17.371778816694828 23.554082057678887 17.66250357889728 C 23.73509210790222 17.69374990526635 23.920765382944772 17.684719141025166 24.097888558773136 17.63605342372725 C 24.2750117346015 17.587387706429336 24.439230589884044 17.500282546833855 24.57886461770079 17.380937218685233 C 24.71849864551754 17.26159189053661 24.83011509363088 17.112938904883652 24.905769837115304 16.945555123770248 C 24.98142458059973 16.778171342656844 25.019259119159507 16.596171311654324 25.016582013756256 16.412503673201957 L 25.016582013756256 1.4125052518928767 C 25.003574640049063 1.1276972933192788 24.89359698656315 0.8558936702707134 24.704890282425268 0.6421776376469506 C 24.516183578287386 0.42846160502318775 24.260088111328493 0.28567629108036896 23.97908220793628 0.23750534351950453 Z M 11.266584515413632 16.85000411703244 C 8.953939121525268 15.633364257948843 6.379732179996579 14.998392715955717 3.766584931698396 15.000003636715103 C 3.3540849545940583 15.00000363671511 2.9415850147426195 15.000003636715103 2.5165850507497227 15.000003636715103 L 2.5165850507497227 2.500005175808272 C 2.9329062440137714 2.476011386071781 3.3502637384343474 2.476011386071781 3.766584931698396 2.500005175808272 C 6.433317048569399 2.497058020295161 9.041852536928927 3.279618820480601 11.266584515413632 4.750005244478415 L 11.266584515413632 16.85000411703244 Z M 22.51658225185891 15.050003585259205 C 22.091582287866014 15.050003585259205 21.67908234801458 15.050003585259205 21.26658237091024 15.050003585259205 C 18.653435122612056 15.048392664499818 16.079229671199343 15.683364206492945 13.76658427731098 16.900004065576542 L 13.76658427731098 4.750005244478415 C 15.991316255795684 3.279618820480601 18.599850254039236 2.497058020295161 21.26658237091024 2.500005175808272 C 21.68290356417429 2.476011386071781 22.10026105859486 2.476011386071781 22.51658225185891 2.500005175808272 L 22.51658225185891 15.050003585259205 Z M 23.97908220793628 20.23750390915048 C 23.08307696080284 20.083170582652524 22.17577447389205 20.00373107281572 21.26658237091024 20.00000564368201 C 18.16453909726418 19.99746253894495 15.12719099691891 20.886971119797703 12.516584396362305 22.56250449668318 C 9.905977795805699 20.886971119797703 6.868628205344457 19.99746253894495 3.766584931698396 20.00000564368201 C 2.8573928287165833 20.00373107281572 1.9500903418057935 20.083170582652524 1.0540850946723521 20.23750390915048 C 0.8913693659424013 20.26332576389109 0.7353634338812511 20.321059342333847 0.5950381785154575 20.407384286501305 C 0.45471292314966383 20.493709230668763 0.33283675644795896 20.60692308535128 0.2364185227293711 20.740514621018363 C 0.14000028901078326 20.874106156685446 0.07094206311289045 21.025439665457206 0.0332149901457984 21.185813735982897 C -0.004512082821293652 21.34618780650859 -0.010163617749348784 21.512437423076197 0.0165852958372943 21.67500332386298 C 0.0801086233069618 21.999608779209993 0.26969819555012253 22.285806364092334 0.5438231903931973 22.470899317131813 C 0.817948185236272 22.655992270171293 1.154259445108885 22.724891211020125 1.479085244929746 22.66250439377138 C 3.2703590258573705 22.352360197622307 5.105586906783864 22.40382059023839 6.876667083019682 22.813852496366785 C 8.6477472592555 23.22388440249518 10.318864644270686 23.98419579221839 11.791584560779498 25.0500040229146 C 12.003286753308062 25.20073418371514 12.256704817131542 25.2817325592041 12.516584396362305 25.2817325592041 C 12.776463975593067 25.2817325592041 13.029882039416549 25.20073418371514 13.241584231945113 25.0500040229146 C 14.714304148453925 23.98419579221839 16.385421533469113 23.22388440249518 18.15650170970493 22.813852496366785 C 19.927581885940747 22.40382059023839 21.76280827675126 22.352360197622307 23.554082057678887 22.66250439377138 C 23.878907857499748 22.724891211020125 24.215218223302774 22.655992270171293 24.489343218145848 22.470899317131813 C 24.763468212988922 22.285806364092334 24.95305868628659 21.999608779209993 25.016582013756256 21.67500332386298 C 25.0433309273429 21.512437423076197 25.037679392414844 21.34618780650859 24.999952319447754 21.185813735982897 C 24.962225246480664 21.025439665457206 24.89316641755146 20.874106156685446 24.79674818383287 20.740514621018363 C 24.700329950114284 20.60692308535128 24.57845378341258 20.493709230668763 24.438128528046786 20.407384286501305 C 24.29780327268099 20.321059342333847 24.14179793666623 20.26332576389109 23.97908220793628 20.23750390915048 L 23.97908220793628 20.23750390915048 Z"
                        clip: true
                    }
                    Arrow_resize_diagonal {
                        id: arrow_resize_diagonal_1

                        x: 181
                        y: 1.88

                        height: 30
                        width: 30

                        clip: true
                        contenidoHeight: 25
                        contenidoWidth: 25
                        contenidoX: 2.50
                        contenidoY: 2.50
                        contenido_ShapePath0_PathSvg0Path: "M 24.90000199508668 0.7749999160766493 C 24.77315833737792 0.46956324807053285 24.530437467185116 0.22684356997071192 24.225000799179 0.09999991226195562 C 24.07472289372343 0.03594869090702062 23.91334839070342 0.001974984484762621 23.750001811981203 0 L 16.250001239776612 0 C 15.918480590024807 5.551115546642257e-16 15.600538419555882 0.13169600701754547 15.366117934502928 0.3661164920705005 C 15.131697449449973 0.6005369771234556 15.00000114440918 0.9184794456156256 15.00000114440918 1.2500000953674317 C 15.00000114440918 1.581520745119238 15.131697449449973 1.8994632136114078 15.366117934502928 2.133883698664363 C 15.600538419555882 2.368304183717318 15.918480590024807 2.500000190734863 16.250001239776612 2.5000001907348635 L 20.73750177288057 2.5000001907348635 L 2.5000001907348635 20.73750177288057 L 2.5000001907348635 16.250001239776612 C 2.500000190734863 15.918480590024807 2.368304183717318 15.600538419555882 2.133883698664363 15.366117934502928 C 1.8994632136114078 15.131697449449973 1.581520745119238 15.00000114440918 1.2500000953674317 15.00000114440918 C 0.9184794456156256 15.00000114440918 0.6005369771234556 15.131697449449973 0.3661164920705005 15.366117934502928 C 0.13169600701754547 15.600538419555882 1.1102231093284513e-15 15.918480590024807 0 16.250001239776612 L 0 23.750001811981203 C 0.001974984484762621 23.91334839070342 0.03594869090702062 24.07472289372343 0.09999991226195562 24.225000799179 C 0.22684356997071192 24.530437467185116 0.46956324807053285 24.77315833737792 0.7749999160766493 24.90000199508668 C 0.925277821532221 24.964053216441613 1.0866535166452167 24.998026922863872 1.2500000953674317 25.000001907348633 L 8.750000667572023 25.000001907348633 C 9.081521317323828 25.000001907348633 9.399463487792753 24.868306794400826 9.633883972845707 24.633886309347872 C 9.868304457898661 24.399465824294918 10.000000762939454 24.08152246173301 10.000000762939454 23.750001811981203 C 10.000000762939454 23.418481162229398 9.868304457898661 23.100537799667485 9.633883972845707 22.86611731461453 C 9.399463487792753 22.631696829561577 9.081521317323828 22.50000171661377 8.750000667572023 22.50000171661377 L 4.262500134468064 22.50000171661377 L 22.50000171661377 4.262500134468064 L 22.50000171661377 8.750000667572023 C 22.50000171661377 9.081521317323828 22.631696829561577 9.399463487792753 22.86611731461453 9.633883972845707 C 23.100537799667485 9.868304457898661 23.418481162229398 10.000000762939454 23.750001811981203 10.000000762939454 C 24.08152246173301 10.000000762939454 24.399465824294918 9.868304457898661 24.633886309347872 9.633883972845707 C 24.868306794400826 9.399463487792753 25.000001907348633 9.081521317323828 25.000001907348633 8.750000667572023 L 25.000001907348633 1.2500000953674317 C 24.998026922863872 1.0866535166452167 24.964053216441613 0.925277821532221 24.90000199508668 0.7749999160766493 Z"
                    }
                    Rectangle {
                        id: boton_sensor_1

                        height: 31.35
                        width: 121.98

                        border.color: "#d7d6d5"
                        border.width: 1
                        color: "#ffffff"
                        radius: 20

                        Rectangle {
                            id: frame_2

                            x: 18

                            height: 31
                            width: 82

                            color: "transparent"

                            Image {
                                id: punto_s_activo_2

                                x: 17
                                y: 3.50

                                source: Qt.resolvedUrl("assets/punto_s_activo_10.png")
                                visible: false
                            }
                            Text {
                                id: sensor_conectado_1

                                x: 6
                                y: 10.50

                                height: 10
                                width: 71

                                color: "#696869"
                                font.family: "Inter"
                                font.pixelSize: 8
                                font.weight: Font.Medium
                                horizontalAlignment: Text.AlignLeft
                                text: "Sensor conectado"
                                textFormat: Text.PlainText
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Image {
                            id: punto_s_activo_3

                            x: 13
                            y: 14

                            source: Qt.resolvedUrl("assets/punto_s_activo_11.png")
                        }
                    }
                }
            }
            Rectangle {
                id: contenido_1

                y: 120

                height: 960
                width: 545

                clip: true
                color: "transparent"

                Image {
                    id: fondo_1

                    y: -53

                    source: Qt.resolvedUrl("assets/fondo_5.png")
                }
                Rectangle {
                    id: main_Content_1

                    height: 960
                    width: 545

                    clip: true
                    color: "transparent"

                    Rectangle {
                        id: container_5

                        x: 24
                        y: 20

                        height: 784
                        width: 295

                        color: "transparent"

                        Rectangle {
                            id: container_6

                            height: 358
                            width: 500

                            color: "transparent"

                            Rectangle {
                                id: container_7

                                height: 45.60
                                width: 500

                                color: "transparent"

                                Rectangle {
                                    id: container_8

                                    y: 1.50

                                    height: 42.60
                                    width: 402.40

                                    border.color: "#170d0e0f"
                                    border.width: 0.80
                                    color: "#a8ffffff"
                                    radius: 26843500

                                    Rectangle {
                                        id: icon_5

                                        x: 16.80
                                        y: 12.80

                                        height: 17
                                        width: 16.59

                                        clip: true
                                        color: "transparent"

                                        Shape {
                                            id: _vector_16

                                            x: 2.07
                                            y: 2.28

                                            height: 11.06
                                            width: 11.06

                                            ShapePath {
                                                id: _vector_16_ShapePath0

                                                fillColor: "#00000000"
                                                strokeColor: "#660d0e0f"
                                                strokeWidth: 1.38

                                                PathSvg {
                                                    id: _vector_16_ShapePath0_PathSvg0

                                                    path: "M 11.058333396911621 5.5291666984558105 C 11.058333396911621 8.582841296417627 8.582841296417627 11.058333396911621 5.5291666984558105 11.058333396911621 C 2.4754921004939945 11.058333396911621 0 8.582841296417627 0 5.5291666984558105 C 0 2.4754921004939945 2.4754921004939945 0 5.5291666984558105 0 C 8.582841296417627 0 11.058333396911621 2.4754921004939945 11.058333396911621 5.5291666984558105 Z"
                                                }
                                            }
                                        }
                                        Shape {
                                            id: _vector_17

                                            x: 11.54
                                            y: 11.75

                                            height: 2.97
                                            width: 2.97

                                            ShapePath {
                                                id: _vector_17_ShapePath0

                                                fillColor: "#00000000"
                                                strokeColor: "#660d0e0f"
                                                strokeWidth: 1.38

                                                PathSvg {
                                                    id: _vector_17_ShapePath0_PathSvg0

                                                    path: "M 2.971926689147949 2.971926689147949 L 0 0"
                                                }
                                            }
                                        }
                                    }
                                    Rectangle {
                                        id: text_Input_1

                                        x: 41.39
                                        y: 10.80

                                        height: 21
                                        width: 991.41

                                        clip: true
                                        color: "transparent"

                                        Text {
                                            id: buscar_por_archivo_o_fecha_1

                                            y: 1

                                            height: 19
                                            width: 993

                                            color: "#800d0e0f"
                                            font.family: "Manrope"
                                            font.letterSpacing: -0.16
                                            font.pixelSize: 14
                                            font.weight: Font.Normal
                                            horizontalAlignment: Text.AlignLeft
                                            text: "Buscar por archivo o fecha…"
                                            textFormat: Text.PlainText
                                            verticalAlignment: Text.AlignTop
                                            wrapMode: Text.Wrap
                                        }
                                    }
                                }
                                Rectangle {
                                    id: container_9

                                    x: 414.40

                                    height: 45.60
                                    width: 85.60

                                    border.color: "#170d0e0f"
                                    border.width: 0.80
                                    color: "#a8ffffff"
                                    radius: 26843500

                                    Rectangle {
                                        id: viewBtn_2

                                        x: 4.80
                                        y: 4.80

                                        height: 36
                                        width: 36

                                        color: "#e59aa8"
                                        radius: 26843500

                                        Rectangle {
                                            id: icon_6

                                            x: 9.50
                                            y: 9.50

                                            height: 17
                                            width: 17

                                            clip: true
                                            color: "transparent"

                                            Shape {
                                                id: _vector_18

                                                x: 8.50
                                                y: 2.13

                                                height: 12.75
                                                width: 0

                                                ShapePath {
                                                    id: _vector_18_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_18_ShapePath0_PathSvg0

                                                        path: "M 0 0 L 0 12.75"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_19

                                                x: 2.13
                                                y: 2.13

                                                height: 12.75
                                                width: 12.75

                                                ShapePath {
                                                    id: _vector_19_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_19_ShapePath0_PathSvg0

                                                        path: "M 1.4166666666666667 0 L 11.333333333333334 0 C 12.11573676764965 0 12.75 0.6342632323503494 12.75 1.4166666666666667 L 12.75 11.333333333333334 C 12.75 12.11573676764965 12.11573676764965 12.75 11.333333333333334 12.75 L 1.4166666666666667 12.75 C 0.6342632323503494 12.75 0 12.11573676764965 0 11.333333333333334 L 0 1.4166666666666667 C 0 0.6342632323503494 0.6342632323503494 0 1.4166666666666667 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_20

                                                x: 2.13
                                                y: 6.38

                                                height: 0
                                                width: 12.75

                                                ShapePath {
                                                    id: _vector_20_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_20_ShapePath0_PathSvg0

                                                        path: "M 0 0 L 12.75 0"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_21

                                                x: 2.13
                                                y: 10.63

                                                height: 0
                                                width: 12.75

                                                ShapePath {
                                                    id: _vector_21_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#ffffff"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_21_ShapePath0_PathSvg0

                                                        path: "M 0 0 L 12.75 0"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Rectangle {
                                        id: viewBtn_3

                                        x: 44.80
                                        y: 4.80

                                        height: 36
                                        width: 36

                                        color: "transparent"
                                        radius: 26843500

                                        Rectangle {
                                            id: icon_7

                                            x: 9.50
                                            y: 9.50

                                            height: 17
                                            width: 17

                                            clip: true
                                            color: "transparent"

                                            Shape {
                                                id: _vector_22

                                                x: 2.13
                                                y: 2.13

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_22_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_22_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_23

                                                x: 9.92
                                                y: 2.13

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_23_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_23_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_24

                                                x: 9.92
                                                y: 9.92

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_24_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_24_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                            Shape {
                                                id: _vector_25

                                                x: 2.13
                                                y: 9.92

                                                height: 4.96
                                                width: 4.96

                                                ShapePath {
                                                    id: _vector_25_ShapePath0

                                                    fillColor: "#00000000"
                                                    strokeColor: "#990d0e0f"
                                                    strokeWidth: 1.42

                                                    PathSvg {
                                                        id: _vector_25_ShapePath0_PathSvg0

                                                        path: "M 0.7083332879202706 0 L 4.249999727521624 0 C 4.64120141959884 0 4.9583330154418945 0.3171315958430552 4.9583330154418945 0.7083332879202706 L 4.9583330154418945 4.249999727521624 C 4.9583330154418945 4.64120141959884 4.64120141959884 4.9583330154418945 4.249999727521624 4.9583330154418945 L 0.7083332879202706 4.9583330154418945 C 0.3171315958430552 4.9583330154418945 0 4.64120141959884 0 4.249999727521624 L 0 0.7083332879202706 C 0 0.3171315958430552 0.3171315958430552 0 0.7083332879202706 0 Z"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Image {
                                id: glassCard_1

                                x: -20
                                y: 43.60

                                clip: true
                                source: Qt.resolvedUrl("assets/glassCard_1.png")
                            }
                        }
                        Image {
                            id: detallessescontenido_1

                            x: -20
                            y: 360

                            clip: true
                            source: Qt.resolvedUrl("assets/detallessescontenido_1.png")
                        }
                    }
                }
            }
        }
    }
}