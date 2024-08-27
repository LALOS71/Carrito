<?php


class ProcesoNuevosPedidos extends TronShop
{
    const TRONSHOP_DAYS = 600;

    private $albaranesCreados = [];

    public function __construct($debug = false)
    {
        parent::__construct($debug);

        //pongo una fecha concreta porque si no se ponen fecha, se cogen automaticamente los pedidos
        //de los ultimos 3 meses
        //$fecha = date("Y-m-d", strtotime('-' . self::TRONSHOP_DAYS . ' days'));
        $fecha = date("2000-01-01");

        

        $orders = $this->getAPIData("orders", false, ['dateFrom' => $fecha]);

        /*
        echo '<br>***************************************';
        echo '<br>PEDIDOS';
        echo "<pre>";
        print_r($orders);
        echo "</pre>";
        echo '<br>***************************************';
        */
        
        $this->albaranesCreados = [];

        foreach ($orders as &$order) {
            /** @var orders $order */

            //SOLO HA DE IMPORTAR LOS PEDIDOS EN ESTADO PROCESADO QUE FALTEN
            if($order->getOrderState() !== 'Processed')
                continue;
            
            $cus = $this->getCustomerAPI($order);
            
            if (!$cus)
                continue;

            $ac = new AlbaranesController();

            if(!$albaran = $ac->existeAlbaranPorNPedido($order)) {
                echo $order->getNumber() . " creado.<br />\n";
                //$ac->nuevoAlbaran($order);
                $codigoAlbaran = $ac->nuevoAlbaran($order);
                
                $this->setAlbaranDetalles($order);

                $codigoAlbaran = $order->getAlbaran()->getIdAlbaran();
                array_push($this->albaranesCreados, $codigoAlbaran);
            }else{
                echo $order->getNumber() . " ya existe.<br />\n";

                $order->setAlbaran(new Albaranes($albaran));
                $this->setAlbaranDetalles($order);
            }


        }

    }

    public function setAlbaranDetalles(orders &$order)
    {
        $adc = new AlbaranesDetallesController();

        //eliminamos items existentes
        $adc->purgeItems($order->getAlbaran()->getIdAlbaran());

        $items = $adc->groupItems($order);

        //echo "<pre>";
        //print_r($items);
        //echo "</pre>";


        foreach ($items as $conceptos){
            /** @var $item OrderItem */
            $item = $conceptos['item'];

            if($item->getProductTypeTitle()!=="Catalog Product" && $item->getProductTypeTitle()!=="Delivery Service" && $item->getItemTypeTitle()!=="Delivery & Payment")
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


    public function getAlbaranesCreados() {
        return $this->albaranesCreados;
    }

}