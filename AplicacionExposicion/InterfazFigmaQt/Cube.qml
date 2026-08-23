import QtQuick

// Icono de pantalla completa, gemelo de Multiply.qml: mismo lienzo de
// 40.68x40.69, mismo glifo negro de 26.68 centrado en (7, 7) y misma opacidad
// de reposo, para que los dos botones de la esquina pesen igual y compartan
// color. El cubo se dibuja con un simple contorno cuadrado: la X de al lado es
// trazo negro sobre nada, y un relleno aquí rompería la pareja.
Rectangle {
    id: cube

    height: 40.68
    width: 40.69

    color: "transparent"
    opacity: 0.25

    Rectangle {
        x: 7
        y: 7

        height: 26.68
        width: 26.69

        border.color: "#000000"
        // El grosor de los brazos de la X ronda los 3 px en el lienzo de
        // diseño; el borde lo iguala para que ninguno de los dos se vea más
        // fino que el otro.
        border.width: 3
        color: "transparent"
        radius: 2
    }
}
