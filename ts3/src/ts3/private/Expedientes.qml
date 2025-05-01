// Expedientes.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "."

Item {
    Rectangle {
        anchors.fill: parent
        color: Theme.viewBackground4 // Naranja Gruvbox
        Text {
            text: "Vista de Expedientes"
            anchors.centerIn: parent
            color: Theme.fg
            font.pixelSize: 24
        }
    }
}
