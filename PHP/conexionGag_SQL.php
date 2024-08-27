<?php

$fichero_configuracion_gag_sql = 'C:\\CONFIGURACION\\cnf_GAG_PRE.inc';

$config_gag_sql = parse_ini_file($fichero_configuracion_gag_sql);

if ($config_gag_sql === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_Gag_Sql = $config_gag_sql['servidor'];
$connectionInfo_Gag_Sql = [
    "Authentication" => "SqlPassword",
    "Encrypt" => 0,
    "Database" => $config_gag_sql['bd'],
    "UID" => $config_gag_sql['usuario'],
    "PWD" => $config_gag_sql['contrasenna'],
    "CharacterSet" => "UTF-8"
];

// Establecer la conexión
$conn_gag_sql = sqlsrv_connect($serverName_Gag_Sql, $connectionInfo_Gag_Sql);

if (!$conn_gag_sql) {
	echo "Connection could not be established.<br />";
        echo "<pre>";
        print_r(sqlsrv_errors());
        echo "</pre>";

        die();
}


?>