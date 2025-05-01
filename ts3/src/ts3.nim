# /home/chiguire/Documents/Projects/portfolio/ts3/src/ts3/ts3.nim
import std/os
import std/strutils
import std/colors
import std/tables
import std/sequtils
import sqlite3

# Check if nimqml is installed. If not, attempt to install it.
# This requires that the user has nim installed and configured correctly.
when not defined(nimqml):
  echo "nimqml is not installed. Attempting to install..."
  let result = execCmd("nimble install nimqml")
  if result != 0:
    echo "Failed to install nimqml. Please install it manually using 'nimble install nimqml' and try again."
    quit(1) # Quit the program if installation fails.
  else:
    echo "nimqml installed successfully."
    import nimqml # Import nimqml after successful installation

import qml

# Definir los colores del tema Gruvbox Dark Hard en Nim
const
  gruvboxDarkHard = {
    "windowBackground": "#fbf1c7",
    "headerBackground": "#282828",
    "viewBackground1": "#f2e5bc",
    "viewBackground2": "#d79921",
    "viewBackground3": "#b16286",
    "viewBackground4": "#e78a4e",
    "bg":           "#fbf1c7",
    "bg0":          "#f9f5d7",
    "bg1":          "#ebdbb2",
    "bg2":          "#d3869b",
    "bg3":          "#8ec07a",
    "fg":           "#3c3836",
    "fg0":          "#a89984",
    "fg1":          "#665c54",
    "fg2":          "#282828",
    "buttonText":   "#fbf1c7",
    "buttonHover":  "#bdae93",
    "buttonDown":   "#7c6f64",
    "borderColor":  "#a89984",
    "linkColor":    "#458588"
  }.toTable

# Definir los colores del tema Base16 Another en Nim
const
  base16Another = {
    "windowBackground": "#f8f8f2",
    "headerBackground": "#181818",
    "viewBackground1": "#f0f0f0",
    "viewBackground2": "#b5e51d",
    "viewBackground3": "#ff6ac1",
    "viewBackground4": "#ffb82e",
    "bg":           "#f8f8f2",
    "bg0":          "#f0f0f0",
    "bg1":          "#d8d8d8",
    "bg2":          "#a8a8a8",
    "bg3":          "#787878",
    "fg":           "#282828",
    "fg0":          "#484848",
    "fg1":          "#686868",
    "fg2":          "#181818",
    "buttonText":   "#f8f8f2",
    "buttonHover":  "#d8d8d8",
    "buttonDown":   "#a8a8a8",
    "borderColor":  "#a8a8a8",
    "linkColor":    "#4271ae"
  }.toTable

# Definir los colores del tema Base24 Beach
const
  base24Beach = {
    "windowBackground": "#fefee8",
    "headerBackground": "#1d2021",
    "viewBackground1": "#f6f4e5",
    "viewBackground2": "#b8bb26",
    "viewBackground3": "#fe6f81",
    "viewBackground4": "#fb4934",
    "bg":           "#fefee8",
    "bg0":          "#f6f4e5",
    "bg1":          "#eee8d5",
    "bg2":          "#d3869b",
    "bg3":          "#8ec07a",
    "fg":           "#1d2021",
    "fg0":          "#a89984",
    "fg1":          "#665c54",
    "fg2":          "#282828",
    "buttonText":   "#fefee8",
    "buttonHover":  "#eee8d5",
    "buttonDown":   "#d3869b",
    "borderColor":  "#a89984",
    "linkColor":    "#458588"
  }.toTable


# Función para cargar y aplicar el tema desde Nim
proc loadTheme(themeName: string) =
  echo "Cargando tema: " & themeName
  var themeData: Table[string, string]
  case themeName:
    of "Gruvbox Dark Hard":
      themeData = gruvboxDarkHard
    of "Base16 Another":
      themeData = base16Another
    of "Base24 Beach":
      themeData = base24Beach
    else:
      themeData = gruvboxDarkHard # Por defecto, usar Gruvbox

  # Actualizar las propiedades del tema en QML
  let engine = qmlEngine()
  let rootContext = engine.rootContext() # Get the root context
  for key, value in themeData.pairs:
    # Convert Nim string to QVariant
    let qmlValue = toQVariant(value)
    rootContext.setProperty(key, qmlValue)

# Función para inicializar la base de datos SQLite3
proc initializeDatabase() =
  let dbPath = "ts3.sqlite" # Nombre del archivo de la base de datos
  var db: sqlite3.Database
  if not fileExists(dbPath):
    # Crear la base de datos si no existe
    try:
      db = open(dbPath)
      echo "Base de datos creada en: " & dbPath

      # Crear las tablas necesarias
      db.exec """CREATE TABLE IF NOT EXISTS personas (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL
      );"""

      db.exec """CREATE TABLE IF NOT EXISTS tribunales (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        ubicacion TEXT NOT NULL
      );"""

      db.exec """CREATE TABLE IF NOT EXISTS expedientes (
        id INTEGER PRIMARY KEY,
        numero TEXT NOT NULL,
        fecha_inicio TEXT NOT NULL,
        tribunal_id INTEGER,
        FOREIGN KEY (tribunal_id) REFERENCES tribunales(id)
      );"""

      db.exec """CREATE TABLE IF NOT EXISTS dias_habiles (
        id INTEGER PRIMARY KEY,
        fecha TEXT NOT NULL UNIQUE,
        tipo TEXT NOT NULL
      );"""

    except Exception as e:
      echo "Error al crear la base de datos: " & e.message
    finally:
      db.close()
  else:
    echo "Base de datos existente encontrada en: " & dbPath



# Función para insertar una persona en la base de datos
proc insertarPersona(nombre, apellido: string) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("INSERT INTO personas (nombre, apellido) VALUES (?, ?)")
        stmt.bind(1, nombre)
        stmt.bind(2, apellido)
        stmt.step()
        echo "Persona insertada: nombre = " & nombre & ", apellido = " & apellido
    except Exception as e:
        echo "Error al insertar persona: " & e.message
    finally:
        db.close()

# Función para obtener todas las personas de la base de datos
proc obtenerPersonas(): seq[seq[string]] =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    var result: seq[seq[string]]
    try:
        db = open(dbPath)
        let stmt = db.prepare("SELECT id, nombre, apellido FROM personas")
        while stmt.step():
            let row = @[
              stmt.getText(0),
              stmt.getText(1),
              stmt.getText(2)
            ]
            result.add(row)
    except Exception as e:
        echo "Error al obtener personas: " & e.message
    finally:
        db.close()
    return result

# Función para actualizar una persona en la base de datos
proc actualizarPersona(id: int, nombre, apellido: string) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("UPDATE personas SET nombre = ?, apellido = ? WHERE id = ?")
        stmt.bind(1, nombre)
        stmt.bind(2, apellido)
        stmt.bind(3, id)
        stmt.step()
        echo "Persona actualizada: id = " & $id & ", nombre = " & nombre & ", apellido = " & apellido
    except Exception as e:
        echo "Error al actualizar persona: " & e.message
    finally:
        db.close()

# Función para eliminar una persona de la base de datos
proc eliminarPersona(id: int) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("DELETE FROM personas WHERE id = ?")
        stmt.bind(1, id)
        stmt.step()
        echo "Persona eliminada: id = " & $id
    except Exception as e:
        echo "Error al eliminar persona: " & e.message
    finally:
        db.close()

# Función para insertar un tribunal
proc insertarTribunal(nombre, ubicacion: string) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("INSERT INTO tribunales (nombre, ubicacion) VALUES (?, ?)")
        stmt.bind(1, nombre)
        stmt.bind(2, ubicacion)
        stmt.step()
        echo "Tribunal insertado: nombre = " & nombre & ", ubicacion = " & ubicacion
    except Exception as e:
        echo "Error al insertar tribunal: " & e.message
    finally:
        db.close()

# Función para obtener todos los tribunales
proc obtenerTribunales(): seq[seq[string]] =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    var result: seq[seq[string]]
    try:
        db = open(dbPath)
        let stmt = db.prepare("SELECT id, nombre, ubicacion FROM tribunales")
        while stmt.step():
            let row = @[stmt.getText(0), stmt.getText(1), stmt.getText(2)]
            result.add(row)
    except Exception as e:
        echo "Error al obtener tribunales: " & e.message
    finally:
        db.close()
    return result

# Función para actualizar un tribunal
proc actualizarTribunal(id: int, nombre, ubicacion: string) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("UPDATE tribunales SET nombre = ?, ubicacion = ? WHERE id = ?")
        stmt.bind(1, nombre)
        stmt.bind(2, ubicacion)
        stmt.bind(3, id)
        stmt.step()
        echo "Tribunal actualizado: id = " & $id & ", nombre = " & nombre & ", ubicacion = " & ubicacion
    except Exception as e:
        echo "Error al actualizar tribunal: " & e.message
    finally:
        db.close()

# Función para eliminar un tribunal
proc eliminarTribunal(id: int) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("DELETE FROM tribunales WHERE id = ?")
        stmt.bind(1, id)
        stmt.step()
        echo "Tribunal eliminado: id = " & $id
    except Exception as e:
        echo "Error al eliminar tribunal: " & e.message
    finally:
        db.close()

# Función para insertar un expediente
proc insertarExpediente(numero, fechaInicio: string, tribunalId: int) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("INSERT INTO expedientes (numero, fecha_inicio, tribunal_id) VALUES (?, ?, ?)")
        stmt.bind(1, numero)
        stmt.bind(2, fechaInicio)
        stmt.bind(3, tribunalId)
        stmt.step()
        echo "Expediente insertado: numero = " & numero & ", fecha_inicio = " & fechaInicio & ", tribunal_id = " & $tribunalId
    except Exception as e:
        echo "Error al insertar expediente: " & e.message
    finally:
        db.close()

# Función para obtener todos los expedientes
proc obtenerExpedientes(): seq[seq[string]] =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    var result: seq[seq[string]]
    try:
        db = open(dbPath)
        let stmt = db.prepare("SELECT id, numero, fecha_inicio, tribunal_id FROM expedientes")
        while stmt.step():
            let row = @[stmt.getText(0), stmt.getText(1), stmt.getText(2), stmt.getText(3)]
            result.add(row)
    except Exception as e:
        echo "Error al obtener expedientes: " & e.message
    finally:
        db.close()
    return result

# Función para actualizar un expediente
proc actualizarExpediente(id: int, numero, fechaInicio: string, tribunalId: int) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("UPDATE expedientes SET numero = ?, fecha_inicio = ?, tribunal_id = ? WHERE id = ?")
        stmt.bind(1, numero)
        stmt.bind(2, fechaInicio)
        stmt.bind(3, tribunalId)
        stmt.bind(4, id)
        stmt.step()
        echo "Expediente actualizado: id = " & $id & ", numero = " & numero & ", fecha_inicio = " & fechaInicio & ", tribunal_id = " & $tribunalId
    except Exception as e:
        echo "Error al actualizar expediente: " & e.message
    finally:
        db.close()

# Función para eliminar un expediente
proc eliminarExpediente(id: int) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("DELETE FROM expedientes WHERE id = ?")
        stmt.bind(1, id)
        stmt.step()
        echo "Expediente eliminado: id = " & $id
    except Exception as e:
        echo "Error al eliminar expediente: " & e.message
    finally:
        db.close()

# Función para insertar un día hábil
proc insertarDiaHabil(fecha, tipo: string) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("INSERT INTO dias_habiles (fecha, tipo) VALUES (?, ?)")
        stmt.bind(1, fecha)
        stmt.bind(2, tipo)
        stmt.step()
        echo "Día hábil insertado: fecha = " & fecha & ", tipo = " & tipo
    except Exception as e:
        echo "Error al insertar día hábil: " & e.message
    finally:
        db.close()

# Función para obtener todos los días hábiles
proc obtenerDiasHabiles(): seq[seq[string]] =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    var result: seq[seq[string]]
    try:
        db = open(dbPath)
        let stmt = db.prepare("SELECT id, fecha, tipo FROM dias_habiles")
        while stmt.step():
            let row = @[stmt.getText(0), stmt.getText(1), stmt.getText(2)]
            result.add(row)
    except Exception as e:
        echo "Error al obtener días hábiles: " & e.message
    finally:
        db.close()
    return result

# Función para actualizar un día hábil
proc actualizarDiaHabil(id: int, fecha, tipo: string) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("UPDATE dias_habiles SET fecha = ?, tipo = ? WHERE id = ?")
        stmt.bind(1, fecha)
        stmt.bind(2, tipo)
        stmt.bind(3, id)
        stmt.step()
        echo "Día hábil actualizado: id = " & $id & ", fecha = " & fecha & ", tipo = " & tipo
    except Exception as e:
        echo "Error al actualizar día hábil: " & e.message
    finally:
        db.close()

# Función para eliminar un día hábil
proc eliminarDiaHabil(id: int) =
    let dbPath = "ts3.sqlite"
    var db: sqlite3.Database
    try:
        db = open(dbPath)
        let stmt = db.prepare("DELETE FROM dias_habiles WHERE id = ?")
        stmt.bind(1, id)
        stmt.step()
        echo "Día hábil eliminado: id = " & $id
    except Exception as e:
        echo "Error al eliminar día hábil: " & e.message
    finally:
        db.close()

# Función para obtener los días hábiles para un mes y año dados
proc obtenerDiasHabilesPorMes(mes, año: int): seq[seq[string]] =
  let dbPath = "ts3.sqlite"
  var db: sqlite3.Database
  var result: seq[seq[string]]
  try:
    db = open(dbPath)
    # Crear una cadena de formato para la fecha
    let fechaInicio = $año & "-" & $mes.toStr.padStart(2, '0') & "-01"
    let fechaFin: string
    if mes == 12:
      fechaFin = $(año + 1) & "-01-01"
    else:
      fechaFin = $año & "-" & $(mes + 1).toStr.padStart(2, '0') & "-01"

    let stmt = db.prepare("SELECT id, fecha, tipo FROM dias_habiles WHERE fecha >= ? AND fecha < ?")
    stmt.bind(1, fechaInicio)
    stmt.bind(2, fechaFin)

    while stmt.step():
      let row = @[stmt.getText(0), stmt.getText(1), stmt.getText(2)]
      result.add(row)
  except Exception as e:
    echo "Error al obtener días hábiles por mes: " & e.message
  finally:
    db.close()
  return result

# Función principal del programa
proc main() =
  # Inicializar la aplicación Qt/QML
  let engine = newQmlEngine()

  # Exponer las funciones de la base de datos a QML.  Make sure the QML can call these
  engine.setContextProperty("insertarPersona", cast[QmlFunction](insertarPersona))
  engine.setContextProperty("obtenerPersonas", cast[QmlFunction](obtenerPersonas))
  engine.setContextProperty("actualizarPersona", cast[QmlFunction](actualizarPersona))
  engine.setContextProperty("eliminarPersona", cast[QmlFunction](eliminarPersona))

  engine.setContextProperty("insertarTribunal", cast[QmlFunction](insertarTribunal))
  engine.setContextProperty("obtenerTribunales", cast[QmlFunction](obtenerTribunales))
  engine.setContextProperty("actualizarTribunal", cast[QmlFunction](actualizarTribunal))
  engine.setContextProperty("eliminarTribunal", cast[QmlFunction](eliminarTribunal))

  engine.setContextProperty("insertarExpediente", cast[QmlFunction](insertarExpediente))
  engine.setContextProperty("obtenerExpedientes", cast[QmlFunction](obtenerExpedientes))
  engine.setContextProperty("actualizarExpediente", cast[QmlFunction](actualizarExpediente))
  engine.setContextProperty("eliminarExpediente", cast[QmlFunction](eliminarExpediente))

  engine.setContextProperty("insertarDiaHabil", cast[QmlFunction](insertarDiaHabil))
  engine.setContextProperty("obtenerDiasHabiles", cast[QmlFunction](obtenerDiasHabiles))
  engine.setContextProperty("actualizarDiaHabil", cast[QmlFunction](actualizarDiaHabil))
  engine.setContextProperty("eliminarDiaHabil", cast[QmlFunction](eliminarDiaHabil))
  engine.setContextProperty("obtenerDiasHabilesPorMes", cast[QmlFunction](obtenerDiasHabilesPorMes))
  engine.setContextProperty("loadTheme", cast[QmlFunction](loadTheme))


  engine.load("src/ts3/private/Main.qml")
  engine.exec()

# Punto de entrada del programa
main()
