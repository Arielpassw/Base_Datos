-- 1
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

-- 2
CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

-- 3
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

-- 4
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

-- 5
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

-- 6
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
-- -----------------------------------
-- tabla CATEGORIA
INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Ciencia', 'Libros científicos y académicos'),
('Literatura', 'Novelas y cuentos'),
('Tecnología', 'Informática y sistemas'),
('Historia', 'Libros históricos');

--tabla AUTOR
INSERT INTO autor (nombre, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiano'),
('Isabel Allende', 'Chilena'),
('Stephen Hawking', 'Británico'),
('Robert Martin', 'Estadounidense');

-- tabla USUARIO
INSERT INTO usuario (nombre, apellido, cedula, correo, telefono, tipo_usuario, estado) VALUES
('Juan', 'Pérez', '0102030405', 'juan@mail.com', '0991111111', 'Estudiante', 'Activo'),
('Ana', 'Gómez', '0102030406', 'ana@mail.com', '0992222222', 'Docente', 'Activo'),
('Luis', 'Martínez', '0102030407', 'luis@mail.com', '0993333333', 'Externo', 'Activo');

 -- tabla LIBRO 
INSERT INTO libro (titulo, isbn, anio_publicacion, ejemplares_totales, ejemplares_disponibles, estado, id_categoria) VALUES
('Cien años de soledad', 'ISBN001', 1967, 5, 3, 'Disponible', 2),
('La casa de los espíritus', 'ISBN002', 1982, 4, 2, 'Disponible', 2),
('Breve historia del tiempo', 'ISBN003', 1988, 3, 1, 'Disponible', 1),
('Clean Code', 'ISBN004', 2008, 6, 6, 'Disponible', 3);

-- tabla LIBRO_AUTOR
INSERT INTO libro_autor (id_libro, id_autor) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- tabla PRESTAMO 
INSERT INTO prestamo (fecha_devolucion, estado, id_usuario, id_libro) VALUES
('2026-01-20', 'Prestado', 1, 1),
('2026-01-18', 'Devuelto', 2, 2),
('2026-01-15', 'Retrasado', 3, 3);

-- CONSULTAS Y OPERACIONES 

-- SIMPLE 
SELECT * FROM libro;

-- CON CONDICION 
SELECT titulo, ejemplares_disponibles from libro 
where ejemplares_disponibles>0; 

-- JOINs 
-- libros y categorias
select l.titulo, c.nombre_categoria
from libro l 
join categoria c on l.id_categoria=c.id_categoria; 

-- libros y autores
select l.titulo, a.nombre as Autor
from libro l 
join libro_autor la on l.id_libro=la.id_libro
join autor a on la.id_autor=a.id_autor;

-- prestamos y usarios 
select u.nombre, u.apellido, p.fecha_prestamo, p.estado
from prestamo p 
join usuario u on p.id_usuario=u.id_usuario;

-- prestamos, libros y usuarios 
select u.nombre, l.titulo, p.fecha_devolucion
from prestamo p 
join usuario u on p.id_usuario=u.id_usuario
join libro l on p.id_libro=l.id_libro;

-- usuarios, prestamos y estados 
select u.nombre, COUNT(p.id_prestamo) as Total_prestamos
from usuario u 
left join prestamo p on u.id_usuario=p.id_usuario
group by u.nombre;

-- libros, autors y categorias 
select l.titulo, a.nombre as Autor, c.nombre_categoria
from libro l 
join libro_autor la on l.id_libro=la.id_libro
join autor a on la.id_autor=a.id_autor
join categoria c on l.id_categoria=c.id_categoria;


-- funciones 
select COUNT(*) as total_prestamos from prestamo;

select AVG(ejemplares_disponibles) as promedio_disponibles 
from libro;

-- funciones de cadena 
select UPPER(nombre) as nombre_mayusculas,
LENGTH(correo) as longitud_correo 
from usuario;

-- subconsultas 
select titulo
from libro 
where id_libro in(
		select id_libro
		from prestamo
		where estado='Retrasado'
);
)

-- vista 
create view  vw_prestamos_activos as 
select u.nombre,l.titulo,p.fecha_devolucion
from prestamo p
join usuario u on p.id_usuario=u.id_usuario
join libro l on p.id_libro=l.id_libro
where p.estado='Prestado';

select*from vw_prestamos_activos;

-- operaciones CRUD 
insert into categoria(nombre_categoria, descripcion)
values ('Filosofia','Libros filosóficos');

update libro 
set ejemplares_disponibles=ejemplares_disponibles-1
where id_libro=1;

delete from prestamo 
where estado ='Devuelto';