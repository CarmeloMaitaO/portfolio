// Calendario.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "."

Item {
    Rectangle {
        anchors.fill: parent
        color: Theme.viewBackground3 // Púrpura Gruvbox
        Text {
            text: "Vista de Calendario"
            anchors.centerIn: parent
            color: Theme.fg
            font.pixelSize: 24
        }
    }
}
