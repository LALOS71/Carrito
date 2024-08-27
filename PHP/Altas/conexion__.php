<?php
$serverName = "192.168.156.136";
$connectionOptions = array(
    "Database" => "gag",
    "Uid" => "backhalconuser",
    "PWD" => "imprenta"
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