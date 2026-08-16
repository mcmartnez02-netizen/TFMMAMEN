import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
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

    // ------------------------------------------------------------------
    // Tipografías
    // ------------------------------------------------------------------
    //
    // Poppins y Manrope vienen en assets/ pero no están instaladas en el
    // sistema: sin registrarlas, cada `font.family` de esta pantalla caía en
    // silencio al sans-serif por defecto y el diseño se veía con otra letra.
    //
    // Los ficheros Light declaran una familia heredada propia ("Poppins
    // Light"), pero también la familia tipográfica "Poppins" con su peso; Qt
    // registra ambas, así que basta con `font.family: "Poppins"` y el
    // `font.weight` elige la cara correcta. Para añadir otro grosor, basta con
    // otro FontLoader apuntando al fichero: no hay que tocar los Text.
    FontLoader { source: Qt.resolvedUrl("assets/poppins/Poppins-Light.ttf") }
    FontLoader { source: Qt.resolvedUrl("assets/poppins/Poppins-Regular.ttf") }
    FontLoader { source: Qt.resolvedUrl("assets/manrope/manrope-light.otf") }
    FontLoader { source: Qt.resolvedUrl("assets/manrope/manrope-regular.otf") }

    // ------------------------------------------------------------------
    // Estados de la simulación
    // ------------------------------------------------------------------
    //
    // El HeartRateSimulator vive en cuatro estados (HR_State en
    // wearable/readings.py) y el controlador emite stateChanged cada vez que
    // cambia. `controller.simulatorState` devuelve el valor del enum como
    // cadena ("Estresado", "Sensible", ...), que es justo lo que espera el
    // `state` de un Item: enlazándolo, la señal mueve la pantalla entera.
    //
    // Ningún elemento visual mira al controlador directamente. Todos se
    // enlazan a las cinco propiedades de abajo, y los State sólo tienen que
    // reescribirlas: así los assets de cada estado quedan juntos en un único
    // sitio en vez de repartidos en un ternario por cada Text, Image y serie.
    property color accentColor: "#e59aa8"
    property string estadoTexto: qsTr("Sereno")
    property string estadoDescripcion: ""
    property url orbeSource: Qt.resolvedUrl("assets/container_1.png")
    property url haloSource: Qt.resolvedUrl("assets/container.png")

    // Sin `state` explícito arriba: los valores por defecto de las propiedades
    // cubren el arranque, antes de la primera lectura del simulador.
    state: controller.simulatorState

    states: [
        State {
            name: "Estresado"
            PropertyChanges {
                modo_instalacion.accentColor: "#d4573f"
                modo_instalacion.estadoTexto: qsTr("Estresado")
                modo_instalacion.estadoDescripcion: qsTr("Ritmo acelerado. No se detecta presencia cercana.")
                modo_instalacion.orbeSource: Qt.resolvedUrl("assets/container_1.png")
                modo_instalacion.haloSource: Qt.resolvedUrl("assets/container.png")
            }
        },
        State {
            name: "Sensible"
            PropertyChanges {
                modo_instalacion.accentColor: "#e59aa8"
                modo_instalacion.estadoTexto: qsTr("Sensible")
                modo_instalacion.estadoDescripcion: qsTr("El ritmo reacciona. Se detecta presencia cercana.")
                modo_instalacion.orbeSource: Qt.resolvedUrl("assets/container_3.png")
                modo_instalacion.haloSource: Qt.resolvedUrl("assets/container_2.png")
            }
        },
        State {
            name: "Relajado"
            PropertyChanges {
                modo_instalacion.accentColor: "#7fb69a"
                modo_instalacion.estadoTexto: qsTr("Relajado")
                modo_instalacion.estadoDescripcion: qsTr("Ritmo estable. Se detecta presencia cercana.")
                modo_instalacion.orbeSource: Qt.resolvedUrl("assets/container_5.png")
                modo_instalacion.haloSource: Qt.resolvedUrl("assets/container_4.png")
            }
        },
        State {
            name: "Latente"
            PropertyChanges {
                modo_instalacion.accentColor: "#8f9ed4"
                modo_instalacion.estadoTexto: qsTr("Latente")
                modo_instalacion.estadoDescripcion: qsTr("Ritmo en reposo. No se detecta presencia cercana.")
                modo_instalacion.orbeSource: Qt.resolvedUrl("assets/container_7.png")
                modo_instalacion.haloSource: Qt.resolvedUrl("assets/container_6.png")
            }
        }
    ]

    // El cambio de estado es un salto seco: el color viaja gradualmente para
    // que la transición se lea como una transición y no como un parpadeo.
    Behavior on accentColor { ColorAnimation { duration: 600 } }

    // ------------------------------------------------------------------
    // Desplazamiento continuo de la estela
    // ------------------------------------------------------------------
    //
    // El controlador recalcula las x en cada lectura tomando la más reciente
    // como origen, así que toda la traza salta a la izquierda de golpe una vez
    // por latido. scrollOffset es lo que le queda por recorrer a ese salto, en
    // segundos de eje: al llegar una lectura se le resta el salto (con lo que
    // la traza se dibuja donde estaba, sin discontinuidad) y desde ahí se anima
    // hasta 0.
    //
    // Lo que se desplaza es el dato, no el eje. Mover la ventana del eje sería
    // más barato —un par de números en vez de repintar la serie— pero arrastra
    // consigo la rejilla y las etiquetas, que se deslizarían junto a la traza.
    // Con el eje clavado, la rejilla se queda quieta y sólo corre la línea.
    property real scrollOffset: 0

    readonly property real windowSpan: controller.windowSize - 1
    // Ventana visible, fija. Fuente única para el eje y para el polígono del
    // degradado, que se dibuja a mano y tiene que mapear igual.
    readonly property real xMin: -windowSpan
    readonly property real xMax: 0

    // Sin Behavior: la duración se recalcula en cada lectura para que la
    // velocidad sea constante (un segundo de eje por segundo real). Con una
    // duración fija, un latido largo dejaría la traza parada y uno corto la
    // haría dar un tirón.
    NumberAnimation {
        id: scrollAnim

        target: modo_instalacion
        property: "scrollOffset"
        to: 0
        easing.type: Easing.Linear
    }

    // Altura del marcador de la lectura más reciente, en lpm.
    //
    // El marcador no viaja con la traza: se queda clavado en x=0 y sólo sube y
    // baja. Y no hace falta inventarse el recorrido, porque la geometría lo
    // impone: al empezar el latido la lectura anterior cae justo sobre x=0 y al
    // terminar lo hace la nueva, así que interpolar linealmente entre sus dos
    // alturas, y en el mismo tiempo que dura el barrido, deja el punto
    // exactamente sobre la línea en todo momento.
    property real markerY: 0

    NumberAnimation {
        id: markerAnim

        target: modo_instalacion
        property: "markerY"
        easing.type: Easing.Linear
    }

    // Cada fotograma del barrido hay que reposicionar lo que se pinta.
    onScrollOffsetChanged: modo_instalacion.applyScroll()
    onMarkerYChanged: modo_instalacion.updateMarker()

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
            }

            // --- Gráfico ---
            // Único elemento con fillHeight: absorbe todo el espacio sobrante
            // al redimensionar la ventana.
            //
            // El GraphsView no va suelto en la columna sino dentro de este
            // Item: la propiedad por defecto de GraphsView es `seriesChildren`,
            // así que cualquier hijo declarado dentro se toma por una serie más
            // y no llega a dibujarse. El degradado necesita ser un hermano.
            Item {
                id: chartArea

                Layout.fillHeight: true
                Layout.fillWidth: true
                // Sin un mínimo, el bloque de pulsaciones y el orbe dejan al
                // gráfico una franja de unos pocos píxeles en ventanas
                // pequeñas y las etiquetas del eje Y se amontonan.
                Layout.minimumHeight: card.height * 0.3
                Layout.topMargin: 24 * modo_instalacion.ui

                // --- Degradado bajo la estela ---
                // QtGraphs no sabe rellenar una LineSeries con un degradado:
                // AreaSeries sólo admite un color plano. Así que el relleno se
                // dibuja aparte, con la misma lista de puntos que la estela.
                //
                // Va declarado antes que el GraphsView para quedar por debajo; como
                // el fondo del gráfico y el del área de trazado son transparentes,
                // el degradado asoma y la rejilla y la línea quedan encima.
                Shape {
                    id: areaFill

                    anchors.fill: parent

                    preferredRendererType: Shape.CurveRenderer

                    ShapePath {
                        // Negativo = sin trazo: el borde superior ya lo dibuja la
                        // LineSeries, que además se anima al llegar puntos.
                        strokeWidth: -1

                        fillGradient: LinearGradient {
                            id: areaGradient

                            // Vertical puro. Los extremos los fija rebuildArea():
                            // arranca en el punto más alto de la estela y muere en
                            // la base del área de trazado.
                            x1: 0
                            x2: 0

                            GradientStop { position: 0.0; color: Qt.alpha(modo_instalacion.accentColor, 0.35) }
                            GradientStop { position: 1.0; color: Qt.alpha(modo_instalacion.accentColor, 0.0) }
                        }

                        PathPolyline { id: areaPolyline }
                    }
                }

                GraphsView {
                    id: chart

                    anchors.fill: parent

                    antialiasing: true

                    // El marcador más reciente cae justo sobre x=0; sin esto el
                    // borde del área de trazado lo corta por la mitad.
                    clipPlotArea: false
                    marginRight: 12

                    // El área de trazado sólo existe una vez medido el gráfico, y
                    // vuelve a moverse en cada redimensionado: el degradado se
                    // recalcula con ella.
                    onPlotAreaChanged: modo_instalacion.applyScroll()

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
                        max: modo_instalacion.xMax
                        min: modo_instalacion.xMin
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

                        color: modo_instalacion.accentColor
                        width: 3
                    }

                    // Marca la lectura más reciente; la estela por sí sola no la
                    // distingue. Comparte accentColor con la estela: al cambiar de
                    // estado se tiñe toda la traza, no sólo el tramo nuevo.
                    ScatterSeries {
                        id: latest

                        pointDelegate: Component {
                            Rectangle {
                                border.color: "#ffffff"
                                border.width: 2
                                color: modo_instalacion.accentColor
                                height: 14
                                radius: 7
                                width: 14
                            }
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
                    // y va centrado sobre ella. Los PNG de cada estado no
                    // comparten tamaño (212, 248, 277...), así que se fuerza la
                    // caja de diseño y PreserveAspectFit los encaja dentro.
                    Image {
                        id: container

                        anchors.centerIn: parent

                        height: 212 * modo_instalacion.ui
                        width: 212 * modo_instalacion.ui

                        fillMode: Image.PreserveAspectFit
                        source: modo_instalacion.haloSource
                    }
                    Image {
                        id: container_1

                        anchors.fill: parent

                        fillMode: Image.PreserveAspectFit
                        source: modo_instalacion.orbeSource
                    }
                }
                Text {
                    id: sereno

                    Layout.alignment: Qt.AlignHCenter

                    color: modo_instalacion.accentColor
                    font.family: "Manrope"
                    font.letterSpacing: -0.16
                    font.pixelSize: Math.round(28 * modo_instalacion.ui)
                    font.weight: Font.Light
                    // controller.stateText es texto de depuración en inglés
                    // ("Resting"); esta pantalla es de cara al público, así que
                    // el rótulo sale del State y no del controlador.
                    text: modo_instalacion.estadoTexto
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
                    text: modo_instalacion.estadoDescripcion
                    textFormat: Text.PlainText
                }
            }
        }
    }

    // `points` es una lista simple, no un modelo: hay que volver a pintar "a mano".
    function redraw() {
        modo_instalacion.startBeat(controller.points);
        modo_instalacion.applyScroll();
        // Por si markerY no ha cambiado de valor (dos lecturas iguales) y su
        // manejador no ha llegado a dispararse.
        modo_instalacion.updateMarker();
    }

    // Vuelca los puntos del controlador en la escena corridos scrollOffset a la
    // derecha. Se ejecuta en cada fotograma del barrido, así que evita rehacer
    // las series cuando basta con reemplazar sus puntos: replace() sobre la
    // lista entera es una sola llamada, mientras que clear() + append() en
    // bucle son casi doscientas por fotograma.
    function applyScroll() {
        var pts = controller.points;
        var off = modo_instalacion.scrollOffset;

        // La traza se corta en x=0 y termina en el propio marcador. Si no, el
        // tramo que está entrando asoma a su derecha, por el margen: línea
        // dibujada después del "ahora", que además deja el punto colgando en
        // mitad de la curva en vez de rematándola.
        //
        // El remate no hay que calcularlo: markerY ya es, por construcción, el
        // valor de la línea en x=0.
        var shifted = [Qt.point(0, modo_instalacion.markerY)];
        for (var i = 0; i < pts.length; ++i) {
            var x = pts[i].x - off;
            if (x < 0)
                shifted.push(Qt.point(x, pts[i].y));
        }

        if (trail.count === shifted.length)
            trail.replace(shifted);
        else {
            trail.clear();
            trail.append(shifted);
        }

        modo_instalacion.rebuildArea(shifted);
    }

    // El marcador se queda en x=0 pase lo que pase; sólo le cambia la altura,
    // que anima markerY. Va aparte de applyScroll() porque las dos animaciones
    // avanzan por su cuenta y cada una repinta lo suyo.
    function updateMarker() {
        if (controller.points.length === 0) {
            latest.clear();
            return;
        }

        if (latest.count === 1)
            latest.replace(0, 0, modo_instalacion.markerY);
        else {
            latest.clear();
            latest.append(0, modo_instalacion.markerY);
        }
    }

    // Relanza el barrido y el ascenso del marcador tras recibir una lectura.
    function startBeat(pts) {
        if (pts.length === 0)
            return;

        scrollAnim.stop();
        markerAnim.stop();

        // Con una sola lectura no hay latido anterior desde el que interpolar:
        // el marcador se coloca de golpe y no hay nada que barrer todavía.
        if (pts.length < 2) {
            modo_instalacion.markerY = pts[0].y;
            return;
        }

        // pts[1] es la lectura que hasta ahora era la más reciente y estaba en
        // x=0: su nueva x es justo lo que ha encogido la ventana.
        var shift = -pts[1].x;
        if (shift <= 0)
            return;

        // Se resta, no se asigna: si la animación anterior no había terminado,
        // ese resto sigue pendiente y se arrastra en vez de descartarse, que es
        // lo que provocaría el tirón. El tope de dos saltos evita que un parón
        // largo acumule un retraso del que ya no se recupera.
        modo_instalacion.scrollOffset = Math.max(modo_instalacion.scrollOffset - shift, -2 * shift);

        // Un segundo de eje por segundo real: el eje X está en segundos, así
        // que la duración en ms es el propio recorrido pendiente por 1000.
        var duration = Math.max(1, Math.round(-modo_instalacion.scrollOffset * 1000));

        scrollAnim.duration = duration;
        scrollAnim.start();

        // Misma duración para las dos: es lo que mantiene el marcador pegado a
        // la línea en lugar de ir por delante o por detrás de ella.
        markerAnim.to = pts[0].y;
        markerAnim.duration = duration;
        markerAnim.start();
    }

    // Rehace el polígono del degradado: la estela más una bajada recta hasta la
    // base del área de trazado por los dos extremos.
    //
    // Los puntos vienen en unidades de los ejes, no en píxeles, y QtGraphs no
    // expone ningún mapToPosition en QML; se convierten a mano contra
    // chart.plotArea, que es el rectángulo real del trazado ya descontados
    // márgenes y etiquetas.
    // Recibe los puntos ya corridos por applyScroll(), no los del controlador:
    // el relleno tiene que viajar pegado a la línea.
    function rebuildArea(pts) {
        var pa = chart.plotArea;
        var xMin = modo_instalacion.xMin;
        var xSpan = modo_instalacion.xMax - xMin;
        var ySpan = axisY.max - axisY.min;

        // En el primer pase el gráfico aún no está medido y los ejes pueden
        // seguir a cero: sin puntos no hay polígono que cerrar.
        if (pts.length < 2 || pa.width <= 0 || pa.height <= 0 || xSpan <= 0 || ySpan <= 0) {
            areaPolyline.path = [];
            return;
        }

        var bottom = pa.y + pa.height;
        var top = bottom;
        var poly = [];

        // `points` llega del más reciente al más antiguo; se recorre al revés
        // para que el polígono avance de izquierda a derecha.
        for (var i = pts.length - 1; i >= 0; --i) {
            var px = pa.x + (pts[i].x - xMin) / xSpan * pa.width;
            var py = pa.y + (axisY.max - pts[i].y) / ySpan * pa.height;
            if (py < top)
                top = py;
            poly.push(Qt.point(px, py));
        }

        poly.push(Qt.point(poly[poly.length - 1].x, bottom));
        poly.push(Qt.point(poly[0].x, bottom));
        areaPolyline.path = poly;

        // El degradado se ancla a la cresta de la estela, no al borde del área:
        // si arrancase arriba del todo, el tramo visible ya empezaría medio
        // desvanecido y el relleno se leería plano.
        areaGradient.y1 = top;
        areaGradient.y2 = bottom;
    }


    Connections {
        target: controller
        function onPointsChanged() { modo_instalacion.redraw() }
    }
}
