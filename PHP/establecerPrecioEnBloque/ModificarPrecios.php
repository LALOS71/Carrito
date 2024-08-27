<?php
try {
    // Conexion prueba
// include_once "./conexion.php";
// Conexion servidor
    include_once "../conexionArtesGraficas.php";

    $jsonData = json_decode($_POST['json'], true);
    $precioBloque = $_POST['precio'];

    foreach ($jsonData as $articulo) {
        // Creo la transacción
        $conn->beginTransaction();
        $id_articulo=$articulo['ID_ARTICULO'];
        $codigo_empresa=$articulo['CODIGO_EMPRESA'];
        $sucursal=$articulo['TIPO_SUCURSAL'];
        $sql="UPDATE [artes_graficas].[dbo].[CANTIDADES_PRECIOS]
        SET PRECIO_UNIDAD = ? 
        WHERE CODIGO_ARTICULO=? 
        AND CODIGO_EMPRESA =? 
        AND TIPO_SUCURSAL = ?
        ";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(1, $precioBloque, PDO::PARAM_INT);
        $stmt->bindParam(2, $id_articulo, PDO::PARAM_INT);
        $stmt->bindParam(3, $codigo_empresa, PDO::PARAM_INT);
        $stmt->bindParam(4, $sucursal, PDO::PARAM_INT);
        $stmt->execute();
        $num_filas_update = $stmt->rowCount();
        // Si el número de filas es mayor a 0 significa que el update a funcionado pero si es menor nos indica que hay que insertar el dato
        if ($num_filas_update == 0) {
            $insertar="INSERT INTO 
            [artes_graficas].[dbo].[CANTIDADES_PRECIOS] 
            ([CODIGO_ARTICULO]
            ,[CANTIDAD]
            ,[PRECIO_UNIDAD]
            ,[PRECIO_PACK]
            ,[TIPO_SUCURSAL]
            ,[CODIGO_EMPRESA]
          ,[CANTIDAD_SUPERIOR])
            VALUES 
            (?,null,?,null,?,?,null)
            ";
            $stmt_insertar = $conn->prepare($insertar);
            $stmt_insertar->execute([$id_articulo, $precioBloque, $sucursal, $codigo_empresa]);

            $num_filas_insert = $stmt_insertar->rowCount();
            // Si el número de filas insertado es mayor a 0 finalizo la transacción
            if ($num_filas_insert > 0) {
                // echo "Se ha insertado un nuevo registro.\n";
                $conn->commit();
            } else {
                // Rollback si no se insertó ninguna fila
                $conn->rollBack();
                // echo "Error al insertar el nuevo registro.\n";
            }
        }else{
            // Si se ha logrado el update también finalizo la transacción
            $conn->commit();
            // echo "Se ha actualizado el registro existente.\n";
        }
    }
    // Creo el mensaje que mostrare del lado del cliente
    $mensaje="Se han actualizado las siguientes empresas:";
    foreach ($jsonData as $key => $info) {
        $mensaje.=" <br>"."Empresa: ".$info['EMPRESA'];
        $mensaje.=" Sucursal: ".$info['TIPO_SUCURSAL'];
    }
    $mensaje.=" <br> Con un precio unidad: ".$precioBloque;
    $response = array(
        "message" => $mensaje
    );

    echo json_encode($response);
}  catch(PDOException $e) {
    // Manejar la excepción
    $conn->rollBack();
    echo "Error al ejecutar la consulta: " . $e->getMessage();
}finally{

    $conn = null;
    
}

