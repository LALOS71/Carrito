<?php


class DBOClass
{
    public function __construct($ws = false)
    {
        if ($ws && (is_array($ws) || is_object($ws))) {
            foreach ($this as $k => $v) {
                if (isset($ws->{$k})) {
                    if (class_exists($k))
                        $this->{$k} = new $k($ws->{$k});
                    else
                        $this->{$k} = $ws->{$k};
                }
            }
        }
    }

    public function add()
    {
        //echo '<br>DBOCLASS - ADD<BR>';
        $SQLServer = new SQLServer();

        $entity = [];
        foreach ($this as $k => $v) {

            if($v || $v===0) {
                if($v instanceof DateTime)
                    $entity[$k] = "'" . $v->format('Ymd H:i:s') . "'";
                elseif(is_numeric($v))
                    $entity[$k] = $v;
                else
                    $entity[$k] = "'" . trim($v) . "'";
            }
        }
        $sql = sprintf(
            "INSERT INTO %s (%s) VALUES (%s) "
            , $SQLServer::DB_PREFIX . get_class($this)
            , join(",", array_keys($entity))
            , join(",", $entity)
        );

        //echo "<pre>";
        //print_r($sql);
        //echo "</pre>\n";

        $SQLServer->InsertInto($sql);

        $sql = sprintf(
            "SELECT * FROM %s WHERE %s = SCOPE_IDENTITY()"
            , $SQLServer::DB_PREFIX . get_class($this)
            , $this->getPrimaryKey()
        );
        return $SQLServer->selectRow($sql);

    }
    public function save()
    {
        $SQLServer = new SQLServer();

        $entity = [];
        foreach ($this as $k => $v) {

            if($v || $v===0) {
                if($v instanceof DateTime)
                    $entity[$k] = "'" . $v->format('Ymd H:i:s') . "'";
                elseif(is_numeric($v))
                    $entity[$k] = $v;
                else
                    $entity[$k] = "'" . trim($v) . "'";
            }
        }
        $sql = sprintf(
            "INSERT INTO %s (%s) VALUES (%s) "
            , $SQLServer::DB_PREFIX . get_class($this)
            , join(",", array_keys($entity))
            , join(",", $entity)
        );

//        echo "<pre>";
//        print_r($sql);
//        echo "</pre>\n";

        $SQLServer->InsertInto($sql);


        return true;

    }

}