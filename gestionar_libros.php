<?php
session_start();

// Validar sesión y rol
if (!isset($_SESSION['usuario_id']) || !in_array($_SESSION['tipo_usuario'], ['Admin', 'Docente'])) {
    header("Location: login.php");
    exit;
}

require_once "conexion.php";

$nombre = $_SESSION['nombre'] ?? 'Usuario';
$tipo = $_SESSION['tipo_usuario'];

$msg = "";
$msg_class = "alert-success";

/* ================= AGREGAR LIBRO ================= */
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['agregar_libro'])) {

    $titulo = trim($_POST['titulo']);
    $isbn = trim($_POST['isbn']);
    $anio = (int) $_POST['anio'];
    $ejemplares_totales = (int) $_POST['ejemplares_totales'];
    $ejemplares_disponibles = (int) $_POST['ejemplares_disponibles'];
    $estado = $_POST['estado'];
    $id_categoria = (int) $_POST['categoria'];
    $autores_input = trim($_POST['autores']);

    $sql = "INSERT INTO libro 
        (titulo, isbn, anio_publicacion, ejemplares_totales, ejemplares_disponibles, estado, id_categoria)
        VALUES ($1,$2,$3,$4,$5,$6,$7)
        RETURNING id_libro";

    $result = pg_query_params($conn, $sql, [
        $titulo,
        $isbn,
        $anio,
        $ejemplares_totales,
        $ejemplares_disponibles,
        $estado,
        $id_categoria
    ]);

    if ($result) {
        $libro = pg_fetch_assoc($result);
        $id_libro = $libro['id_libro'];

        if (!empty($autores_input)) {
            $autores_array = explode(',', $autores_input);

            foreach ($autores_array as $autor_nombre) {
                $autor_nombre = trim($autor_nombre);
                if ($autor_nombre === '') continue;

                $res_check = pg_query_params(
                    $conn,
                    "SELECT id_autor FROM autor WHERE nombre = $1",
                    [$autor_nombre]
                );

                if ($res_check && pg_num_rows($res_check) > 0) {
                    $autor = pg_fetch_assoc($res_check);
                    $id_autor = $autor['id_autor'];
                } else {
                    $res_insert = pg_query_params(
                        $conn,
                        "INSERT INTO autor (nombre) VALUES ($1) RETURNING id_autor",
                        [$autor_nombre]
                    );
                    $autor = pg_fetch_assoc($res_insert);
                    $id_autor = $autor['id_autor'];
                }

                pg_query_params(
                    $conn,
                    "INSERT INTO libro_autor (id_libro, id_autor) VALUES ($1,$2)",
                    [$id_libro, $id_autor]
                );
            }
        }

        $msg = "Libro agregado correctamente.";
        $msg_class = "alert-success";
    } else {
        $msg = "Error al agregar libro.";
        $msg_class = "alert-error";
    }
}

/* ================= ELIMINAR (DESACTIVAR) ================= */
if (isset($_GET['eliminar'])) {
    $id_libro = (int) $_GET['eliminar'];

    $sql = "UPDATE libro SET estado='No disponible' WHERE id_libro=$1";
    $result = pg_query_params($conn, $sql, [$id_libro]);

    if ($result) {
        $msg = "Libro desactivado correctamente.";
        $msg_class = "alert-success";
    } else {
        $msg = "Error al desactivar libro.";
        $msg_class = "alert-error";
    }
}

/* ================= LISTAR LIBROS ================= */
$sql_libros = "
SELECT l.id_libro, l.titulo, l.isbn, l.anio_publicacion,
       l.ejemplares_totales, l.ejemplares_disponibles,
       l.estado, c.nombre_categoria,
       string_agg(a.nombre, ', ') AS autores
FROM libro l
JOIN categoria c ON l.id_categoria = c.id_categoria
LEFT JOIN libro_autor la ON l.id_libro = la.id_libro
LEFT JOIN autor a ON la.id_autor = a.id_autor
GROUP BY l.id_libro, c.nombre_categoria
ORDER BY l.titulo
";

$result_libros = pg_query($conn, $sql_libros);
$libros = [];
if ($result_libros) {
    while ($row = pg_fetch_assoc($result_libros)) {
        $libros[] = $row;
    }
}

/* ================= LISTAR CATEGORÍAS ================= */
$result_categorias = pg_query($conn, "SELECT id_categoria, nombre_categoria FROM categoria ORDER BY nombre_categoria");
$categorias = $result_categorias ? pg_fetch_all($result_categorias) : [];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestionar Libros</title>
    <link rel="stylesheet" href="estilos.css">
</head>
<body>

<div class="navbar">
    <h2>Gestionar Libros</h2>
    <a href="dashboard.php" class="btn-volver">Volver</a>
</div>

<div class="container">
    <h3>Bienvenido, <?= htmlspecialchars($nombre) ?> (<?= htmlspecialchars($tipo) ?>)</h3>

    <?php if ($msg) { ?>
        <div class="alert <?= $msg_class ?>"><?= htmlspecialchars($msg) ?></div>
    <?php } ?>

    <h4>Agregar nuevo libro</h4>
    <form method="POST" class="formulario">
        <input type="text" name="titulo" required placeholder="Título">
        <input type="text" name="isbn" required placeholder="ISBN">
        <input type="number" name="anio" required placeholder="Año de publicación" min="1500">
        <input type="number" name="ejemplares_totales" required placeholder="Ejemplares totales" min="1">
        <input type="number" name="ejemplares_disponibles" required placeholder="Ejemplares disponibles" min="0">

        <select name="estado" required>
            <option value="Disponible">Disponible</option>
            <option value="No disponible">No disponible</option>
        </select>

        <select name="categoria" required>
            <option value="">-- Categoría --</option>
            <?php foreach ($categorias as $c) { ?>
                <option value="<?= $c['id_categoria'] ?>">
                    <?= htmlspecialchars($c['nombre_categoria']) ?>
                </option>
            <?php } ?>
        </select>

        <label>Autores (separar con coma):</label>
        <input type="text" name="autores" placeholder="Ej: Gabriel García Márquez, J.K. Rowling">

        <button type="submit" name="agregar_libro" class="btn-submit">Agregar Libro</button>
    </form>

    <h4>Lista de libros</h4>
    <table class="tabla-libros">
        <thead>
            <tr>
                <th>Título</th>
                <th>ISBN</th>
                <th>Año</th>
                <th>Totales</th>
                <th>Disponibles</th>
                <th>Estado</th>
                <th>Categoría</th>
                <th>Autores</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
        <?php foreach ($libros as $l) { ?>
            <tr>
                <td><?= htmlspecialchars($l['titulo']) ?></td>
                <td><?= htmlspecialchars($l['isbn']) ?></td>
                <td><?= htmlspecialchars($l['anio_publicacion']) ?></td>
                <td><?= htmlspecialchars($l['ejemplares_totales']) ?></td>
                <td><?= htmlspecialchars($l['ejemplares_disponibles']) ?></td>
                <td><?= htmlspecialchars($l['estado']) ?></td>
                <td><?= htmlspecialchars($l['nombre_categoria']) ?></td>
                <td><?= htmlspecialchars($l['autores']) ?></td>
                <td>
                    <div class="acciones">
                        <a href="editar_libro.php?id=<?= $l['id_libro'] ?>"
                           class="btn btn-editar btn-editar-eliminar">
                            Editar
                        </a>

                        <a href="?eliminar=<?= $l['id_libro'] ?>"
                           class="btn btn-eliminar btn-editar-eliminar"
                           onclick="return confirm('¿Deseas desactivar este libro?')">
                            Eliminar
                        </a>
                    </div>
                </td>
            </tr>
        <?php } ?>
        </tbody>
    </table>
</div>

</body>
</html>

<?php
pg_close($conn);
?>
