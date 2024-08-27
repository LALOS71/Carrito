<?php

class Tablas extends DBOClass
{
    public $TipoTabla;
    public $Codigo;
    public $Texto;
    public $Texto2;
    public $Importe;
    public $Texto3;

    /**
     * @return mixed
     */
    public function getTipoTabla()
    {
        return $this->TipoTabla;
    }

    /**
     * @param mixed $TipoTabla
     */
    public function setTipoTabla($TipoTabla): void
    {
        $this->TipoTabla = $TipoTabla;
    }

    /**
     * @return mixed
     */
    public function getCodigo()
    {
        return $this->Codigo;
    }

    /**
     * @param mixed $Codigo
     */
    public function setCodigo($Codigo): void
    {
        $this->Codigo = $Codigo;
    }

    /**
     * @return mixed
     */
    public function getTexto()
    {
        return $this->Texto;
    }

    /**
     * @param mixed $Texto
     */
    public function setTexto($Texto): void
    {
        $this->Texto = $Texto;
    }

    /**
     * @return mixed
     */
    public function getTexto2()
    {
        return $this->Texto2;
    }

    /**
     * @param mixed $Texto2
     */
    public function setTexto2($Texto2): void
    {
        $this->Texto2 = $Texto2;
    }

    /**
     * @return mixed
     */
    public function getImporte()
    {
        return $this->Importe;
    }

    /**
     * @param mixed $Importe
     */
    public function setImporte($Importe): void
    {
        $this->Importe = $Importe;
    }

    /**
     * @return mixed
     */
    public function getTexto3()
    {
        return $this->Texto3;
    }

    /**
     * @param mixed $Texto3
     */
    public function setTexto3($Texto3): void
    {
        $this->Texto3 = $Texto3;
    }



}