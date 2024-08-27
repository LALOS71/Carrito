<?php

class Albaranes extends DBOClass
{
    private $primary_key = 'IdAlbaran';

    public $IdEmpresa = 1;
    public $IdAlbaran;
    public $IdCliente;
    /** @var $Fecha DateTime */
    public $Fecha;
    public $DirEntrega;
    public $IdFormaEnvio = 1;
    public $Anulado = 0;
    public $Observaciones = "";
    public $Factura;
    public $EjercicioFactura;
    public $IdEstado = 0;
    public $NPedido = 0;
    public $Ip_Mod = 'GlobaliaGifts';
    /** @var $Fecha_Mod DateTime */
    public $Fecha_Mod;
    public $PermitirEdicion = 1;
    public $ValorarCero;
    public $FechaValija = null;
    public $ProvGraf;
    public $NoFacturable = 0;
    public $CodSpatam;
    public $Origen = 1;
    public $NPedido_Globaliagifts;

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
    public function getIdCliente()
    {
        return $this->IdCliente;
    }

    /**
     * @param mixed $IdCliente
     */
    public function setIdCliente($IdCliente): void
    {
        $this->IdCliente = $IdCliente;
    }

    /**
     * @return mixed
     */
    public function getFecha()
    {
        return $this->Fecha;
    }

    /**
     * @param mixed $Fecha
     */
    public function setFecha($Fecha): void
    {
        $this->Fecha = $Fecha;
    }

    /**
     * @return mixed
     */
    public function getDirEntrega()
    {
        return $this->DirEntrega;
    }

    /**
     * @param mixed $DirEntrega
     */
    public function setDirEntrega($DirEntrega): void
    {
        $this->DirEntrega = $DirEntrega;
    }

    /**
     * @return mixed
     */
    public function getIdFormaEnvio()
    {
        return $this->IdFormaEnvio;
    }

    /**
     * @param mixed $IdFormaEnvio
     */
    public function setIdFormaEnvio($IdFormaEnvio): void
    {
        $this->IdFormaEnvio = $IdFormaEnvio;
    }

    /**
     * @return mixed
     */
    public function getAnulado()
    {
        return $this->Anulado;
    }

    /**
     * @param mixed $Anulado
     */
    public function setAnulado($Anulado): void
    {
        $this->Anulado = $Anulado;
    }

    /**
     * @return mixed
     */
    public function getObservaciones()
    {
        return $this->Observaciones;
    }

    /**
     * @param mixed $Observaciones
     */
    public function setObservaciones($Observaciones): void
    {
        $this->Observaciones = $Observaciones;
    }

    /**
     * @return mixed
     */
    public function getFactura()
    {
        return $this->Factura;
    }

    /**
     * @param mixed $Factura
     */
    public function setFactura($Factura): void
    {
        $this->Factura = $Factura;
    }

    /**
     * @return mixed
     */
    public function getEjercicioFactura()
    {
        return $this->EjercicioFactura;
    }

    /**
     * @param mixed $EjercicioFactura
     */
    public function setEjercicioFactura($EjercicioFactura): void
    {
        $this->EjercicioFactura = $EjercicioFactura;
    }

    /**
     * @return mixed
     */
    public function getIdEstado()
    {
        return $this->IdEstado;
    }

    /**
     * @param mixed $IdEstado
     */
    public function setIdEstado($IdEstado): void
    {
        $this->IdEstado = $IdEstado;
    }

    /**
     * @return mixed
     */
    public function getNPedido()
    {
        return $this->NPedido;
    }

    /**
     * @param mixed $NPedido
     */
    public function setNPedido($NPedido): void
    {
        $this->NPedido = $NPedido;
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

    /**
     * @return mixed
     */
    public function getPermitirEdicion()
    {
        return $this->PermitirEdicion;
    }

    /**
     * @param mixed $PermitirEdicion
     */
    public function setPermitirEdicion($PermitirEdicion): void
    {
        $this->PermitirEdicion = $PermitirEdicion;
    }

    /**
     * @return mixed
     */
    public function getValorarCero()
    {
        return $this->ValorarCero;
    }

    /**
     * @param mixed $ValorarCero
     */
    public function setValorarCero($ValorarCero): void
    {
        $this->ValorarCero = $ValorarCero;
    }

    /**
     * @return mixed
     */
    public function getFechaValija()
    {
        return $this->FechaValija;
    }

    /**
     * @param mixed $FechaValija
     */
    public function setFechaValija($FechaValija): void
    {
        $this->FechaValija = $FechaValija;
    }

    /**
     * @return mixed
     */
    public function getProvGraf()
    {
        return $this->ProvGraf;
    }

    /**
     * @param mixed $ProvGraf
     */
    public function setProvGraf($ProvGraf): void
    {
        $this->ProvGraf = $ProvGraf;
    }

    /**
     * @return mixed
     */
    public function getNoFacturable()
    {
        return $this->NoFacturable;
    }

    /**
     * @param mixed $NoFacturable
     */
    public function setNoFacturable($NoFacturable): void
    {
        $this->NoFacturable = $NoFacturable;
    }

    /**
     * @return mixed
     */
    public function getCodSpatam()
    {
        return $this->CodSpatam;
    }

    /**
     * @param mixed $CodSpatam
     */
    public function setCodSpatam($CodSpatam): void
    {
        $this->CodSpatam = $CodSpatam;
    }

    /**
     * @return mixed
     */
    public function getOrigen()
    {
        return $this->Origen;
    }

    /**
     * @param mixed $Origen
     */
    public function setOrigen($Origen): void
    {
        $this->Origen = $Origen;
    }

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
    public function getNPedidoGlobaliagifts()
    {
        return $this->NPedido_Globaliagifts;
    }

    /**
     * @param mixed $NPedido_Globaliagifts
     */
    public function setNPedidoGlobaliagifts($NPedido_Globaliagifts): void
    {
        $this->NPedido_Globaliagifts = $NPedido_Globaliagifts;
    }



}