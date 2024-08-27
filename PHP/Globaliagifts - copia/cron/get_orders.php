<?php


error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: text/html; charset=utf-8');

//$_SERVER['REQUEST_METHOD'] = 'POST';
//$_SERVER['HTTP_USER_AGENT'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36';


//if (php_sapi_name() != "cli")
//    die("noc\n");
include_once('../autoload.php');

require '../vendor/autoload.php'; 
use PHPMailer\PHPMailer\PHPMailer;


set_error_handler([new TronShop(), 'iErrorHandler'], E_ALL);


try {
    ob_end_flush();
    ob_implicit_flush();

    $nuevosPedidos = new ProcesoNuevosPedidos(true);


    // Enviar correo electrónico con el resultado
    $mail = new PHPMailer();
    $mail->isSMTP();
    $mail->CharSet = 'UTF-8'; 
    $mail->Host = '192.168.150.44'; // Reemplaza con el servidor SMTP
    //$mail->SMTPAuth = true;
    //$mail->Username = 'tu_correo_electronico'; // Reemplaza con tu correo electrónico
    //$mail->Password = 'tu_contraseña_correo'; // Reemplaza con tu contraseña de correo electrónico
    //$mail->SMTPSecure = 'tls';
    //$mail->Port = 587;
    $mail->setFrom('malba@globalia.com', 'manuel alba');
    $mail->addAddress('malba@globalia.com', 'Destinatario'); // Reemplaza con el correo de destino
    $mail->isHTML(true);
    //$fechaAsunto = date("Y-m-d", strtotime('-1 day'));
    $fechaAsunto = date("Y-m-d");

    
    $mail->Subject = 'Globaliagifts - Creación de Albaranes - ' . $fechaAsunto;
    

    

    if (!empty($nuevosPedidos->getAlbaranesCreados())) {
        $mensaje = "<br>Se han creado Albaranes Nuevos desde Globaliagifts para el Día ${fechaAsunto}.";
        $mensaje .= "<br><br>Códigos de Albaranes Creados:<br>" . implode("<br>", $nuevosPedidos->getAlbaranesCreados());
    }else{
        $mensaje = "<br>Para el Día ${fechaAsunto} no se han creado Albaranes Nuevos desde Globaliagifts.";
    }

    $mensaje .= "<br><br>Un saludo.";

    $mail->Body = $mensaje;


    
    if (!$mail->send()) {
        echo "Error al enviar el correo: " . $mail->ErrorInfo;
    } else {
        echo "El proceso se ha completado con éxito. Se ha enviado un correo informando de la existencia
         de albaranes nuevos.";
    }

} catch (Error $e) {
    print_r($e);
}