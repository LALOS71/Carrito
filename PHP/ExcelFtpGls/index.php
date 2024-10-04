﻿<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// para que se cargue la biblioteca PhpSpreadsheet
require 'vendor/autoload.php'; 

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PHPMailer\PHPMailer\PHPMailer;

include_once "../conexionArtesGraficas_SQL.php";

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
$sql .= " SELECT A.ID_CLIENTE, CASE WHEN A.ID_CLIENTE = 0 THEN 'GAG' ELSE B.CODIGO_EXTERNO END AS CODIGO_EXTERNO";
$sql .= ", CASE WHEN A.ID_CLIENTE = 0 THEN 'ALMACEN GAG' ELSE B.NOMBRE END AS NOMBRE";
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
$result = sqlsrv_query($conn_artes_graficas_sql, $sql);

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

try {
    echo "<BR>...... instanciamos spreadsheet.";
	// Crear una instancia de PhpSpreadsheet
	$spreadsheet = new Spreadsheet();
	
	echo "<BR>...... Activamos una hoja.";
	$sheet = $spreadsheet->getActiveSheet();
	
	// Encabezados de columna
	
	echo "<BR>...... Configuramos Cabeceras.";
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
	echo "<BR>...... Rellenamos Filas.";
	while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
		$columnIndex = 1;
		foreach ($row as $value) {
			$sheet->setCellValueByColumnAndRow($columnIndex, $rowIndex, $value);
			$columnIndex++;
		}
		$rowIndex++;
	}
	
	$fecha_actual = date("Y_m_d");
	
	echo "<BR>...... Guardamos Excel.";
	// Guardar el archivo Excel
	$writer = new Xlsx($spreadsheet);
	//si se ejecuta desde la consola da error la ruta
	//$writer->save($_SERVER['DOCUMENT_ROOT'] . '\PHP\files\listado_printers_' . $fecha_actual . '.xlsx'); 
	//$writer->save('D:\Intranets\Ventas\asp\Carrito_Imprenta\PHP\files\listado_printers_' . $fecha_actual . '.xlsx'); 
	$writer->save('A:\iis-web\carrito\PHP\files\listado_printers_' . $fecha_actual . '.xlsx'); 
	
	echo "<BR><br>...FICHERO listado_printers_' . $fecha_actual . '.xlsx GENERADO...";

} catch (Exception $e) {
    echo '<br>Error: ',  $e->getMessage(), "<br>";
}


// Cerrar la conexión
sqlsrv_close($conn_artes_graficas_sql);

echo "<BR><br>...CERRADA LA CONEXION CON LA BASE DE DATOS...";

//enviamos el fichero de excel al ftp
//desde la consola de windows da error porque no entiende el directorio
//$srcFile = $_SERVER['DOCUMENT_ROOT'] . '\PHP\files\listado_printers_' . $fecha_actual . '.xlsx';
$srcFile = 'A:\iis-web\carrito\PHP\files\listado_printers_' . $fecha_actual . '.xlsx';
$dstFile = '/IN/listado_printers_' . $fecha_actual . '.xlsx';
 


$fichero_ftp_gls = 'C:\\CONFIGURACION\\cnf_FTP_GLS.inc';

$config_ftp_gls = parse_ini_file($fichero_ftp_gls);

if ($config_ftp_gls === false) {
    die("Error al leer el archivo de configuración.");
}

//datos ftp GLS
$port = '22';
$host = $config_ftp_gls['servidor'];
$username = $config_ftp_gls['usuario'];
$password = $config_ftp_gls['contrasenna'];



echo "<BR><br>...NOS CONECTAMOS AL FTP...";
// Create connection the the remote host
$conn_ftp = ssh2_connect($host, $port);
ssh2_auth_password($conn_ftp, $username, $password);
 
// Create SFTP session
$sftp = ssh2_sftp($conn_ftp);
 
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
$mail->setFrom('malba@globalia-artesgraficas.com', 'manuel alba');
$mail->addAddress('malba@globalia-artesgraficas.com', 'Destinatario'); // correo de destino
$mail->isHTML(true);
$mail->Subject = 'Informe de proceso';
$mail->Body = 'Se ha realizado el proceso correctamente.';
$mail->addAttachment($srcFile); // Adjunta el archivo Excel
$mail->Timeout = 30; // Tiempo de espera en segundos


if (!$mail->send()) {
    echo "Error al enviar el correo: " . $mail->ErrorInfo;
} else {
    echo "El proceso se ha completado con éxito. Se ha enviado un correo con los resultados.";
}







echo "<BR><br>...FIN...";








?>
