// Search.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "."

Item {
    Rectangle {
        anchors.fill: parent
        color: Theme.viewBackground1 // Azul Gruvbox
        Text {
            text: "Vista de Búsqueda"
            anchors.centerIn: parent
            color: Theme.fg
            font.pixelSize: 24
        }
    }
}
