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

<!-- NAVBAR -->
<div class="navbar">
    <h2>Editar Libro</h2>
    <a href="gestionar_libros.php" class="btn-volver">Volver</a>
</div>

<!-- CONTENIDO -->
<div class="container">

    <h3>Editar información del libro</h3>

    <form method="POST" class="formulario">

        <label for="titulo">Título</label>
        <input type="text" id="titulo" name="titulo"
               value="<?= htmlspecialchars($libro['titulo']) ?>" required>

        <label for="isbn">ISBN</label>
        <input type="text" id="isbn" name="isbn"
               value="<?= htmlspecialchars($libro['isbn']) ?>" required>

        <label for="anio">Año de publicación</label>
        <input type="number" id="anio" name="anio"
               value="<?= $libro['anio_publicacion'] ?>" required>

        <label for="total">Ejemplares totales</label>
        <input type="number" id="total" name="ejemplares_totales"
               value="<?= $libro['ejemplares_totales'] ?>" required>

        <label for="disponibles">Ejemplares disponibles</label>
        <input type="number" id="disponibles" name="ejemplares_disponibles"
               value="<?= $libro['ejemplares_disponibles'] ?>" min="0" required>

        <label for="estado">Estado</label>
        <select name="estado" id="estado">
            <option value="Disponible" <?= $libro['estado']=='Disponible' ? 'selected' : '' ?>>
                Disponible
            </option>
            <option value="No disponible" <?= $libro['estado']=='No disponible' ? 'selected' : '' ?>>
                No disponible
            </option>
        </select>

        <div class="acciones">
            <button type="submit" class="btn btn-submit">
                Guardar cambios
            </button>

            <a href="gestionar_libros.php" class="btn btn-volver">
                Cancelar
            </a>
        </div>

    </form>

</div>

</body>
</html>
