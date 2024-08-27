SELECT
    PEDIDOS.ID Id,
    PEDIDOS.CODCLI,
    V_EMPRESAS.EMPRESA,
    V_CLIENTES.NOMBRE,
    V_CLIENTES.CODIGO_EXTERNO,
    PEDIDOS.PEDIDO,
    CONVERT(VARCHAR(10), PEDIDOS.FECHA, 103) FECHA,
    PEDIDOS.ESTADO,
    V_EMPRESAS.ID AS EMPRESA_ID,
    V_CLIENTES.TIPO as TIPO_CLIENTE,
    V_CLIENTES.REQUIERE_AUTORIZACION,
    PEDIDOS.PEDIDO_AUTOMATICO,
    isnull (PEDIDOS.GASTOS_ENVIO, 0) GASTOS_ENVIO,
    isnull (Nreg, 0) Nreg,
    round(isnull (total_devoluciones, 0), 2) as TotalDevoluciones,
    round(isnull (TOTAL_SALDOS, 0), 2) as TotalSaldos,
    CASE
        WHEN CARGOABONO1 = CARGOABONO2 THEN CARGOABONO1
        WHEN CARGOABONO1 <> CARGOABONO2 THEN 'CARGOABONO'
        ELSE NULL
    END AS CONTROL_CARGOABONO,
    round(
        (
            isnull (total, 0) + isnull (gastos_envio, 0) - isnull (total_devoluciones, 0)
        ) * 0.21,
        2
    ) as TotIva,
    round(
        (
            (
                isnull (total, 0) + isnull (gastos_envio, 0) - isnull (TOTAL_SALDOS, 0) - isnull (total_devoluciones, 0)
            ) + (
                (
                    isnull (total, 0) + isnull (gastos_envio, 0) - isnull (total_devoluciones, 0)
                ) * 0.21
            )
        ),
        2
    ) as TotalEnvio,
    (
        select
            count(*)
        from
            pedidos_detalles
            INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID
        where
            id_pedido = PEDIDOS.ID
            AND ARTICULOS.COMPROMISO_COMPRA = 'NO'
    ) AS COMPROMISO_COMPRA_NO,
    (
        select
            count(*)
        from
            pedidos_detalles
            INNER JOIN ARTICULOS ON PEDIDOS_DETALLES.ARTICULO = ARTICULOS.ID
        where
            id_pedido = PEDIDOS.ID
            AND ARTICULOS.REQUIERE_HOJA_RUTA = 'SI'
    ) AS HOJA_RUTA_SI,
    (
        SELECT
            TOP 1 OBSERVACIONES
        FROM
            PEDIDOS_OBSERVACIONES
        WHERE
            PEDIDO = PEDIDOS.ID
        ORDER BY
            FECHA DESC
    ) AS OBSERVACIONES
FROM
    PEDIDOS
    INNER JOIN V_CLIENTES ON PEDIDOS.CODCLI = V_CLIENTES.Id
    INNER JOIN V_EMPRESAS ON V_CLIENTES.EMPRESA = V_EMPRESAS.Id
    LEFT JOIN (
        SELECT
            ID_Pedido,
            sum(total) Total,
            Sum(1) NReg
        FROM
            Pedidos_Detalles
        where
            estado <> 'ANULADO'
        GROUP BY
            ID_Pedido
    ) Tot ON PEDIDOS.ID = Tot.ID_Pedido
    LEFT JOIN (
        SELECT
            ID_PEDIDO,
            SUM(IMPORTE) AS TOTAL_DEVOLUCIONES
        FROM
            DEVOLUCIONES_PEDIDOS
        GROUP BY
            ID_PEDIDO
    ) Dev ON Dev.ID_PEDIDO = PEDIDOS.ID
    LEFT JOIN (
        SELECT
            ID_PEDIDO,
            SUM(
                CASE
                    WHEN CARGO_ABONO = 'CARGO' THEN IMPORTE * (-1)
                    WHEN CARGO_ABONO = 'ABONO' THEN IMPORTE
                    ELSE IMPORTE
                END
            ) AS TOTAL_SALDOS,
            MAX(CARGO_ABONO) AS CARGOABONO1,
            MIN(CARGO_ABONO) AS CARGOABONO2
        FROM
            SALDOS_PEDIDOS
        GROUP BY
            ID_PEDIDO
    ) Saldos ON SALDOS.ID_PEDIDO = PEDIDOS.ID
WHERE
    1 = 1
    AND PEDIDOS.ESTADO = 'SIN TRATAR'
ORDER BY
    PEDIDOS.FECHA DESC,
    PEDIDOS.CODCLI,
    PEDIDOS.ID