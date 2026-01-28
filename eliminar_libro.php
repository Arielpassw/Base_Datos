<?php
session_start();

if (!isset($_SESSION['usuario_id']) || !in_array($_SESSION['tipo_usuario'], ['Admin','Docente'])) {
    header("Location: login.php");
    exit;
}

require_once "conexion.php";

if (!isset($_GET['id'])) {
    header("Location: gestionar_libros.php");
    exit;
}

$id_libro = (int) $_GET['id'];

pg_query_params($conn,
    "UPDATE libro SET estado='No disponible' WHERE id_libro=$1",
    [$id_libro]
);

header("Location: gestionar_libros.php");
exit;
