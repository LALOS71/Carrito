<?php


class Clientes extends DBOClass
{
    private $primary_key = 'IdCliente';
    public $IdCliente;
    public $idEmpresa = 1;
    public $IdSap;
    public $DelGrupo = 0;
    public $COD;
    public $TITULO;
    public $NIF;
    public $DOMICILIO;
    public $Direccion_Envio;
    public $POBLACION;
    public $POBLACIONENVIO;
    public $PROVINCIA;
    public $PROVINCIAENVIO;
    public $CODPOSTAL;
    public $CODPOSTALENVIO;
    public $TELEF01;
    public $FAX01;
    public $EMAIL;
    public $TITULOL;
    public $LIMITE = 0;
    public $DIAS = 0;
    public $FORMA_PAGO = 3;
    public $IdFormaPago;
    public $Texto_Pago;
    public $CUENTA_BANCARIA;
    public $CodExterno;
    public $IdCadena = 270; //GlobaliaGifts
    public $PedMinimoConCompromiso;
    public $PedMinimoSinCompromiso;
    public $Contrasena;
    public $FAlta;
    public $FBaja;
    public $Borrado = 0;
    public $ReqAutoriza;
    public $IdTipoCliente;
    public $JefeEconomato;
    public $idMarca;
    public $idTipoPrecio;
    public $idTipo;
    public $idValidadora;
    public $Contacto;
    public $idPais;
    public $idTipoIva;
    public $idTratoEspecial;
    public $CodContable;
    public $idTipoDocumento;
    public $SALT;
    public $NCliente_Globaliagifts;

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
    public function getIdEmpresa()
    {
        return $this->idEmpresa;
    }

    /**
     * @param mixed $idEmpresa
     */
    public function setIdEmpresa($idEmpresa): void
    {
        $this->idEmpresa = $idEmpresa;
    }

    /**
     * @return mixed
     */
    public function getIdSap()
    {
        return $this->IdSap;
    }

    /**
     * @param mixed $IdSap
     */
    public function setIdSap($IdSap): void
    {
        $this->IdSap = $IdSap;
    }

    /**
     * @return mixed
     */
    public function getDelGrupo()
    {
        return $this->DelGrupo;
    }

    /**
     * @param mixed $DelGrupo
     */
    public function setDelGrupo($DelGrupo): void
    {
        $this->DelGrupo = $DelGrupo;
    }

    /**
     * @return mixed
     */
    public function getCOD()
    {
        return $this->COD;
    }

    /**
     * @param mixed $COD
     */
    public function setCOD($COD): void
    {
        $this->COD = $COD;
    }

    /**
     * @return mixed
     */
    public function getTITULO()
    {
        return $this->TITULO;
    }

    /**
     * @param mixed $TITULO
     */
    public function setTITULO($TITULO): void
    {
        $this->TITULO = $TITULO;
    }

    /**
     * @return mixed
     */
    public function getNIF()
    {
        return $this->NIF;
    }

    /**
     * @param mixed $NIF
     */
    public function setNIF($NIF): void
    {
        $this->NIF = $NIF;
    }

    /**
     * @return mixed
     */
    public function getDOMICILIO()
    {
        return $this->DOMICILIO;
    }

    /**
     * @param mixed $DOMICILIO
     */
    public function setDOMICILIO($DOMICILIO): void
    {
        $this->DOMICILIO = $DOMICILIO;
    }

    /**
     * @return mixed
     */
    public function getDireccionEnvio()
    {
        return $this->Direccion_Envio;
    }

    /**
     * @param mixed $Direccion_Envio
     */
    public function setDireccionEnvio($Direccion_Envio): void
    {
        $this->Direccion_Envio = $Direccion_Envio;
    }

    /**
     * @return mixed
     */
    public function getPOBLACION()
    {
        return $this->POBLACION;
    }

    /**
     * @param mixed $POBLACION
     */
    public function setPOBLACION($POBLACION): void
    {
        $this->POBLACION = $POBLACION;
    }

    /**
     * @return mixed
     */
    public function getPOBLACIONENVIO()
    {
        return $this->POBLACIONENVIO;
    }

    /**
     * @param mixed $POBLACIONENVIO
     */
    public function setPOBLACIONENVIO($POBLACIONENVIO): void
    {
        $this->POBLACIONENVIO = $POBLACIONENVIO;
    }

    /**
     * @return mixed
     */
    public function getPROVINCIA()
    {
        return $this->PROVINCIA;
    }

    /**
     * @param mixed $PROVINCIA
     */
    public function setPROVINCIA($PROVINCIA): void
    {
        $this->PROVINCIA = $PROVINCIA;
    }

    /**
     * @return mixed
     */
    public function getPROVINCIAENVIO()
    {
        return $this->PROVINCIAENVIO;
    }

    /**
     * @param mixed $PROVINCIAENVIO
     */
    public function setPROVINCIAENVIO($PROVINCIAENVIO): void
    {
        $this->PROVINCIAENVIO = $PROVINCIAENVIO;
    }

    /**
     * @return mixed
     */
    public function getCODPOSTAL()
    {
        return $this->CODPOSTAL;
    }

    /**
     * @param mixed $CODPOSTAL
     */
    public function setCODPOSTAL($CODPOSTAL): void
    {
        $this->CODPOSTAL = $CODPOSTAL;
    }

    /**
     * @return mixed
     */
    public function getCODPOSTALENVIO()
    {
        return $this->CODPOSTALENVIO;
    }

    /**
     * @param mixed $CODPOSTALENVIO
     */
    public function setCODPOSTALENVIO($CODPOSTALENVIO): void
    {
        $this->CODPOSTALENVIO = $CODPOSTALENVIO;
    }

    /**
     * @return mixed
     */
    public function getTELEF01()
    {
        return $this->TELEF01;
    }

    /**
     * @param mixed $TELEF01
     */
    public function setTELEF01($TELEF01): void
    {
        $this->TELEF01 = $TELEF01;
    }

    /**
     * @return mixed
     */
    public function getFAX01()
    {
        return $this->FAX01;
    }

    /**
     * @param mixed $FAX01
     */
    public function setFAX01($FAX01): void
    {
        $this->FAX01 = $FAX01;
    }

    /**
     * @return mixed
     */
    public function getEMAIL()
    {
        return $this->EMAIL;
    }

    /**
     * @param mixed $EMAIL
     */
    public function setEMAIL($EMAIL): void
    {
        $this->EMAIL = $EMAIL;
    }

    /**
     * @return mixed
     */
    public function getTITULOL()
    {
        return $this->TITULOL;
    }

    /**
     * @param mixed $TITULOL
     */
    public function setTITULOL($TITULOL): void
    {
        $this->TITULOL = $TITULOL;
    }

    /**
     * @return mixed
     */
    public function getLIMITE()
    {
        return $this->LIMITE;
    }

    /**
     * @param mixed $LIMITE
     */
    public function setLIMITE($LIMITE): void
    {
        $this->LIMITE = $LIMITE;
    }

    /**
     * @return mixed
     */
    public function getDIAS()
    {
        return $this->DIAS;
    }

    /**
     * @param mixed $DIAS
     */
    public function setDIAS($DIAS): void
    {
        $this->DIAS = $DIAS;
    }

    /**
     * @return mixed
     */
    public function getFORMAPAGO()
    {
        return $this->FORMA_PAGO;
    }

    /**
     * @param mixed $FORMA_PAGO
     */
    public function setFORMAPAGO($FORMA_PAGO): void
    {
        $this->FORMA_PAGO = $FORMA_PAGO;
    }

    /**
     * @return mixed
     */
    public function getIdFormaPago()
    {
        return $this->IdFormaPago;
    }

    /**
     * @param mixed $IdFormaPago
     */
    public function setIdFormaPago($IdFormaPago): void
    {
        $this->IdFormaPago = $IdFormaPago;
    }

    /**
     * @return mixed
     */
    public function getTextoPago()
    {
        return $this->Texto_Pago;
    }

    /**
     * @param mixed $Texto_Pago
     */
    public function setTextoPago($Texto_Pago): void
    {
        $this->Texto_Pago = $Texto_Pago;
    }

    /**
     * @return mixed
     */
    public function getCUENTABANCARIA()
    {
        return $this->CUENTA_BANCARIA;
    }

    /**
     * @param mixed $CUENTA_BANCARIA
     */
    public function setCUENTABANCARIA($CUENTA_BANCARIA): void
    {
        $this->CUENTA_BANCARIA = $CUENTA_BANCARIA;
    }

    /**
     * @return mixed
     */
    public function getCodExterno()
    {
        return $this->CodExterno;
    }

    /**
     * @param mixed $CodExterno
     */
    public function setCodExterno($CodExterno): void
    {
        $this->CodExterno = $CodExterno;
    }

    /**
     * @return mixed
     */
    public function getIdCadena()
    {
        return $this->IdCadena;
    }

    /**
     * @param mixed $IdCadena
     */
    public function setIdCadena($IdCadena): void
    {
        $this->IdCadena = $IdCadena;
    }

    /**
     * @return mixed
     */
    public function getPedMinimoConCompromiso()
    {
        return $this->PedMinimoConCompromiso;
    }

    /**
     * @param mixed $PedMinimoConCompromiso
     */
    public function setPedMinimoConCompromiso($PedMinimoConCompromiso): void
    {
        $this->PedMinimoConCompromiso = $PedMinimoConCompromiso;
    }

    /**
     * @return mixed
     */
    public function getPedMinimoSinCompromiso()
    {
        return $this->PedMinimoSinCompromiso;
    }

    /**
     * @param mixed $PedMinimoSinCompromiso
     */
    public function setPedMinimoSinCompromiso($PedMinimoSinCompromiso): void
    {
        $this->PedMinimoSinCompromiso = $PedMinimoSinCompromiso;
    }

    /**
     * @return mixed
     */
    public function getContrasena()
    {
        return $this->Contrasena;
    }

    /**
     * @param mixed $Contrasena
     */
    public function setContrasena($Contrasena): void
    {
        $this->Contrasena = $Contrasena;
    }

    /**
     * @return mixed
     */
    public function getFAlta()
    {
        return $this->FAlta;
    }

    /**
     * @param mixed $FAlta
     */
    public function setFAlta($FAlta): void
    {
        $this->FAlta = $FAlta;
    }

    /**
     * @return mixed
     */
    public function getFBaja()
    {
        return $this->FBaja;
    }

    /**
     * @param mixed $FBaja
     */
    public function setFBaja($FBaja): void
    {
        $this->FBaja = $FBaja;
    }

    /**
     * @return mixed
     */
    public function getBorrado()
    {
        return $this->Borrado;
    }

    /**
     * @param mixed $Borrado
     */
    public function setBorrado($Borrado): void
    {
        $this->Borrado = $Borrado;
    }

    /**
     * @return mixed
     */
    public function getReqAutoriza()
    {
        return $this->ReqAutoriza;
    }

    /**
     * @param mixed $ReqAutoriza
     */
    public function setReqAutoriza($ReqAutoriza): void
    {
        $this->ReqAutoriza = $ReqAutoriza;
    }

    /**
     * @return mixed
     */
    public function getIdTipoCliente()
    {
        return $this->IdTipoCliente;
    }

    /**
     * @param mixed $IdTipoCliente
     */
    public function setIdTipoCliente($IdTipoCliente): void
    {
        $this->IdTipoCliente = $IdTipoCliente;
    }

    /**
     * @return mixed
     */
    public function getJefeEconomato()
    {
        return $this->JefeEconomato;
    }

    /**
     * @param mixed $JefeEconomato
     */
    public function setJefeEconomato($JefeEconomato): void
    {
        $this->JefeEconomato = $JefeEconomato;
    }

    /**
     * @return mixed
     */
    public function getIdMarca()
    {
        return $this->idMarca;
    }

    /**
     * @param mixed $idMarca
     */
    public function setIdMarca($idMarca): void
    {
        $this->idMarca = $idMarca;
    }

    /**
     * @return mixed
     */
    public function getIdTipoPrecio()
    {
        return $this->idTipoPrecio;
    }

    /**
     * @param mixed $idTipoPrecio
     */
    public function setIdTipoPrecio($idTipoPrecio): void
    {
        $this->idTipoPrecio = $idTipoPrecio;
    }

    /**
     * @return mixed
     */
    public function getIdTipo()
    {
        return $this->idTipo;
    }

    /**
     * @param mixed $idTipo
     */
    public function setIdTipo($idTipo): void
    {
        $this->idTipo = $idTipo;
    }

    /**
     * @return mixed
     */
    public function getIdValidadora()
    {
        return $this->idValidadora;
    }

    /**
     * @param mixed $idValidadora
     */
    public function setIdValidadora($idValidadora): void
    {
        $this->idValidadora = $idValidadora;
    }

    /**
     * @return mixed
     */
    public function getContacto()
    {
        return $this->Contacto;
    }

    /**
     * @param mixed $Contacto
     */
    public function setContacto($Contacto): void
    {
        $this->Contacto = $Contacto;
    }

    /**
     * @return mixed
     */
    public function getIdPais()
    {
        return $this->idPais;
    }

    /**
     * @param mixed $idPais
     */
    public function setIdPais($idPais): void
    {
        $this->idPais = $idPais;
    }

    /**
     * @return mixed
     */
    public function getIdTipoIva()
    {
        return $this->idTipoIva;
    }

    /**
     * @param mixed $idTipoIva
     */
    public function setIdTipoIva($idTipoIva): void
    {
        $this->idTipoIva = $idTipoIva;
    }

    /**
     * @return mixed
     */
    public function getIdTratoEspecial()
    {
        return $this->idTratoEspecial;
    }

    /**
     * @param mixed $idTratoEspecial
     */
    public function setIdTratoEspecial($idTratoEspecial): void
    {
        $this->idTratoEspecial = $idTratoEspecial;
    }

    /**
     * @return mixed
     */
    public function getCodContable()
    {
        return $this->CodContable;
    }

    /**
     * @param mixed $CodContable
     */
    public function setCodContable($CodContable): void
    {
        $this->CodContable = $CodContable;
    }

    /**
     * @return mixed
     */
    public function getIdTipoDocumento()
    {
        return $this->idTipoDocumento;
    }

    /**
     * @param mixed $idTipoDocumento
     */
    public function setIdTipoDocumento($idTipoDocumento): void
    {
        $this->idTipoDocumento = $idTipoDocumento;
    }

    /**
     * @return mixed
     */
    public function getSALT()
    {
        return $this->SALT;
    }

    /**
     * @param mixed $SALT
     */
    public function setSALT($SALT): void
    {
        $this->SALT = $SALT;
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
    public function getNClienteGlobaliagifts()
    {
        return $this->NCliente_Globaliagifts;
    }

    /**
     * @param mixed $NCliente_Globaliagifts
     */
    public function setNClienteGlobaliagifts($NCliente_Globaliagifts): void
    {
        $this->NCliente_Globaliagifts = $NCliente_Globaliagifts;
    }



}