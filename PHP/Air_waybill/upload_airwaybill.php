<?php
//phpinfo();
// Incluir el archivo de conexión
include_once("../conexionArtesGraficas.php");

    //Load Composer's autoloader
    require '../correo/vendor/autoload.php';   

    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;


if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    $prefix = $_POST['prefix'];
    $serial = $_POST['serial'];
    $pedido = $_POST['num_pedido'];
    $codcli = $_POST['cod_cli'];
    $email = $_POST['email'];
    $nombre_apellido = $_POST['nombre_apellido'];
    $albaran = $_POST['num_albaran'];
    $file = $_FILES['archivo'];
    $anio = date('Y');
    //$codcli = $_POST
    $overwrite = isset($_POST['overwrite']) ? $_POST['overwrite'] : false;   

    // Directorio donde se guardarán los archivos subidos
   // $uploadDir = 'C:/CARRITO_IMPRENTA/Carrito/GAG/Pedidos/'.$anio.'/'. $codcli . '__' . $pedido . '/';
    $uploadDir = '../../GAG/Pedidos/'.$anio.'/'. $codcli . '__' . $pedido . '/';
     
    
    if (!is_dir($uploadDir)) {      
        mkdir($uploadDir, 0777, true);
    } 
    
    // Nombre del archivo con ruta completa
    //$uploadFile = $uploadDir .'Air_WayBill_'.$albaran.'_'.basename($file['name']);
    $uploadFile = $uploadDir .'Air_WayBill_'.$albaran.'_'.$prefix.'-'.$serial.'.pdf';
    // $uploadFile = $uploadDir . basename($file['name']);
    //$uploadFile = $uploadDir .'Prueba__.pdf';
    //    echo '<pre>';
    //   var_dump($nombre_apellido);
    //    echo '<br/> nombre archivo ';
    //    var_dump($email);
    //  echo '<br/> ARCHIVO ';
    //   var_dump($file['name']);  
    //    echo '</pre>';
     // die;
    
    if (file_exists($uploadFile) && !$overwrite) {
        echo json_encode([
            'status' => 'exists',
            'message' => 'El archivo ya existe. ¿Desea reemplazarlo?',
        ]);
        exit;
    }
   

    // Mover el archivo subido a la carpeta asignada
    if (move_uploaded_file($file['tmp_name'], $uploadFile)) {

         
        // echo '<pre>';
        // var_dump($uploadDir);
        // echo '<br/> nombre archivo ';
        // var_dump($uploadFile);
        // echo '<br/> ARCHIVO ';
        // var_dump($file['tmp_name']);  
        // echo '</pre>';
        // die;
        try {
            // Verificar si el archivo ya existe en la base de datos
            $sql = "SELECT COUNT(*) FROM ALBARANES_AIRWILLBILL WHERE ALBARAN = :albaran AND PREFIX = :numero1 AND SERIAL = :numero2";
            $stmt = $conn_artes_graficas->prepare($sql);
            $stmt->execute([':albaran' => $albaran,
                            ':numero1' => $prefix,
                            ':numero2' => $serial
                        ]);
            $exists = $stmt->fetchColumn() > 0;
           
            if ($exists && !$overwrite) {
                $response = [
                    'status' => 'exists',
                    'message' => 'El archivo ya existe. ¿Desea reemplazarlo?'
                ];
                // Guardar la URL del archivo en la base de datos
            } else if ($overwrite) {          
                // Actualizar el registro existente
                $sql = "UPDATE ALBARANES_AIRWILLBILL SET PREFIX = :numero1, SERIAL = :numero2 
                        WHERE ALBARAN = :albaran";
            } else {
                $sql = "INSERT INTO ALBARANES_AIRWILLBILL (ALBARAN, PREFIX, SERIAL) 
                        VALUES (:albaran, :numero1, :numero2)";
            }
            $stmt = $conn_artes_graficas->prepare($sql);
            // echo '<pre>';
            // var_dump($stmt);  
            // echo '</pre>';
            // die;

            $stmt->execute([
                ':albaran' => $albaran,
                ':numero1' => $prefix,
                ':numero2' => $serial
            ]);

            $response = [
                'status' => 'success',
                'message' => 'Archivo subido y datos guardados correctamente',
                'fileUrl' => $uploadFile
            ];
        } catch (PDOException $e) {
                $response = [
                    'status' => 'error',
                    'message' => 'Error al guardar los datos: ' . $e->getMessage()
                ];
        }
    } else {
        $response = [
            'status' => 'error',
            'message' => 'Error al mover el archivo subido'
        ];
    }
} else {
    $response = [
        'status' => 'error',
        'message' => 'No se ha subido ningún archivo'
    ];
}

   //  Enviar respuesta como JSON
   // echo json_encode($response);


    /*************** Envio AirWayBill Adjunto ****************************/
    

    
    $fichero_configuracion_email_aws = 'C:\\CONFIGURACION\\cnf_EMAIL_AWS.inc';

    $config_email_aws = parse_ini_file($fichero_configuracion_email_aws);
    
    if ($config_email_aws === false) {
        die("Error al leer el archivo de configuración.");
    }
    
    $serverAWS = $config_email_aws['servidor'];
    $usuarioAWS = $config_email_aws['usuario'];
    $passAWS = $config_email_aws['contrasenna'];
    
    
    
    // Enviar correo electrónico con el resultado
    $mail = new PHPMailer();
    
    try {
        $mail->SMTPDebug = 0; // Nivel de depuración (0 = off, 1 = cliente, 2 = cliente y servidor)
        $mail->isSMTP();
        $mail->Host = $serverAWS; // servidor SMTP
        $mail->SMTPAuth = true;
        $mail->Username = $usuarioAWS; // usuario
        $mail->Password = $passAWS; // contraseña
        //$mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS; // Para SSL
        //$mail->Port = 465;
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // Encriptación TLS
        $mail->Port       = 587; // Puerto TCP para conectarse
        $mail->CharSet = 'UTF-8'; // Especificar el charset
       // $mail->setFrom('malba@globalia-artesgraficas.com', 'manuel alba');
        $mail->setFrom('noreply@globalia-artesgraficas.com', 'No Reply'); // correo Remitente

        $mail->addAddress('malba@globalia-artesgraficas.com', 'Destinatario'); // correo de destino prueba
       // $mail->addAddress('malba@globalia.com', 'Manuel Alba Globalia'); // correo de destino prueba

        //$mail->addAddress($email, $nombre_apellido); // correo de destinatario real 

        $mail->addAddress('carlos.gonzalez@globalia-artesgraficas.com', 'Carlos Gonzalez'); // correo de destino prueba borrar
       // // $mail->addAddress('malba@globalia-artesgraficas.com', 'Manuel Alba');
       // $mail->addAddress('manuel.alba.gallego@gmail.com', 'Manuel Gmail'); // correo de destino prueba borrar
        $mail->addAddress('Dardolop@gmail.com', 'Dardo López'); // correo de destino prueba borrar
        $mail->addAddress('dlopez@tecnosoftware.com', 'DARDO LOPEZ'); // correo de destino  prueba borrar      
      
        $mail->isHTML(true);
        //$mail->CharSet = 'UTF-8'; // Especificar el charset
        $mail->Subject = " Pruebas Air_Way_Bill correspondiente al pedido: {$pedido}";
        $mail->Body = " Estimado prueba de nombre:  {$nombre_apellido}, Email:  {$email} <br/>";
        $mail->Body .= ' Adjuntamos el AWB correspondiente a su pedido: <b>' . $pedido .'</b>';
        $mail->Body .= '<br /> Puede hacer el seguimiento de su pedido en tiempo real desde el enlace que encontrar&aacute; asociado a este pedido en la secci&oacute;n de “Pedidos Realizados”.';

        $mail->Body .= '<br/><br /> Saludos y gracias.';
        $mail->addAttachment($uploadFile); // Adjunta el archivo Excel
        $mail->Timeout = 30; // Tiempo de espera en segundos
    
        $mail->send();

   
    } catch (Exception $e) {
          echo "Error al enviar el correo: {$mail->ErrorInfo}";
    }    

    /*************** Fin Envio AirWayBill Adjunto ****************************/
    
    
 // Enviar respuesta como JSON
 echo json_encode($response);








