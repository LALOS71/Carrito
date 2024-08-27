<?php

class TronShop
{
    const COLOR_ERROR = "\e[0;101m";
    const COLOR_SUCCESS = "\e[0;102m";
    const COLOR_WARNING = "\e[0;30;103m";
    const COLOR_INFO = "\e[0;29;100m";
    const COLOR_END = "\e[0m";

    const TRONSHOP_API_DOMAIN = 'https://api-ts-westeu.promotron.com/tronshop-api/';
    const TRONSHOP_API_KEY = 'otH8DLCq1XphYzOv8Z5MNPwWUbxF8pDSAkili+Tari4=';

    const DEFAULT_LANGUAGE_ID = 1;

    public $debug = false;
    public $echo = false;
    public $print = false;

    public $isCli;

    public $xml;

    const U_MAX_EXEC_TIME = 240;
    public $U_START_TIME;

    public function __construct($debug = false)
    {
        $this->debug = $debug;
        if (php_sapi_name() == "cli") {
            $this->isCli = true;
        } else {
            $this->isCli = false;
        }
        $start = new DateTime();
        $this->U_START_TIME = $start->getTimestamp();
    }


    /**
     * API
     */


    public function getCurl($url, $params = '')
    {
        if ($params != '')
            $url .= '?' . $params;

        $headers = [
            'accept: application/json',
            'ApiKey: ' . self::TRONSHOP_API_KEY,
        ];

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, self::TRONSHOP_API_DOMAIN . $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

        $result = curl_exec($ch);
        curl_close($ch);

        return json_decode($result);
    }


    public function getAPIData($entity, $parameter = false, $query = false)
    {
        try {
            $url = $parameter ? $entity . "/" . $parameter : $entity;
            $url = $query ? $url . "?" . http_build_query($query) : $url;

            $items = $this->getCurl($url);

            return $this->setApiDataToArray($items, $entity);
        } catch (Exception $o) {
            $this->traceError($o, $entity);
            return array();
        }
    }



    public function setApiDataToArray($data, $entity)
    {


        $arr = array();
        if (is_array($data)) {
            foreach ($data as $item) {
                try{
                    $arr[] = new $entity($item);
                } catch (Error $e) {
                    print_r($e);
                }
            }
        } else {
            $arr[] = new $entity($data);
        }
        return $arr;
    }



    /**
     * DBO
     */



    public function getDBOData($entity, $fields, $where, $value)
    {
        try {
            $sql = sprintf(
                "SELECT %s FROM %s WHERE %s=%s"
                , $fields
                , $entity
                , $where
                , is_string($value) ? "'" . $value . "'" : $value
            );


//            echo "<pre>";
//            print_r($sql);
//            echo "</pre>";


//            return $this->setApiDataToArray($items, $entity);
        } catch (Exception $o) {
            $this->traceError($o, $entity);
            return array();
        }
    }













    public function searchGroupByName($groupName)
    {
        foreach ($this->ps_groups as $id_group => $group) {
            if ($group['name'] == $groupName)
                return $id_group;
        }
        return false;
    }





    /* COMMON */



    public function exception($o, $message = '')
    {
        /** @var Exception $o */

        $this->errorp($o->getMessage(), $message);
    }

    /**
     * @param Error|Exception|SoapFault $e
     * @param string $message
     */
    public static function traceError($e, $message = '', $debug = false)
    {

        $pError = '<b>' . get_class($e) . '</b>: ' . $e->getMessage() . ' in ' . $e->getFile() . ':' . $e->getLine();
        if ($message != '')
            $pError .= "\n" . "<br />CUSTOM MESSAGE: " . $message;

        if (isset($_SERVER['REQUEST_URI']))
            $pError .= "\n" . "<br />REQUEST_URI: " . $_SERVER['REQUEST_URI'];
        if (!is_null($e->getTrace())) {
            $pError .= "\n" . '<br />Stack trace:';
            foreach ($e->getTrace() as $k => $trace) {
                $pError .= sprintf("\n " . '<br />#%s %s%s %s%s%s(%s)',
                    $k,
                    (isset($trace['file']) ? $trace['file'] : ''),
                    (isset($trace['line']) ? '(' . $trace['line'] . '):' : ''),
                    (isset($trace['class']) ? $trace['class'] : ''),
                    (isset($trace['type']) ? $trace['type'] : ''),
                    (isset($trace['function']) ? $trace['function'] : ''),
                    '' //json_encode($trace['args'])
                );
            }
        }

        if (php_sapi_name() == "cli") {
            printf("%s\n\n%s\n%s\n",
                self::COLOR_ERROR,
                strip_tags($pError),
                self::COLOR_END
            );
        } elseif ($debug) {
            print_r('<div style="border:solid 1px red;padding:10px;color: #333;display:block;background: white;">' . $pError . '</div>');
        }

    }

    public function iErrorHandler($errno, $errstr, $errfile, $errline)
    {
        if (!(error_reporting() & $errno)) {
            return;
        }

        switch ($errno) {
            case E_ERROR:
                $pError = "Error";
                break;
            case E_WARNING:
                $pError = "Warning";
                break;
            case E_PARSE:
                $pError = "Parse Error";
                break;
            case E_NOTICE:
                $pError = "Notice";
                break;
            case E_CORE_ERROR:
                $pError = "Core Error";
                break;
            case E_CORE_WARNING:
                $pError = "Core Warning";
                break;
            case E_COMPILE_ERROR:
                $pError = "Compile Error";
                break;
            case E_COMPILE_WARNING:
                $pError = "Compile Warning";
                break;
            case E_USER_ERROR:
                $pError = "User Error";
                break;
            case E_USER_WARNING:
                $pError = "User Warning";
                break;
            case E_USER_NOTICE:
                $pError = "User Notice";
                break;
            case E_STRICT:
                $pError = "Strict Notice";
                break;
            case E_RECOVERABLE_ERROR:
                $pError = "Recoverable Error";
                break;
            default:
                $pError = "Unknown error ($errno)";
                break;

        }
        $pError .= ": " . $errstr . ' in ' . $errfile . ':' . $errline;
        if (isset($_SERVER['REQUEST_URI']))
            $pError .= "\nREQUEST_URI: " . $_SERVER['REQUEST_URI'];

        if (php_sapi_name() == "cli") {
            printf("%s\n\n%s\n%s\n",
                self::COLOR_WARNING,
                strip_tags($pError),
                self::COLOR_END
            );
        } else {
            print_r('<div style="border:solid 1px greenyellow;padding:10px;color: #333;display:block;background: white;">' . $pError . '</div>');
        }

        return true;
    }

    public static function toRewriteURL($str)
    {
        $str = str_replace(array("Á", "É", "Í", "Ó", "Ú", "Ü", "\u00dc", "Ñ"), array("a", "e", "i", "o", "u", "u", "u", "n"), $str);
        $str = str_replace(array("á", "é", "í", "ó", "ú", "ü", "\u00fc", "ñ"), array("a", "e", "i", "o", "u", "u", "u", "n"), $str);
        $str = trim(strtolower($str));
        $str = str_replace("+", " plus ", $str);
        $str = str_replace("'", "", $str);
        $str = str_replace("/", "-", $str);
        $str = preg_replace("/[^a-z0-9]+/", "-", $str);
        $str = trim($str, "-");

        return $str;
    }

    function eliminar_tildes($cadena)
    {

        $cadena = str_replace(
            array('á', 'à', 'ä', 'â', 'ª', 'Á', 'À', 'Â', 'Ä'),
            array('a', 'a', 'a', 'a', 'a', 'A', 'A', 'A', 'A'),
            $cadena
        );

        $cadena = str_replace(
            array('é', 'è', 'ë', 'ê', 'É', 'È', 'Ê', 'Ë'),
            array('e', 'e', 'e', 'e', 'E', 'E', 'E', 'E'),
            $cadena);

        $cadena = str_replace(
            array('í', 'ì', 'ï', 'î', 'Í', 'Ì', 'Ï', 'Î'),
            array('i', 'i', 'i', 'i', 'I', 'I', 'I', 'I'),
            $cadena);

        $cadena = str_replace(
            array('ó', 'ò', 'ö', 'ô', 'Ó', 'Ò', 'Ö', 'Ô'),
            array('o', 'o', 'o', 'o', 'O', 'O', 'O', 'O'),
            $cadena);

        $cadena = str_replace(
            array('ú', 'ù', 'ü', 'û', 'Ú', 'Ù', 'Û', 'Ü'),
            array('u', 'u', 'u', 'u', 'U', 'U', 'U', 'U'),
            $cadena);

        $cadena = str_replace(
            array('ñ', 'Ñ', 'ç', 'Ç'),
            array('n', 'N', 'c', 'C'),
            $cadena
        );

        return $cadena;
    }


    public function echop($str)
    {
        if ($this->debug || $this->echo || $this->print) {
            $date = date('H:i:s');
            if (php_sapi_name() == "cli") {
                echo "" . $date . " - ";
                print_r($str);
                echo "\n";
            } else {
                echo $date . " - <b>" . $str . "</b><br />\n";
            }
        }
    }

    public function echosuccess($str)
    {
        if ($this->debug || $this->echo || $this->print) {
            $date = date('H:i:s');
            if (php_sapi_name() == "cli") {
                echo "" . $date . " - \033[0;30;42m";
                print_r($str);
                echo "\e[0m";
                echo "\n";
            } else {
                echo $date . " - <b>" . $str . "</b><br />\n";
            }
        }
    }

    public function errorp($errname, $errinfo = "", $errid = "")
    {
        $date = date('H:i:s');
        if (php_sapi_name() == "cli") {
            if ($this->debug || $this->echo) {
//                echo "\033[1;31;47m";
            }
            echo sprintf("%s - %s%s%s",
                $date,
                $errname,
                ($errinfo != '' ? ' - ' . $errinfo : ''),
                ($errid != '' ? ' - ' . $errid : '')
            );

            if ($this->debug || $this->echo) {
//                echo "\e[0m";
            }
            echo "\n";
        } elseif ($this->debug) {
            echo sprintf("%s - <b style='color:red'>%s%s%s</b><br />\n",
                $date,
                $errname,
                ($errinfo != '' ? ' - ' . $errinfo : ''),
                ($errid != '' ? ' - ' . $errid : '')
            );
        }
    }


    public static function urls_amigables($url)
    {
        // Tranformamos todo a minusculas
        $url = strtolower($url);
        //Rememplazamos caracteres especiales latinos
        $find = array('á', 'é', 'í', 'ó', 'ú', 'ñ', 'Á', 'É', 'Í', 'Ó', 'Ú', 'Ñ');
        $repl = array('a', 'e', 'i', 'o', 'u', 'n', 'a', 'e', 'i', 'o', 'u', 'n');
        $url = str_replace($find, $repl, $url);
        // Añaadimos los guiones
        $find = array(' ', '&', '\r\n', '\n', '+');
        $url = str_replace($find, '-', $url);
        // Eliminamos y Reemplazamos demás caracteres especiales
        $find = array('/[^a-z0-9\-<>]/', '/[\-]+/', '/<[^>]*>/');
        $repl = array('', '-', '');
        $url = preg_replace($find, $repl, $url);
        return $url;
    }





    public static function readCsv($path, $delimiter = ",", $headers = true)
    {
        $array = $fields = array();
        $i = 0;
        $handle = @fopen($path, "r");
        if ($handle) {
            while (($row = fgetcsv($handle, 4096, $delimiter)) !== false) {
                if ($headers && empty($fields)) {
                    $fields = $row;
                    continue;
                }
                foreach ($row as $k => $value) {
                    if ($headers) {
                        $array[$i][$fields[$k]] = $value;
                    } else
                        $array[$i][] = $value;
                }
                $i++;
            }
            if (!feof($handle)) {
                echo "Error: unexpected fgets() fail\n";
            }
            fclose($handle);
        }
        return $array;
    }

}
