<?php


class ProcesoNuevosPedidos extends TronShop
{
    const TRONSHOP_DAYS = 60;

    public function __construct($debug = false)
    {
        parent::__construct($debug);
        
        //pongo una fecha concreta porque si no se ponen fecha, se cogen automaticamente los pedidos
        //de los ultimos 3 meses
        //$fecha = date("Y-m-d", strtotime('-' . self::TRONSHOP_DAYS . ' days'));
        $fecha = date("2000-01-01");

        $orders = $this->getAPIData("orders", false, ['dateFrom' => $fecha]);


        foreach ($orders as &$order) {
            /** @var orders $order */

            //if($order->getOrderState() !== 'Processed')
            //    continue;


            echo "<br>gestionamos el pedido: " . $order->getNumber();

            $cus = $this->getCustomerAPI($order);
            if (!$cus)
                continue;

            $ac = new AlbaranesController();

            if(!$albaran = $ac->existeAlbaranPorNPedido($order)) {
                echo $order->getNumber() . " creado.<br />\n";
                $ac->nuevoAlbaran($order);

                $this->setAlbaranDetalles($order);
            }else{
                echo $order->getNumber() . " ya existe.<br />\n";

//                $order->setAlbaran(new Albaranes($albaran));
//                $this->setAlbaranDetalles($order);
            }


        }

    }

    public function setAlbaranDetalles(orders &$order)
    {
        $adc = new AlbaranesDetallesController();

        //eliminamos items existentes
        $adc->purgeItems($order->getAlbaran()->getIdAlbaran());

        $items = $adc->groupItems($order);

        foreach ($items as $conceptos){
            /** @var $item OrderItem */
            $item = $conceptos['item'];

            if($item->getProductTypeTitle()!=="Catalog Product" && $item->getItemTypeTitle()!=="Delivery & Payment")
                continue;

            $adc->addItemToAlbaran($item, $conceptos, $order);
        }
    }

    public function getCustomerAPI(orders &$order)
    {
        $customers = $this->getAPIData("customers", $order->getCustomerPersonId());
        if (count($customers) == 0)
            return false;
        $customer = $customers[0];
        $order->setCustomer($customer);
        /** @var $customer customers */
        //$string_pru = (string) $customer->getCompany();
        if (!$customer->getCompany() || !$customer->getCompany()->gettaxNumber())
            {
            echo "<br>el pedido " . $order->getnumber() . " me lo salto porque el cliente " . $customer->getId() . " NO tiene Compañia o NIF";
            return false;
            }

            
        $cC = new ClientesController();

        if (!$gagCustomer = $cC->clienteExists($order)) {
            $gagCustomer = $cC->nuevoCliente($order);
        }

        echo "<br>el pedido " . $order->getNumber() . " tiene el cliente " . $customer->getId() . " con Compañia: " . print_r($customer->getCompany()) . " y NIF: " . print_r($customer->getCompany()->gettaxNumber());
        
        $order->setCliente($gagCustomer);
        return true;
    }

}