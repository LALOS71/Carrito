<?php

$fichero_configuracion = 'C:\\CONFIGURACION\\cnf_ARTES_GRAFICAS.inc';

$config = parse_ini_file($fichero_configuracion);

if ($config === false) {
    die("Error al leer el archivo de configuración.");
}


$serverName = $config['servidor'];
$connectionOptions = array(
    "Database" => $config['bd'],
    "Uid" => $config['usuario'],
    "PWD" => $config['contrasenna']
);


 $opciones = array(
    PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8,
); 
try {
    $conn = new PDO("sqlsrv:Server=$serverName;Database={$connectionOptions['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions['Uid'], $connectionOptions['PWD']);,  $opciones);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}

$databases = array(
    "artes_graficas" => "artes_graficas",
    "gag" => "GAG",
    "maletas" => "MALETAS"
);
$connectionOptions = array(
    "Uid" => $config['usuario'],
    "PWD" => $config['contrasenna'],
);
function getConnections($databases) {
    global $serverName, $connectionOptions;

    $connections = [];
    foreach ($databases as $key => $database) {
        try {
            $conn1 = new PDO("sqlsrv:Server=$serverName;Database=$database;Encrypt=0;TrustServerCertificate=true", $connectionOptions['Uid'], $connectionOptions['PWD']);
            $conn1->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $connections[$key] = $conn1;
        } catch (PDOException $e) {
            die("Error al conectar a $database: " . $e->getMessage());
        }
    }
    return $connections;
}

$connections = getConnections($databases);

