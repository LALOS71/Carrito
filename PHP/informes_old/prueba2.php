<?php
//phpinfo();
require_once 'config.php';
//$codEmpresa = $_POST['selectedValue'];


 class tablaDatos {
    public $conexion;
    public $conexion2;
    public $tablageneral;
    public function __construct() {
        $objeto = new Conexion();
        $this->conexion = $objeto->Conectar();
        
        $objeto = new Conexion2();
        $this->conexion2 = $objeto->Conectar();

        $this->tablaGeneral();
    } 
    public function tablaGeneral() {
        $query = "SELECT ARTICULOS.*,  
                    COALESCE(FORMAT(DEVOLUCIONES.UNIDADES_DEVUELTAS, 'N2'), '0') AS UNIDADES_DEVUELTAS,
                    COALESCE(FORMAT(DEVOLUCIONES.TOTAL_DEVOLUCIONES, 'N2'), '0.00') + ' €' AS TOTAL_IMPORTE_DEVOLUCIONES,
                    COALESCE(FORMAT(UNIDADES_DEVUELTAS - DEVOLUCIONES.UNIDADES_DEVUELTAS, 'N2'), '0') AS CANTIDAD_NETA,                    
                    COALESCE(FORMAT((ARTICULOS.CANTIDAD_TOTAL - UNIDADES_DEVUELTAS), 'N2'), '0') AS CANTIDAD_NETA,
                    COALESCE(FORMAT((ARTICULOS.TOTAL_IMPORTE - TOTAL_DEVOLUCIONES), 'N2'), '0.00') + ' €' AS TOTAL_IMPORTE_NETO  
              FROM (SELECT E.EMPRESA AS NOMBRE_EMPRESA, SUM(A.CANTIDAD) as CANTIDAD_TOTAL, 
                          ROUND(SUM(
                                    CASE
                                        WHEN B.TOTAL = 0 THEN 0
                                        ELSE (
                                            A.CANTIDAD * (B.TOTAL / B.CANTIDAD)
                                        )
                                    END
                                ), 2
                            ) AS TOTAL_IMPORTE, COALESCE(ROUND(
                                SUM(A.CANTIDAD * B.PRECIO_COSTE), 2),0.00) AS TOTAL_PRECIO_COSTE_PEDIDO
                    FROM ENTRADAS_SALIDAS_ARTICULOS A
                    INNER JOIN PEDIDOS_DETALLES B ON A.PEDIDO = B.ID_PEDIDO AND A.ID_ARTICULO = B.ARTICULO
                    INNER JOIN PEDIDOS C ON A.PEDIDO = C.ID
                    INNER JOIN V_CLIENTES D ON C.CODCLI = D.ID
                    INNER JOIN V_EMPRESAS E ON D.EMPRESA = E.ID
                    INNER JOIN ARTICULOS F ON B.ARTICULO = F.ID
                    WHERE 1 = 1 AND A.E_S = 'SALIDA' AND A.TIPO = 'PEDIDO'
                    GROUP BY E.EMPRESA
                ) ARTICULOS
                LEFT JOIN (SELECT V.EMPRESA, SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS
                                , SUM(ROUND(
                                    (
                                        UNIDADES_ACEPTADAS * (T.TOTAL / T.CANTIDAD)
                                    ), 2
                                )
                            ) AS TOTAL_DEVOLUCIONES
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
        $statement = $this->conexion->query($query);
        $data = $statement->fetchAll(PDO::FETCH_ASSOC); 

        echo json_encode($data, JSON_UNESCAPED_UNICODE);
    }
};

 new tablaDatos();