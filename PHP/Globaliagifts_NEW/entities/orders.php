<?php


class orders extends TronShopClass
{
    public $id;
    public $number;
    public $createdOn;
    public $salesPerson;
    public $orderState;
    public $paymentState;
    public $deliveryState;
    public $paymentType;
    public $deliveryType;
    public $salePrice;
    public $salePriceVat;
    public $saleCurrencyIsoCode;
    public $saleForeignCurrencyIsoCode;
    public $saleForeignCurrencyCountryCode;
    public $saleForeignRateValue;
    public $saleForeignRateDate;
    public $purchasePrice;
    public $purchasePriceVat;
    public $purchaseCurrencyIsoCode;
    public $customerPersonId;
    public $customerIdentifier;
    public $phoneNumber;
    public $email;
    public $comment;

    public $company;
    public $billingAddress;
    public $deliveryAdress;
    public $itemsCount;
    public $items;
    public $customer;
    public $cliente;
    public $productos;
    public $albaran;


    public function __construct($ws = false)
    {
        parent::__construct($ws);
        if (is_array($this->items) && count($this->items)>0) {
            foreach ($this->items as $i => $element) {
                $element = new OrderItem($element);
                $this->items[$element->getId()] = $element;
                unset($this->items[$i]);
            }
        }
    }



    /**
     * @return mixed
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @param mixed $id
     */
    public function setId($id): void
    {
        $this->id = $id;
    }

    /**
     * @return mixed
     */
    public function getNumber()
    {
        return $this->number;
    }

    /**
     * @param mixed $number
     */
    public function setNumber($number): void
    {
        $this->number = $number;
    }

    /**
     * @return mixed
     */
    public function getCreatedOn()
    {
        return $this->createdOn;
    }

    /**
     * @param mixed $createdOn
     */
    public function setCreatedOn($createdOn): void
    {
        $this->createdOn = $createdOn;
    }

    /**
     * @return mixed
     */
    public function getSalesPerson()
    {
        return $this->salesPerson;
    }

    /**
     * @param mixed $salesPerson
     */
    public function setSalesPerson($salesPerson): void
    {
        $this->salesPerson = $salesPerson;
    }

    /**
     * @return mixed
     */
    public function getOrderState()
    {
        return $this->orderState;
    }

    /**
     * @param mixed $orderState
     */
    public function setOrderState($orderState): void
    {
        $this->orderState = $orderState;
    }

    /**
     * @return mixed
     */
    public function getPaymentState()
    {
        return $this->paymentState;
    }

    /**
     * @param mixed $paymentState
     */
    public function setPaymentState($paymentState): void
    {
        $this->paymentState = $paymentState;
    }

    /**
     * @return mixed
     */
    public function getDeliveryState()
    {
        return $this->deliveryState;
    }

    /**
     * @param mixed $deliveryState
     */
    public function setDeliveryState($deliveryState): void
    {
        $this->deliveryState = $deliveryState;
    }

    /**
     * @return mixed
     */
    public function getPaymentType()
    {
        return $this->paymentType;
    }

    /**
     * @param mixed $paymentType
     */
    public function setPaymentType($paymentType): void
    {
        $this->paymentType = $paymentType;
    }

    /**
     * @return mixed
     */
    public function getDeliveryType()
    {
        return $this->deliveryType;
    }

    /**
     * @param mixed $deliveryType
     */
    public function setDeliveryType($deliveryType): void
    {
        $this->deliveryType = $deliveryType;
    }

    /**
     * @return mixed
     */
    public function getSalePrice()
    {
        return $this->salePrice;
    }

    /**
     * @param mixed $salePrice
     */
    public function setSalePrice($salePrice): void
    {
        $this->salePrice = $salePrice;
    }

    /**
     * @return mixed
     */
    public function getSalePriceVat()
    {
        return $this->salePriceVat;
    }

    /**
     * @param mixed $salePriceVat
     */
    public function setSalePriceVat($salePriceVat): void
    {
        $this->salePriceVat = $salePriceVat;
    }

    /**
     * @return mixed
     */
    public function getSaleCurrencyIsoCode()
    {
        return $this->saleCurrencyIsoCode;
    }

    /**
     * @param mixed $saleCurrencyIsoCode
     */
    public function setSaleCurrencyIsoCode($saleCurrencyIsoCode): void
    {
        $this->saleCurrencyIsoCode = $saleCurrencyIsoCode;
    }

    /**
     * @return mixed
     */
    public function getSaleForeignCurrencyIsoCode()
    {
        return $this->saleForeignCurrencyIsoCode;
    }

    /**
     * @param mixed $saleForeignCurrencyIsoCode
     */
    public function setSaleForeignCurrencyIsoCode($saleForeignCurrencyIsoCode): void
    {
        $this->saleForeignCurrencyIsoCode = $saleForeignCurrencyIsoCode;
    }

    /**
     * @return mixed
     */
    public function getSaleForeignCurrencyCountryCode()
    {
        return $this->saleForeignCurrencyCountryCode;
    }

    /**
     * @param mixed $saleForeignCurrencyCountryCode
     */
    public function setSaleForeignCurrencyCountryCode($saleForeignCurrencyCountryCode): void
    {
        $this->saleForeignCurrencyCountryCode = $saleForeignCurrencyCountryCode;
    }

    /**
     * @return mixed
     */
    public function getSaleForeignRateValue()
    {
        return $this->saleForeignRateValue;
    }

    /**
     * @param mixed $saleForeignRateValue
     */
    public function setSaleForeignRateValue($saleForeignRateValue): void
    {
        $this->saleForeignRateValue = $saleForeignRateValue;
    }

    /**
     * @return mixed
     */
    public function getSaleForeignRateDate()
    {
        return $this->saleForeignRateDate;
    }

    /**
     * @param mixed $saleForeignRateDate
     */
    public function setSaleForeignRateDate($saleForeignRateDate): void
    {
        $this->saleForeignRateDate = $saleForeignRateDate;
    }

    /**
     * @return mixed
     */
    public function getPurchasePrice()
    {
        return $this->purchasePrice;
    }

    /**
     * @param mixed $purchasePrice
     */
    public function setPurchasePrice($purchasePrice): void
    {
        $this->purchasePrice = $purchasePrice;
    }

    /**
     * @return mixed
     */
    public function getPurchasePriceVat()
    {
        return $this->purchasePriceVat;
    }

    /**
     * @param mixed $purchasePriceVat
     */
    public function setPurchasePriceVat($purchasePriceVat): void
    {
        $this->purchasePriceVat = $purchasePriceVat;
    }

    /**
     * @return mixed
     */
    public function getPurchaseCurrencyIsoCode()
    {
        return $this->purchaseCurrencyIsoCode;
    }

    /**
     * @param mixed $purchaseCurrencyIsoCode
     */
    public function setPurchaseCurrencyIsoCode($purchaseCurrencyIsoCode): void
    {
        $this->purchaseCurrencyIsoCode = $purchaseCurrencyIsoCode;
    }

    /**
     * @return mixed
     */
    public function getCustomerPersonId()
    {
        return $this->customerPersonId;
    }

    /**
     * @param mixed $customerPersonId
     */
    public function setCustomerPersonId($customerPersonId): void
    {
        $this->customerPersonId = $customerPersonId;
    }

    /**
     * @return mixed
     */
    public function getCustomerIdentifier()
    {
        return $this->customerIdentifier;
    }

    /**
     * @param mixed $customerIdentifier
     */
    public function setCustomerIdentifier($customerIdentifier): void
    {
        $this->customerIdentifier = $customerIdentifier;
    }

    /**
     * @return mixed
     */
    public function getPhoneNumber()
    {
        return $this->phoneNumber;
    }

    /**
     * @param mixed $phoneNumber
     */
    public function setPhoneNumber($phoneNumber): void
    {
        $this->phoneNumber = $phoneNumber;
    }

    /**
     * @return mixed
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * @param mixed $email
     */
    public function setEmail($email): void
    {
        $this->email = $email;
    }

    /**
     * @return mixed
     */
    public function getComment()
    {
        return $this->comment;
    }

    /**
     * @param mixed $comment
     */
    public function setComment($comment): void
    {
        $this->comment = $comment;
    }

    /**
     * @return mixed
     */
    public function getCompany(): company
    {
        return $this->company;
    }

    /**
     * @param mixed $company
     */
    public function setCompany($company): void
    {
        $this->company = $company;
    }

    /**
     * @return mixed
     */
    public function getBillingAddress()
    {
        return $this->billingAddress;
    }

    /**
     * @param mixed $billingAddress
     */
    public function setBillingAddress($billingAddress): void
    {
        $this->billingAddress = $billingAddress;
    }

    /**
     * @return mixed
     */
    public function getDeliveryAdress()
    {
        return $this->deliveryAdress;
    }

    /**
     * @param mixed $deliveryAdress
     */
    public function setDeliveryAdress($deliveryAdress): void
    {
        $this->deliveryAdress = $deliveryAdress;
    }

    /**
     * @return mixed
     */
    public function getItemsCount()
    {
        return $this->itemsCount;
    }

    /**
     * @param mixed $itemsCount
     */
    public function setItemsCount($itemsCount): void
    {
        $this->itemsCount = $itemsCount;
    }

    /**
     * @return mixed
     */
    public function getItems()
    {
        return $this->items;
    }

    /**
     * @param mixed $items
     */
    public function setItems($items): void
    {
        $this->items = $items;
    }

    /**
     * @return mixed
     */
    public function getCustomer(): customers
    {
        return $this->customer;
    }

    /**
     * @param mixed $customer
     */
    public function setCustomer($customer): void
    {
        $this->customer = $customer;
    }

    /**
     * @return mixed
     */
    public function getCliente(): Clientes
    {
        return $this->cliente;
    }

    /**
     * @param mixed $cliente
     */
    public function setCliente($cliente): void
    {
        $this->cliente = $cliente;
    }

    /**
     * @return mixed
     */
    public function getProductos()
    {
        return $this->productos;
    }

    /**
     * @param mixed $productos
     */
    public function setProductos($productos): void
    {
        $this->productos = $productos;
    }

    /**
     * @return mixed
     */
    public function getAlbaran(): Albaranes
    {
        return $this->albaran;
    }

    /**
     * @param mixed $albaran
     */
    public function setAlbaran($albaran): void
    {
        $this->albaran = $albaran;
    }




}