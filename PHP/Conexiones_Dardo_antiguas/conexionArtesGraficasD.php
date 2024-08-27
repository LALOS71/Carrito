<?php
//phpinfo();
/* ========== Conexion Vieja o principal =========================================== */
$serverName = "globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com";
// $serverName = $_ENV["DB_SERVER_ARTESGRAFICAS"];
$connectionOptions = array(
    "Database" => "PRE__artes_graficas",
    "Uid" => "PRE__USUARIO_IIS",
    "PWD" => "PRE__globalia",
);
 $opciones = array(
    PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8,
); 
try {
    $conn = new PDO("sqlsrv:Server=$serverName;Database={$connectionOptions['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions['Uid'], $connectionOptions['PWD']); //, $opciones);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}
/* =================================================================================================== */
//$serverName = "globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com";
$databases = array(
    "artes_graficas" => "PRE__artes_graficas",
    "gag" => "PRE__GAG",
    "maletas" => "PRE__MALETAS"
);
$connectionOptions = array(
    "Uid" => "PRE__USUARIO_IIS",
    "PWD" => "PRE__globalia",
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

