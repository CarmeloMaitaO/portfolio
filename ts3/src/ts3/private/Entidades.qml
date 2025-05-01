// Entidades.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "."

Item {
    Rectangle {
        anchors.fill: parent
        color: Theme.viewBackground2 // Verde Gruvbox
        Text {
            text: "Vista de Entidades"
            anchors.centerIn: parent
            color: Theme.fg
            font.pixelSize: 24
        }
    }
}
