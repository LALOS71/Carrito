<?php

class OrderItem extends TronShopClass
{
    public $id;
    public $parentId;
    public $orderId;
    public $productID;
    public $productType;
    public $productTypeTitle;
    public $productImageUrl;
    public $productCode;
    public $displayProductCode;
    public $productDescription;
    public $itemTitle;
    public $itemCount;
    public $itemDescription;
    public $itemTypeTitle;
    public $supplierName;
    public $supplierCode;
    public $supplierProductCode;
    public $salePrice;
    public $salePriceVat;
    public $saleVat;
    public $purchasePrice;
    public $purchaseVat;
    public $fileUrl;

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
    public function getParentId()
    {
        return $this->parentId;
    }

    /**
     * @param mixed $parentId
     */
    public function setParentId($parentId): void
    {
        $this->parentId = $parentId;
    }

    /**
     * @return mixed
     */
    public function getOrderId()
    {
        return $this->orderId;
    }

    /**
     * @param mixed $orderId
     */
    public function setOrderId($orderId): void
    {
        $this->orderId = $orderId;
    }

    /**
     * @return mixed
     */
    public function getProductID()
    {
        return $this->productID;
    }

    /**
     * @param mixed $productID
     */
    public function setProductID($productID): void
    {
        $this->productID = $productID;
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
    public function getProductImageUrl()
    {
        return $this->productImageUrl;
    }

    /**
     * @param mixed $productImageUrl
     */
    public function setProductImageUrl($productImageUrl): void
    {
        $this->productImageUrl = $productImageUrl;
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
    public function getDisplayProductCode()
    {
        return $this->displayProductCode;
    }

    /**
     * @param mixed $displayProductCode
     */
    public function setDisplayProductCode($displayProductCode): void
    {
        $this->displayProductCode = $displayProductCode;
    }

    /**
     * @return mixed
     */
    public function getProductDescription()
    {
        return $this->productDescription;
    }

    /**
     * @param mixed $productDescription
     */
    public function setProductDescription($productDescription): void
    {
        $this->productDescription = $productDescription;
    }

    /**
     * @return mixed
     */
    public function getItemTitle()
    {
        return $this->itemTitle;
    }

    /**
     * @param mixed $itemTitle
     */
    public function setItemTitle($itemTitle): void
    {
        $this->itemTitle = $itemTitle;
    }

    /**
     * @return mixed
     */
    public function getItemCount()
    {
        return $this->itemCount;
    }

    /**
     * @param mixed $itemCount
     */
    public function setItemCount($itemCount): void
    {
        $this->itemCount = $itemCount;
    }

    /**
     * @return mixed
     */
    public function getItemDescription()
    {
        return $this->itemDescription;
    }

    /**
     * @param mixed $itemDescription
     */
    public function setItemDescription($itemDescription): void
    {
        $this->itemDescription = $itemDescription;
    }

    /**
     * @return mixed
     */
    public function getItemTypeTitle()
    {
        return $this->itemTypeTitle;
    }

    /**
     * @param mixed $itemTypeTitle
     */
    public function setItemTypeTitle($itemTypeTitle): void
    {
        $this->itemTypeTitle = $itemTypeTitle;
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
    public function getSupplierCode()
    {
        return $this->supplierCode;
    }

    /**
     * @param mixed $supplierCode
     */
    public function setSupplierCode($supplierCode): void
    {
        $this->supplierCode = $supplierCode;
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
    public function getSaleVat()
    {
        return $this->saleVat;
    }

    /**
     * @param mixed $saleVat
     */
    public function setSaleVat($saleVat): void
    {
        $this->saleVat = $saleVat;
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
    public function getPurchaseVat()
    {
        return $this->purchaseVat;
    }

    /**
     * @param mixed $purchaseVat
     */
    public function setPurchaseVat($purchaseVat): void
    {
        $this->purchaseVat = $purchaseVat;
    }

    /**
     * @return mixed
     */
    public function getFileUrl()
    {
        return $this->fileUrl;
    }

    /**
     * @param mixed $fileUrl
     */
    public function setFileUrl($fileUrl): void
    {
        $this->fileUrl = $fileUrl;
    }


}