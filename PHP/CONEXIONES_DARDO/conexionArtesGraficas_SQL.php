<?php


$serverName = $config['servidor'];
$connectionInfo = [
    "Authentication" => "SqlPassword",
    "Encrypt" => 0,
    "Database" => $config['bd'],
    "UID" => $config['usuario'],
    "PWD" => $config['contrasenna'],
    "CharacterSet" => "UTF-8"
];

// Establecer la conexión
$conn_artes_graficas_sql = sqlsrv_connect($serverName, $connectionInfo);

// Verificar si la conexión fue exitosa
if ($conn_artes_graficas_sql === false) {
    die(print_r(sqlsrv_errors(), true));
}

?>