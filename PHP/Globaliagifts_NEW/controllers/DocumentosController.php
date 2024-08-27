<?php


class DocumentosController extends TronShop
{


    public static function getType($nif = '')
    {

        if($nif=="")
            return 3;

        $nif_codes = 'TRWAGMYFPDXBNJZSQVHLCKE';


        if (self::validateCIF($nif))
            return 1;

        if (preg_match ('/^[0-9]{8}[A-Z]{1}$/', $nif)) {
            // DNIs
            $num = substr($nif, 0, 8);

            if ($nif[8] == $nif_codes[$num % 23])
                return 1;
        }
        if (preg_match ('/^[XYZ][0-9]{7}[A-Z]{1}$/', $nif)) {
            // NIEs normales
            $tmp = substr ($nif, 1, 7);
            $tmp = strtr(substr ($nif, 0, 1), 'XYZ', '012') . $tmp;
            if ($nif[8] == $nif_codes[$tmp % 23])
                return 2;
        }
        if (preg_match ('/^[KLM]{1}/', $nif)) {
            // NIFs especiales

            $sum = (string) self::getCifSum($nif);
            if(!$sum)
                return 3;
            $n = 10 - substr($sum, -1);

            return ($nif[8] == chr($n + 64));
        }
        if (preg_match ('/^[T]{1}[A-Z0-9]{8}$/', $nif)) {
            // NIE extraño
            return 2;
        }

        return 3;
    }


    public static function getCifSum($cif) {
        echo "<pre>";
        print_r($cif);
        echo "</pre>";
        echo "<pre>";
        print_r(strlen($cif));
        echo "</pre>";



        if(strlen($cif)<8)
            return false;
        $sum = $cif[2] + $cif[4] + $cif[6];

        for ($i = 1; $i<8; $i += 2) {
            $tmp = (string) (2 * $cif[$i]);

            $tmp = $tmp[0] + ((strlen ($tmp) == 2) ?  $tmp[1] : 0);

            $sum += $tmp;
        }

        return $sum;
    }
    public static function validateCIF($dni)
    {
        $cif = strtoupper($dni);
        for ($i = 0; $i < 9; $i++) {
            $num[$i] = substr($cif, $i, 1);
        }
        // Si no tiene un formato valido devuelve error
        if (!preg_match('/((^[A-Z]{1}[0-9]{7}[A-Z0-9]{1}$|^[T]{1}[A-Z0-9]{8}$)|^[0-9]{8}[A-Z]{1}$)/', $cif)) {
            return false;
        }
        // Comprobacion de NIFs estandar
//        if (preg_match('/(^[0-9]{8}[A-Z]{1}$)/', $cif)) {
//            if ($num[8] == substr('TRWAGMYFPDXBNJZSQVHLCKE', substr($cif, 0, 8) % 23, 1)) {
//                return true;
//            } else {
//                return false;
//            }
//        }
        // Algoritmo para comprobacion de codigos tipo CIF
        $suma = $num[2] + $num[4] + $num[6];
        for ($i = 1; $i < 8; $i += 2) {
            $suma += (int)substr((2 * $num[$i]), 0, 1) + (int)substr((2 * $num[$i]), 1, 1);
        }
        $n = 10 - substr($suma, strlen($suma) - 1, 1);
        // Comprobacion de NIFs especiales (se calculan como CIFs o como NIFs)
        if (preg_match('/^[KLM]{1}/', $cif)) {
            if ($num[8] == chr(64 + $n) || $num[8] == substr('TRWAGMYFPDXBNJZSQVHLCKE', substr($cif, 1, 8) % 23, 1)) {
                return true;
            } else {
                return false;
            }
        }
        // Comprobacion de CIFs
        if (preg_match('/^[ABCDEFGHJNPQRSUVW]{1}/', $cif)) {
            if ($num[8] == chr(64 + $n) || $num[8] == substr($n, strlen($n) - 1, 1)) {
                return true;
            } else {
                return false;
            }
        }
        // Comprobacion de NIEs
        // T
        if (preg_match('/^[T]{1}/', $cif)) {
            if ($num[8] == preg_match('/^[T]{1}[A-Z0-9]{8}$/', $cif)) {
                return true;
            } else {
                return false;
            }
        }
        // XYZ
        if (preg_match('/^[XYZ]{1}/', $cif)) {
            if ($num[8] == substr('TRWAGMYFPDXBNJZSQVHLCKE', substr(str_replace(array('X', 'Y', 'Z'), array('0', '1', '2'), $cif), 0, 8) % 23, 1)) {
                return true;
            } else {
                return false;
            }
        }
        // Si todavía no se ha verificado devuelve error
        return false;

    }
}