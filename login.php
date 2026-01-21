<?php
session_start();
require_once "conexion.php";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $correo = $_POST["correo"];
    $password = $_POST["password"];

    $sql = "SELECT id_usuario, tipo_usuario, password_hash 
            FROM usuario 
            WHERE correo = $1 AND estado='Activo'";

    $result = pg_query_params($conn, $sql, [$correo]);

    if ($row = pg_fetch_assoc($result)) {
        if (password_verify($password, $row["password_hash"])) {

            $_SESSION["usuario_id"] = $row["id_usuario"];
            $_SESSION["tipo_usuario"] = $row["tipo_usuario"];

            /* cerrar conexión antes de redirigir */
            if (isset($conn)) {
                pg_close($conn);
            }

            header("Location: dashboard.php");
            exit;

        } else {
            $error = "Contraseña incorrecta";
        }
    } else {
        $error = "Usuario no encontrado";
    }
}

/*  cerrar conexión si no hubo redirect */
if (isset($conn)) {
    pg_close($conn);
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login - Biblioteca</title>
    <link rel="stylesheet" href="estilos.css?v=1.0">

</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <h2> Sistema Bibliotecario</h2>
</div>

<!-- CONTENIDO -->
<div class="container" style="max-width:400px;">
    <h3>Iniciar sesión</h3>

    <form method="POST">
        <input type="email" name="correo" required placeholder="Correo">
        <input type="password" name="password" required placeholder="Contraseña">
        <button type="submit">Ingresar</button>
    </form>

    <?php if (isset($error)) { ?>
        <div class="alert alert-error"><?= htmlspecialchars($error) ?></div>
    <?php } ?>

</div>

</body>
</html>
