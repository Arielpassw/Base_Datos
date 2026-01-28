# Sistema de Gestion Bibliotecaria

Este proyecto consiste en el diseño e implementacion de una base de datos relacional para la administracion eficiente de un sistema bibliotecario, incluyendo la gestion de usuarios, libros, autores, categorias y el control automatizado de prestamos.

## Resumen General
- Proyecto: SISTEMA DE BIBLIOTECA
- Tecnologias: PostgreSQL, PHP, HTML, CSS
- Entorno: DBeaver, XAMPP, Clever Cloud
- Integrantes: Arias Ariel, Tana Emilia 

## Objetivos
### General
Diseñar, implementar y administrar una base de datos relacional utilizando un sistema gestor estándar, aplicando principios de modelado, normalización y seguridad, con el fin de resolver un caso práctico que simule necesidades reales de almacenamiento y gestión de información.


### Especificos
- Analizar requerimientos para identificar entidades como libros, usuarios y prestamos.
- Diseñar un modelo Entidad-Relacion normalizado hasta la Tercera Forma Normal (3FN).
- Implementar seguridad mediante roles, permisos y auditoria automatizada con triggers.

## Analisis y Modelado (3FN)
El sistema ha sido normalizado para evitar redundancias y garantizar la integridad de los datos.

### Entidades Principales:
- USUARIO: Gestion de estudiantes, docentes y externos.
- LIBRO: Control de ISBN, ejemplares totales y disponibilidad.
- PRESTAMO: Registro de fechas de salida, entrega y estados (Prestado/Devuelto/Retrasado).
- CATEGORIA / AUTOR: Clasificacion y autoria de los ejemplares.
- LIBRO_AUTOR: RELACIÓN N:M

## Implementacion SQL

### Creacion de Tablas Criticas
```sql
-- Ejemplo de tabla Libro
Tabla Libro
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


Tabla Categoría 
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

Tabla Autor
CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

Tabla Usuario
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

Tabla Libro_autor
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

Tabla Prestamos
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
```

## Roles
- Administrador
- Estudiante
- Docente

## Backups 
En este proyecto se realizo los siguientes backups: 
-  Backup Completo
-  Backup Caliente
-  Backup Incremental

# INTERFAZ GRAFICA (PHP)
La interfaz gráfica del Sistema Bibliotecario permite la interacción de los usuarios que cuentan con credenciales de acceso, garantizando un uso controlado y seguro del sistema. Su propósito principal es permitir que los usuarios con rol de Administrador y Docente registren nuevos usuarios, específicamente Estudiantes, generando credenciales que les permitan acceder y utilizar las funcionalidades del sistema bibliotecario de forma eficiente.

## Arquitectura de la interfaz 
•	Capa de presentación, encargada de la interacción con el usuario mediante interfaces gráficas desarrolladas en HTML y CSS.

•	Capa de lógica de negocio, implementada en PHP, responsable del procesamiento de la información y la gestión de las funcionalidades del sistema.

•	Capa de datos, donde se almacena la información en una base de datos PostgreSQL alojada en la nube.   

## Estructura del proyecto (interfaz gráfica)

<img width="451" height="665" alt="image" src="https://github.com/user-attachments/assets/dea8423b-d3b0-4921-9dd8-fe95b1f9ed2a" />


## Login 

<img width="489" height="351" alt="image" src="https://github.com/user-attachments/assets/42e57329-55b5-48ec-90e9-e62212a981c8" />

## Dashboard.php

<img width="853" height="360" alt="image" src="https://github.com/user-attachments/assets/350d0d46-6cef-460a-9aac-3bb0b7947e20" />

<img width="861" height="523" alt="image" src="https://github.com/user-attachments/assets/820661cb-12b4-4c7c-b0a0-495fdb1192dd" />

<img width="831" height="470" alt="image" src="https://github.com/user-attachments/assets/7cbc03a1-fdd1-4baa-a3e3-2d45230f1b0c" />

## Registar
<img width="466" height="453" alt="image" src="https://github.com/user-attachments/assets/058e1a55-20fe-4a7d-bf6f-f288efab42f3" />
<img width="539" height="165" alt="image" src="https://github.com/user-attachments/assets/e1e0e351-2bd6-417f-b495-2b186d0b855f" />


## ANEXO FRONTEND
https://app-ebe8dcd4-ecdc-48a2-9333-bc247672cd12.cleverapps.io/login.php  

## Video 
https://youtu.be/9bAM5Vh0fqc 










