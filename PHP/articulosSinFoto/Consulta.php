<?php
// Conexion prueba
// include_once "./conexion.php";
// Conexion servidor
include_once "../conexionArtesGraficas.php";
class Consulta{
    public static function formarInfo($id,$referencia,$articulo,$empresa,$agrupacion_familia,$familia,$mostrar,$borrado){
        return array(
            "id" => $id,
            "codigo_sap" => $referencia,
            "descripcion" => $articulo,
            "empresa" => $empresa,
            "agrupacion_familia" => $agrupacion_familia,
            "familia" => $familia,
            "mostrar" => $mostrar,
            "borrado" => $borrado,
        );
    }
}
// Ruta a la carpeta de imágenes
// $ruta_carpeta_imagenes = "./imagenes_articulos/";
$ruta_carpeta_imagenes = "../../Imagenes_Articulos/";

// Obtener la lista de archivos de imágenes en la carpeta
$archivos_imagenes = scandir($ruta_carpeta_imagenes);

// Array para almacenar los códigos de las imágenes
$codigos_imagenes = array();

// Extraer los códigos de los nombres de archivo de las imágenes
foreach ($archivos_imagenes as $nombre_archivo) {
    // echo $nombre_archivo."<br>";
    // Solo procesar archivos con extensiones de imagen (puedes ajustar esto según tus necesidades)
    if (pathinfo($nombre_archivo, PATHINFO_EXTENSION) == "jpg" || pathinfo($nombre_archivo, PATHINFO_EXTENSION) == "JPG" || pathinfo($nombre_archivo, PATHINFO_EXTENSION) == "JPEG" || pathinfo($nombre_archivo, PATHINFO_EXTENSION) == "jpeg") {
        $codigos_imagenes[] = pathinfo($nombre_archivo, PATHINFO_FILENAME);
    }
}

// Simulación de códigos de artículos de la base de datos
$codigos_articulos_base_datos = array();
$articulos_base_datos = array();

$stmt = $conn->query("SELECT articulos.id,
max(articulos.codigo_sap) as referencia,
max(articulos.descripcion)as articulo,
max(articulos.mostrar) as mostrar,
max(articulos.borrado) as borrado,
CASE 
        WHEN COUNT(DISTINCT empresa) > 1 THEN 'Varias...'
        ELSE MAX(empresa)
    END AS empresa,
CASE 
WHEN COUNT(DISTINCT familia_agrupada.GRUPO_FAMILIAS) > 1 THEN 'Varias...'
ELSE MAX(familia_agrupada.GRUPO_FAMILIAS)
END AS agrupacion_familia,
CASE
WHEN COUNT(DISTINCT familia.DESCRIPCION) > 1 THEN 'Varias...'
ELSE MAX(familia.DESCRIPCION)
END AS familia
FROM 
artes_graficas.dbo.ARTICULOS articulos
LEFT JOIN artes_graficas.dbo.ARTICULOS_EMPRESAS articulos_empresas ON articulos.ID = articulos_empresas.ID_ARTICULO
LEFT JOIN artes_graficas.dbo.FAMILIAS familia ON articulos_empresas.FAMILIA = familia.ID
LEFT JOIN artes_graficas.dbo.V_EMPRESAS empresa ON articulos_empresas.CODIGO_EMPRESA = empresa.ID
LEFT JOIN artes_graficas.dbo.FAMILIAS_AGRUPADAS familia_agrupada ON familia.id = familia_agrupada.ID_FAMILIA
GROUP BY 
    articulos.ID
ORDER BY articulos.ID DESC
");
while ($row = $stmt->fetch()) {
    array_push($articulos_base_datos,$row);
}
$conn = null;
$codigos_articulos_base_datos = array_column($articulos_base_datos, "id");

// Comparar las listas y encontrar discrepancias
$articulos_sin_imagen = array_diff($codigos_articulos_base_datos, $codigos_imagenes);

$repetidos = array_count_values($articulos_sin_imagen);

// Filtrar los IDs que se repiten
$idsRepetidos = array_filter($repetidos, function($valor) {
    return $valor > 1;
});

$articulos_sin_imagen_info = array();

foreach ($articulos_sin_imagen as $id) {
    foreach ($articulos_base_datos as $articulo) {
        if ($articulo['id'] === $id) {
            $articulos_sin_imagen_info[] =Consulta::formarInfo($articulo['id'],$articulo['referencia'],$articulo['articulo'],$articulo['empresa'],$articulo['agrupacion_familia'],$articulo['familia'],$articulo['mostrar'],$articulo['borrado']);
            break;
        }
    }
}
// Convertir los resultados a JSON
$resultado_json = json_encode($articulos_sin_imagen_info);
// var_dump($codigos_imagenes);
echo $resultado_json;

