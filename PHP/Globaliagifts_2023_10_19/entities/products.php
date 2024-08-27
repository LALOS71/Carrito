<?php

class products extends TronShopClass
{
    public $guid;
    public $productType;
    public $productTypeTitle;
    public $productState;
    public $productStateTitle;
    public $productName;
    public $productFullName;
    public $productShortName;
    public $productFullDescription;
    public $productShortDescription;
    public $productCode;
    public $ownProductCode;
    public $supplierProductCode;
    public $supplierGuid;
    public $supplierName;
    public $primaryCategory;
    public $priceLevels;

    /**
     * @return mixed
     */
    public function getGuid()
    {
        return $this->guid;
    }

    /**
     * @param mixed $guid
     */
    public function setGuid($guid): void
    {
        $this->guid = $guid;
    }

    /**
     * @return mixed
     */
    public function getProductType()
    {
        return $this->productType;
    }

    /**
     * @param mixed $productType
     */
    public function setProductType($productType): void
    {
        $this->productType = $productType;
    }

    /**
     * @return mixed
     */
    public function getProductTypeTitle()
    {
        return $this->productTypeTitle;
    }

    /**
     * @param mixed $productTypeTitle
     */
    public function setProductTypeTitle($productTypeTitle): void
    {
        $this->productTypeTitle = $productTypeTitle;
    }

    /**
     * @return mixed
     */
    public function getProductState()
    {
        return $this->productState;
    }

    /**
     * @param mixed $productState
     */
    public function setProductState($productState): void
    {
        $this->productState = $productState;
    }

    /**
     * @return mixed
     */
    public function getProductStateTitle()
    {
        return $this->productStateTitle;
    }

    /**
     * @param mixed $productStateTitle
     */
    public function setProductStateTitle($productStateTitle): void
    {
        $this->productStateTitle = $productStateTitle;
    }

    /**
     * @return mixed
     */
    public function getProductName()
    {
        return $this->productName;
    }

    /**
     * @param mixed $productName
     */
    public function setProductName($productName): void
    {
        $this->productName = $productName;
    }

    /**
     * @return mixed
     */
    public function getProductFullName()
    {
        return $this->productFullName;
    }

    /**
     * @param mixed $productFullName
     */
    public function setProductFullName($productFullName): void
    {
        $this->productFullName = $productFullName;
    }

    /**
     * @return mixed
     */
    public function getProductShortName()
    {
        return $this->productShortName;
    }

    /**
     * @param mixed $productShortName
     */
    public function setProductShortName($productShortName): void
    {
        $this->productShortName = $productShortName;
    }

    /**
     * @return mixed
     */
    public function getProductFullDescription()
    {
        return $this->productFullDescription;
    }

    /**
     * @param mixed $productFullDescription
     */
    public function setProductFullDescription($productFullDescription): void
    {
        $this->productFullDescription = $productFullDescription;
    }

    /**
     * @return mixed
     */
    public function getProductShortDescription()
    {
        return $this->productShortDescription;
    }

    /**
     * @param mixed $productShortDescription
     */
    public function setProductShortDescription($productShortDescription): void
    {
        $this->productShortDescription = $productShortDescription;
    }

    /**
     * @return mixed
     */
    public function getProductCode()
    {
        return $this->productCode;
    }

    /**
     * @param mixed $productCode
     */
    public function setProductCode($productCode): void
    {
        $this->productCode = $productCode;
    }

    /**
     * @return mixed
     */
    public function getOwnProductCode()
    {
        return $this->ownProductCode;
    }

    /**
     * @param mixed $ownProductCode
     */
    public function setOwnProductCode($ownProductCode): void
    {
        $this->ownProductCode = $ownProductCode;
    }

    /**
     * @return mixed
     */
    public function getSupplierProductCode()
    {
        return $this->supplierProductCode;
    }

    /**
     * @param mixed $supplierProductCode
     */
    public function setSupplierProductCode($supplierProductCode): void
    {
        $this->supplierProductCode = $supplierProductCode;
    }

    /**
     * @return mixed
     */
    public function getSupplierGuid()
    {
        return $this->supplierGuid;
    }

    /**
     * @param mixed $supplierGuid
     */
    public function setSupplierGuid($supplierGuid): void
    {
        $this->supplierGuid = $supplierGuid;
    }

    /**
     * @return mixed
     */
    public function getSupplierName()
    {
        return $this->supplierName;
    }

    /**
     * @param mixed $supplierName
     */
    public function setSupplierName($supplierName): void
    {
        $this->supplierName = $supplierName;
    }

    /**
     * @return mixed
     */
    public function getPrimaryCategory()
    {
        return $this->primaryCategory;
    }

    /**
     * @param mixed $primaryCategory
     */
    public function setPrimaryCategory($primaryCategory): void
    {
        $this->primaryCategory = $primaryCategory;
    }

    /**
     * @return mixed
     */
    public function getPriceLevels()
    {
        return $this->priceLevels;
    }

    /**
     * @param mixed $priceLevels
     */
    public function setPriceLevels($priceLevels): void
    {
        $this->priceLevels = $priceLevels;
    }



}