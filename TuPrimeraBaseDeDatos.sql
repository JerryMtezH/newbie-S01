#Crear Tabla:

CREATE TABLE usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre VARCHAR(64) NOT NULL,
  apellido  VARCHAR(64) NOT NULL,
  email VARCHAR(128) UNIQUE NOT NULL,
  fecha_nacimiento DATETIME NOT NULL,
  genero VARCHAR(10) NOT NULL
  );

#Insertar el primer Registro sin el campo apodo.

INSERT INTO usuarios
  (nombre, apellido, email, fecha_nacimiento, genero)
  VALUES
  ('Carlos', 'Ribero', 'carlos@yahoo.com', '1970-11-03', 'masculino');

#Consultar el registro.

SELECT * FROM usuarios;

#Modificar la tabla para añadir el campo apodo.

ALTER TABLE usuarios
  ADD COLUMN apodo VARCHAR(64) NOT NULL DEFAULT " ";

#Prueba para validar que no acepta nulos.

INSERT INTO usuarios
  (nombre, apellido, email, fecha_nacimiento, genero, apodo)
  VALUES
  ('Jorge', 'Ernesto', 'george@yahoo.com', '1970-11-03', 'masculino',
  NULL);

#Validacion del Nulo.
#Error: NOT NULL constraint failed: usuarios.apodo

#Insertar el registro sin nulo.

INSERT INTO usuarios
  (nombre, apellido, email, fecha_nacimiento, genero, apodo)
  VALUES
  ('Jorge', 'Ernesto', 'george@yahoo.com', '1970-11-03', 'masculino',
  	'george');

#Actualizar registro. 

UPDATE usuarios
  SET apodo='Charly'
  WHERE nombre='Carlos';