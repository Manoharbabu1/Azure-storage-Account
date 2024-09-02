# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$vnetName = "myVNet"
$subnetName = "mySubnet"

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
    -VirtualNetwork $vnet -AddressPrefix "10.0.0.0/24" `
    -ServiceEndpoint "Microsoft.Storage"
$vnet | Set-AzVirtualNetwork

# Configure Service Endpoint for Storage Account
Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -VirtualNetwork $vnet `
    -Subnet $subnet

# Cleanup
Remove-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -VirtualNetwork $vnet `
    -Subnet $subnet
Remove-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
