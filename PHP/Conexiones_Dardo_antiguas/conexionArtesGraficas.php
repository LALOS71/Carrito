<?php
//phpinfo();
/* ========== Conexion Vieja  =========================================== 
    $serverName = "globalia-ag-pro-v2.clg0eqcx5qj9.eu-west-1.rds.amazonaws.com";
    // $serverName = $_ENV["DB_SERVER_ARTESGRAFICAS"];
    $connectionOptions = array(
        "Database" => "PRE__artes_graficas",
        "Uid" => "PRE__USUARIO_IIS",
        "PWD" => "PRE__globalia",
    );
*/
/* ========== Conexion desarrollo o principal =========================================== */

$fichero_configuracion = 'C:\\CONFIGURACION\\cnf_ARTES_GRAFICAS_PRE.inc';

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
    $conn = new PDO("sqlsrv:Server=$serverName;Database={$connectionOptions['Database']};Encrypt=0;TrustServerCertificate=true", $connectionOptions['Uid'], $connectionOptions['PWD'], $opciones);    
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
   // echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}

