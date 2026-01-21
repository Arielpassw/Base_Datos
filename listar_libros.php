<?php
session_start();

if (!isset($_SESSION["usuario_id"])) {
    header("Location: login.php");
    exit;
}

require_once "conexion.php";

$sql = "
SELECT l.titulo, c.nombre_categoria, l.ejemplares_disponibles
FROM libro l
JOIN categoria c ON l.id_categoria = c.id_categoria
";

$result = pg_query($conn, $sql);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Libros disponibles</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <h2>Libros disponibles</h2>
    <a href="dashboard.php" class="btn-volver">Volver</a>
</div>

<!-- CONTENIDO -->
<div class="container">
    <?php if ($result && pg_num_rows($result) > 0) { ?>
        <table class="tabla-libros">
            <thead>
                <tr>
                    <th>Título</th>
                    <th>Categoría</th>
                    <th>Disponibles</th>
                </tr>
            </thead>
            <tbody>
                <?php while ($row = pg_fetch_assoc($result)) { ?>
                <tr>
                    <td><?= htmlspecialchars($row["titulo"]) ?></td>
                    <td><?= htmlspecialchars($row["nombre_categoria"]) ?></td>
                    <td><?= htmlspecialchars($row["ejemplares_disponibles"]) ?></td>
                </tr>
                <?php } ?>
            </tbody>
        </table>
    <?php } else { ?>
        <div class="alert">No hay libros disponibles.</div>
    <?php } ?>
</div>

</body>
</html>

<?php
if (isset($conn)) {
    pg_close($conn);
}
?>
