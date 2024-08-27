<?php


class AlbaranesDetallesController
{
    const table = "Albaranes_Detalles";

    public function __construct($value = '')
    {

    }

    public function purgeItems($id){
        $SQLServer = new SQLServer();


        $sql = sprintf(
            "DELETE FROM %s WHERE IdAlbaran = %s"
            , $SQLServer::DB_PREFIX . self::table
            , $id
        );

        $SQLServer->execute($sql);
    }

    public function groupItems(orders $order)
    {
        $items = [];

        foreach ($order->getItems() as $k=>&$item){
            /** @var $item OrderItem */
            $found = false;
            if($item->getParentId()=="") {
                $items[$item->getId()] = ['item' => $item, 'child' => []];
                $found = true;
            }else{
                if(isset($items[$item->getParentId()])){
                    $items[$item->getParentId()]['child'][$item->getId()] = $item;
                    $found = true;
                }else{
                    foreach ($items as $key=>$parents){
                        $childs = array_column($parents['child'], 'id');


                        if(in_array($item->getParentId(), $childs)){
                            $items[$key]['child'][$item->getId()] = $item;
                            $found = true;
                        }
                    }
                }
            }
//            if(!$found){
//                echo "<pre> NO ENCONTRADO";
//                print_r($item);
//                echo "</pre>";
//            }
        }

        return $items;

    }

    public function addItemToAlbaran(OrderItem $item, array $conceptos, orders $order)
    {
        $albaran = $order->getAlbaran();
        $fecha = new DateTime();
        $detalle = new Albaranes_Detalles();
        $detalle->setIdEmpresa(1);
        $detalle->setIdAlbaran($albaran->getIdAlbaran());
        $detalle->setCantidad($item->getItemCount() ?: 0);

        $importe = $item->getItemCount() * $item->getSalePrice();
        $title = $item->getItemTitle();

        if($item->getProductTypeTitle() == "Catalog Product"){
            foreach ($conceptos['child'] as $concepto){
                /** @var $concepto OrderItem */
//                if($concepto->getProductTypeTitle() == "Catalog Product" && $concepto->getItemTypeTitle()=="Product")
//                    $title = $concepto->getItemTitle();
                $importe += $concepto->getItemCount() * $concepto->getSalePrice();
            }
        }elseif($item->getItemTypeTitle()==="Delivery & Payment"){

            foreach ($conceptos['child'] as $concepto){
                /** @var $concepto OrderItem */
//                if($concepto->getProductTypeTitle() == "Delivery Service" && $concepto->getItemTypeTitle()=="Product")
//                    $title = $concepto->getItemTitle();
                $importe += $concepto->getItemCount() * $concepto->getSalePrice();
            }
        }

        $detalle->setConcepto($title);
        $detalle->setImporte($importe ?: 0);

        $detalle->setFechaMod($fecha);

        $detalle->add();
        return true;

    }
}