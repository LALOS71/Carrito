<?php
//phpinfo();
// Incluir el archivo de conexión
include_once("../conexionArtesGraficas.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    $prefix = $_POST['prefix'];
    $serial = $_POST['serial'];
    $pedido = $_POST['num_pedido'];
    $codcli = $_POST['cod_cli'];
    $albaran = $_POST['num_albaran'];
    $file = $_FILES['archivo'];
    $anio = date('Y');
    //$codcli = $_POST
    $overwrite = isset($_POST['overwrite']) ? $_POST['overwrite'] : false;

   /*   echo '<pre>';
    var_dump($sucursal );
    var_dump($factura);
    var_dump($pedido);
    var_dump($codcli);
    var_dump($albaran);
    var_dump($anio);
    echo '</pre>';
    
    die;  */

    // Directorio donde se guardarán los archivos subidos
   // $uploadDir = 'C:/CARRITO_IMPRENTA/Carrito/GAG/Pedidos/'.$anio.'/'. $codcli . '__' . $pedido . '/';
    $uploadDir = '../../GAG/Pedidos/'.$anio.'/'. $codcli . '__' . $pedido . '/';
     
    
    if (!is_dir($uploadDir)) {      
        mkdir($uploadDir, 0777, true);
    } 
    
    // Nombre del archivo con ruta completa
    $uploadFile = $uploadDir .'Air_WayBill_'.$albaran.'_'.basename($file['name']);
    $uploadFile = $uploadDir .'Air_WayBill_'.$albaran.'_'.$prefix.'-'.$serial.'.pdf';
    
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
            $stmt = $conn->prepare($sql);
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
            $stmt = $conn->prepare($sql);
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

    // Enviar respuesta como JSON
    echo json_encode($response);







