<?php


class AlbaranesController
{


    public function __construct($value = '')
    {

    }

    public function nuevoAlbaran(orders $order)
    {
        /** @var Clientes $cliente */
        $cliente = $order->getCliente();

        $address = $cliente->getDireccionEnvio() . "\r\n" . $cliente->getCODPOSTALENVIO() . " " . $cliente->getPOBLACIONENVIO() . "\r\n" . $cliente->getPROVINCIAENVIO();
        $deliveryAddress = $order->getDeliveryAdress();
        /** @var Address $deliveryAddress */
        if(trim($deliveryAddress->getStreet())!=="") {

            $pc = new ProvinciasController();
            $provincia = $pc->getProvinceName($deliveryAddress->getZipCode());

            $address = $deliveryAddress->getStreet() . "\r\n" . $deliveryAddress->getZipCode() . " " . $deliveryAddress->getCity() . "\r\n" . $provincia;
        }

        $dateOrder = date_create_from_format('Y-m-d\TH:i:s.u\+00:00', $order->getCreatedOn());
        $fecha = new DateTime();

        $albaran = new Albaranes();
        $albaran->setIdCliente($cliente->getIdCliente());
        $albaran->setCodSpatam($order->getNumber());
        $albaran->setFecha($dateOrder);
        $albaran->setDirEntrega(trim(chop($address,250)));
//        $albaran->setIpMod($_SERVER['REMOTE_ADDR']);
        $albaran->setFechaMod($fecha);
        $albaran->setNPedidoGlobaliagifts($order->getId());

        if(!$row = $albaran->add())
            return false;
        $order->setAlbaran(new Albaranes($row));
        return true;
    }

    public function existeAlbaranPorNPedido(orders &$order)
    {
        $SQLServer = new SQLServer();

        $sql = sprintf(
            "SELECT * FROM %s WHERE NPedido_Globaliagifts = '%s'"
            , $SQLServer::DB_PREFIX . 'Albaranes'
            , $order->getId()
        );


        return $SQLServer->selectRow($sql);

    }
}