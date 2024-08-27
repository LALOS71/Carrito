CONSULTA: -- FILTRO DIFERENCIAR SUCURSALES
SELECT
  ARTICULOS.*
 ,DEVOLUCIONES.UNIDADES_DEVUELTAS
 ,DEVOLUCIONES.TOTAL_DEVOLUCIONES AS TOTAL_IMPORTE_DEVOLUCIONES
FROM (SELECT
    E.EMPRESA AS NOMBRE_EMPRESA
   ,D.ID CODCLIENTE
   ,D.NOMBRE
   ,D.CODIGO_EXTERNO
   ,SUM(A.CANTIDAD) AS CANTIDAD_TOTAL
   ,ROUND(SUM(CASE
      WHEN B.TOTAL = 0 THEN 0
      ELSE (A.CANTIDAD * (B.TOTAL / B.CANTIDAD))
    END), 2) AS TOTAL_IMPORTE
   ,ROUND(SUM(A.CANTIDAD * B.PRECIO_COSTE), 2) AS TOTAL_PRECIO_COSTE_PEDIDO
  FROM ENTRADAS_SALIDAS_ARTICULOS A
  INNER JOIN PEDIDOS_DETALLES B
    ON A.PEDIDO = B.ID_PEDIDO
    AND A.ID_ARTICULO = B.ARTICULO
  INNER JOIN PEDIDOS C
    ON A.PEDIDO = C.ID
  INNER JOIN V_CLIENTES D
    ON C.CODCLI = D.ID
  INNER JOIN V_EMPRESAS E
    ON D.EMPRESA = E.ID
  INNER JOIN ARTICULOS F
    ON B.ARTICULO = F.ID
  WHERE 1 = 1
  AND A.E_S = 'SALIDA'
  AND A.TIPO = 'PEDIDO'
  AND (CONVERT(VARCHAR(8), A.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME, '01-04-2024', 103), 112))
  AND (CONVERT(VARCHAR(8), A.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME, '23-04-2024', 103), 112))
  GROUP BY E.EMPRESA
          ,D.ID
          ,D.NOMBRE
          ,D.CODIGO_EXTERNO) ARTICULOS
LEFT JOIN (SELECT
    V.EMPRESA
   ,W.ID AS CODCLIENTE
   ,SUM(UNIDADES_ACEPTADAS) AS UNIDADES_DEVUELTAS
   ,SUM(ROUND((UNIDADES_ACEPTADAS * (T.TOTAL / T.CANTIDAD)), 2)) AS TOTAL_DEVOLUCIONES
  FROM DEVOLUCIONES_DETALLES Z
  INNER JOIN (SELECT
      ID_ARTICULO
     ,PEDIDO
     ,E_S
     ,TIPO
     ,MIN(FECHA) AS FECHA
    FROM ENTRADAS_SALIDAS_ARTICULOS
    GROUP BY PEDIDO
            ,ID_ARTICULO
            ,E_S
            ,TIPO) Y
    ON Z.ID_ARTICULO = Y.ID_ARTICULO
    AND Z.ID_PEDIDO = Y.PEDIDO
    AND Z.UNIDADES_ACEPTADAS >= 1
    AND Y.E_S = 'SALIDA'
    AND Y.TIPO = 'PEDIDO'
  LEFT JOIN PEDIDOS X
    ON X.ID = Z.ID_PEDIDO
  LEFT JOIN V_CLIENTES W
    ON W.ID = X.CODCLI
  LEFT JOIN V_EMPRESAS V
    ON V.ID = W.EMPRESA
  LEFT JOIN PEDIDOS_DETALLES T
    ON Z.ID_PEDIDO = T.ID_PEDIDO
    AND Z.ID_ARTICULO = T.ARTICULO
  WHERE Z.UNIDADES_ACEPTADAS >= 1
  AND (CONVERT(VARCHAR(8), Y.FECHA, 112) >= CONVERT(VARCHAR(8), CONVERT(DATETIME, '01-04-2024', 103), 112))
  AND (CONVERT(VARCHAR(8), Y.FECHA, 112) <= CONVERT(VARCHAR(8), CONVERT(DATETIME, '23-04-2024', 103), 112))
  GROUP BY V.EMPRESA
          ,W.ID) DEVOLUCIONES
  ON ARTICULOS.NOMBRE_EMPRESA = DEVOLUCIONES.EMPRESA
    AND ARTICULOS.CODCLIENTE = DEVOLUCIONES.CODCLIENTE
ORDER BY ARTICULOS.NOMBRE_EMPRESA, ARTICULOS.NOMBRE