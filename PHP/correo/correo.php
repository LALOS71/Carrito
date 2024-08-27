<?php
// class Correo{
//     public function enviar(){}
// }
//Import PHPMailer classes into the global namespace
//These must be at the top of your script, not inside a function
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

//Load Composer's autoloader
require 'vendor/autoload.php';
// $contenido = file_get_contents('../../Envio_Mails_CDO\Ejemplo_Email_CDO\Config.inc');

// include_once "../../Envio_Mails_CDO\Ejemplo_Email_CDO\Config.inc";
// include "./Config.inc";
//Create an instance; passing `true` enables exceptions

// if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $mail = new PHPMailer(true);
    try {
        $mail->isSMTP(); // Send using SMTP
        $mail->Host       = 'email-smtp.eu-west-1.amazonaws.com'; // Set the SMTP server
        $mail->SMTPAuth   = true; // Enable SMTP authentication
        $mail->Username   = 'AKIAY7674MHZ2YVMG4FB'; // SMTP username
        $mail->Password   = 'BMh0vesbacnJDQqRGaJMn3WwPPwzxgdMMpz7yfq4'; // SMTP password
        // $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // Enable TLS encryption, `ssl` also accepted
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS; // Enable TLS encryption, `ssl` also accepted
        $mail->Port       = 465; // TCP port to connect to
        // $mail->Port       = 25; // TCP port to connect to
        $mail->Timeout    = 60;
        //Server settings
        // $mail->SMTPDebug = SMTP::DEBUG_SERVER;                      //Enable verbose debug output
        // $mail->isSMTP();                                            //Send using SMTP
        // $mail->Host       = "email-smtp.eu-west-1.amazonaws.com";                     //Set the SMTP server to send through
        // // $mail->Host       = "192.168.150.44";                     //Set the SMTP server to send through
        // // $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
        // $mail->Username   = "AKIAY7674MHZ2YVMG4FB";                     //SMTP username
        // // $mail->Username   = CDO_SENDUSERNAME;                     //SMTP username
        // $mail->Password   = "BMh0vesbacnJDQqRGaJMn3WwPPwzxgdMMpz7yfq4/Tlj";                               //SMTP password
        // // $mail->Password   = CDO_SENDPASSWORD;                               //SMTP password
        // $mail->SMTPSecure = "ssl";
        // // $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
        // $mail->Port       = 465;     
        // $mail->Timeout       =   60;                               //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
        // $mail->Port       = CDO_PORT;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`
    
        //Recipients
        $mail->setFrom('alvaroredrodriguez@globalia-artesgraficas.com', 'Alvaro Redondo Rodriguez');
        // $mail->addAddress('joe@example.net', 'Joe User');     //Add a recipient
        $mail->addAddress('alvaroredrodriguez@globalia-artesgraficas.com');               //Name is optional
        // $mail->addReplyTo('info@example.com', 'Information');
        // $mail->addCC('cc@example.com');
        // $mail->addBCC('bcc@example.com');
    
        //Attachments
        // $mail->addAttachment('/var/tmp/file.tar.gz');         //Add attachments
        // $mail->addAttachment('/tmp/image.jpg', 'new.jpg');    //Optional name
    
        //Content
        $mail->isHTML(true);                                  //Set email format to HTML
        $mail->Subject = "Solicitud alta nuevo cliente";
        $mail->Body    = 'Razon social: '.$_POST['txtrazonsocial'].'<br>'.
        "Nombre comercial: ".$_POST["txtnombre"].'<br>'.
        "NIF/CIF: ".$_POST["txtnifcif"];
        // $mail->AltBody = 'Lo demás';
    
        $mail->send();
        // echo 'Message has been sent';
    } catch (Exception $e) {
        echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
    }
// }