<?php

$fichero_configuracion_gag_sap = 'C:\\CONFIGURACION\\cnf_GAG_SAP_PRE.inc';

$config_gag_sap = parse_ini_file($fichero_configuracion_gag_sap);

if ($config_gag_sap === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_gag_sap = $config_gag_sap['servidor'];
$connectionOptions_gag_sap = array(
    "Database" => $config_gag_sap['bd'],
    "Uid" => $config_gag_sap['usuario'],
    "PWD" => $config_gag_sap['contrasenna']
);  
$opciones = array(
    PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8
);
try {
    $conn_gag_sap = new PDO("sqlsrv:Server=$serverName_gag_sap;Database={$connectionOptions_gag_sap['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions_gag_sap['Uid'], $connectionOptions_gag_sap['PWD'],$opciones);
    $conn_gag_sap->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}
?>