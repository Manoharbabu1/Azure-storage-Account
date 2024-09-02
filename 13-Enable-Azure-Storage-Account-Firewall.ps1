# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$allowedIpAddress = "192.168.1.1"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Enable Storage Account Firewall
Set-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -EnableHttpsTrafficOnly $true `
    -DefaultAction Deny

# Allow Specific IP Address
Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -IPAddressOrRange $allowedIpAddress

# Cleanup
Remove-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -IPAddressOrRange $allowedIpAddress
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
