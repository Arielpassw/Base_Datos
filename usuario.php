<?php
session_start();

/* SOLO estudiantes */
if (!isset($_SESSION["usuario_id"]) || $_SESSION["tipo_usuario"] !== "Estudiante") {
    header("Location: login.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Usuario - Biblioteca</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<div class="navbar">
    <h2>Sistema Bibliotecario</h2>
    <a href="dashboard.php" class="btn-volver">Volver</a>
</div>

<div class="container">
    <h3>Panel del Estudiante</h3>
    <p>Bienvenido <?= htmlspecialchars($_SESSION["nombre"] ?? "Estudiante") ?></p>

    <ul class="menu">
        <li><a href="listar_libros.php"> Ver catálogo</a></li>
        <li><a href="mis_prestamos.php"> Mis préstamos</a></li>
    </ul>
</div>

</body>
</html>
