<?php
$host = "b1zetqd57gzbxqypyqcb-postgresql.services.clever-cloud.com";
$port = "50013";
$dbname = "b1zetqd57gzbxqypyqcb";
$user = "uopjjbtugtnt5ilyi0t3";
$password = "Nak8WHKI3SJtGuhuTFHS";

$conn_string = "host=$host port=$port dbname=$dbname user=$user password=$password sslmode=require";

/*Evitar abrir más de una conexión por request */
if (!isset($conn) || !$conn) {
    $conn = pg_connect($conn_string);
}

if (!$conn) {
    die(" No se pudo conectar a PostgreSQL en Clever Cloud.");
}
