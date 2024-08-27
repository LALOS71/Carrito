<?php


class TronShopClass
{
    public function __construct($ws = false)
    {
        if ($ws && (is_array($ws) || is_object($ws))) {
            foreach ($this as $k => $v) {

                if (isset($ws->{$k})) {
                    if (class_exists($k))
                        $this->{$k} = new $k($ws->{$k});
                    else
                        $this->{$k} = $ws->{$k};
                }

            }
        }
    }

}