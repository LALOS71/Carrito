<?php
// Conexion prueba
// include_once "./conexion.php";
// Conexion servidor
include_once "../conexionArtesGraficas.php";
try {
    $articulos_cantidad_precio = array();
    $id = $_POST['idArticulo'];
    
    $sql2 = "SELECT articulos.id as ID_ARTICULO,
        articulos.compromiso_compra as COMPROMISO_COMPRA,
        empresa.id as CODIGO_EMPRESA,
        articulos.codigo_sap as CODIGO_SAP,
        empresa.EMPRESA
        ,empresas_tipos.TIPO_PRECIO as TIPO_SUCURSAL
        FROM 
        artes_graficas.dbo.ARTICULOS articulos
        LEFT JOIN artes_graficas.dbo.ARTICULOS_EMPRESAS articulos_empresas ON articulos.ID = articulos_empresas.ID_ARTICULO
        LEFT JOIN artes_graficas.dbo.V_EMPRESAS empresa ON articulos_empresas.CODIGO_EMPRESA = empresa.ID
        LEFT JOIN artes_graficas.dbo.V_EMPRESAS_TIPOS_PRECIOS empresas_tipos ON empresa.ID = empresas_tipos.ID_EMPRESA
        WHERE articulos.ID = :id
        ";

    $stmt = $conn->prepare($sql2);
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);
    $stmt->execute();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        array_push($articulos_cantidad_precio, $row);
    }

    // Convertir los resultados a JSON
    $resultado_json = json_encode($articulos_cantidad_precio);

    echo $resultado_json;
} catch (PDOException $e) {
    echo "Error al ejecutar la consulta: " . $e->getMessage();
} finally {
    $conn = null;
}
