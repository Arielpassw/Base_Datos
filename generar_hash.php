<?php
$password = "juanito123";  // la contraseña real del usuario
$hash = password_hash($password, PASSWORD_BCRYPT);

echo "Contraseña: $password <br>";
echo "Hash: $hash";
