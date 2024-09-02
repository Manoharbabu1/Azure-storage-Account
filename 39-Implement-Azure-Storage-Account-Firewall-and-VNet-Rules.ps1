# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocfirewallvnetaccount"
$vnetName = "myVNet"
$subnetName = "mySubnet"
$allowedIpAddress = "192.168.0.1"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create Virtual Network and Subnet
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup `
    -Name $vnetName -Location $location `
    -AddressPrefix "10.0.0.0/16"
$subnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName `
    -VirtualNetwork $vnet -AddressPrefix "10.0.0.0/24"
$vnet | Set-AzVirtualNetwork

# Configure Storage Account Firewall and VNet Rules
Set-AzStorageAccountNetworkRuleSet -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -DefaultAction Deny `
    -Bypass AzureServices

Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -VirtualNetwork $vnet `
    -Subnet $subnet `
    -IPAddressOrRange $allowedIpAddress

# Cleanup
Remove-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -IPAddressOrRange $allowedIpAddress
Remove-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
