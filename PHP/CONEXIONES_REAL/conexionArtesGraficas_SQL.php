<?php

$fichero_configuracion = 'C:\\CONFIGURACION\\cnf_ARTES_GRAFICAS.inc';

$config = parse_ini_file($fichero_configuracion);

if ($config === false) {
    die("Error al leer el archivo de configuración.");
}


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