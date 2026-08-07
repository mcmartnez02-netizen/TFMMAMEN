import QtQuick
import QtQuick.Shapes

Rectangle {
    id: grupo_menu

    height: 777.60
    width: 280

    clip: true
    color: "#f2f1f0"

    Shape {
        id: _vector

        y: 44.10

        height: 175.90
        width: 255.40

        visible: false

        ShapePath {
            id: _vector_ShapePath0

            fillRule: ShapePath.WindingFill
            joinStyle: ShapePath.MiterJoin
            strokeColor: "#00000000"
            strokeStyle: ShapePath.SolidLine
            strokeWidth: 0.72

            fillGradient: LinearGradient {
                id: _vector_ShapePath0_LinearGradient_1
            
                x1: _vector.width * 0
                x2: _vector.width * 0
                y1: _vector.height * 0
                y2: _vector.height * 1
            
                GradientStop {
                    id: _vector_ShapePath0_LinearGradient_1_GradientStop
            
                    color: "#4db4afc1"
                    position: 0
                }
                GradientStop {
                    id: _vector_ShapePath0_LinearGradient_1_GradientStop_1
            
                    color: "#00b4afc1"
                    position: 1
                }
            }

            PathSvg {
                id: _vector_ShapePath0_PathSvg0

                path: "M 0 83.73959350585938 L 2.119819998054503 82.20000457763672 L 4.265180092926021 80.70000457763672 L 6.384999847412109 79.30000305175781 L 8.504819601898198 78 L 10.65017994033813 76.4000015258789 L 12.769999694824218 73.30000305175781 L 14.889819449310307 66.80000305175781 L 17.03517881347658 56.900001525878906 L 19.15499954223633 47.20000457763672 L 21.274820270996074 42.900001525878906 L 23.42017866088869 46.70000457763672 L 25.539999389648436 56.400001525878906 L 27.659820118408184 66.70000457763672 L 29.805178508300802 73.80000305175781 L 31.924999237060547 77.20000457763672 L 34.044819965820295 78.70000457763672 L 36.19017835571291 79.70000457763672 L 38.30999908447266 80.5999984741211 L 40.429819813232406 81.4000015258789 L 42.57517820312502 82.0999984741211 L 44.69499893188477 82.5999984741211 L 46.81481966064451 82.9000015258789 L 48.96017805053713 82.9000015258789 L 51.07999877929687 82.80000305175781 L 53.19981950805662 82.4000015258789 L 55.34517789794924 81.70000457763672 L 57.46499862670898 80.9000015258789 L 59.58481935546873 79.9000015258789 L 61.730177745361345 78.70000457763672 L 63.849998474121094 77.4000015258789 L 65.96981530578621 76 L 68.11518148986809 74.5999984741211 L 70.2349983215332 73.20000457763672 L 72.35481515319832 71.70000457763672 L 74.5001813372802 69.9000015258789 L 76.61999816894532 66.4000015258789 L 78.73981500061042 59.20000457763672 L 80.88518118469231 48.599998474121094 L 83.00499801635742 37.900001525878906 L 85.12481484802254 32.5 L 87.27018103210442 34.900001525878906 L 89.38999786376954 42.900001525878906 L 91.50981469543464 51.400001525878906 L 93.65518087951652 56.5 L 95.77499771118164 57.70000457763672 L 97.89481454284676 56.80000305175781 L 100.04018072692864 55.30000305175781 L 102.15999755859374 53.599998474121094 L 104.27981439025886 51.80000305175781 L 106.42518057434074 49.80000305175781 L 108.54499740600586 47.70000457763672 L 110.66481423767098 45.400001525878906 L 112.81018042175286 43.099998474121094 L 114.92999725341797 40.70000457763672 L 117.04981408508309 38.30000305175781 L 119.19518026916496 36 L 121.31499710083008 33.70000457763672 L 123.43481393249519 31.599998474121094 L 125.58018011657708 29.800003051757812 L 127.69999694824219 28.099998474121094 L 129.8198137799073 26.800003051757812 L 131.9651799639892 25.800003051757812 L 134.0849967956543 25.20000457763672 L 136.20481362731942 25 L 138.3501798114013 24.800003051757812 L 140.4699966430664 23.20000457763672 L 142.58981347473153 18.300003051757812 L 144.7351796588134 10.200000762939453 L 146.85499649047853 2.4000015258789062 L 148.97481332214363 0 L 151.12017950622553 5.700000762939453 L 153.23999633789063 17.200000762939453 L 155.35981316955574 29.400001525878906 L 157.50517935363763 38.20000457763672 L 159.62499618530273 43.30000305175781 L 161.74481301696784 46.5 L 163.89017920104973 49 L 166.00999603271484 51.5 L 168.12981286437997 53.80000305175781 L 170.27517904846184 56 L 172.39499588012694 58.099998474121094 L 174.51481271179208 60.099998474121094 L 176.66017889587394 61.900001525878906 L 178.77999572753907 63.70000457763672 L 180.89981255920418 65.30000305175781 L 183.04517874328607 66.9000015258789 L 185.16499557495118 68.5 L 187.28481240661628 70.0999984741211 L 189.43017859069818 71.70000457763672 L 191.54999542236328 73.30000305175781 L 193.6698122540284 74.9000015258789 L 195.81517843811028 76.5999984741211 L 197.93499526977538 78.30000305175781 L 200.05481210144052 80.0999984741211 L 202.20017828552238 81.4000015258789 L 204.3199951171875 81 L 206.43981194885262 76.9000015258789 L 208.5851781329345 69.0999984741211 L 210.70499496459962 61.099998474121094 L 212.82481179626473 58.099998474121094 L 214.97017798034662 62.80000305175781 L 217.08999481201172 72.9000015258789 L 219.20981164367683 83.20000457763672 L 221.35517782775872 89.79999542236328 L 223.47499465942383 92.4000015258789 L 225.59481149108893 92.79999542236328 L 227.74017767517083 92.29999542236328 L 229.85999450683593 91.50000762939453 L 231.97981133850107 90.50000762939453 L 234.12517752258293 89.29999542236328 L 236.24499435424806 88.00000762939453 L 238.36481118591317 86.50000762939453 L 240.51017736999503 84.9000015258789 L 242.62999420166017 83.30000305175781 L 244.74981103332527 81.80000305175781 L 246.89517721740717 80.4000015258789 L 249.01499404907227 79.0999984741211 L 251.13481088073738 78 L 253.28017706481927 77.0999984741211 L 255.39999389648438 76.4000015258789 L 255.39999389648438 175.89999389648438 L 0 175.89999389648438 L 0 83.73959350585938 Z"
            }
        }
    }
    Image {
        id: _vector_1

        y: 44.10

        source: Qt.resolvedUrl("assets/_vector_5.png")
        visible: false
    }
    Rectangle {
        id: principal

        height: 2352
        width: 1920

        color: "#f2f1f0"
        visible: false

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
                    width: 335

                    Text {
                        id: infousuario

                        height: 55
                        width: 336

                        color: "#000000"
                        font.family: "Manrope"
                        font.pixelSize: 40
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignLeft
                        text: "Sobre el proyecto"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        id: lectura_emocional

                        y: 55

                        height: 24
                        width: 248

                        color: "#696869"
                        font.family: "Inter"
                        font.pixelSize: 20
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignLeft
                        text: "Cuerpo digital y presencia"
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
                            id: _vector_2

                            x: 7.33
                            y: 22

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
                        Shape {
                            id: _vector_3

                            x: 7.33
                            y: 11

                            height: 0
                            width: 29.33

                            ShapePath {
                                id: _vector_3_ShapePath0

                                fillColor: "#00000000"
                                strokeColor: "#990d0e0f"
                                strokeWidth: 1.60

                                PathSvg {
                                    id: _vector_3_ShapePath0_PathSvg0

                                    path: "M 0 0 L 29.33333396911621 0"
                                }
                            }
                        }
                        Shape {
                            id: _vector_4

                            x: 7.33
                            y: 33

                            height: 0
                            width: 29.33

                            ShapePath {
                                id: _vector_4_ShapePath0

                                fillColor: "#00000000"
                                strokeColor: "#990d0e0f"
                                strokeWidth: 1.60

                                PathSvg {
                                    id: _vector_4_ShapePath0_PathSvg0

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

                            source: Qt.resolvedUrl("assets/punto_s_activo_22.png")
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

                        source: Qt.resolvedUrl("assets/punto_s_activo_23.png")
                    }
                }
            }
        }
        Rectangle {
            id: container

            y: 120

            height: 2232
            width: 1920

            color: "#ffffff"

            Rectangle {
                id: header

                height: 330
                width: 1920

                color: "transparent"

                Text {
                    id: january_1_2025

                    x: 892
                    y: 80

                    height: 26
                    width: 137

                    color: "#8c000000"
                    font.family: "Inter"
                    font.letterSpacing: -0.09
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 26.10
                    lineHeightMode: Text.FixedHeight
                    text: "January 1, 2025"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                }
                Rectangle {
                    id: header_1

                    x: 560
                    y: 138

                    height: 112
                    width: 800

                    color: "transparent"

                    Text {
                        id: sobre_el_proyecto

                        height: 70
                        width: 800

                        color: "#000000"
                        font.family: "Inter"
                        font.letterSpacing: -1.60
                        font.pixelSize: 64
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 70.40
                        lineHeightMode: Text.FixedHeight
                        text: "Sobre el proyecto"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                    Text {
                        id: author_Founder_of_Namedly

                        x: 280
                        y: 86

                        height: 26
                        width: 241

                        color: "#8c000000"
                        font.family: "Inter"
                        font.letterSpacing: -0.09
                        font.pixelSize: 18
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 26.10
                        lineHeightMode: Text.FixedHeight
                        text: "Author, Founder of Namedly "
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            Rectangle {
                id: image

                y: 330

                height: 573.33
                width: 1920

                color: "transparent"

                Image {
                    id: image_1

                    x: 240

                    source: Qt.resolvedUrl("assets/image_4.png")
                }
            }
            Rectangle {
                id: text_block_1

                y: 903.33

                height: 506
                width: 1920

                color: "transparent"

                Rectangle {
                    id: wrapper

                    x: 240
                    y: 80

                    height: 346
                    width: 1440

                    color: "transparent"

                    Rectangle {
                        id: paragraph

                        height: 149
                        width: 1440

                        color: "transparent"

                        Text {
                            id: first_subheader

                            height: 29
                            width: 1441

                            color: "#000000"
                            font.family: "Inter"
                            font.letterSpacing: -0.48
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 28.80
                            lineHeightMode: Text.FixedHeight
                            text: "First subheader"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                        Text {
                            id: the_first_paragraph_of_an_article_is_often_an_in

                            y: 45

                            height: 104
                            width: 1441

                            color: "#8c000000"
                            font.family: "Inter"
                            font.letterSpacing: -0.09
                            font.pixelSize: 18
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 26.10
                            lineHeightMode: Text.FixedHeight
                            text: "The first paragraph of an article is often an introduction to the text. Sometimes it’s called the “lead,” and sometimes that word is spelled “lede.” When you’re writing an article—whether it’s for a blog or a review site or somewhere else—it’s always a good idea to begin with something interesting to hook a reader. If it’s a piece of thought leadership, maybe you want to start with a little anecdote, or a familiar problem. If you’re putting together something for businesses, you might start off with a relevant piece of data."
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                    }
                    Rectangle {
                        id: paragraph_1

                        y: 197

                        height: 149
                        width: 1440

                        color: "transparent"

                        Text {
                            id: another_subheader_to_break_up_text

                            height: 29
                            width: 1441

                            color: "#000000"
                            font.family: "Inter"
                            font.letterSpacing: -0.48
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 28.80
                            lineHeightMode: Text.FixedHeight
                            text: "Another subheader to break up text"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                        Text {
                            id: the_second_paragraph_of_an_article_is_sometimes_

                            y: 45

                            height: 104
                            width: 1441

                            color: "#8c000000"
                            font.family: "Inter"
                            font.letterSpacing: -0.09
                            font.pixelSize: 18
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 26.10
                            lineHeightMode: Text.FixedHeight
                            text: "The second paragraph of an article is sometimes called the “nut graph,” which is short for “nutshell paragraph.” That’s because this is usually where the article gets to the heart of the matter—the main point. After the first section, the reader is ready to hear what’s truly at stake in this piece of writing. They’re invested. They’re paying attention. If your piece is long enough to have long, multi-paragraph sections, then you’ll want to use this strategy throughout to make sure you’re holding reader attention in a consistent way."
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
            Rectangle {
                id: quote

                y: 1409.33

                height: 396
                width: 1920

                clip: true
                color: "transparent"

                Text {
                    id: a_large_heavily_bolded_quote_for_emphasis_and_br

                    x: 240
                    y: 80

                    height: 124
                    width: 1441

                    color: "#000000"
                    font.family: "Inter"
                    font.letterSpacing: -0.96
                    font.pixelSize: 48
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 62.40
                    lineHeightMode: Text.FixedHeight
                    text: "“A large, heavily bolded quote for emphasis and breaking up content.”"
                    textFormat: Text.PlainText
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                }
                Rectangle {
                    id: author

                    x: 849
                    y: 252

                    height: 64
                    width: 222

                    color: "transparent"

                    Image {
                        id: image_2

                        source: Qt.resolvedUrl("assets/image_5.png")
                    }
                    Rectangle {
                        id: name

                        x: 80

                        height: 64
                        width: 142

                        color: "transparent"

                        Text {
                            id: full_name

                            height: 34
                            width: 109

                            color: "#000000"
                            font.family: "Inter"
                            font.letterSpacing: -0.36
                            font.pixelSize: 24
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 33.60
                            lineHeightMode: Text.FixedHeight
                            text: "Full name"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignTop
                        }
                        Text {
                            id: role_at_company

                            y: 38

                            height: 26
                            width: 143

                            color: "#8c000000"
                            font.family: "Inter"
                            font.letterSpacing: -0.09
                            font.pixelSize: 18
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignLeft
                            lineHeight: 26.10
                            lineHeightMode: Text.FixedHeight
                            text: "Role at company"
                            textFormat: Text.PlainText
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
            Rectangle {
                id: text_block_2

                y: 1805.33

                height: 427
                width: 1920

                color: "transparent"

                Rectangle {
                    id: paragraph_2

                    x: 240
                    y: 80

                    height: 149
                    width: 1440

                    color: "transparent"

                    Text {
                        id: last_subheader_for_good_measure

                        height: 29
                        width: 1441

                        color: "#000000"
                        font.family: "Inter"
                        font.letterSpacing: -0.48
                        font.pixelSize: 24
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 28.80
                        lineHeightMode: Text.FixedHeight
                        text: "Last subheader, for good measure"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                    Text {
                        id: finally_you_arrive_at_the_ending_of_the_article_

                        y: 45

                        height: 104
                        width: 1441

                        color: "#8c000000"
                        font.family: "Inter"
                        font.letterSpacing: -0.09
                        font.pixelSize: 18
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 26.10
                        lineHeightMode: Text.FixedHeight
                        text: "Finally you arrive at the ending of the article. This is a good place to wrap things up and conclude with takeaways. If you’re writing something for a more traditional publication, it can be nice to end on an anecdote that mirrors the theme of the piece. If you’re putting together some content for a company blog, you’ll probably just want to close out in a tidy way and include a CTA of some kind. Writers should take note: Usually, when you write a draft, you finally get to the main point at the end. An old editing trick is to take that idea and put it at the top of the piece. Consider whether that would work for you in this case."
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
        Rectangle {
            id: contenido

            y: 2352

            height: 3503
            width: 1920

            clip: true
            color: "transparent"
        }
    }
    Image {
        id: menu_1

        source: Qt.resolvedUrl("assets/menu.png")

        Rectangle {
            id: titulo_grupo

            x: 16
            y: 24

            height: 44
            width: 247.20

            color: "transparent"

            Rectangle {
                id: icono

                x: 12

                height: 44
                width: 44

                color: "#f9edef"
                radius: 16

                Rectangle {
                    id: icon_1

                    x: 9
                    y: 9

                    height: 26
                    width: 26

                    clip: true
                    color: "transparent"

                    Shape {
                        id: _vector_5

                        x: 2.08
                        y: 3.12

                        height: 18.72
                        width: 21.84

                        ShapePath {
                            id: _vector_5_ShapePath0

                            fillColor: "#dd7c93"
                            fillRule: ShapePath.WindingFill
                            joinStyle: ShapePath.MiterJoin
                            strokeColor: "#00000000"
                            strokeStyle: ShapePath.SolidLine
                            strokeWidth: 0.26

                            PathSvg {
                                id: _vector_5_ShapePath0_PathSvg0

                                path: "M 10.920000076293945 18.719999313354492 C 3.120000021798271 13.259999513626099 0 8.839999675750732 0 5.4599997997283936 C 0 2.0799999237060547 2.6000000181652245 0 5.7200000399634945 0 C 8.060000056312198 0 9.880000069027854 1.2999999523162842 10.920000076293945 3.379999876022339 C 11.960000083560036 1.2999999523162842 13.780000096275693 0 16.120000112624396 0 C 19.240000134422665 0 21.84000015258789 2.0799999237060547 21.84000015258789 5.4599997997283936 C 21.84000015258789 8.839999675750732 18.72000013078962 13.259999513626099 10.920000076293945 18.719999313354492 Z"
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: titulo

                x: 68
                y: 1

                height: 42
                width: 127.20

                color: "transparent"

                Rectangle {
                    id: titulo_1

                    height: 24
                    width: 127.20

                    color: "transparent"

                    Text {
                        id: latencia_afectiva

                        height: 24
                        width: 129

                        color: "#0d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 24
                        lineHeightMode: Text.FixedHeight
                        text: "Latencia afectiva"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: instalacion

                    y: 24

                    height: 18
                    width: 127.20

                    color: "transparent"

                    Text {
                        id: instalaci_n_interactiva

                        height: 18
                        width: 120

                        color: "#660d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 12
                        font.weight: Font.Normal
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 18
                        lineHeightMode: Text.FixedHeight
                        text: "Instalación interactiva"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
            }
        }
        Rectangle {
            id: navegacion

            x: 16
            y: 68

            height: 230
            width: 247.20

            color: "transparent"

            Rectangle {
                id: bpulsaciones

                y: 32

                height: 45
                width: 247.20

                color: "transparent"
                radius: 16

                Rectangle {
                    id: icon_2

                    x: 14
                    y: 13

                    height: 19
                    width: 19

                    clip: true
                    color: "transparent"

                    Shape {
                        id: _vector_6

                        x: 1.58
                        y: 1.58

                        height: 15.83
                        width: 15.83

                        ShapePath {
                            id: _vector_6_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_6_ShapePath0_PathSvg0

                                path: "M 15.833333969116211 7.9166669845581055 L 13.870000919342054 7.9166669845581055 C 13.524017675871658 7.915926912119775 13.187314395402975 8.02853373018083 12.91138732621257 8.237266116300178 C 12.635460257022164 8.445998502419526 12.435498851195906 8.739365867778016 12.342083949724838 9.072500394503276 L 10.481666906356804 15.690833721796661 C 10.469676390127288 15.731944064418935 10.44467540007433 15.768057272942311 10.410416782697029 15.793751238187177 C 10.376158165319728 15.819445203432043 10.33449035238446 15.833333969116211 10.291667079925537 15.833333969116211 C 10.248843807466613 15.833333969116211 10.207175994531344 15.819445203432043 10.172917377154043 15.793751238187177 C 10.138658759776742 15.768057272942311 10.113657769723785 15.731944064418935 10.10166725349427 15.690833721796661 L 5.731666715621941 0.14250005857149972 C 5.719676199392427 0.1013897159492263 5.694675209339467 0.06527726241804714 5.660416591962166 0.039583297173180654 C 5.626157974584865 0.013889331928314166 5.584490161649596 1.7578531929092434e-16 5.541666889190673 0 C 5.498843616731751 1.7578531929092434e-16 5.457175803796481 0.013889331928314166 5.4229171864191805 0.039583297173180654 C 5.38865856904188 0.06527726241804714 5.363657578988921 0.1013897159492263 5.3516670627594065 0.14250005857149972 L 3.491250019391373 6.760833574612934 C 3.3982014189003635 7.092664206219655 3.199426660263725 7.385075468334071 2.9251006228085767 7.593677547518837 C 2.6507745853534286 7.802279626703603 2.315878142774332 7.91568083701149 1.9712498979568407 7.9166669845581055 L 0 7.9166669845581055"
                            }
                        }
                    }
                }
                Rectangle {
                    id: _text

                    x: 45
                    y: 12

                    height: 21
                    width: 78

                    color: "transparent"

                    Text {
                        id: pulsaciones

                        height: 21
                        width: 79

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 21
                        lineHeightMode: Text.FixedHeight
                        text: "Pulsaciones"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: _text_1

                    y: 22.50

                    height: 0
                    width: 3

                    color: "#e59aa8"
                }
            }
            Rectangle {
                id: binfo

                y: 83

                height: 45
                width: 247.20

                color: "transparent"
                radius: 16

                Rectangle {
                    id: icon_3

                    x: 14
                    y: 13

                    height: 19
                    width: 19

                    clip: true
                    color: "transparent"

                    Shape {
                        id: _vector_7

                        x: 5.54
                        y: 2.38

                        height: 7.92
                        width: 7.92

                        ShapePath {
                            id: _vector_7_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_7_ShapePath0_PathSvg0

                                path: "M 7.9166669845581055 3.9583334922790527 C 7.9166669845581055 6.1444607758179925 6.1444607758179925 7.9166669845581055 3.9583334922790527 7.9166669845581055 C 1.772206208740113 7.9166669845581055 0 6.1444607758179925 0 3.9583334922790527 C 0 1.772206208740113 1.772206208740113 0 3.9583334922790527 0 C 6.1444607758179925 0 7.9166669845581055 1.772206208740113 7.9166669845581055 3.9583334922790527 Z"
                            }
                        }
                    }
                    Shape {
                        id: _vector_8

                        x: 3.17
                        y: 10.29

                        height: 6.33
                        width: 12.67

                        ShapePath {
                            id: _vector_8_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_8_ShapePath0_PathSvg0

                                path: "M 12.666666984558105 6.333333492279053 C 12.666666984558102 4.653628952866157 11.999407249831073 3.0427205283132466 10.811676853037966 1.8549901315201396 C 9.623946456244859 0.6672597347270326 8.013038031691949 1.406282533151571e-15 6.333333492279053 0 C 4.653628952866157 1.406282533151571e-15 3.0427209058093396 0.6672597347270326 1.8549905090162326 1.8549901315201396 C 0.6672601122231256 3.0427205283132466 2.1094237997273566e-15 4.653628952866157 0 6.333333492279053"
                            }
                        }
                    }
                }
                Rectangle {
                    id: _text_2

                    x: 45
                    y: 12

                    height: 21
                    width: 150

                    color: "transparent"

                    Text {
                        id: informaci_n_del_usuario

                        height: 21
                        width: 151

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 21
                        lineHeightMode: Text.FixedHeight
                        text: "Información del usuario"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: _text_3

                    y: 22.50

                    height: 0
                    width: 3

                    color: "#e59aa8"
                }
            }
            Rectangle {
                id: bdatos

                y: 134

                height: 45
                width: 247.20

                color: "transparent"
                radius: 16

                Rectangle {
                    id: icon_4

                    x: 14
                    y: 13

                    height: 19
                    width: 19

                    clip: true
                    color: "transparent"

                    Shape {
                        id: _vector_9

                        x: 2.38
                        y: 1.58

                        height: 4.75
                        width: 14.25

                        ShapePath {
                            id: _vector_9_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_9_ShapePath0_PathSvg0

                                path: "M 14.25 2.375 C 14.25 3.68667629857858 11.06002899010976 4.75 7.125 4.75 C 3.1899710098902387 4.75 0 3.68667629857858 0 2.375 C 0 1.0633237014214199 3.1899710098902387 0 7.125 0 C 11.06002899010976 0 14.25 1.0633237014214199 14.25 2.375 Z"
                            }
                        }
                    }
                    Shape {
                        id: _vector_10

                        x: 2.38
                        y: 3.96

                        height: 13.46
                        width: 14.25

                        ShapePath {
                            id: _vector_10_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_10_ShapePath0_PathSvg0

                                path: "M 0 0 L 0 11.083333856919232 C 2.8158241960341002e-8 11.713223049553916 0.7506673832734425 12.317313922683129 2.0868640343348184 12.762712843140273 C 3.4230606853961945 13.208111763597417 5.235332558552424 13.458333969116211 7.125 13.458333969116211 C 9.014667441447576 13.458333969116211 10.826938559611637 13.208111763597417 12.163135210673014 12.762712843140273 C 13.49933186173439 12.317313922683129 14.249999971841758 11.713223049553916 14.25 11.083333856919232 L 14.25 0"
                            }
                        }
                    }
                    Shape {
                        id: _vector_11

                        x: 2.38
                        y: 9.50

                        height: 2.38
                        width: 14.25

                        ShapePath {
                            id: _vector_11_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_11_ShapePath0_PathSvg0

                                path: "M 0 0 C 2.8158241960341002e-8 0.6298891628781954 0.7506673832734425 1.233980007469654 2.0868640343348184 1.6793789068857827 C 3.4230606853961945 2.1247778063019114 5.235332558552424 2.375 7.125 2.375 C 9.014667441447576 2.375 10.826938559611637 2.1247778063019114 12.163135210673014 1.6793789068857827 C 13.49933186173439 1.233980007469654 14.249999971841758 0.6298891628781954 14.25 0"
                            }
                        }
                    }
                }
                Rectangle {
                    id: _text_4

                    x: 45
                    y: 12

                    height: 21
                    width: 109

                    color: "transparent"

                    Text {
                        id: datos_y_sesiones

                        height: 21
                        width: 110

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 21
                        lineHeightMode: Text.FixedHeight
                        text: "Datos y sesiones"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: _text_5

                    y: 22.50

                    height: 0
                    width: 3

                    color: "#e59aa8"
                }
            }
            Rectangle {
                id: bconfiguracion

                y: 185

                height: 45
                width: 247.20

                color: "transparent"
                radius: 16

                Rectangle {
                    id: icon_5

                    x: 14
                    y: 13

                    height: 19
                    width: 19

                    clip: true
                    color: "transparent"

                    Shape {
                        id: _vector_12

                        x: 2.36
                        y: 1.58

                        height: 15.83
                        width: 14.28

                        ShapePath {
                            id: _vector_12_ShapePath0

                            fillColor: "#00000000"
                            fillRule: ShapePath.WindingFill
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_12_ShapePath0_PathSvg0

                                path: "M 7.313084810732532 0 L 6.964751035214735 0 C 6.544824887526465 3.5157063858184867e-16 6.142098146574985 0.16681493619365995 5.845165538300961 0.46374753986315226 C 5.548232930026937 0.7606801435326446 5.381417613750374 1.163407255735143 5.381417613750374 1.583333396911621 L 5.381417613750374 1.7258332667350713 C 5.381132817984521 2.003490990383636 5.307838102085341 2.2761921430687893 5.16888579688204 2.5165796297021643 C 5.029933491678738 2.7569671163355394 4.830209763736529 2.9565878791197036 4.589750903018193 3.0954166701634676 L 4.249334730798058 3.29333334477742 C 4.008637646444219 3.43229987471021 3.7356007067452586 3.5054601050360814 3.4576676425697723 3.5054601050360814 C 3.179734578394286 3.5054601050360814 2.906698016191431 3.43229987471021 2.666000931837592 3.29333334477742 L 2.5472508497285435 3.2300000693003312 C 2.1839273409221724 3.02041645307184 1.7522885980032963 2.963559807380241 1.3470857893212933 3.0719107430873915 C 0.9418829806392903 3.180261678794542 0.5962290971549882 3.4449658597500528 0.38600090307789864 3.8079167742729165 L 0.21183420406705264 4.108750210285188 C 0.00225058458854982 4.472073713457504 -0.054606250732776924 4.903712827179061 0.05374468665457089 5.308915629577586 C 0.1620956240419187 5.714118431976112 0.4267999978502474 6.059772121352313 0.7897509180013886 6.270000312169395 L 0.9085010001104367 6.349167284011855 C 1.1478026937071668 6.487321465933673 1.3467828133071005 6.685695500664749 1.485666119300535 6.924574772416144 C 1.6245494252939694 7.16345404416754 1.6984998746217472 7.434520048907513 1.7001677108426174 7.710833461761467 L 1.7001677108426174 8.114583659172057 C 1.7012753593412988 8.393582838800986 1.628640775262524 8.667921121285838 1.4896188810116922 8.909819205745316 C 1.3505969867608603 9.151717290204795 1.1501245542789644 9.352585040570613 0.9085010001104367 9.49208353328704 L 0.7897509180013886 9.563333656946815 C 0.4267999978502474 9.773561847763897 0.1620956240419187 10.119215537140098 0.05374468665457089 10.524418339538624 C -0.054606250732776924 10.92962114193715 0.00225058458854982 11.361259878162608 0.21183420406705264 11.724583381334924 L 0.38600090307789864 12.025417572339393 C 0.5962290971549882 12.388368486862257 0.9418829806392903 12.653072290321667 1.3470857893212933 12.761423226028818 C 1.7522885980032963 12.869774161735968 2.1839273409221724 12.81291751604437 2.5472508497285435 12.60333389981588 L 2.666000931837592 12.54000062433879 C 2.906698016191431 12.401034094405999 3.179734578394286 12.32787348658403 3.4576676425697723 12.32787348658403 C 3.7356007067452586 12.32787348658403 4.008637646444219 12.401034094405999 4.249334730798058 12.54000062433879 L 4.589750903018193 12.737917298952743 C 4.830209763736529 12.876746089996507 5.029933491678738 13.07636723027677 5.16888579688204 13.316754716910145 C 5.307838102085341 13.55714220354352 5.381132817984521 13.829842601236475 5.381417613750374 14.10750032488504 L 5.381417613750374 14.25000057220459 C 5.381417613750374 14.669926713381068 5.548232930026937 15.072653448087467 5.845165538300961 15.36958605175696 C 6.142098146574985 15.666518655426453 6.544824887526465 15.833333969116211 6.964751035214735 15.833333969116211 L 7.313084810732532 15.833333969116211 C 7.7330109584208016 15.833333969116211 8.135737699372282 15.666518655426453 8.432670307646307 15.36958605175696 C 8.729602915920331 15.072653448087467 8.896418232196893 14.669926713381068 8.896418232196893 14.25000057220459 L 8.896418232196893 14.10750032488504 C 8.896703027962745 13.829842601236475 8.969997743861924 13.55714220354352 9.108950049065227 13.316754716910145 C 9.247902354268529 13.07636723027677 9.447626082210737 12.876746089996507 9.688084942929073 12.737917298952743 L 10.02850111514921 12.54000062433879 C 10.269198199503048 12.401034094405999 10.542234761705902 12.32787348658403 10.82016782588139 12.32787348658403 C 11.098100890056877 12.32787348658403 11.371137452259731 12.401034094405999 11.61183453661357 12.54000062433879 L 11.730584241226513 12.60333389981588 C 12.093907750032884 12.81291751604437 12.52554724794397 12.869774161735968 12.930750056625973 12.761423226028818 C 13.335952865307975 12.653072290321667 13.681607315036436 12.388368486862257 13.891835509113525 12.025417572339393 L 14.066001641880215 11.716666533152237 C 14.275585261358717 11.353343029979921 14.332441907931992 10.921704293754464 14.224090970544644 10.516501491355939 C 14.115740033157296 10.111298688957413 13.851036225593123 9.76564499958121 13.488085305441983 9.555416808764129 L 13.36933560082904 9.49208353328704 C 13.127712046660513 9.352585040570613 12.927238481690301 9.151717290204795 12.78821658743947 8.909819205745316 C 12.649194693188639 8.667921121285838 12.576561241598176 8.393582838800986 12.577668890096858 8.114583659172057 L 12.577668890096858 7.718750309944152 C 12.576561241598176 7.439751130315224 12.649194693188639 7.165412847830373 12.78821658743947 6.923514763370894 C 12.927238481690301 6.681616678911416 13.127712046660513 6.480748928545597 13.36933560082904 6.34125043582917 L 13.488085305441983 6.270000312169395 C 13.851036225593123 6.059772121352313 14.115740033157296 5.714118431976112 14.224090970544644 5.308915629577586 C 14.332441907931992 4.903712827179061 14.275585261358717 4.472073713457504 14.066001641880215 4.108750210285188 L 13.891835509113525 3.8079167742729165 C 13.681607315036436 3.4449658597500528 13.335952865307975 3.180261678794542 12.930750056625973 3.0719107430873915 C 12.52554724794397 2.963559807380241 12.093907750032884 3.02041645307184 11.730584241226513 3.2300000693003312 L 11.61183453661357 3.29333334477742 C 11.371137452259731 3.43229987471021 11.098100890056877 3.5054601050360814 10.82016782588139 3.5054601050360814 C 10.542234761705902 3.5054601050360814 10.269198199503048 3.43229987471021 10.02850111514921 3.29333334477742 L 9.688084942929073 3.0954166701634676 C 9.447626082210737 2.9565878791197036 9.247902354268529 2.7569671163355394 9.108950049065227 2.5165796297021643 C 8.969997743861924 2.2761921430687893 8.896703027962745 2.003490990383636 8.896418232196893 1.7258332667350713 L 8.896418232196893 1.583333396911621 C 8.896418232196893 1.163407255735143 8.729602915920331 0.7606801435326446 8.432670307646307 0.46374753986315226 C 8.135737699372282 0.16681493619365995 7.7330109584208016 3.5157063858184867e-16 7.313084810732532 0 Z"
                            }
                        }
                    }
                    Shape {
                        id: _vector_13

                        x: 7.13
                        y: 7.13

                        height: 4.75
                        width: 4.75

                        ShapePath {
                            id: _vector_13_ShapePath0

                            fillColor: "#00000000"
                            strokeColor: "#990d0e0f"
                            strokeWidth: 1.39

                            PathSvg {
                                id: _vector_13_ShapePath0_PathSvg0

                                path: "M 4.75 2.375 C 4.75 3.68667629857858 3.68667629857858 4.75 2.375 4.75 C 1.0633237014214199 4.75 0 3.68667629857858 0 2.375 C 0 1.0633237014214199 1.0633237014214199 0 2.375 0 C 3.68667629857858 0 4.75 1.0633237014214199 4.75 2.375 Z"
                            }
                        }
                    }
                }
                Rectangle {
                    id: _text_6

                    x: 45
                    y: 12

                    height: 21
                    width: 92

                    color: "transparent"

                    Text {
                        id: configuraci_n

                        height: 21
                        width: 93

                        color: "#990d0e0f"
                        font.family: "Manrope"
                        font.letterSpacing: -0.16
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignLeft
                        lineHeight: 21
                        lineHeightMode: Text.FixedHeight
                        text: "Configuración"
                        textFormat: Text.PlainText
                        verticalAlignment: Text.AlignTop
                    }
                }
                Rectangle {
                    id: _text_7

                    y: 22.50

                    height: 0
                    width: 3

                    color: "#e59aa8"
                }
            }
        }
        Rectangle {
            id: salir_grupo

            x: 16
            y: 298

            height: 455.60
            width: 247.20

            color: "transparent"

            Rectangle {
                id: salir

                y: 386.60

                height: 69
                width: 247.20

                color: "transparent"

                Rectangle {
                    id: boton_salir

                    y: 24

                    height: 45
                    width: 247.20

                    color: "transparent"
                    radius: 16

                    Rectangle {
                        id: icon_6

                        x: 14
                        y: 13

                        height: 19
                        width: 19

                        clip: true
                        color: "transparent"

                        Shape {
                            id: _vector_14

                            x: 2.38
                            y: 2.38

                            height: 14.25
                            width: 4.75

                            ShapePath {
                                id: _vector_14_ShapePath0

                                fillColor: "#00000000"
                                strokeColor: "#660d0e0f"
                                strokeWidth: 1.39

                                PathSvg {
                                    id: _vector_14_ShapePath0_PathSvg0

                                    path: "M 4.75 14.25 L 1.5833333333333333 14.25 C 1.163407209018866 14.25 0.7606801129877567 14.08318469300866 0.4637475212415059 13.78625210126241 C 0.16681492949525517 13.489319509516159 3.515706244646329e-16 13.086592790981133 0 12.666666666666666 L 0 1.5833333333333333 C 0 1.163407209018866 0.16681492949525517 0.7606801129877567 0.4637475212415059 0.4637475212415059 C 0.7606801129877567 0.16681492949525517 1.163407209018866 3.515706244646329e-16 1.5833333333333333 0 L 4.75 0"
                                }
                            }
                        }
                        Shape {
                            id: _vector_15

                            x: 12.67
                            y: 5.54

                            height: 7.92
                            width: 3.96

                            ShapePath {
                                id: _vector_15_ShapePath0

                                fillColor: "#00000000"
                                fillRule: ShapePath.WindingFill
                                strokeColor: "#660d0e0f"
                                strokeWidth: 1.39

                                PathSvg {
                                    id: _vector_15_ShapePath0_PathSvg0

                                    path: "M 0 7.9166669845581055 L 3.9583334922790527 3.9583334922790527 L 0 0"
                                }
                            }
                        }
                        Shape {
                            id: _vector_16

                            x: 7.13
                            y: 9.50

                            height: 0
                            width: 9.50

                            ShapePath {
                                id: _vector_16_ShapePath0

                                fillColor: "#00000000"
                                strokeColor: "#660d0e0f"
                                strokeWidth: 1.39

                                PathSvg {
                                    id: _vector_16_ShapePath0_PathSvg0

                                    path: "M 9.5 0 L 0 0"
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: _text_8

                        x: 45
                        y: 12

                        height: 21
                        width: 29

                        color: "transparent"

                        Text {
                            id: salir_1

                            height: 21
                            width: 30

                            color: "#660d0e0f"
                            font.family: "Manrope"
                            font.letterSpacing: -0.16
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignLeft
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
    }
}