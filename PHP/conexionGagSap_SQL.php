<?php

$fichero_configuracion_gag_sap_sql = 'C:\\CONFIGURACION\\cnf_GAG_SAP_PRE.inc';

$config_gag_sap_sql = parse_ini_file($fichero_configuracion_gag_sap_sql);

if ($config_gag_sap_sql === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_gag_sap_sql = $config_gag_sap_sql['servidor'];
$connectionInfo_gag_sap_sql = [
    "Authentication" => "SqlPassword",
    "Encrypt" => 0,
    "Database" => $config_gag_sap_sql['bd'],
    "UID" => $config_gag_sap_sql['usuario'],
    "PWD" => $config_gag_sap_sql['contrasenna'],
    "CharacterSet" => "UTF-8"
];

// Establecer la conexión
$conn_gag_sap_sql = sqlsrv_connect($serverName_gag_sap_sql, $connectionInfo_gag_sap_sql);

// Verificar si la conexión fue exitosa
if ($conn_gag_sap_sql === false) {
    die(print_r(sqlsrv_errors(), true));
}

?>