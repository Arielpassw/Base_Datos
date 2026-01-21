<?php
session_start();
require_once "conexion.php";

/* Validación de sesión */
if (!isset($_SESSION["usuario_id"]) || $_SESSION["tipo_usuario"] != "Externo") {
    if (isset($conn)) pg_close($conn);
    header("Location: login.php");
    exit;
}

$tipo = $_SESSION["tipo_usuario"];
$nombre = $_SESSION["nombre"] ?? "Usuario";
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Externo - Biblioteca</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <h2>Panel Externo</h2>
    <a href="logout.php" class="btn-volver">Cerrar sesión</a>
</div>

<!-- CONTENIDO -->
<div class="container">
    <h3>Bienvenido, <?= htmlspecialchars($nombre) ?> (<?= htmlspecialchars($tipo) ?>)</h3>

    <ul class="menu">
        <li><a href="registrar_prestamo.php">Registrar préstamos</a></li>
        <li><a href="registrar_devolucion.php">Registrar devoluciones</a></li>
        <li><a href="listar_libros.php">Ver libros disponibles</a></li>
    </ul>
</div>

</body>
</html>

<?php
/* Cerrar conexión */
if (isset($conn)) pg_close($conn);
?>
