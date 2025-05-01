/* Tabla que contiene todas las personas del índice. Contiene tanto abogados como no abogados, siendo diferenciados por la posesión de impre */
CREATE TABLE IF NOT EXISTS "Personas" (
	-- Cédula de identidad de la persona
	"cedula" INTEGER NOT NULL UNIQUE,
	-- Impre del abogado (en caso de serlo)
	"impre" INTEGER UNIQUE,
	-- Nombres de la persona
	"nombres" VARCHAR NOT NULL,
	-- Apellidos de la persona
	"apellidos" VARCHAR NOT NULL,
	PRIMARY KEY("cedula"),
	FOREIGN KEY ("cedula") REFERENCES "Telefonos"("cedula")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("cedula") REFERENCES "Correos"("cedula")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("cedula") REFERENCES "Partes"("cedula")
	ON UPDATE CASCADE ON DELETE CASCADE
);

/* Teléfonos de cada persona. Una persona puede tener varios teléfonos */
CREATE TABLE IF NOT EXISTS "Telefonos" (
	-- Cédula de la persona
	"cedula" INTEGER NOT NULL UNIQUE,
	-- Teléfono de la persona
	"telefono" INTEGER NOT NULL UNIQUE DEFAULT 584,
	PRIMARY KEY("cedula", "telefono")
);

/* Correos de cada persona. Una persona puede tener varios correos */
CREATE TABLE IF NOT EXISTS "Correos" (
	-- Cédula de la persona
	"cedula" INTEGER NOT NULL UNIQUE,
	-- Correo de la persona
	"correo" VARCHAR UNIQUE,
	PRIMARY KEY("cedula")
);

/* Partes de un expediente. Cada persona ('cedula') está vínculada a un 'numero' de expediente y cumple con un rol ("parte") */
CREATE TABLE IF NOT EXISTS "Partes" (
	-- Cedula de la persona
	"cedula" INTEGER NOT NULL UNIQUE,
	-- Número del expediente
	"numero" INTEGER NOT NULL,
	-- Bitflag que representa qué rol desempeña la parte:
	-- 
	-- 0: demandado
	-- 1: abogado del demandado
	-- 2: demandante
	-- 3: abogado del demandante
	"parte" INTEGER NOT NULL,
	PRIMARY KEY("cedula", "numero", "parte")
);

/* Expedientes. Identificados por su número, poseen un "auto" (fecha de entrada), un "tipo" que define los lapsos procesales a los que se somete, un motivo (de la disputa) y una fecha de egreso una vez que se cumplan todos los lapsos procesales */
CREATE TABLE IF NOT EXISTS "Expedientes" (
	-- Número del expediente
	"numero" INTEGER NOT NULL UNIQUE,
	-- Fecha de entrada del expediente
	"auto" DATE NOT NULL,
	-- Bitflag que indica el tipo de expediente:
	-- 
	-- 0: interlocutorias
	-- 1: definitivas
	-- 2: breve
	-- 3: recusaciones
	"tipo" INTEGER NOT NULL,
	-- Motivo del expediente
	"motivo" TEXT NOT NULL,
	-- Fecha en la que sale el expediente según los datos de los días en los que se dió despacho y demás
	"egreso" DATE,
	PRIMARY KEY("numero"),
	FOREIGN KEY ("numero") REFERENCES "Partes"("numero")
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY ("numero") REFERENCES "Origen"("numero")
	ON UPDATE CASCADE ON DELETE CASCADE
);

/* Tribunal que origina el expediente */
CREATE TABLE IF NOT EXISTS "Origen" (
	-- Nombre del tribunal de origen
	"nombre" VARCHAR NOT NULL,
	-- Número del expediente
	"numero" INTEGER NOT NULL,
	PRIMARY KEY("nombre", "numero")
);

/* Tribunales conocidos */
CREATE TABLE IF NOT EXISTS "Tribunales" (
	-- Nombre del tribunal
	"nombre" VARCHAR NOT NULL UNIQUE,
	PRIMARY KEY("nombre"),
	FOREIGN KEY ("nombre") REFERENCES "Origen"("nombre")
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Dias" (
	-- Día que se está registrando
	"dia" DATE NOT NULL UNIQUE,
	-- Bitflag que indica qué tipo de día fue:
	-- 
	-- - 0: laboral con despacho
	-- - 1: laboral sin despacho
	-- - 2: no laboral
	-- - 3: feriado
	-- - 4: receso judicial
	"tipo" INTEGER NOT NULL,
	PRIMARY KEY("dia", "tipo")
);
