<?php
session_start();

// RUTAS DE LAS CARPETAS
define("DIRECTORIO_GRANDE","../../../Imagenes_Articulos/");
define("DIRECTORIO_MINIATURAS",'../../../Imagenes_Articulos/Miniaturas/i_');
define("RUTA_TEMPORAL",'../../../Imagenes_articulos/grandes/temp.jpg');


class GestionarImagen
{
    public static function procesarImagen($imagen): ?string
    {
        $_SESSION['error'] = "";
        $nombreImagen = NULL;
        if (isset($imagen["name"]) && $imagen["name"] != "") {
            $nombreImagen = self::subirImagen($imagen);
        } else {
            $nombreImagen = "caratula.png";
        }
        return $nombreImagen;
    }
    public static function subirImagen($imagen): ?string
    {
        $imagenGrande = false;
        $nombreImagen = NULL;
        $extension = strtolower(pathinfo($imagen["name"], PATHINFO_EXTENSION));
        // $nombre = strtolower(pathinfo($imagen["name"], PATHINFO_FILENAME));
        // Comprobar si el archivo es una imagen
        $esImagen = @getimagesize($imagen["tmp_name"]);
        if ($esImagen === false) {
            $_SESSION["error"] = "El archivo no es una imagen.";
            // Comprobar el tamaño del archivo
        } elseif ($imagen["size"] > 1048576) {
            // $_SESSION["error"] = "Rescalando archivo para que tenga 1MB de tamaño máximo.";
            $imagenGrande = true;
            // $rutaArchivo = $directorioDestino . $nombreImagen;
            // Permitir ciertos formatos de archivo
        } elseif ($extension != "jpg" && $extension != "jpeg") {
            $_SESSION["error"] = "Lo siento, solo se permiten archivos JPG.";
        }
        // Intentar mover el archivo subido al directorio destino
        if ($_SESSION["error"] == "") {
            $nombreImagen =  $_POST["codigo"] . '.' . $extension;
            $rutaArchivo = DIRECTORIO_GRANDE . $nombreImagen;
            self::darDeBaja(DIRECTORIO_GRANDE,$nombreImagen,$extension);
            $resultado = @move_uploaded_file($imagen["tmp_name"], $rutaArchivo);
            
            self::redimensionar($rutaArchivo, $nombreImagen, $extension);
            if ($imagenGrande) {
                $maxSize = 1048576; // Tamaño máximo deseado en bytes (1 MB)
                $quality = 75; // Calidad de compresión inicial
                do {
                    // Redimensionar la imagen con la calidad actual
                    $imageData = self::comprimir($rutaArchivo, $quality);
                    
                    // Guardar la imagen redimensionada en una ruta temporal
                    file_put_contents(RUTA_TEMPORAL, $imageData);
 
                    // Verificar el tamaño del archivo después de comprimir la imagen
                    $currentSize = strlen($imageData);
 
                    // Si el tamaño del archivo es menor que el tamaño máximo, salir del bucle
                    if ($currentSize < $maxSize) {
                        break;
                    }
 
                    // Si el tamaño del archivo es igual o mayor al tamaño máximo, reducir la calidad para intentar reducir el tamaño
                    $quality -= 5; // Reducir la calidad en 5 unidades
                } while ($quality > 0);
                // Guardar la imagen redimensionada final en la ubicación deseada
                rename(RUTA_TEMPORAL, DIRECTORIO_GRANDE . $nombreImagen);
                // http_response_code(200);
            }
            if ($resultado === false) {
                $nombreImagen = NULL;
                $_SESSION["error"] = "Hubo un error al subir el archivo.";
                // http_response_code(500);
            }
            // http_response_code(200);
        }
        return $nombreImagen;
    }
    public static function redimensionar($ruta, $nombre,$extension): ?string
    {
 
        // Ruta de la imagen original
        $rutaImagenOriginal = $ruta;
        // Altura deseada
        $alturaDeseada = 140;
 
        // Ancho máximo permitido
        $anchoMaximo = 225;
 
        // Obtener las dimensiones originales de la imagen
        list($anchoOriginal, $alturaOriginal) = getimagesize($rutaImagenOriginal);
 
        // Calcular la nueva anchura manteniendo la relación de aspecto
        $nuevoAncho = $anchoOriginal * ($alturaDeseada / $alturaOriginal);
 
        // Si la nueva anchura es mayor al ancho máximo permitido, ajustar la anchura y altura
        if ($nuevoAncho > $anchoMaximo) {
            $nuevoAncho = $anchoMaximo;
            $nuevaAltura = $alturaOriginal * ($anchoMaximo / $anchoOriginal);
        } else {
            $nuevaAltura = $alturaDeseada;
        }
 
        // Crear una nueva imagen con las nuevas dimensiones
        $nuevaImagen = imagecreatetruecolor(intval($nuevoAncho), intval($nuevaAltura));
 
        // Cargar la imagen original
        $imagenOriginal = imagecreatefromjpeg($rutaImagenOriginal);
 
        // Redimensionar la imagen original a la nueva imagen
        imagecopyresampled($nuevaImagen, $imagenOriginal, 0, 0, 0, 0, intval($nuevoAncho), intval($nuevaAltura), intval($anchoOriginal), intval($alturaOriginal));
 
        // Guardar la nueva imagen redimensionada
        self::darDeBaja(DIRECTORIO_MINIATURAS,$nombre,$extension);
        $rutaNuevaImagen = DIRECTORIO_MINIATURAS . $nombre;
        imagejpeg($nuevaImagen, $rutaNuevaImagen);
 
        // Liberar memoria
        imagedestroy($imagenOriginal);
        imagedestroy($nuevaImagen);
        return "";
    }
    public static function darDeBaja($ruta, $nombre, $extension){
        $completo = $ruta . $nombre;
        if (file_exists($completo)) {
            $fecha_hora = date('Y-m-d_H-i-s');
            $nombreRenombrado = $_POST['codigo']."_".$fecha_hora.'.'.$extension;
            $rutaRenombrada = $ruta . $nombreRenombrado;
            rename($completo,$rutaRenombrada);
        }
        return "";
    }
    public static function comprimir($ruta, $calidad)
    {
        // Crear una imagen a partir del archivo original
        $image = imagecreatefromjpeg($ruta);
 
        // Obtener las dimensiones originales de la imagen
        $originalWidth = imagesx($image);
        $originalHeight = imagesy($image);
 
        // Calcular las nuevas dimensiones de acuerdo a la calidad especificada
        $newWidth = $originalWidth * ($calidad / 100.0);
        $newHeight = $originalHeight * ($calidad / 100.0);
 
        // Crear una nueva imagen con las dimensiones redimensionadas
        $resizedImage = @imagecreatetruecolor($newWidth, $newHeight);
 
        // Redimensionar la imagen original a la nueva imagen con las dimensiones redimensionadas
        @imagecopyresampled($resizedImage, $image, 0, 0, 0, 0, $newWidth, $newHeight, $originalWidth, $originalHeight);
 
        // Capturar la salida de la imagen redimensionada como un string
        ob_start();
        imagejpeg($resizedImage, NULL, $calidad);
        $imageData = ob_get_clean();
 
        // Liberar memoria
        imagedestroy($image);
        imagedestroy($resizedImage);
 
        return $imageData;
    }
}
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (isset($_FILES['imagen'])) {
        GestionarImagen::procesarImagen($_FILES['imagen']);
    }
    if (isset($_POST['baja']) && $_POST['baja'] === "true") {
        $nombreImagen =  $_POST["codigo"] . '.jpg';
        GestionarImagen::darDeBaja(DIRECTORIO_GRANDE,$nombreImagen,"jpg");
        GestionarImagen::darDeBaja(DIRECTORIO_MINIATURAS,$nombreImagen,"jpg");
    }
}