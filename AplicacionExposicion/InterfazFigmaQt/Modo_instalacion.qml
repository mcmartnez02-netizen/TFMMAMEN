import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtGraphs

// Pantalla de exposición en modo instalación.
//
// Reescrita a mano sobre la exportación de Figma: la versión original traía la
// maqueta de escritorio y la de móvil en el mismo archivo, todo posicionado con
// x/y absolutos sobre un lienzo de 2657x1244, y el "gráfico" era en realidad un
// PNG plano con el texto y el orbe ya incrustados. Aquí sólo queda la versión
// de escritorio, montada con Layouts y con un GraphsView real.
Rectangle {
    id: modo_instalacion

    // El diseño de Figma está hecho a 1920x1080. Escalamos tipografías, orbe y
    // márgenes con ese factor para que no se queden diminutos en una pantalla
    // grande ni desborden en una pequeña; los Layouts reparten el resto.
    //
    // Se mide contra la tarjeta y no contra la ventana: es la tarjeta la que
    // contiene el texto, y en ventanas grandes deja de crecer al llegar al
    // tamaño de diseño.
    readonly property real ui: Math.max(0.3, Math.min(1.0,
                                   Math.min(card.width / 1920, card.height / 1080)))

    signal exitRequested()

    color: "#f2f1f0"

    // Sombra de la tarjeta. MultiEffect oculta su source, así que la aplicamos
    // sobre un rectángulo fantasma en lugar de sobre la tarjeta real, que tiene
    // hijos interactivos.
    Rectangle {
        id: cardShadowSource

        anchors.fill: card
        color: "#ffffff"
        radius: card.radius
        visible: false
    }
    MultiEffect {
        anchors.fill: card
        source: cardShadowSource

        autoPaddingEnabled: true
        blurMax: 32
        shadowBlur: 1.0
        shadowColor: "#1a000000"
        shadowEnabled: true
        shadowVerticalOffset: 6
    }

    Rectangle {
        id: card

        anchors.centerIn: parent

        // La tarjeta crece con la ventana pero nunca pasa del tamaño de diseño.
        height: Math.min(parent.height - 2 * margin, 1080)
        width: Math.min(parent.width - 2 * margin, 1920)

        readonly property real margin: 32

        clip: true
        color: "#ffffff"
        radius: 24

        Item {
            id: grupo_exit

            anchors.right: parent.right
            anchors.rightMargin: 55 * modo_instalacion.ui
            anchors.top: parent.top
            anchors.topMargin: 55 * modo_instalacion.ui

            height: multiply.height * modo_instalacion.ui
            width: multiply.width * modo_instalacion.ui

            Multiply {
                id: multiply

                anchors.centerIn: parent
                opacity: exitArea.containsMouse ? 0.6 : 0.25
                scale: modo_instalacion.ui

                Behavior on opacity { NumberAnimation { duration: 120 } }
            }
            MouseArea {
                id: exitArea

                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: modo_instalacion.exitRequested()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.bottomMargin: 48 * modo_instalacion.ui
            anchors.leftMargin: 84 * modo_instalacion.ui
            anchors.rightMargin: 84 * modo_instalacion.ui
            anchors.topMargin: 70 * modo_instalacion.ui

            spacing: 0

            // --- Pulsaciones actuales ---
            RowLayout {
                id: gruponpulsac

                Layout.alignment: Qt.AlignHCenter
                spacing: 18 * modo_instalacion.ui

                Text {
                    id: element

                    color: "#000000"
                    font.family: "Poppins"
                    font.pixelSize: Math.round(200 * modo_instalacion.ui)
                    font.weight: Font.Light
                    text: controller.bpm > 0 ? controller.bpm : "--"
                    textFormat: Text.PlainText
                }
                Text {
                    id: textolpm

                    // Baja el "LPS" a la línea base del número en vez de
                    // centrarlo contra una cifra tres veces más alta.
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 34 * modo_instalacion.ui

                    color: "#696869"
                    font.family: "Manrope"
                    font.pixelSize: Math.round(70 * modo_instalacion.ui)
                    font.weight: Font.Light
                    text: qsTr("LPS")
                    textFormat: Text.PlainText
                }                

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

            // --- Gráfico ---
            // Único elemento con fillHeight: absorbe todo el espacio sobrante
            // al redimensionar la ventana.
            GraphsView {
                id: chart

                Layout.fillHeight: true
                Layout.fillWidth: true
                // Sin un mínimo, el bloque de pulsaciones y el orbe dejan al
                // gráfico una franja de unos pocos píxeles en ventanas
                // pequeñas y las etiquetas del eje Y se amontonan.
                Layout.minimumHeight: card.height * 0.3
                Layout.topMargin: 24 * modo_instalacion.ui

                antialiasing: true

                // El marcador más reciente cae justo sobre x=0; sin esto el
                // borde del área de trazado lo corta por la mitad.
                clipPlotArea: false
                marginRight: 12

                theme: GraphsTheme {
                    axisXLabelFont.pointSize: Math.max(7, Math.round(11 * modo_instalacion.ui))
                    axisYLabelFont.pointSize: Math.max(7, Math.round(11 * modo_instalacion.ui))
                    backgroundVisible: false
                    colorScheme: GraphsTheme.ColorScheme.Light
                    gridVisible: true
                    labelTextColor: "#696869"
                    plotAreaBackgroundVisible: false

                    grid.mainColor: "#e3e1df"
                    grid.mainWidth: 1
                    grid.subColor: "#e3e1df"

                    axisX.labelTextColor: "#696869"
                    axisX.mainColor: "#e3e1df"
                    axisX.subColor: "#e3e1df"

                    axisY.labelTextColor: "#696869"
                    axisY.mainColor: "#e3e1df"
                    axisY.subColor: "#e3e1df"
                }

                // QtGraphs formatea las etiquetas desde un double: %d no vale.
                axisX: ValueAxis {
                    id: axisX

                    labelFormat: "%.0fs"
                    max: 0
                    min: -(controller.windowSize - 1)
                    subGridVisible: false
                    subTickCount: 0
                    tickAnchor: 0
                    tickInterval: 10
                }

                axisY: ValueAxis {
                    id: axisY

                    labelFormat: "%.0f"
                    max: controller.yMax
                    min: controller.yMin
                    subGridVisible: false
                    subTickCount: 0
                    tickAnchor: 0
                    // Un rango de ~70 lpm en 10 en 10 no cabe en un gráfico bajo.
                    tickInterval: modo_instalacion.ui < 0.6 ? 20 : 10
                }

                LineSeries {
                    id: trail

                    color: controller.excited ? "#d4adbc" : "#e59aa8"
                    width: 3
                }

                // Marca la lectura más reciente; la estela por sí sola no la
                // distingue. Sólo este punto se tiñe según el estado, así que
                // las muestras pasadas nunca se repintan como excitadas.
                ScatterSeries {
                    id: latest

                    pointDelegate: Component {
                        Rectangle {
                            border.color: "#ffffff"
                            border.width: 2
                            color: controller.excited ? "#d4adbc" : "#e59aa8"
                            height: 14
                            radius: 7
                            width: 14
                        }
                    }
                }
            }

            // --- Orbe de estado ---
            ColumnLayout {
                id: bolaestado

                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 48 * modo_instalacion.ui

                spacing: 8 * modo_instalacion.ui

                Item {
                    id: bola

                    Layout.alignment: Qt.AlignHCenter

                    implicitHeight: 110 * modo_instalacion.ui
                    implicitWidth: 110 * modo_instalacion.ui

                    // El halo (212x212) es casi el doble que la esfera (110x110)
                    // y va centrado sobre ella.
                    Image {
                        id: container

                        anchors.centerIn: parent

                        height: 212 * modo_instalacion.ui
                        width: 212 * modo_instalacion.ui

                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl(controller.excited ? "assets/container_6.png" 
                                                                  : "assets/container.png")
                    }
                    Image {
                        id: container_1

                        anchors.fill: parent

                        fillMode: Image.PreserveAspectFit
                        source: Qt.resolvedUrl(controller.excited ? "assets/container_7.png"
                                                                  : "assets/container_1.png")
                    }
                }
                Text {
                    id: sereno

                    Layout.alignment: Qt.AlignHCenter

                    color: controller.excited ? "#d4adbc" : "#e59aa8"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: Math.round(28 * modo_instalacion.ui)
                    font.weight: Font.Light
                    // controller.stateText es texto de depuración en inglés
                    // ("Resting"); esta pantalla es de cara al público.
                    text: controller.excited ? qsTr("Excitado") : qsTr("Sereno")
                    textFormat: Text.PlainText
                }
                Text {
                    id: descripcion

                    Layout.alignment: Qt.AlignHCenter

                    color: "#990d0e0f"
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: Math.round(15 * modo_instalacion.ui)
                    font.weight: Font.Normal
                    text: qsTr("Ritmo estable. Se detecta presencia cercana.")
                    textFormat: Text.PlainText
                }
            }
        }
    }

    // `points` es una lista simple, no un modelo: hay que repintar a mano.
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
        function onPointsChanged() { modo_instalacion.redraw() }
    }
}
