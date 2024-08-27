<?php


class ClientesController
{


    public function clienteExists(orders $order)
    {
        $personId = $order->getCustomerPersonId();
        $company = $order->getCompany();
        $nif = $company->getTaxNumber();
        $sql = sprintf(
            "SELECT * FROM dbo.Clientes WHERE NCliente_Globaliagifts='%s' OR NIF='%s'"
            , $personId
            , $nif
        );

        $SQLServer = new SQLServer();

        return $SQLServer->selectRow($sql, 'Clientes');
    }

    public function nuevoCliente(orders $order)
    {
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
        $cliente->setTITULO($customer->getFirstName() . " " . $customer->getLastName());
        $cliente->setTITULOL($customer->getFirstName() . " " . $customer->getLastName());
        $cliente->setNIF($company->getTaxNumber());

        $cliente->setIdTipoDocumento($docType);
        $cliente->setEMAIL($customer->getEmail());
        $cliente->setTELEF01($customer->getPhoneNumber());
        $cliente->setDOMICILIO(trim($billingAddress->getStreet(). ", " . $billingAddress->getStreetNumber(), " \t\n\r\0\x0B,"));
        $cliente->setDireccionEnvio(trim($deliveryAdress->getStreet(). ", " . $deliveryAdress->getStreetNumber(), " \t\n\r\0\x0B,"));
        $cliente->setPOBLACION($billingAddress->getCity());
        $cliente->setPOBLACIONENVIO($deliveryAdress->getCity());
        $cliente->setCODPOSTAL($billingAddress->getZipCode());
        $cliente->setCODPOSTALENVIO($deliveryAdress->getZipCode());
        $cliente->setPROVINCIA($provincia);
        $cliente->setPROVINCIAENVIO($provinciaEnvio);
        $cliente->setFAlta($fecha);
        $cliente->setIdPais($idPais);
        $cliente->setNClienteGlobaliagifts($customer->getId());


        $clienteRow = $cliente->add();

        $cliente = new Clientes($clienteRow);


        return $cliente;
    }


}