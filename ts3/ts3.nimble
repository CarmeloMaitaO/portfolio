# Package

version       = "0.1.0"
author        = "Carmelo Maita"
description   = "Administrador de lapsos judiciales"
license       = "MIT"
srcDir        = "src"
bin           = @["ts3"]


# Dependencies

requires "nim >= 2.2.2"
requires "norm >= 2.8.7"
requires "xl >= 1.1.0"
requires "nimqml >= 0.9.2"

task gui_test, "Runs the Main.qml file with the qml command":
  exec("qml src/ts3/private/Main.qml")
