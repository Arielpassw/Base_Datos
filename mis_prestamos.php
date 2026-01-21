<?php
session_start();

// Validar sesión
if (!isset($_SESSION['usuario_id'])) {
    header("Location: login.php");
    exit;
}

// Guardar datos del usuario
$id_usuario = $_SESSION['usuario_id'];
$nombre = $_SESSION['nombre'] ?? 'Usuario';
$tipo = $_SESSION['tipo_usuario'];

// Solo Estudiante puede acceder
if (!in_array($tipo, ['Estudiante'])) {
    header("Location: dashboard.php");
    exit;
}

require_once "conexion.php"; // Debe definir $conn

// Consulta SQL para obtener los préstamos del usuario
$sql = "SELECT p.id_prestamo, l.titulo, p.fecha_prestamo, p.fecha_devolucion, 
               p.fecha_entrega, p.estado
        FROM prestamo p
        JOIN libro l ON p.id_libro = l.id_libro
        WHERE p.id_usuario = $1
        ORDER BY p.fecha_prestamo DESC";

$result = pg_query_params($conn, $sql, [$id_usuario]);

$prestamos = [];
if ($result) {
    while ($row = pg_fetch_assoc($result)) {
        $prestamos[] = $row;
    }
} else {
    $error = pg_last_error($conn);
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Préstamos - Biblioteca</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <h2>Mis Préstamos</h2>
    <a href="dashboard.php" class="btn-volver">Volver</a>
</div>

<!-- CONTENIDO -->
<div class="container">
    <h3>Bienvenido, <?= htmlspecialchars($nombre) ?></h3>
    <p>Rol: <b><?= htmlspecialchars($tipo) ?></b></p>

    <?php if (!empty($prestamos)) { ?>
        <table class="tabla-prestamos">
            <thead>
                <tr>
                    <th>Libro</th>
                    <th>Fecha de Préstamo</th>
                    <th>Fecha de Devolución</th>
                    <th>Fecha de Entrega</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($prestamos as $p) { ?>
                    <tr>
                        <td><?= htmlspecialchars($p['titulo']) ?></td>
                        <td><?= htmlspecialchars($p['fecha_prestamo']) ?></td>
                        <td><?= htmlspecialchars($p['fecha_devolucion']) ?></td>
                        <td><?= htmlspecialchars($p['fecha_entrega'] ?? '-') ?></td>
                        <td><?= htmlspecialchars($p['estado']) ?></td>
                    </tr>
                <?php } ?>
            </tbody>
        </table>
    <?php } else { ?>
        <div class="alert">No tienes préstamos registrados.</div>
    <?php } ?>

    <?php if (isset($error)) { ?>
        <div class="alert">Error al obtener los préstamos: <?= htmlspecialchars($error) ?></div>
    <?php } ?>
</div>

</body>
</html>

<?php
// Cerrar conexión
if (isset($conn)) {
    pg_close($conn);
}
?>
