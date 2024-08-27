<?php
//phpinfo();
// Incluir el archivo de conexión
//define('BASE_PATH', realpath(dirname(__FILE__) . '/../PHP'));
//include_once(BASE_PATH . '/conexionArtesGraficas.php');
//include_once('conexionArtesGraficasD.php');
//include_once('../conexionArtesGraficas.php');

// Consulta a la base de datos "artes_graficas"
try {
    $sql = "SELECT ID, CODIGO_SAP, DESCRIPCION FROM ARTICULOS ORDER BY 2";
    $articulos = $conn->query($sql)->fetchAll(PDO::FETCH_ASSOC);
     
} catch (PDOException $e) {
    echo "Error al realizar la consulta en artes_graficas: " . $e->getMessage();
}

// Consulta a la base de datos "GAG"
try {
    $query = "SELECT * FROM V_EMPRESAS ORDER BY EMPRESA";
    $empresas = $conn->query($query)->fetchAll(PDO::FETCH_ASSOC);  
    
} catch (PDOException $e) {
    echo "Error al realizar la consulta en GAG: " . $e->getMessage();
}


