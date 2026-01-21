<?php
session_start();

if (!isset($_SESSION["usuario_id"])) {
    header("Location: login.php");
    exit;
}

require_once "conexion.php";

$rol_actual = $_SESSION["tipo_usuario"];
$nombre = $_SESSION["nombre"] ?? "Usuario";

// Manejo del formulario
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $nombre_usuario = $_POST["nombre"];
    $apellido = $_POST["apellido"];
    $cedula = $_POST["cedula"];
    $correo = $_POST["correo"];
    $telefono = $_POST["telefono"];
    $tipo_usuario = $_POST["tipo_usuario"];
    $password = $_POST["password"];

    // Validar que Docente no cree Admin
    if ($rol_actual === "Docente" && $tipo_usuario === "Admin") {
        $msg = "Los docentes no pueden crear usuarios Admin.";
    } else {
        $hash = password_hash($password, PASSWORD_BCRYPT);

        $sql = "INSERT INTO usuario 
                (nombre, apellido, cedula, correo, telefono, tipo_usuario, estado, password_hash)
                VALUES ($1,$2,$3,$4,$5,$6,'Activo',$7)";

        $result = pg_query_params($conn, $sql, [
            $nombre_usuario, $apellido, $cedula, $correo, $telefono, $tipo_usuario, $hash
        ]);

        $msg = $result ? "Usuario registrado correctamente" : "Error al registrar usuario: " . pg_last_error($conn);
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Usuario</title>
    <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body>

<div class="navbar">
    <h2>Registrar Usuario</h2>
    <a href="dashboard.php" class="btn-volver">Volver</a>
</div>

<div class="container">
    <h3>Bienvenido, <?= htmlspecialchars($nombre) ?> (<?= htmlspecialchars($rol_actual) ?>)</h3>

    <?php if (isset($msg)) { ?>
        <div class="alert"><?= htmlspecialchars($msg) ?></div>
    <?php } ?>

    <form method="POST">
        <input type="text" name="nombre" required placeholder="Nombre">
        <input type="text" name="apellido" required placeholder="Apellido">
        <input type="text" name="cedula" required placeholder="Cédula">
        <input type="email" name="correo" placeholder="Correo">
        <input type="text" name="telefono" placeholder="Teléfono">

        <select name="tipo_usuario" required>
            <option value="">-- Tipo de usuario --</option>
            <?php if ($rol_actual === "Admin") { ?>
                <option value="Admin">Admin</option>
                <option value="Docente">Docente</option>
            <?php } ?>
            <option value="Estudiante">Estudiante</option>
        </select>

        <input type="password" name="password" required placeholder="Contraseña">
        <button type="submit">Registrar</button>
    </form>
</div>

</body>
</html>

<?php
if (isset($conn)) pg_close($conn);
?>