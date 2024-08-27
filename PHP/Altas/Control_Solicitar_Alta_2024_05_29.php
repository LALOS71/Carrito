<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    include_once "./conexion.php";
    date_default_timezone_set('Europe/Madrid');
    $fechaActual = date("Y-m-d H:i:s");

    //$fechaActual = date("Y-m-d");
    $datos = array(
        'razonSocial' => $_POST['txtrazonsocial'],
        'nif' => $_POST['txtnifcif'],
        'direccion' => $_POST['txtdireccionfiscal'],
        'direccionEnvio' => $_POST['txtdireccion'],
        'poblacion' => $_POST['txtpoblacionfiscal'],
        'poblacionenvio' => $_POST['txtpoblacion'],
        'provincia' => $_POST['txtprovinciafiscal'],
        'provinciaEnvio' => $_POST['txtprovincia'],
        'codPostal' => $_POST['txtcodigopostalfiscal'],
        'codPostalEnvio' => $_POST['txtcodigopostal'],
        'telef' => $_POST['txttelefono'],
        'email' => $_POST['txtemail'],
        'nombreComPer' => $_POST['txtnombre'],
        'fechaActual' => $fechaActual,
	//'fechaActual' => '04/29/2023',
        'contacto' => $_POST['txtnombre']." ".$_POST['txttelefono'],
    );
    // $razonSocial = $_POST['txtrazonsocial'];
    // $nif = $_POST['txtnifcif'];
    try {
        $insert = "set dateformat dmy;INSERT INTO [dbo].[Clientes]
            ([idEmpresa]
            ,[IdSap]
            ,[DelGrupo]
            ,[COD]
            ,[TITULO]
            ,[NIF]
            ,[DOMICILIO]
            ,[Direccion_Envio]
            ,[POBLACION]
            ,[POBLACIONENVIO]
            ,[PROVINCIA]
            ,[PROVINCIAENVIO]
            ,[CODPOSTAL]
            ,[CODPOSTALENVIO]
            ,[TELEF01]
            ,[FAX01]
            ,[EMAIL]
            ,[TITULOL]
            ,[LIMITE]
            ,[DIAS]
            ,[FORMA_PAGO]
            ,[IdFormaPago]
            ,[Texto_Pago]
            ,[CUENTA_BANCARIA]
            ,[CodExterno]
            ,[IdCadena]
            ,[PedMinimoConCompromiso]
            ,[PedMinimoSinCompromiso]
            ,[Contrasena]
            ,[FAlta]
            ,[FBaja]
            ,[Borrado]
            ,[ReqAutoriza]
            ,[IdTipoCliente]
            ,[JefeEconomato]
            ,[idMarca]
            ,[idTipoPrecio]
            ,[idTipo]
            ,[idValidadora]
            ,[Contacto]
            ,[idPais]
            ,[idTipoIva]
            ,[idTratoEspecial]
            ,[CodContable]
            ,[idTipoDocumento]
            ,[SALT]
            ,[NCliente_Globaliagifts]
            ,[ZONA_ENVIO_INTERNACIONAL]
            ,[SCHENGEN_NOSCHENGEN])
      VALUES
            (1
            ,NULL
            ,0
            ,0
            ,:razonSocial
            ,:nif
            ,:direccion
            ,:direccionEnvio
            ,:poblacion
            ,:poblacionenvio
            ,:provincia
            ,:provinciaEnvio
            ,:codPostal
            ,:codPostalEnvio
            ,:telef
            ,NULL
            ,:email
            ,:nombreComPer
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL   
            ,NULL
            ,NULL
            ,999
            ,NULL
            ,NULL
            ,NULL
            ,convert(datetime, :fechaActual, 102)
            ,NULL
            ,0
            ,0
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,:contacto
            ,11
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,NULL)
            ";
        $stmt = $conn->prepare($insert);
	
        foreach ($datos as $campo => $valor) {
            // echo "Campo: ".$campo." valor: ".$valor;
            // echo "<br>";
            $nombreSustituir=':'.$campo;
            $stmt->bindValue($nombreSustituir, $valor);
            // $stmt->bindValue(':'.$campo, $valor);
    
        }
	
	$stmt->execute();
    
        // while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        //     array_push($articulos_cantidad_precio, $row);
        // }
        echo json_encode(array('success' => true));
        // $resultado_json = json_encode($articulos_cantidad_precio);
    
    } catch (PDOException $e) {
        // echo "Error al ejecutar la consulta: " . $e->getMessage();
        echo json_encode(array('success' => false, 'errors' => $e->getMessage(), 'SQL' => $fechaActual));
    
    } finally {
        $conn = null;
        // echo $resultado_json;
    }
}else{
    echo json_encode(array('success' => false, 'errors' => ['No se han enviado datos por el formulario.']));
}
// var_dump($_POST);
