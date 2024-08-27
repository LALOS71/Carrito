<?php
$serverName = "globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com";
// $serverName = $_ENV["DB_SERVER_GAG"];
$connectionOptions = array(
    "Database" => "PRE__GAG",
    "Uid" => "PRE__USUARIO_‎IIS",
    "PWD" => "PRE__globalia"
);  
$opciones = array(
    PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8
);
try {
    $conn = new PDO("sqlsrv:Server=$serverName;Database={$connectionOptions['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions['Uid'], $connectionOptions['PWD'],$opciones);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}
?>