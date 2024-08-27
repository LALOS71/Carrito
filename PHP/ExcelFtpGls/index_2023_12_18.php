<?php

// para que se cargue la biblioteca PhpSpreadsheet
require 'vendor/autoload.php'; 

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PHPMailer\PHPMailer\PHPMailer;

$serverName = "192.168.156.136";
$connectionInfo = [
    "Authentication" => "SqlPassword",
    "Encrypt" => 0,
    "Database" => "artes_graficas",
    "UID" => "backhalconuser",
    "PWD" => "imprenta",
    "CharacterSet" => "UTF-8"
];

echo "<br>...CONECTANDO CON LA BASE DE DATOS...";
// Establecer la conexión
$conn = sqlsrv_connect($serverName, $connectionInfo);

if (!$conn) {
    die("Error en la conexión: " . print_r(sqlsrv_errors()));
}

// Consulta SQL

$sql = "SELECT C.ID AS ID_CLIENTE, C.CODIGO_EXTERNO, C.NOMBRE, C.TIPO";
$sql .= ", 'PENDIENTE DE FIRMA ' + CAST(B.CANTIDAD AS VARCHAR(10)) + ' IMP.' AS SN_IMPRESORA_PEDIDOS";
$sql .= ", B.ID_PEDIDO , CONVERT(varchar, A.FECHA, 103) as ULTIMA_FECHA, A.ESTADO";
//AQUI HAY QUE METER OTRA COLUMNA QUE INDIQUE SI ES FACTURABLE SI O NO....
$sql .= ", CASE WHEN A.ESTADO IN ('ACTIVA', 'DEFECTUOSA', 'AVERIADA', 'EN REVISION', 'EN CESION'";
$sql .= ", 'SOLICITUD BAJA', 'SOLICITUD DEFECTUOSA', 'SOLICITUD AVERIADA', 'BAJA APROBADA'";
$sql .= ", 'BAJA RECHAZADA') THEN 'SI' ELSE 'NO'";
$sql .= " END AS FACTURABLE";
$sql .= ", A.RENTING_IMPRESORA_GLS AS RENTING";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.NOMBRE_FISCAL_FACTURAR ELSE NULL END AS RAZON_SOCIAL";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.DIRECCION_FACTURAR ELSE NULL END AS DIRECCION";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.CP_FACTURAR ELSE NULL END AS CP";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.CIUDAD_FACTURAR ELSE NULL END AS POBLACION";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.PROVINCIA_FACTURAR ELSE NULL END AS PROVINCIA";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.NIF_FACTURAR ELSE NULL END AS NIF";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.EMAIL ELSE NULL END AS EMAIL";
$sql .= " FROM PEDIDOS A";
$sql .= " INNER JOIN PEDIDOS_DETALLES B ON A.ID=B.ID_PEDIDO";
$sql .= " LEFT JOIN V_CLIENTES C ON C.ID=A.CODCLI";
$sql .= " WHERE PEDIDO_AUTOMATICO='IMPRESORA_GLS_ADMIN'";
$sql .= " AND B.ARTICULO=4583";
$sql .= " AND B.ESTADO = 'PENDIENTE_FIRMA'";
$sql .= " UNION";
$sql .= " SELECT C.ID AS ID_CLIENTE, C.CODIGO_EXTERNO, C.NOMBRE, C.TIPO";
$sql .= ", 'PENDIENTE ENVIAR ' + CAST(B.CANTIDAD AS VARCHAR(10)) + ' IMP.' AS SN_IMPRESORA_PEDIDOS";
$sql .= ", B.ID_PEDIDO , CONVERT(varchar, A.FECHA, 103) as ULTIMA_FECHA, 'PENDIENTE' AS ESTADO";
$sql .= ", 'NO' AS FACTURABLE";
$sql .= ", A.RENTING_IMPRESORA_GLS AS RENTING ";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.NOMBRE_FISCAL_FACTURAR ELSE NULL END AS RAZON_SOCIAL";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.DIRECCION_FACTURAR ELSE NULL END AS DIRECCION";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.CP_FACTURAR ELSE NULL END AS CP";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.CIUDAD_FACTURAR ELSE NULL END AS POBLACION";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.PROVINCIA_FACTURAR ELSE NULL END AS PROVINCIA";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.NIF_FACTURAR ELSE NULL END AS NIF";
$sql .= ", CASE WHEN C.TIPO = 'ARRASTRES' THEN C.EMAIL ELSE NULL END AS EMAIL";
$sql .= " FROM PEDIDOS A";
$sql .= " INNER JOIN PEDIDOS_DETALLES B ON A.ID=B.ID_PEDIDO";
$sql .= " LEFT JOIN V_CLIENTES C ON C.ID=A.CODCLI";
$sql .= " WHERE (PEDIDO_AUTOMATICO='IMPRESORA_GLS' OR PEDIDO_AUTOMATICO='IMPRESORA_GLS_ADMIN'";
$sql .= " OR PEDIDO_AUTOMATICO='IMPRESORA_GLS_GAG')";
$sql .= " AND B.ARTICULO=4583";
$sql .= " AND B.ESTADO NOT IN ('ENVIADO','RECHAZADO', 'ENVIO PARCIAL', 'ANULADO', 'PENDIENTE_FIRMA')";
$sql .= " UNION";
$sql .= " SELECT A.ID_CLIENTE, B.CODIGO_EXTERNO, CASE WHEN A.ID_CLIENTE = 0 THEN 'ALMACEN GAG' ELSE B.NOMBRE END AS NOMBRE";
$sql .= ", CASE WHEN A.ID_CLIENTE = 0 THEN 'ALMACEN' ELSE B.TIPO END AS TIPO, A.SN_IMPRESORA, A.ID_PEDIDO";
$sql .= ", CONVERT(varchar, HIS.FECHA, 103) AS ULTIMA_FECHA, A.ESTADO";
$sql .= ", CASE WHEN A.ESTADO IN ('ACTIVA', 'DEFECTUOSA', 'AVERIADA', 'EN REVISION', 'EN CESION'";
$sql .= ", 'SOLICITUD BAJA', 'SOLICITUD DEFECTUOSA', 'SOLICITUD AVERIADA', 'BAJA APROBADA'";
$sql .= ", 'BAJA RECHAZADA') THEN 'SI' ELSE 'NO' END AS FACTURABLE";
$sql .= ", A.RENTING AS RENTING";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.NOMBRE_FISCAL_FACTURAR ELSE NULL END AS RAZON_SOCIAL";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.DIRECCION_FACTURAR ELSE NULL END AS DIRECCION";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.CP_FACTURAR ELSE NULL END AS CP";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.CIUDAD_FACTURAR ELSE NULL END AS POBLACION";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.PROVINCIA_FACTURAR ELSE NULL END AS PROVINCIA";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.NIF_FACTURAR ELSE NULL END AS NIF";
$sql .= ", CASE WHEN TIPO = 'ARRASTRES' THEN B.EMAIL ELSE NULL END AS EMAIL";
$sql .= " FROM GLS_IMPRESORAS A";
$sql .= " INNER JOIN (SELECT SN_IMPRESORA, FECHA";
$sql .= ", ROW_NUMBER() OVER( PARTITION BY SN_IMPRESORA ORDER BY FECHA DESC) AS NUMFILA";
$sql .= " FROM GLS_IMPRESORAS_HISTORICO) HIS ON A.SN_IMPRESORA=HIS.SN_IMPRESORA AND NUMFILA=1";
$sql .= " LEFT JOIN V_CLIENTES B ON A.ID_CLIENTE=B.ID";
$sql .= " WHERE 1=1 ORDER BY 2, 3";







echo "<BR><br>...OBTENIENDO LAS IMPRESORAS...";
$result = sqlsrv_query($conn, $sql);

if ($result === false) {
    die("Error en la consulta: " . sqlsrv_errors());
}

/*
echo "<BR><br>...MOSTRAMOS LAS IMPRESORAS...";
// Recorrer y mostrar los registros
while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
    echo "IMPRESORA: " . $row['SN_IMPRESORA_PEDIDOS'];
    // Agrega aquí más campos según tu tabla
    echo "<br>";
}
*/


echo "<BR><br>...EXPORTAMOS A EXCEL (fichero resultados.xlsx)...";



// Crear una instancia de PhpSpreadsheet
$spreadsheet = new Spreadsheet();
$sheet = $spreadsheet->getActiveSheet();

// Encabezados de columna


$columnHeaders = array("ID_CLIENTE", "CODIGO_EXTERNO", "NOMBRE", "TIPO", "SN_IMPRENTA_PEDIDOS"
    , "ID_PEDIDO", "ULTIMA_FECHA", "ESTADO", "FACTURABLE", "RENTING", "RAZON SOCIAL", "DIRECCION", "CP"
    , "POBLACION", "PROVINCIA", "NIF", "EMAIL");

$columnIndex = 1;
foreach ($columnHeaders as $header) {
    $sheet->setCellValueByColumnAndRow($columnIndex, 1, $header);
    $columnIndex++;
}

// Llenar la hoja de cálculo con los datos de la base de datos
$rowIndex = 2; // Empezar desde la segunda fila
while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
    $columnIndex = 1;
    foreach ($row as $value) {
        $sheet->setCellValueByColumnAndRow($columnIndex, $rowIndex, $value);
        $columnIndex++;
    }
    $rowIndex++;
}

$fecha_actual = date("Y_m_d");

// Guardar el archivo Excel
$writer = new Xlsx($spreadsheet);
//si se ejecuta desde la consola da error la ruta
//$writer->save($_SERVER['DOCUMENT_ROOT'] . '\PHP\files\Impresoras_GLS_' . $fecha_actual . '.xlsx'); 
$writer->save('D:\Intranets\Ventas\asp\Carrito_Imprenta\PHP\files\Impresoras_GLS_' . $fecha_actual . '.xlsx'); 

echo "<BR><br>...FICHERO Impresoras_GLS_' . $fecha_actual . '.xlsx GENERADO...";


// Cerrar la conexión
sqlsrv_close($conn);

echo "<BR><br>...CERRADA LA CONEXION CON LA BASE DE DATOS...";

//enviamos el fichero de excel al ftp
//desde la consola de windows da error porque no entiende el directorio
//$srcFile = $_SERVER['DOCUMENT_ROOT'] . '\PHP\files\Impresoras_GLS_' . $fecha_actual . '.xlsx';
$srcFile = 'D:\Intranets\Ventas\asp\Carrito_Imprenta\PHP\files\Impresoras_GLS_' . $fecha_actual . '.xlsx';
$dstFile = '/IN/Impresoras_GLS_' . $fecha_actual . '.xlsx';
 
//datos ftp globalia
//$host = 'sftp.globalia-corp.com';
//$port = '22';
//$username = 'facturassaphalcon';
//$password = 'FacturasS4P';

//datos ftp GLS
$host = 'atenea.gls-spain.es';
$port = '22';
$username = 'factprinters';
$password = '$Ra2N2)94a';



echo "<BR><br>...NOS CONECTAMOS AL FTP...";
// Create connection the the remote host
$conn = ssh2_connect($host, $port);
ssh2_auth_password($conn, $username, $password);
 
// Create SFTP session
$sftp = ssh2_sftp($conn);
 
$sftpStream = fopen('ssh2.sftp://'.$sftp.$dstFile, 'w');
 
try {
 
    if (!$sftpStream) {
        throw new Exception("Could not open remote file: $dstFile");
    }
 
    $data_to_send = file_get_contents($srcFile);
 
    if ($data_to_send === false) {
        throw new Exception("Could not open local file: $srcFile.");
    }
 
    echo "<BR><br>...ENVIANDO EL FICHERO...";
    if (fwrite($sftpStream, $data_to_send) === false) {
        throw new Exception("Could not send data from file: $srcFile.");
    }
 
    echo "<BR><br>...PROCESO DE ENVIO DEL FICHERO POR FTP FINALIZADO...";    
    fclose($sftpStream);
 
} catch (Exception $e) {
    error_log('Exception: ' . $e->getMessage());
    fclose($sftpStream);
}


// Enviar correo electrónico con el resultado
$mail = new PHPMailer();
$mail->isSMTP();
$mail->Host = '192.168.150.44'; // Reemplaza con el servidor SMTP
//$mail->SMTPAuth = true;
//$mail->Username = 'tu_correo_electronico'; // Reemplaza con tu correo electrónico
//$mail->Password = 'tu_contraseña_correo'; // Reemplaza con tu contraseña de correo electrónico
//$mail->SMTPSecure = 'tls';
//$mail->Port = 587;
$mail->setFrom('malba@globalia.com', 'manuel alba');
$mail->addAddress('malba@globalia.com', 'Destinatario'); // Reemplaza con el correo de destino
$mail->isHTML(true);
$mail->Subject = 'Informe de proceso';
$mail->Body = 'Se ha realizado el proceso correctamente.';
$mail->addAttachment($srcFile); // Adjunta el archivo Excel

if (!$mail->send()) {
    echo "Error al enviar el correo: " . $mail->ErrorInfo;
} else {
    echo "El proceso se ha completado con éxito. Se ha enviado un correo con los resultados.";
}







echo "<BR><br>...FIN...";








?>
