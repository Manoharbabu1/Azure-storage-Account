# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$vnetName = "MyVNet"
$subnetName = "MySubnet"
$privateEndpointName = "MyPrivateEndpoint"

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

# Create Private Endpoint for Storage Account
$subnetId = (Get-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName).Subnets[0].Id
New-AzPrivateEndpoint -ResourceGroupName $resourceGroup `
    -Name $privateEndpointName `
    -Location $location `
    -SubnetId $subnetId `
    -PrivateLinkServiceConnection @{"Name"="Storage";"PrivateLinkServiceId"=(Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Id;"GroupIds"="blob"}

# Cleanup
Remove-AzPrivateEndpoint -ResourceGroupName $resourceGroup -Name $privateEndpointName -Force
Remove-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
