<?php


class ProcesoNuevosPedidos extends TronShop
{
    const TRONSHOP_DAYS = 60;

    public function __construct($debug = false)
    {
        parent::__construct($debug);
        $fecha = date("Y-m-d", strtotime('-' . self::TRONSHOP_DAYS . ' days'));

        $orders = $this->getAPIData("orders", false, ['dateFrom' => $fecha]);


        foreach ($orders as &$order) {
            /** @var orders $order */

            if($order->getOrderState() !== 'Processed')
                continue;


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
        if (!$customer->getCompany() || !$customer->getCompany()->gettaxNumber())
            return false;

        $cC = new ClientesController();

        if (!$gagCustomer = $cC->clienteExists($order)) {
            $gagCustomer = $cC->nuevoCliente($order);
        }

        $order->setCliente($gagCustomer);
        return true;
    }

}