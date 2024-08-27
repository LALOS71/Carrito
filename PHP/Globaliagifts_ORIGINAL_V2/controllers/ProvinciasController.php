<?php


class ProvinciasController extends TronShop
{


    public function getProvinceName($postalcode)
    {
        $province_zip = substr($postalcode, 0, 2);

        $sql = sprintf(
            "SELECT * FROM dbo.Provincias WHERE zipcode='%s'"
            , $province_zip
        );

        $SQLServer = new SQLServer();

        $provincia = $SQLServer->selectRow($sql, 'Provincias');

        if ($provincia)
            return $provincia->getName();
        return "";
    }
}