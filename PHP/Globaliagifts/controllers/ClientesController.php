<?php


class ClientesController
{


    public function clienteExists(orders $order)
    {
        $personId = $order->getCustomerPersonId();
        $company = $order->getCompany();
        $nif = $company->getTaxNumber();
        $sql = sprintf(
            //OJO, quitamos la comprobacion por nif porque se puede dar el caso de tener
            //varios clientes con el mismo nif, y puede ser que el pedido/albaran quede asignado
            //al que no corresponde, asi forzamos a que o existe el cliente exacto por su id de globaliagift
            //o se da de alta por no existir en GAG
            //"SELECT * FROM dbo.Clientes WHERE NCliente_Globaliagifts='%s' OR NIF='%s'"
            "SELECT * FROM dbo.Clientes WHERE NCliente_Globaliagifts='%s'"
            , $personId
            , $nif
        );

        $SQLServer = new SQLServer();

        return $SQLServer->selectRow($sql, 'Clientes');
    }

    public function nuevoCliente(orders $order)
    {
        //echo '<br>CLIENTESCONTROLLER - NUEVOCLIENTE';
        /** @var $customer customers */
        $customer = $order->getCustomer();
        /** @var $company company */
        $company = $customer->getCompany();
        /** @var $billingAddress billingAddress */
        $billingAddress = $order->getBillingAddress();
//        if(is_null($billingAddress))
//            $billingAddress = $order->getBillingAddress();
        /** @var $deliveryAdress deliveryAdress */
        $deliveryAdress = $order->getDeliveryAdress();
        $fecha = new DateTime();

        $pc = new ProvinciasController();
        $provincia = $pc->getProvinceName($billingAddress->getZipCode());
        $provinciaEnvio = $pc->getProvinceName($deliveryAdress->getZipCode());

        $tc = new TablasController();
        $idPais = $tc->searchCountryByISO($billingAddress->getCountryIsoCode());

        $docType = DocumentosController::getType($company->getTaxNumber());

        $cliente = new Clientes();
        //$cliente->setTITULO($customer->getFirstName() . " " . $customer->getLastName());
        $cliente->setTITULO(mb_strtoupper($company->getName(), 'UTF-8'));
        $cliente->setTITULOL(mb_strtoupper($customer->getFirstName() . " " . $customer->getLastName(), 'UTF-8'));
        $cliente->setNIF(mb_strtoupper($company->getTaxNumber(), 'UTF-8'));

        $cliente->setIdTipoDocumento($docType);
        $cliente->setEMAIL(mb_strtoupper($customer->getEmail(), 'UTF-8'));
        $cliente->setTELEF01($customer->getPhoneNumber());
        $cliente->setDOMICILIO(mb_strtoupper(trim($billingAddress->getStreet(). ", " . $billingAddress->getStreetNumber(), " \t\n\r\0\x0B,"), 'UTF-8'));
        $cliente->setDireccionEnvio(mb_strtoupper(trim($deliveryAdress->getStreet(). ", " . $deliveryAdress->getStreetNumber(), " \t\n\r\0\x0B,"), 'UTF-8'));
        $cliente->setPOBLACION(mb_strtoupper($billingAddress->getCity(), 'UTF-8'));
        $cliente->setPOBLACIONENVIO(mb_strtoupper($deliveryAdress->getCity(), 'UTF-8'));
        $cadena_cp = mb_strtoupper($billingAddress->getZipCode(), 'UTF-8');
        if (mb_strlen($cadena_cp, 'UTF-8') < 5){
            $cadena_cp = str_pad($cadena_cp, 5, '0', STR_PAD_LEFT);
        }
        $cliente->setCODPOSTAL($cadena_cp);

        $cadena_cp = mb_strtoupper($deliveryAdress->getZipCode(), 'UTF-8');
        if (mb_strlen($cadena_cp, 'UTF-8') < 5){
            $cadena_cp = str_pad($cadena_cp, 5, '0', STR_PAD_LEFT);
        }
        $cliente->setCODPOSTALENVIO($cadena_cp);
        //$cliente->setPROVINCIA($provincia);
        //$cliente->setPROVINCIAENVIO($provinciaEnvio);
        $cliente->setPROVINCIA(mb_strtoupper($billingAddress->getRegion(), 'UTF-8'));
        $cliente->setPROVINCIAENVIO(mb_strtoupper($deliveryAdress->getRegion(), 'UTF-8'));
        $cliente->setFAlta($fecha);
        $cliente->setIdPais($idPais);
        $cliente->setNClienteGlobaliagifts($customer->getId());

        echo '<br>CLIENTESCONTROLLER - NUEVOCLIENTE - antes de add<br>';
        $clienteRow = $cliente->add();

        echo '<br>CLIENTESCONTROLLER - NUEVOCLIENTE - antes de new CLIENTES<br>';
        $cliente = new Clientes($clienteRow);

        echo '<br>CLIENTESCONTROLLER - NUEVOCLIENTE - FIN<br>';

        
        return $cliente;
    }


}