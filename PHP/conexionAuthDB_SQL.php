<?php

$fichero_configuracion_authdb_sql = 'C:\\CONFIGURACION\\cnf_AUTHDB_PRE.inc';

$config_authdb_sql = parse_ini_file($fichero_configuracion_authdb_sql);

if ($config_authdb_sql === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_authdb_sql = $config_authdb_sql['servidor'];
$connectionInfo_authdb_sql = [
    "Authentication" => "SqlPassword",
    "Encrypt" => 0,
    "Database" => $config_authdb_sql['bd'],
    "UID" => $config_authdb_sql['usuario'],
    "PWD" => $config_authdb_sql['contrasenna'],
    "CharacterSet" => "UTF-8"
];

// Establecer la conexión
$conn_authdb_sql = sqlsrv_connect($serverName_authdb_sql, $connectionInfo_authdb_sql);

// Verificar si la conexión fue exitosa
if ($conn_authdb_sql === false) {
    die(print_r(sqlsrv_errors(), true));
}

?>