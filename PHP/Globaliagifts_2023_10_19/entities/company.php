<?php


class company extends TronShopClass
{
    public $name;
    public $registrationNumber = "";
    public $taxNumber = "";
    public $vatId = "";

    /**
     * @return mixed
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param mixed $name
     */
    public function setName($name): void
    {
        $this->name = $name;
    }

    /**
     * @return mixed
     */
    public function getRegistrationNumber()
    {
        return $this->registrationNumber;
    }

    /**
     * @param mixed $registrationNumber
     */
    public function setRegistrationNumber($registrationNumber): void
    {
        $this->registrationNumber = $registrationNumber;
    }

    /**
     * @return mixed
     */
    public function getTaxNumber()
    {
        return $this->taxNumber;
    }

    /**
     * @param mixed $taxNumber
     */
    public function setTaxNumber($taxNumber): void
    {
        $this->taxNumber = $taxNumber;
    }

    /**
     * @return mixed
     */
    public function getVatId()
    {
        return $this->vatId;
    }

    /**
     * @param mixed $vatId
     */
    public function setVatId($vatId): void
    {
        $this->vatId = $vatId;
    }





}