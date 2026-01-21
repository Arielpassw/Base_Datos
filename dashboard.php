<?php
session_start();

/* Validar sesión */
if (!isset($_SESSION["usuario_id"])) {
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
    <title>Dashboard - Biblioteca</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <h2>Sistema Bibliotecario</h2>
    <a href="logout.php" class="btn-volver">Cerrar sesión</a>
</div>

<!-- CONTENIDO -->
<div class="container">
    <h3>Bienvenido, <?= htmlspecialchars($nombre) ?></h3>
    <p>Rol: <b><?= htmlspecialchars($tipo) ?></b></p>

    <ul class="menu">
        <!-- PARA TODOS -->
        <li><a href="listar_libros.php">Ver libros disponibles</a></li>

        <!-- ESTUDIANTES -->
        <?php if ($tipo === "Estudiante") { ?>
            <li><a href="mis_prestamos.php">Mis préstamos</a></li>
        <?php } ?>

        <!-- ADMIN Y DOCENTE -->
        <?php if (in_array($tipo, ['Admin', 'Docente'])) { ?>
            <li><a href="prestamos.php">Ver préstamos</a></li>
            <li><a href="registrar_prestamo.php">Registrar préstamo</a></li>
            <li><a href="registrar_usuario.php">Registrar usuario</a></li>
            <li><a href="gestionar_libros.php">Gestionar libros</a></li>
        <?php } ?>
    </ul>
</div>

</body>
</html>
