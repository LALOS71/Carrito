<?php


class SQLServer
{
    const DB_PREFIX = "dbo.";
    const DB_DATABASE = "GAG";
    const DB_USER = "sa";
    const DB_PASSWORD = "Globalia2023.*";



    public function __construct()
    {
        $serverName = "localhost";
        global $sqlsrv;

        $connectionInfo = [
            "Authentication" => "SqlPassword",
            "Encrypt" => 0,
            "Database" => self::DB_DATABASE,
            "UID" => self::DB_USER,
            "PWD" => self::DB_PASSWORD,
            "CharacterSet" => "UTF-8"
        ];
        $sqlsrv = sqlsrv_connect($serverName, $connectionInfo);

        if (!$sqlsrv) {
            echo "Connection could not be established.<br />";
            echo "<pre>";
            print_r(sqlsrv_errors());
            echo "</pre>";

            die();
        }

    }

    public static function select($sql)
    {
        global $sqlsrv;


        $result = sqlsrv_query($sqlsrv, $sql);

        if ($result === false)
            return false;
//        while($row = sqlsrv_fetch_object($result)) {
//            print_r($row);
//        }
        return $result; //$resultado;

    }

    public static function Update($sql)
    {
        global $sqlsrv;

        $stmt = sqlsrv_query($sqlsrv, $sql);
        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }
    }

    public static function InsertInto($sql)
    {
        global $sqlsrv;

        $stmt = sqlsrv_query($sqlsrv, $sql);
        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }
        return $stmt;
    }

    public static function execute($sql)
    {
        global $sqlsrv;

        $stmt = sqlsrv_query($sqlsrv, $sql);
        if ($stmt === false) {
            die(print_r(sqlsrv_errors(), true));
        }
        return $stmt;
    }

    public static function lastId()
    {
        global $sqlsrv;
    }


    public function selectRow($sql, $entity = false)
    {
        $rst = $this->select($sql);
        $records = [];

        if (!$rst)
            return false;

        while ($row = sqlsrv_fetch_object($rst)) {
            if ($entity) {
                $records[] = new $entity($row);
            } else {
                $records[] = $row;
            }
        }

        if (count($records) == 0)
            return false;

        return $records[0];
    }


    public function selectAll($sql, $entity = false)
    {
        $rst = $this->select($sql);

        $records = [];

        while ($row = sqlsrv_fetch_object($rst)) {
            if ($entity) {
                $records = new $entity($row);
            } else {
                $records = $row;
            }
        }

        return $records;
    }

}