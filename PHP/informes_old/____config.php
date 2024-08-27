<?php 

    class Conexion{	  
        public static function Conectar() {        
            // Configuración para la primera base de datos                
                define('DB1_HOST', '10.153.1.3');
                define('DB1_NAME', 'ARTES_GRAFICAS');
                define('DB1_USER', 'ARTESGRAFICASUSER');
                define('DB1_PASS', 'ARTESGRAFICASUSER');				        
            //$opciones = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');			
            try{
                //$conexion = new PDO("sqlsrv:Server=" . DB3_HOST . ";Database=" . DB3_NAME, DB3_USER, DB3_PASS, $opciones);
                $conexion = new PDO("sqlsrv:Server=" . DB1_HOST . ";Database=" . DB1_NAME, DB1_USER, DB1_PASS);
                $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
                //echo "conectada con exito '". DB1_NAME ."' ";	 
                return $conexion;
            }catch (Exception $e){
                die("El error de Conexión es: ". $e->getMessage());
            }
        }
    }

    
    class Conexion2{	  
        public static function Conectar() {        
            // Configuración para la primera base de datos                
                define('DB2_HOST', '10.153.1.3');
                define('DB2_NAME', 'Gag');
                define('DB2_USER', 'ARTESGRAFICASUSER');
                define('DB2_PASS', 'ARTESGRAFICASUSER');				        
            //$opciones = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');			
            try{
                //$conexion = new PDO("sqlsrv:Server=" . DB4_HOST . ";Database=" . DB4_NAME, DB4_USER, DB4_PASS, $opciones);
                $conexion = new PDO("sqlsrv:Server=" . DB2_HOST . ";Database=" . DB2_NAME, DB2_USER, DB2_PASS);
                $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);	
               // echo "conectada con exito '". DB2_NAME ."' 2"; 		
                return $conexion;
            }catch (Exception $e){
                die("El error de Conexión es: ". $e->getMessage());
            }
        }
    }

     // Configuración para la primera base de datos
    /*  define('DB1_HOST', 'NB564');
     define('DB1_NAME', 'artes_graficas');
     define('DB1_USER', 'sa');
     define('DB1_PASS', '1234'); */	
     
    // Configuración para la primera base de datos                
    /* define('DB2_HOST', 'NB564');
    define('DB2_NAME', 'GAG');
    define('DB2_USER', 'sa');
    define('DB2_PASS', '1234');			 */
   
/* 
    try {
        // Conexión a la primera base de datos
        $db1 = new PDO("sqlsrv:Server=" . DB1_HOST . ";Database=" . DB1_NAME, DB1_USER, DB1_PASS);
        $db1->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Conexión a la segunda base de datos
        $db2 = new PDO("sqlsrv:Server=" . DB2_HOST . ";Database=" . DB2_NAME, DB2_USER, DB2_PASS);
        $db2->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
       // echo "conectada con exito";
    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
 */
