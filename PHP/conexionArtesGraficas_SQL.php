<?php

$fichero_configuracion_artes_graficas_sql = 'C:\\CONFIGURACION\\cnf_ARTES_GRAFICAS_PRE.inc';

$config_artes_graficas_sql = parse_ini_file($fichero_configuracion_artes_graficas_sql);

if ($config_artes_graficas_sql === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_artes_graficas_sql = $config_artes_graficas_sql['servidor'];
$connectionInfo_artes_graficas_sql = [
    "Authentication" => "SqlPassword",
    "Encrypt" => 0,
    "Database" => $config_artes_graficas_sql['bd'],
    "UID" => $config_artes_graficas_sql['usuario'],
    "PWD" => $config_artes_graficas_sql['contrasenna'],
    "CharacterSet" => "UTF-8"
];

// Establecer la conexión
$conn_artes_graficas_sql = sqlsrv_connect($serverName_artes_graficas_sql, $connectionInfo_artes_graficas_sql);

// Verificar si la conexión fue exitosa
if ($conn_artes_graficas_sql === false) {
    die(print_r(sqlsrv_errors(), true));
}

?>