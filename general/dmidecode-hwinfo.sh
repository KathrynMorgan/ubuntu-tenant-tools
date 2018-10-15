# Example commands to retrieve system info matching smbios-sys-info fields

PRODUCT=$(dmidecode -s system-product-name)
VENDOR=$(dmidecode -s system-manufacturer)
BIOS_VERSION=$(dmidecode -s bios-version)
SERVICE_TAG=$(dmidecode -s system-serial-number)
ESV=$(echo $((36#$SERVICE_TAG)))
ASSET_TAG=$(dmidecode -s chassis-asset-tag)
OWNERSHIP=$(ownership)

echo "Product Name:            $PRODUCT"
echo "Vendor:                  $VENDOR"
echo "BIOS Version:            $BIOS_VERSION"
echo "Service Tag:             $SERVICE_TAG"
echo "Express Service Code     $ESV"
echo "Asset Tag:               $ASSET_TAG"
echo "Property Ownership Tag:  $OWNERSHIP"
