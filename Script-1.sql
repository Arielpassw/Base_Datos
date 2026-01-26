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

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

select * from autor;

