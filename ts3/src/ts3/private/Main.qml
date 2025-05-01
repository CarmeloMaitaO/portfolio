import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 800
    height: 600
    title: "TS3 Application"

    // Theme properties (bound from Nim)
    property color windowBackground: "#fbf1c7"
    property color headerBackground: "#282828"
    property color viewBackground1: "#f2e5bc"
    property color viewBackground2: "#d79921"
    property color viewBackground3: "#b16286"
    property color viewBackground4: "#e78a4e"
    property color bg: "#fbf1c7"
    property color bg0: "#f9f5d7"
    property color bg1: "#ebdbb2"
    property color bg2: "#d3869b"
    property color bg3: "#8ec07a"
    property color fg: "#3c3836"
    property color fg0: "#a89984"
    property color fg1: "#665c54"
    property color fg2: "#282828"
    property color buttonText: "#fbf1c7"
    property color buttonHover: "#bdae93"
    property color buttonDown: "#7c6f64"
    property color borderColor: "#a89984"
    property color linkColor: "#458588"

    // Apply theme to the main window
    backgroundColor: windowBackground

    // Function to call Nim's loadTheme (for demonstration)
    function loadThemeFromNim(themeName) {
        loadTheme(themeName); // Call the Nim function
    }

    header: Rectangle {
        height: 50
        color: headerBackground
        Label {
            text: "TS3 Application"
            anchors.centerIn: parent
            color: buttonText // Use a theme color
            font.pixelSize: 20
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors.margins: 10

        RowLayout {
            // width: parent.width
            // height: 50
            Button {
                text: "Load Gruvbox"
                onClicked: loadThemeFromNim("Gruvbox Dark Hard")
                // Apply theme to button.  Example of using the theme.
                color: headerBackground
                style: ButtonStyle {
                    label: Label {
                        color: buttonText
                        text: parent.text
                    }
                }

            }
            Button {
                text: "Load Base16"
                onClicked: loadThemeFromNim("Base16 Another")
                color: headerBackground
                 style: ButtonStyle {
                    label: Label {
                        color: buttonText
                        text: parent.text
                    }
                }
            }
            Button {
                text: "Load Beach"
                onClicked: loadThemeFromNim("Base24 Beach")
                color: headerBackground
                style: ButtonStyle {
                    label: Label {
                        color: buttonText
                        text: parent.text
                    }
                }
            }
        }

        // Main content area (example: a list of something)
        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Rectangle {
                width: parent.width
                color: viewBackground1
                ColumnLayout {
                    Repeater {
                        model: 10 // Example:  Create 10 items
                        delegate: Rectangle {
                            width: parent.width - 20
                            height: 50
                            color: (index % 2 === 0) ? viewBackground2 : viewBackground3 // Alternate background
                            Layout.margins: 10
                            Label {
                                text: "Item " + (index + 1)
                                anchors.centerIn: parent
                                color: fg
                            }
                            Rectangle{
                                width: 2
                                height: parent.height
                                color: borderColor
                                anchors.left:  parent.left
                            }
                        }
                    }
                    Rectangle{
                        width: parent.width
                        height: 2
                        color: borderColor
                    }
                }
            }
        }

        // Status bar (example)
        Rectangle {
            height: 30
            color: headerBackground
            Label {
                text: "Status: Ready"
                anchors.centerIn: parent
                color: buttonText
            }
        }
    }
}
