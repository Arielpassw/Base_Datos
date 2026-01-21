<?php
session_start();

if (!isset($_SESSION["usuario_id"])) {
    header("Location: login.php");
    exit;
}

require_once "conexion.php";

$sql = "
SELECT u.nombre, l.titulo, p.fecha_prestamo, p.estado
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN libro l ON p.id_libro = l.id_libro
";

$result = pg_query($conn, $sql);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Préstamos - Biblioteca</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <h2> Préstamos</h2>
    <a href="dashboard.php" class="btn-volver"> Volver</a>
</div>

<!-- CONTENIDO -->
<div class="container">
    <table>
        <tr>
            <th>Usuario</th>
            <th>Libro</th>
            <th>Fecha</th>
            <th>Estado</th>
        </tr>

        <?php while ($row = pg_fetch_assoc($result)) { ?>
        <tr>
            <td><?= htmlspecialchars($row["nombre"]) ?></td>
            <td><?= htmlspecialchars($row["titulo"]) ?></td>
            <td><?= htmlspecialchars($row["fecha_prestamo"]) ?></td>
            <td><?= htmlspecialchars($row["estado"]) ?></td>
        </tr>
        <?php } ?>
    </table>
</div>

</body>
</html>

<?php
/* cerrar conexión */
if (isset($conn)) {
    pg_close($conn);
}
?>
