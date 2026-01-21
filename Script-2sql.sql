-- CREACIÓN DE TABLAS 

-- Tabla categoria
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla autor
CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

-- Tabla usuarios
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cedula VARCHAR(10) NOT NULL UNIQUE,
    correo VARCHAR(100) UNIQUE,
    telefono VARCHAR(15),
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('Estudiante', 'Docente', 'Externo')),
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(10) NOT NULL CHECK (estado IN ('Activo', 'Inactivo'))
);

-- Modificación de la Tabla usuarios 
ALTER TABLE usuario
ADD COLUMN password_hash VARCHAR(255);


UPDATE usuario 
SET password_hash = '$2y$10$4Ex8zFpAzqgwABV680497eBhNp61RGRjizPGxVFa6pDO8wlVK9kBC'
WHERE correo = 'juan@mail.com';
SELECT correo, password_hash FROM usuario WHERE correo='juan@mail.com';

select * from usuario u ;


-- Tabla libro
CREATE TABLE libro (
    id_libro SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    anio_publicacion INT CHECK (anio_publicacion >= 1500),
    ejemplares_totales INT NOT NULL CHECK (ejemplares_totales > 0),
    ejemplares_disponibles INT NOT NULL CHECK (ejemplares_disponibles >= 0),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Disponible', 'No disponible')),
    id_categoria INT NOT NULL,
    CONSTRAINT fk_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Tabla Libro_autor
CREATE TABLE libro_autor (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES libro(id_libro)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Tabla prestamo
CREATE TABLE prestamo (
    id_prestamo SERIAL PRIMARY KEY,
    fecha_prestamo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_devolucion DATE NOT NULL,
    fecha_entrega DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Prestado', 'Devuelto', 'Retrasado')),
    id_usuario INT NOT NULL,
    id_libro INT NOT NULL,
    CONSTRAINT fk_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_libro
        FOREIGN KEY (id_libro)
        REFERENCES libro(id_libro)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Vizualición de las tablas creadas 
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- REGISTROS 

-- Ingresos Categoria 
INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Ciencia', 'Libros científicos y académicos'),
('Literatura', 'Novelas y cuentos'),
('Tecnología', 'Informática y sistemas'),
('Historia', 'Libros históricos');

--Ingresos Autor
INSERT INTO autor (nombre, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiano'),
('Isabel Allende', 'Chilena'),
('Stephen Hawking', 'Británico'),
('Robert Martin', 'Estadounidense');

-- Ingresos Usuario
INSERT INTO usuario (nombre, apellido, cedula, correo, telefono, tipo_usuario, estado) VALUES
('Juan', 'Pérez', '0102030405', 'juan@mail.com', '0991111111', 'Estudiante', 'Activo'),
('Ana', 'Gómez', '0102030406', 'ana@mail.com', '0992222222', 'Docente', 'Activo'),
('Luis', 'Martínez', '0102030407', 'luis@mail.com', '0993333333', 'Externo', 'Activo');

 -- Ingresos Libro 
INSERT INTO libro (titulo, isbn, anio_publicacion, ejemplares_totales, ejemplares_disponibles, estado, id_categoria) VALUES
('Cien años de soledad', 'ISBN001', 1967, 5, 3, 'Disponible', 2),
('La casa de los espíritus', 'ISBN002', 1982, 4, 2, 'Disponible', 2),
('Breve historia del tiempo', 'ISBN003', 1988, 3, 1, 'Disponible', 1),
('Clean Code', 'ISBN004', 2008, 6, 6, 'Disponible', 3);

-- Ingresos Libro_autor
INSERT INTO libro_autor (id_libro, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- Ingresos Prestamos
INSERT INTO prestamo (fecha_devolucion, estado, id_usuario, id_libro) VALUES
('2026-01-20', 'Prestado', 1, 1),
('2026-01-18', 'Devuelto', 2, 2),
('2026-01-15', 'Retrasado', 3, 3);


-- 4. CONSULTAS Y OPERACIONES 

-- SIMPLE 
SELECT * FROM libro;

-- CON CONDICION 
SELECT titulo, ejemplares_disponibles from libro 
where ejemplares_disponibles>0; 

-- JOINs 

-- Libros y Categorias
select l.titulo, c.nombre_categoria
from libro l 
join categoria c on l.id_categoria=c.id_categoria; 

-- Libros y Autores
select l.titulo, a.nombre as Autor
from libro l 
join libro_autor la on l.id_libro=la.id_libro
join autor a on la.id_autor=a.id_autor;

-- Prestamos y Usarios 
select u.nombre, u.apellido, p.fecha_prestamo, p.estado
from prestamo p 
join usuario u on p.id_usuario=u.id_usuario;

-- Prestamos, Libros y Usuarios 
select u.nombre, l.titulo, p.fecha_devolucion
from prestamo p 
join usuario u on p.id_usuario=u.id_usuario
join libro l on p.id_libro=l.id_libro;

-- Usuarios, Prestamos y Estados 
select u.nombre, COUNT(p.id_prestamo) as Total_prestamos
from usuario u 
left join prestamo p on u.id_usuario=p.id_usuario
group by u.nombre;

-- Libros, Autores y Categorias 
select l.titulo, a.nombre as Autor, c.nombre_categoria
from libro l 
join libro_autor la on l.id_libro=la.id_libro
join autor a on la.id_autor=a.id_autor
join categoria c on l.id_categoria=c.id_categoria;


-- Funciones 
select COUNT(*) as total_prestamos from prestamo;

select AVG(ejemplares_disponibles) as promedio_disponibles 
from libro;

-- Funciones de Cadena 
select UPPER(nombre) as nombre_mayusculas,
LENGTH(correo) as longitud_correo 
from usuario;

-- Subconsultas 
select titulo
from libro 
where id_libro in(
		select id_libro
		from prestamo
		where estado='Retrasado'
);


-- Vistas
create view  vw_prestamos_activos as 
select u.nombre,l.titulo,p.fecha_devolucion
from prestamo p
join usuario u on p.id_usuario=u.id_usuario
join libro l on p.id_libro=l.id_libro
where p.estado='Prestado';

select*from vw_prestamos_activos;

-- Operaciones CRUD 
insert into categoria(nombre_categoria, descripcion)
values ('Filosofia','Libros filosóficos');

update libro 
set ejemplares_disponibles=ejemplares_disponibles-1
where id_libro=1;

delete from prestamo 
where estado ='Devuelto';

SELECT current_user;


-- 5.	ADMINISTRACIÓN Y SEGURIDAD 

-- Simulación de roles  
-- ADMINISTRADOR 

GRANT ALL PRIVILEGES ON
libro, usuario, prestamo, autor, categoria, libro_autor
TO uopjjbtugtnt5ilyi0t3;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO uopjjbtugtnt5ilyi0t3;

-- BIBLIOTECARIO 
GRANT SELECT, INSERT, UPDATE ON
libro, usuario, prestamo
TO uopjjbtugtnt5ilyi0t3;

-- USUARIO 
GRANT SELECT ON
libro, autor, categoria
TO uopjjbtugtnt5ilyi0t3;


-- INDICES --
CREATE INDEX idx_usuario_cedula ON usuario(cedula);
CREATE INDEX idx_libro_titulo ON libro(titulo);
CREATE INDEX idx_prestamo_estado ON prestamo(estado);
CREATE INDEX idx_prestamo_usuario ON prestamo(id_usuario);

-- EXPLAIN --
--SIN EXPLAIN--
SELECT * FROM prestamo WHERE estado = 'Prestado';
-- CON EXPLAIN -- 
EXPLAIN
SELECT * FROM prestamo WHERE estado = 'Prestado';


-- PRUEBAS --

-- Prueba de rendimiento

EXPLAIN
SELECT u.nombre, l.titulo, p.fecha_prestamo
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN libro l ON p.id_libro = l.id_libro
WHERE p.estado = 'Prestado';

-- Pruebas de carga

INSERT INTO prestamo (fecha_devolucion, estado, id_usuario, id_libro)
SELECT
  CURRENT_DATE + 7,
  'Prestado',
  1,
  1
FROM generate_series(1, 1000);

select * from prestamo;

-- Pruebas de estrés

UPDATE prestamo
SET estado = 'Devuelto'
WHERE id_prestamo IN (
  SELECT id_prestamo FROM prestamo LIMIT 500
);


-- AUDITORÍAS

-- Tabla Auditoría
CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    tabla_afectada VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    usuario_bd VARCHAR(50) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    registro_id INT,
    descripcion TEXT
);

-- Función de auditoría (prestamo)
CREATE OR REPLACE FUNCTION fn_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria (
        tabla_afectada,
        operacion,
        usuario_bd,
        registro_id,
        descripcion
    )
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        current_user,
        CASE
            WHEN TG_OP = 'DELETE' THEN OLD.id_prestamo
            ELSE NEW.id_prestamo
        END,
        'Operación realizada sobre la tabla ' || TG_TABLE_NAME
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para INSERT
CREATE TRIGGER trg_auditoria_insert
AFTER INSERT ON prestamo
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria();


-- Trigger para UPDATE
CREATE TRIGGER trg_auditoria_update
AFTER UPDATE ON prestamo
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria();

-- Trigger para DELETE
CREATE TRIGGER trg_auditoria_delete
AFTER DELETE ON prestamo
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria();


-- PRUEBAS AUDITORÍA 

-- INSERT de prueba
INSERT INTO prestamo (fecha_devolucion, estado, id_usuario, id_libro)
VALUES ('2026-01-25', 'Prestado', 1, 1);

-- UPDATE prestamo
UPDATE prestamo
SET estado = 'Devuelto'
WHERE id_prestamo = 1;

-- DELETE de prueba
DELETE FROM prestamo
WHERE id_prestamo = 1;

-- Verificación de auditoría
SELECT * FROM auditoria ORDER BY fecha DESC;


select * from usuario u 














