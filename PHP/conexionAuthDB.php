<?php
require 'GAGSAP_PRE/vendor/autoload.php';


use OAuth2\Storage\Pdo;
use OAuth2\GrantType\ClientCredentials;
use OAuth2\Server;

$fichero_configuracion_authdb = 'C:\\CONFIGURACION\\cnf_AUTHDB_PRE.inc';

$config_authdb = parse_ini_file($fichero_configuracion_authdb);



if ($config_authdb === false) {
    die("Error al leer el archivo de configuración.");
}


try {
    
    $dsn = "sqlsrv:Server={$config_authdb['servidor']};Database={$config_authdb['bd']};TrustServerCertificate=yes;Encrypt=no";
    $username = $config_authdb['usuario'];
    $password = $config_authdb['contrasenna'];

    $conn_authdb = new Pdo([
        'dsn' => $dsn,
        'username' => $username,
        'password' => $password,
    ]);
    
    //echo "Conexión establecida correctamente";

} catch (PDOException $e) {
    die("Error al conectar: " . $e->getMessage());
}
?>