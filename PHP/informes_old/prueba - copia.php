<?php

define('BASE_PATH', realpath(dirname(__FILE__) . '/../../PHP'));
include_once(BASE_PATH . '/conexionArtesGraficas.php');

ini_set('memory_limit', '256M');
ini_set('max_execution_time', 60); // Aumenta el tiempo a 60 segundos

$opcion = intval((isset($_POST['opcion'])) ? $_POST['opcion'] : '');
$empresaId = (isset($_POST['selectedValue'])) ? $_POST['selectedValue'] : '';
$articuloid = (isset($_POST['selectedValue2'])) ? $_POST['selectedValue2'] : '';

 $fechaInicio = (isset($_POST['fechaInicio'])) ? $_POST['fechaInicio'] : '01-01-2000';
$fechaFin = (isset($_POST['fechaFin'])) ? $_POST['fechaFin'] : date('d-m-Y');


if (!empty($fechaInicio)) {
    $fechaInicio = date_format(date_create($fechaInicio), 'd-m-Y');
  }  
if (!empty($fechaFin)) {
    $fechaFin = date_format(date_create($fechaFin), 'd-m-Y');
  } 

 
 /*  $fechaInicio = date('Y-m-d', strtotime($fechaInicio));
  $fechaFin = date('Y-m-d', strtotime($fechaFin)); */

$filtros = (isset($_POST['filtros'])) ? $_POST['filtros'] : array();
$filtros2 = (isset($_POST['filtros2'])) ? $_POST['filtros2'] : array();

$data = '';
$select = "";
$groupby = "";
$groupby2 = "";
$and = "";


$select = "E.EMPRESA AS NOMBRE_EMPRESA, B.ESTADO";
$groupby = "E.EMPRESA, B.ESTADO";

// Verificar si el checkbox está marcado y construir las partes SELECT y GROUP BY
if (isset($filtros['chkdiferenciar_sucursales']) && $filtros['chkdiferenciar_sucursales']) {
    $select .= ", D.ID AS CODCLIENTE, D.NOMBRE, D.CODIGO_EXTERNO ";
    $groupby .= ", D.ID, D.NOMBRE, D.CODIGO_EXTERNO ";
   
}
if (isset($filtros['chkdiferenciar_articulos']) && $filtros['chkdiferenciar_articulos']
    || isset($filtros['chkdiferenciar_rappel']) || isset($filtros['chkdiferenciar_costes']))  {        
    // Query 2: otros filtros están seleccionados junto con 'chkdiferenciar_sucursales'
    $select .= ", B.ARTICULO AS ID_ARTICULO, F.CODIGO_SAP, F.DESCRIPCION, F.UNIDADES_DE_PEDIDO, F.RAPPEL, F.VALOR_RAPPEL, F.PRECIO_COSTE
    , (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=F.PROVEEDOR) AS PROVEEDOR, F.REFERENCIA_DEL_PROVEEDOR ";
    $groupby .= ", B.ARTICULO, F.CODIGO_SAP, F.DESCRIPCION, F.UNIDADES_DE_PEDIDO, F.RAPPEL, F.VALOR_RAPPEL, F.PRECIO_COSTE
    , F.PROVEEDOR, F.REFERENCIA_DEL_PROVEEDOR";

    $groupby2 = ", Z.ID_ARTICULO "; 
    $and = " AND ARTICULOS.ID_ARTICULO=DEVOLUCIONES.ID_ARTICULO ";
} 

if (isset($filtros['chkdiferenciar_marca']) && $filtros['chkdiferenciar_marca']
    || isset($filtros['chkdiferenciar_tipo']) && $filtros['chkdiferenciar_tipo']) {
    $select .= ", D.MARCA, D.TIPO ";
    $groupby .= ", D.MARCA, D.TIPO";

    $groupby2 = ", W.MARCA, W.TIPO";
    $and = " AND ARTICULOS.MARCA=DEVOLUCIONES.MARCA AND ARTICULOS.TIPO=DEVOLUCIONES.TIPO ";

}

$estadoPedido = isset($filtros['chkpedidos_parciales']) && $filtros['chkpedidos_parciales'] ? "AND B.ESTADO = 'ENVIADO'" : "";

$estadoPedido1 = isset($filtros2['chkpedidos_parciales']) && $filtros2['chkpedidos_parciales'] ? "AND D.ESTADO = 'ENVIADO'" : "";

$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
$limit = 50; // Número de resultados por página
$offset = ($page - 1) * $limit;

try {
    switch ($opcion) { 
              
         case 1: // General 
            $query = "SELECT ARTICULOS.*
                    , ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS,0) AS UNIDADES_DEVUELTAS
                    , FORMAT(ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES,0),'0.00') + ' €' AS TOTAL_IMPORTE_DEVOLUCIONES
                    , ARTICULOS.CANTIDAD_TOTAL - ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS, 0) AS CANTIDAD_NETA
                    , ARTICULOS.TOTAL_IMPORTE - ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 0) AS TOTAL_NETO                  
                FROM (SELECT E.EMPRESA AS NOMBRE_EMPRESA, B.ESTADO, SUM(A.CANTIDAD) as CANTIDAD_TOTAL, 
                            ROUND(SUM(CASE WHEN B.TOTAL = 0 THEN 0
                                        ELSE(A.CANTIDAD * (B.TOTAL / B.CANTIDAD))
                                    END), 2) AS TOTAL_IMPORTE
                    , COALESCE(ROUND(SUM(A.CANTIDAD * B.PRECIO_COSTE), 2),0.00) AS TOTAL_PRECIO_COSTE_PEDIDO
                    FROM ENTRADAS_SALIDAS_ARTICULOS A
                    INNER JOIN PEDIDOS_DETALLES B ON A.PEDIDO = B.ID_PEDIDO AND A.ID_ARTICULO = B.ARTICULO
                    INNER JOIN PEDIDOS C ON A.PEDIDO = C.ID
                    INNER JOIN V_CLIENTES D ON C.CODCLI = D.ID
                    INNER JOIN V_EMPRESAS E ON D.EMPRESA = E.ID
                    INNER JOIN ARTICULOS F ON B.ARTICULO = F.ID
                    WHERE 1 = 1 AND A.E_S = 'SALIDA' AND A.TIPO = 'PEDIDO'
                    GROUP BY E.EMPRESA, B.ESTADO) ARTICULOS
                LEFT JOIN (SELECT V.EMPRESA, SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS
                              , SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL / T.CANTIDAD)), 2)) AS TOTAL_DEVOLUCIONES
                            FROM DEVOLUCIONES_DETALLES Z
                            INNER JOIN (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA
                                    FROM ENTRADAS_SALIDAS_ARTICULOS
                                    GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO
                            ) Y ON Z.ID_ARTICULO = Y.ID_ARTICULO
                            AND Z.ID_PEDIDO = Y.PEDIDO
                            AND Z.UNIDADES_ACEPTADAS >= 1
                            AND Y.E_S = 'SALIDA'
                            AND Y.TIPO = 'PEDIDO'
                            LEFT JOIN PEDIDOS X ON X.ID = Z.ID_PEDIDO
                            LEFT JOIN V_CLIENTES W ON W.ID = X.CODCLI
                            LEFT JOIN V_EMPRESAS V ON V.ID = W.EMPRESA
                            LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO = T.ID_PEDIDO
                            AND Z.ID_ARTICULO = T.ARTICULO
                            WHERE Z.UNIDADES_ACEPTADAS >= 1
                            GROUP BY V.EMPRESA
                    ) DEVOLUCIONES ON ARTICULOS.NOMBRE_EMPRESA = DEVOLUCIONES.EMPRESA
                ORDER BY ARTICULOS.NOMBRE_EMPRESA";

            $statement = $conn->query($query);
            $data = $statement->fetchAll(PDO::FETCH_ASSOC);
        break;

        case 2:  //Empresas  

            $query = "SELECT ARTICULOS.*           
                    , ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS,0) AS UNIDADES_DEVUELTAS
                    , FORMAT(ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES,0),'0.00') + ' €' AS TOTAL_IMPORTE_DEVOLUCIONES
                    , ARTICULOS.CANTIDAD_TOTAL - ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS, 0) AS CANTIDAD_NETA
                    , ARTICULOS.TOTAL_IMPORTE - ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 0) AS TOTAL_NETO	 
                    FROM (SELECT E.EMPRESA AS NOMBRE_EMPRESA, B.ESTADO, SUM(A.CANTIDAD) AS CANTIDAD_TOTAL
                    , ROUND(SUM(CASE WHEN B.TOTAL = 0 THEN 0 
                            ELSE (A.CANTIDAD * (B.TOTAL / B.CANTIDAD)) END), 2) AS TOTAL_IMPORTE
                    , COALESCE(ROUND(SUM(A.CANTIDAD * B.PRECIO_COSTE), 2),0.00) AS TOTAL_PRECIO_COSTE_PEDIDO
                    FROM ENTRADAS_SALIDAS_ARTICULOS A 
                    INNER JOIN PEDIDOS_DETALLES B ON A.PEDIDO = B.ID_PEDIDO AND A.ID_ARTICULO = B.ARTICULO 
                    INNER JOIN PEDIDOS C ON A.PEDIDO = C.ID 
                    INNER JOIN V_CLIENTES D ON C.CODCLI = D.ID 
                    INNER JOIN V_EMPRESAS E ON D.EMPRESA = E.ID 
                    INNER JOIN ARTICULOS F ON B.ARTICULO = F.ID
                    WHERE 1=1
                    AND ('".$empresaId."' = '' OR D.EMPRESA = '".$empresaId."')
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (A.FECHA >= '".$fechaInicio."' AND A.FECHA <= '".$fechaFin."')") ." 
                    AND A.E_S = 'SALIDA' AND A.TIPO = 'PEDIDO' 
                    GROUP BY E.EMPRESA, B.ESTADO) AS ARTICULOS
                    LEFT JOIN (SELECT V.EMPRESA, SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS,
                        SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL / T.CANTIDAD)), 2)) AS TOTAL_DEVOLUCIONES 
                    FROM DEVOLUCIONES_DETALLES Z 
                    INNER JOIN (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA FROM ENTRADAS_SALIDAS_ARTICULOS 
                    GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y ON Z.ID_ARTICULO = Y.ID_ARTICULO 
                    AND Z.ID_PEDIDO = Y.PEDIDO AND Z.UNIDADES_ACEPTADAS >= 1 AND Y.E_S = 'SALIDA' AND Y.TIPO = 'PEDIDO' 
                    LEFT JOIN PEDIDOS X ON X.ID = Z.ID_PEDIDO LEFT JOIN V_CLIENTES W ON W.ID = X.CODCLI 
                    LEFT JOIN V_EMPRESAS V ON V.ID = W.EMPRESA LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO = T.ID_PEDIDO 
                    AND Z.ID_ARTICULO = T.ARTICULO  
                    WHERE Z.UNIDADES_ACEPTADAS >= 1
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (Y.FECHA >= '".$fechaInicio."' AND Y.FECHA <= '".$fechaFin."')") ."     
                    GROUP BY V.EMPRESA) AS DEVOLUCIONES ON ARTICULOS.NOMBRE_EMPRESA = DEVOLUCIONES.EMPRESA 
                    ORDER BY ARTICULOS.NOMBRE_EMPRESA ASC";          
                   
            $stmt = $conn->query($query);
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
        break;   

        case 3: // Articulos
                        
            $query = "SELECT ARTICULOS.*, COALESCE(DEVOLUCIONES.UNIDADES_DEVUELTAS, 0) AS UNIDADES_DEVUELTAS
                    , COALESCE(FORMAT(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 'N2'), '0.00') + ' €' AS TOTAL_IMPORTE_DEVOLUCIONES 
                    , COALESCE(FORMAT(ROUND(CASE WHEN ARTICULOS.TOTAL_IMPORTE=0 THEN 0 
                        ELSE (DEVOLUCIONES.UNIDADES_DEVUELTAS * (ARTICULOS.TOTAL_IMPORTE/ARTICULOS.CANTIDAD_TOTAL)) END, 2),'N2'), '0.00') + ' €' AS TOTAL_IMPORTE_DEVOLUCIONES 
                FROM (SELECT A.ID AS ID_ARTICULO , A.CODIGO_SAP as CODIGO_SAP, A.DESCRIPCION as ARTICULO, A.UNIDADES_DE_PEDIDO
                    , A.RAPPEL, A.VALOR_RAPPEL, A.PRECIO_COSTE, D.ESTADO
                    , (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=A.PROVEEDOR) AS PROVEEDOR, A.REFERENCIA_DEL_PROVEEDOR
                    , COALESCE(SUM(B.CANTIDAD),0) as CANTIDAD_TOTAL		
                    , ROUND(SUM(CASE WHEN D.TOTAL=0 THEN 0 ELSE (B.CANTIDAD * (D.TOTAL/D.CANTIDAD)) END), 2) AS TOTAL_IMPORTE		
                    , COALESCE(FORMAT(ROUND(SUM(B.CANTIDAD * D.PRECIO_COSTE), 2),'N2'), '0.00') + ' €' AS TOTAL_PRECIO_COSTE_PEDIDO 
                    FROM ARTICULOS A 
                    INNER JOIN ENTRADAS_SALIDAS_ARTICULOS B ON A.ID=B.ID_ARTICULO AND B.E_S='SALIDA' AND B.TIPO='PEDIDO' 
                    INNER JOIN PEDIDOS C ON C.ID = B.PEDIDO 
                    INNER JOIN PEDIDOS_DETALLES D ON C.ID=D.ID_PEDIDO AND A.ID=D.ARTICULO 
                    INNER JOIN V_CLIENTES E ON C.CODCLI = E.Id 
                    INNER JOIN V_EMPRESAS F ON E.EMPRESA = F.Id 
                    WHERE 1=1
                    AND ('".$articuloid."' = '' OR A.ID = '".$articuloid."')
                    {$estadoPedido1}
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (B.FECHA >= '".$fechaInicio."' AND B.FECHA <= '".$fechaFin."')") ." 
                    -- AND (CONVERT(VARCHAR(8), B.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'01-01-2024', 103) , 112)) 
                    -- AND (CONVERT(VARCHAR(8), B.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'10-05-2024', 103) , 112)) 
                    GROUP BY A.ID, A.CODIGO_SAP, A.DESCRIPCION, A.UNIDADES_DE_PEDIDO, A.RAPPEL, A.VALOR_RAPPEL, A.PRECIO_COSTE, A.PROVEEDOR
                    , D.ESTADO, A.REFERENCIA_DEL_PROVEEDOR) ARTICULOS 
                    LEFT JOIN (SELECT Z.ID_ARTICULO
                    , COALESCE(SUM(UNIDADES_ACEPTADAS),0) AS UNIDADES_DEVUELTAS
                    , COALESCE(SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)),0) AS TOTAL_DEVOLUCIONES 
                    -- , SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS
                    -- , SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)) AS TOTAL_DEVOLUCIONES 
                    FROM DEVOLUCIONES_DETALLES Z 
                    INNER JOIN (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA FROM ENTRADAS_SALIDAS_ARTICULOS 
                    GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y ON Z.ID_ARTICULO=Y.ID_ARTICULO 
                    AND Z.ID_PEDIDO=Y.PEDIDO AND Z.UNIDADES_ACEPTADAS>=1 AND Y.E_S='SALIDA' AND Y.TIPO='PEDIDO' 
                    LEFT JOIN PEDIDOS X ON X.ID=Z.ID_PEDIDO LEFT JOIN V_CLIENTES W ON W.ID=X.CODCLI 
                    LEFT JOIN V_EMPRESAS V ON V.ID=W.EMPRESA LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO=T.ID_PEDIDO AND Z.ID_ARTICULO=T.ARTICULO 
                    WHERE Z.UNIDADES_ACEPTADAS>=1
                    AND ('".$articuloid."' = '' OR Z.ID_ARTICULO = '".$articuloid."')
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (Y.FECHA >= '".$fechaInicio."' AND Y.FECHA <= '".$fechaFin."')") ." 
                    -- AND (CONVERT(VARCHAR(8), Y.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME,'01-01-2024', 103) , 112)) 
                    -- AND (CONVERT(VARCHAR(8), Y.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME,'10-05-2024', 103) , 112)) 
                    GROUP BY Z.ID_ARTICULO) DEVOLUCIONES ON ARTICULOS.ID_ARTICULO=DEVOLUCIONES.ID_ARTICULO 
                    ORDER BY ARTICULOS.ARTICULO";

            $stmt = $conn->query($query);
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);          
        break;
       
        case 4: // Empresas cheked dif.Sucursales + check.dif.articulos + check.Mostr info.rappel + check.mostrar coste

            $query = "SELECT ARTICULOS.*                
                    , ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS,0) AS UNIDADES_DEVUELTAS
                    , FORMAT(ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES,0),'0.00') + ' €' AS TOTAL_IMPORTE_DEVOLUCIONES
                    , ARTICULOS.CANTIDAD_TOTAL - ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS, 0) AS CANTIDAD_NETA
                    , ARTICULOS.TOTAL_IMPORTE - ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 0) AS TOTAL_NETO
                FROM (SELECT {$select}                
                    , SUM(A.CANTIDAD) as CANTIDAD_TOTAL
                    , ROUND(SUM(CASE WHEN B.TOTAL=0 THEN 0 ELSE (A.CANTIDAD * (B.TOTAL/B.CANTIDAD)) END), 2) AS TOTAL_IMPORTE               
                    , COALESCE(ROUND(SUM(A.CANTIDAD * B.PRECIO_COSTE), 2),0.00) AS TOTAL_PRECIO_COSTE_PEDIDO 
                    FROM ENTRADAS_SALIDAS_ARTICULOS A 
                    INNER JOIN PEDIDOS_DETALLES B ON A.PEDIDO=B.ID_PEDIDO AND A.ID_ARTICULO=B.ARTICULO 
                    INNER JOIN PEDIDOS C ON A.PEDIDO=C.ID INNER JOIN V_CLIENTES D ON C.CODCLI=D.ID 
                    INNER JOIN V_EMPRESAS E ON D.EMPRESA=E.ID 
                    INNER JOIN ARTICULOS F ON B.ARTICULO=F.ID WHERE 1=1 AND A.E_S='SALIDA' AND A.TIPO='PEDIDO'                
                    AND ('".$empresaId."' = '' OR D.EMPRESA = '".$empresaId."')
                    {$estadoPedido} 
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (A.FECHA >= '".$fechaInicio."' AND A.FECHA <= '".$fechaFin."')") . "
                    GROUP BY {$groupby}) ARTICULOS  
                    LEFT JOIN (SELECT V.EMPRESA, W.ID AS CODCLIENTE {$groupby2}
                    , SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS
                    , SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)) AS TOTAL_DEVOLUCIONES FROM DEVOLUCIONES_DETALLES Z 
                    INNER JOIN (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA FROM ENTRADAS_SALIDAS_ARTICULOS 
                    GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y ON Z.ID_ARTICULO=Y.ID_ARTICULO AND Z.ID_PEDIDO=Y.PEDIDO AND Z.UNIDADES_ACEPTADAS>=1 
                    AND Y.E_S='SALIDA' AND Y.TIPO='PEDIDO' LEFT JOIN PEDIDOS X ON X.ID=Z.ID_PEDIDO LEFT JOIN V_CLIENTES W ON W.ID=X.CODCLI 
                    LEFT JOIN V_EMPRESAS V ON V.ID=W.EMPRESA LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO=T.ID_PEDIDO AND Z.ID_ARTICULO=T.ARTICULO 
                    WHERE Z.UNIDADES_ACEPTADAS>=1
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (Y.FECHA >= '".$fechaInicio."' AND Y.FECHA <= '".$fechaFin."')") . "                
                    GROUP BY V.EMPRESA, W.ID {$groupby2}) DEVOLUCIONES ON ARTICULOS.NOMBRE_EMPRESA=DEVOLUCIONES.EMPRESA 
                    {$and} 
                    -- AND ARTICULOS.CODCLIENTE=DEVOLUCIONES.CODCLIENTE 
                    ORDER BY ARTICULOS.NOMBRE_EMPRESA 
                    --,ARTICULOS.DESCRIPCION
                    -- , ARTICULOS.NOMBRE
                    ";  
                 /*  var_dump($query);
                 die;       */                 
           
            $stmt = $conn->query($query);
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC); 
          
        break; 

        case 5: // Articulos + cheked dif.Empresas + check.dif.Sucur + check.dif.Marcas + check.dif tipo

            $query = "SELECT ARTICULOS.*
                    , COALESCE(DEVOLUCIONES.UNIDADES_DEVUELTAS, 0) AS UNIDADES_DEVUELTAS
                    , COALESCE(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 0) AS TOTAL_DEVOLUCIONES
                    , ARTICULOS.CANTIDAD_TOTAL - ISNULL(DEVOLUCIONES.UNIDADES_DEVUELTAS, 0) AS CANTIDAD_NETA
                    , ARTICULOS.TOTAL_IMPORTE - ISNULL(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 0) AS TOTAL_NETO
                    , ROUND(CASE WHEN ARTICULOS.TOTAL_IMPORTE=0 THEN 0 
                        ELSE (DEVOLUCIONES.UNIDADES_DEVUELTAS * (ARTICULOS.TOTAL_IMPORTE/ARTICULOS.CANTIDAD_TOTAL)) END, 2) AS TOTAL_IMPORTE_DEVOLUCIONES 
                FROM (SELECT A.ID AS ID_ARTICULO , A.CODIGO_SAP as CODIGO_SAP, A.DESCRIPCION as ARTICULO, A.UNIDADES_DE_PEDIDO, A.RAPPEL, A.VALOR_RAPPEL
                    , A.PRECIO_COSTE, (SELECT DESCRIPCION FROM PROVEEDORES WHERE ID=A.PROVEEDOR) AS PROVEEDOR, A.REFERENCIA_DEL_PROVEEDOR, F.EMPRESA AS NOMBRE_EMPRESA
                    , E.Id AS CODCLIENTE, E.NOMBRE, E.CODIGO_EXTERNO, E.MARCA, E.TIPO, D.ESTADO
                    , SUM(B.CANTIDAD) as CANTIDAD_TOTAL
                    , ROUND(SUM(CASE WHEN D.TOTAL=0 THEN 0 ELSE (B.CANTIDAD * (D.TOTAL/D.CANTIDAD)) END), 2) AS TOTAL_IMPORTE
                    , ROUND(SUM(B.CANTIDAD * D.PRECIO_COSTE), 2) AS TOTAL_PRECIO_COSTE_PEDIDO FROM ARTICULOS A 
                    INNER JOIN ENTRADAS_SALIDAS_ARTICULOS B ON A.ID=B.ID_ARTICULO AND B.E_S='SALIDA' AND B.TIPO='PEDIDO' 
                    INNER JOIN PEDIDOS C ON C.ID = B.PEDIDO INNER JOIN PEDIDOS_DETALLES D ON C.ID=D.ID_PEDIDO AND A.ID=D.ARTICULO 
                    INNER JOIN V_CLIENTES E ON C.CODCLI = E.Id INNER JOIN V_EMPRESAS F ON E.EMPRESA = F.Id WHERE 1=1                    
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (B.FECHA >= '".$fechaInicio."' AND B.FECHA <= '".$fechaFin."')") ." 
                    {$estadoPedido1}
                    AND ('".$articuloid."' = '' OR A.ID = '".$articuloid."')
                    GROUP BY A.ID, A.CODIGO_SAP, A.DESCRIPCION, A.UNIDADES_DE_PEDIDO, D.ESTADO, A.RAPPEL, A.VALOR_RAPPEL, A.PRECIO_COSTE, A.PROVEEDOR
                    , A.REFERENCIA_DEL_PROVEEDOR, F.EMPRESA, E.ID, E.NOMBRE, E.CODIGO_EXTERNO, E.MARCA, E.TIPO)	ARTICULOS 
                    LEFT JOIN (SELECT Z.ID_ARTICULO, V.EMPRESA, W.ID AS CODCLIENTE, W.MARCA, W.TIPO
                    , SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS
                    , SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL/T.CANTIDAD)),2)) AS TOTAL_DEVOLUCIONES FROM DEVOLUCIONES_DETALLES Z 
                    INNER JOIN (SELECT ID_ARTICULO, PEDIDO, E_S, TIPO, MIN(FECHA) AS FECHA FROM ENTRADAS_SALIDAS_ARTICULOS 
                    GROUP BY PEDIDO, ID_ARTICULO, E_S, TIPO) Y ON Z.ID_ARTICULO=Y.ID_ARTICULO AND Z.ID_PEDIDO=Y.PEDIDO AND Z.UNIDADES_ACEPTADAS>=1 
                    AND Y.E_S='SALIDA' AND Y.TIPO='PEDIDO' LEFT JOIN PEDIDOS X ON X.ID=Z.ID_PEDIDO LEFT JOIN V_CLIENTES W ON W.ID=X.CODCLI 
                    LEFT JOIN V_EMPRESAS V ON V.ID=W.EMPRESA LEFT JOIN PEDIDOS_DETALLES T ON Z.ID_PEDIDO=T.ID_PEDIDO AND Z.ID_ARTICULO=T.ARTICULO 
                    WHERE Z.UNIDADES_ACEPTADAS>=1                     
                    AND ('".$articuloid."' = '' OR Z.ID_ARTICULO = '".$articuloid."')
                    ". (empty($fechaInicio) && empty($fechaFin) ? "" : "AND (Y.FECHA >= '".$fechaInicio."' AND Y.FECHA <= '".$fechaFin."')") ."  
                    GROUP BY Z.ID_ARTICULO, V.EMPRESA, W.ID, W.MARCA, W.TIPO) DEVOLUCIONES ON ARTICULOS.ID_ARTICULO=DEVOLUCIONES.ID_ARTICULO 
                    AND ARTICULOS.NOMBRE_EMPRESA=DEVOLUCIONES.EMPRESA AND ARTICULOS.CODCLIENTE=DEVOLUCIONES.CODCLIENTE 
                    AND ARTICULOS.MARCA=DEVOLUCIONES.MARCA AND ARTICULOS.TIPO=DEVOLUCIONES.TIPO 
                    ORDER BY ARTICULOS.ARTICULO, ARTICULOS.NOMBRE_EMPRESA, ARTICULOS.NOMBRE, ARTICULOS.MARCA, ARTICULOS.TIPO";

            $stmt = $conn->query($query);
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);          
                        
        break;      

        default:
            $data = 'Dardo no ingresa opciones ';
        break;
    }

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
echo json_encode($data, JSON_UNESCAPED_UNICODE);
