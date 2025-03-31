import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import QtGraphicalEffects 1.13

ApplicationWindow {
    id: loginPage
    visible: true
    opacity: 0.8
    x: 732; y:245
    width: 456; height: 529
    color: "#3C096C"
    flags: Qt.FramelessWindowHint
    Component.onCompleted: ()=> Utils.applyRadius(loginPage, 20);
}
