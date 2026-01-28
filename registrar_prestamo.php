<?php
session_start();

if (!isset($_SESSION["usuario_id"])) {
    header("Location: login.php");
    exit;
}

require_once "conexion.php";

// Obtener usuarios (solo Estudiantes)
$sql_usuarios = "SELECT id_usuario, nombre, tipo_usuario FROM usuario WHERE tipo_usuario='Estudiante' ORDER BY nombre";
$result_usuarios = pg_query($conn, $sql_usuarios);
$usuarios = pg_fetch_all($result_usuarios);

// Obtener libros disponibles
$sql_libros = "SELECT id_libro, titulo, ejemplares_disponibles FROM libro WHERE ejemplares_disponibles > 0 ORDER BY titulo";
$result_libros = pg_query($conn, $sql_libros);
$libros = pg_fetch_all($result_libros);

// Registrar préstamo
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_usuario = $_POST["id_usuario"];
    $id_libro = $_POST["id_libro"];
    $fecha_dev = $_POST["fecha_devolucion"];

    pg_query($conn, "BEGIN");

    $sql1 = "INSERT INTO prestamo (fecha_devolucion, estado, id_usuario, id_libro)
             VALUES ($1, 'Prestado', $2, $3)";
    $r1 = pg_query_params($conn, $sql1, [$fecha_dev, $id_usuario, $id_libro]);

    $sql2 = "UPDATE libro
             SET ejemplares_disponibles = ejemplares_disponibles - 1
             WHERE id_libro = $1 AND ejemplares_disponibles > 0";
    $r2 = pg_query_params($conn, $sql2, [$id_libro]);

    if ($r1 && $r2) {
        pg_query($conn, "COMMIT");
        $msg = "Préstamo registrado con éxito";
        $msg_class = "alert-success";
    } else {
        pg_query($conn, "ROLLBACK");
        $msg = "Error en la transacción";
        $msg_class = "alert-error";
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Préstamo</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<div class="navbar">
    <h2>Registrar Préstamo</h2>
    <a href="dashboard.php" class="btn-volver">Volver</a>
</div>

<div class="container">
    <form method="POST" class="formulario">
        <label for="id_usuario">Selecciona Usuario:</label>
        <select id="id_usuario" name="id_usuario" required>
            <option value="">-- Seleccionar Estudiante --</option>
            <?php foreach ($usuarios as $u): ?>
                <option value="<?= $u['id_usuario'] ?>"><?= htmlspecialchars($u['nombre']) ?></option>
            <?php endforeach; ?>
        </select>

        <label for="id_libro">Selecciona Libro:</label>
        <select id="id_libro" name="id_libro" required>
            <option value="">-- Seleccionar Libro --</option>
            <?php foreach ($libros as $l): ?>
                <option value="<?= $l['id_libro'] ?>">
                    <?= htmlspecialchars($l['titulo']) ?> (Disponibles: <?= $l['ejemplares_disponibles'] ?>)
                </option>
            <?php endforeach; ?>
        </select>

        <label for="fecha_devolucion">Fecha de Devolución:</label>
        <input type="date" id="fecha_devolucion" name="fecha_devolucion" required>

        <button type="submit" class="btn-submit">Registrar Préstamo</button>
    </form>

    <?php if (isset($msg)) { ?>
        <div class="alert <?= $msg_class ?>"><?= htmlspecialchars($msg) ?></div>
    <?php } ?>
</div>

</body>
</html>

<?php
if (isset($conn)) pg_close($conn);
?>
