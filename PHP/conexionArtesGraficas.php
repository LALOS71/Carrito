<?php

$fichero_configuracion_artes_graficas = 'C:\\CONFIGURACION\\cnf_ARTES_GRAFICAS_PRE.inc';

$config_artes_graficas = parse_ini_file($fichero_configuracion_artes_graficas);

if ($config_artes_graficas === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName_artes_graficas = $config_artes_graficas['servidor'];
$connectionOptions_artes_graficas = array(
    "Database" => $config_artes_graficas['bd'],
    "Uid" => $config_artes_graficas['usuario'],
    "PWD" => $config_artes_graficas['contrasenna']
);  
$opciones = array(
    PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8
);
try {
    $conn_artes_graficas = new PDO("sqlsrv:Server=$serverName_artes_graficas;Database={$connectionOptions_artes_graficas['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions_artes_graficas['Uid'], $connectionOptions_artes_graficas['PWD'],$opciones);
    $conn_artes_graficas->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}
