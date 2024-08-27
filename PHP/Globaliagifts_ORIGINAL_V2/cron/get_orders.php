<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: text/html; charset=utf-8');

//$_SERVER['REQUEST_METHOD'] = 'POST';
//$_SERVER['HTTP_USER_AGENT'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36';


//if (php_sapi_name() != "cli")
//    die("noc\n");
include_once('../autoload.php');


set_error_handler([new TronShop(), 'iErrorHandler'], E_ALL);

try {
    ob_end_flush();
    ob_implicit_flush();

    new ProcesoNuevosPedidos(true);

} catch (Error $e) {
    print_r($e);
}