<?php

class Albaranes_Detalles extends DBOClass
{
    private $primary_key = 'IdAlbaran';


    public $IdAlbaranDetalles;
    public $IdEmpresa;
    public $IdAlbaran;
    public $IdHojaRuta;
    public $idNTrabajo;
    public $Cantidad;
    public $Concepto;
    public $Importe;
    public $Documento;
    public $Ip_Mod = 'GlobaliaGifts';
    public $Fecha_Mod;

    /**
     * @return string
     */
    public function getPrimaryKey(): string
    {
        return $this->primary_key;
    }

    /**
     * @param string $primary_key
     */
    public function setPrimaryKey(string $primary_key): void
    {
        $this->primary_key = $primary_key;
    }

    /**
     * @return mixed
     */
    public function getIdAlbaranDetalles()
    {
        return $this->IdAlbaranDetalles;
    }

    /**
     * @param mixed $IdAlbaranDetalles
     */
    public function setIdAlbaranDetalles($IdAlbaranDetalles): void
    {
        $this->IdAlbaranDetalles = $IdAlbaranDetalles;
    }

    /**
     * @return mixed
     */
    public function getIdEmpresa()
    {
        return $this->IdEmpresa;
    }

    /**
     * @param mixed $IdEmpresa
     */
    public function setIdEmpresa($IdEmpresa): void
    {
        $this->IdEmpresa = $IdEmpresa;
    }

    /**
     * @return mixed
     */
    public function getIdAlbaran()
    {
        return $this->IdAlbaran;
    }

    /**
     * @param mixed $IdAlbaran
     */
    public function setIdAlbaran($IdAlbaran): void
    {
        $this->IdAlbaran = $IdAlbaran;
    }

    /**
     * @return mixed
     */
    public function getIdHojaRuta()
    {
        return $this->IdHojaRuta;
    }

    /**
     * @param mixed $IdHojaRuta
     */
    public function setIdHojaRuta($IdHojaRuta): void
    {
        $this->IdHojaRuta = $IdHojaRuta;
    }

    /**
     * @return mixed
     */
    public function getIdNTrabajo()
    {
        return $this->idNTrabajo;
    }

    /**
     * @param mixed $idNTrabajo
     */
    public function setIdNTrabajo($idNTrabajo): void
    {
        $this->idNTrabajo = $idNTrabajo;
    }

    /**
     * @return mixed
     */
    public function getCantidad()
    {
        return $this->Cantidad;
    }

    /**
     * @param mixed $Cantidad
     */
    public function setCantidad($Cantidad): void
    {
        $this->Cantidad = $Cantidad;
    }

    /**
     * @return mixed
     */
    public function getConcepto()
    {
        return $this->Concepto;
    }

    /**
     * @param mixed $Concepto
     */
    public function setConcepto($Concepto): void
    {
        $this->Concepto = $Concepto;
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
    public function getDocumento()
    {
        return $this->Documento;
    }

    /**
     * @param mixed $Documento
     */
    public function setDocumento($Documento): void
    {
        $this->Documento = $Documento;
    }

    /**
     * @return mixed
     */
    public function getIpMod()
    {
        return $this->Ip_Mod;
    }

    /**
     * @param mixed $Ip_Mod
     */
    public function setIpMod($Ip_Mod): void
    {
        $this->Ip_Mod = $Ip_Mod;
    }

    /**
     * @return mixed
     */
    public function getFechaMod()
    {
        return $this->Fecha_Mod;
    }

    /**
     * @param mixed $Fecha_Mod
     */
    public function setFechaMod($Fecha_Mod): void
    {
        $this->Fecha_Mod = $Fecha_Mod;
    }


}