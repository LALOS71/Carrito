<?php


class TablasController extends TronShop
{


    public function searchCountryByISO($value = '')
    {

        $sql = sprintf(
            "SELECT * FROM dbo.Tablas WHERE Texto3=%s"
            , is_string($value) ? "'" . $value . "'" : $value
        );

        $SQLServer = new SQLServer();

        $country = $SQLServer->selectRow($sql);

        if ($country)
            return $country->Codigo;
        return false;
    }


}