// Theme.qml
pragma Singleton // Permite importar este objeto directamente por su nombre
import QtQuick 2.15

QtObject {
    // Gruvbox Dark Palette (aproximada)
    readonly property color bg: "#282828"        // Fondo principal oscuro
    readonly property color bg1: "#3c3836"       // Fondo ligeramente más claro
    readonly property color bg2: "#504945"       // Fondo medio
    readonly property color bg3: "#665c54"       // Fondo más claro
    readonly property color bg4: "#7c6f64"       // Fondo muy claro / Borde sutil
    readonly property color fg: "#ebdbb2"        // Texto principal (foreground)
    readonly property color fg1: "#d5c4a1"       // Texto secundario
    readonly property color gray: "#a89984"      // Gris neutro
    readonly property color red: "#fb4934"        // Rojo brillante
    readonly property color green: "#b8bb26"      // Verde brillante
    readonly property color yellow: "#fabd2f"     // Amarillo brillante
    readonly property color blue: "#83a598"       // Azul brillante
    readonly property color purple: "#d3869b"     // Púrpura brillante
    readonly property color aqua: "#8ec07c"       // Aqua brillante
    readonly property color orange: "#fe8019"     // Naranja brillante

    // Colores específicos de UI (puedes ajustarlos)
    readonly property color windowBackground: bg
    readonly property color headerBackground: bg1
    readonly property color buttonBackground: bg2
    readonly property color buttonHover: bg3
    readonly property color buttonText: fg
    readonly property color viewBackground1: blue // Para Search
    readonly property color viewBackground2: green // Para Entidades
    readonly property color viewBackground3: purple // Para Calendario
    readonly property color viewBackground4: orange // Para Expedientes
    readonly property color borderColor: bg4
}
