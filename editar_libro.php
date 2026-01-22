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

/* Obtener libro */
$res = pg_query_params(
    $conn,
    "SELECT * FROM libro WHERE id_libro = $1",
    [$id_libro]
);

if (pg_num_rows($res) !== 1) {
    header("Location: gestionar_libros.php");
    exit;
}

$libro = pg_fetch_assoc($res);

/* Actualizar libro */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $titulo = trim($_POST['titulo']);
    $isbn = trim($_POST['isbn']);
    $anio = (int) $_POST['anio'];
    $ejemplares_totales = (int) $_POST['ejemplares_totales'];
    $ejemplares_disponibles = (int) $_POST['ejemplares_disponibles'];
    $estado = $_POST['estado'];

    pg_query_params(
        $conn,
        "UPDATE libro SET
            titulo = $1,
            isbn = $2,
            anio_publicacion = $3,
            ejemplares_totales = $4,
            ejemplares_disponibles = $5,
            estado = $6
         WHERE id_libro = $7",
        [
            $titulo,
            $isbn,
            $anio,
            $ejemplares_totales,
            $ejemplares_disponibles,
            $estado,
            $id_libro
        ]
    );

    header("Location: gestionar_libros.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Editar Libro</title>
<link rel="stylesheet" href="estilos.css">
</head>
<body>

<h3>Editar Libro</h3>

<form method="POST">
    <input type="text" name="titulo"
           value="<?= htmlspecialchars($libro['titulo']) ?>" required>

    <input type="text" name="isbn"
           value="<?= htmlspecialchars($libro['isbn']) ?>" required>

    <input type="number" name="anio"
           value="<?= $libro['anio_publicacion'] ?>" required>

    <input type="number" name="ejemplares_totales"
           value="<?= $libro['ejemplares_totales'] ?>" required>

    <input type="number" name="ejemplares_disponibles"
           value="<?= $libro['ejemplares_disponibles'] ?>" required min="0">

    <select name="estado">
        <option value="Disponible" <?= $libro['estado']=='Disponible' ? 'selected' : '' ?>>
            Disponible
        </option>
        <option value="No disponible" <?= $libro['estado']=='No disponible' ? 'selected' : '' ?>>
            No disponible
        </option>
    </select>

    <div class="acciones">
        <button type="submit" class="btn btn-editar">
            Guardar Cambios
        </button>

    <button type="submit" class="btn btn-cancelar" href="gestionar_libros.php">Cancelar</button>
    </div>
</form>

</body>
</html>
