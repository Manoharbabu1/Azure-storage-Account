# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Geo-Redundant Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_RAGRS `
    -Kind StorageV2 `
    -Location $location

# Initiate Account Failover
Invoke-AzStorageAccountFailover -ResourceGroupName $resourceGroup `
    -Name $storageAccountName

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
