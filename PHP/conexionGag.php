<?php

$fichero_configuracion_gag = 'C:\\CONFIGURACION\\cnf_GAG_PRE.inc';

$config_gag = parse_ini_file($fichero_configuracion_gag);

if ($config_gag === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_Gag = $config['servidor'];
$connectionOptions_Gag = array(
    "Database" => $config_gag['bd'],
    "Uid" => $config_gag['usuario'],
    "PWD" => $config_gag['contrasenna']
);  
$opciones = array(
    PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8
);
try {
    $conn_gag = new PDO("sqlsrv:Server=$serverName_gag;Database={$connectionOptions_gag['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions_gag['Uid'], $connectionOptions_gag['PWD'],$opciones);
    $conn_gag->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}
?>