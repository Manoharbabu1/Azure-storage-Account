# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$storageSyncServiceName = "MySyncService"
$syncGroupName = "MySyncGroup"
$azureFileShareName = "MyFileShare"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create a Storage Sync Service
New-AzStorageSyncService -ResourceGroupName $resourceGroup `
    -StorageSyncServiceName $storageSyncServiceName `
    -Location $location

# Create a Sync Group
New-AzStorageSyncGroup -ResourceGroupName $resourceGroup `
    -StorageSyncServiceName $storageSyncServiceName `
    -SyncGroupName $syncGroupName

# Create a Cloud Endpoint
New-AzStorageSyncCloudEndpoint -ResourceGroupName $resourceGroup `
    -StorageSyncServiceName $storageSyncServiceName `
    -SyncGroupName $syncGroupName `
    -StorageAccountName $storageAccountName `
    -AzureFileShareName $azureFileShareName

# Cleanup
Remove-AzStorageSyncCloudEndpoint -ResourceGroupName $resourceGroup `
    -StorageSyncServiceName $storageSyncServiceName `
    -SyncGroupName $syncGroupName `
    -Name $azureFileShareName
Remove-AzStorageSyncGroup -ResourceGroupName $resourceGroup `
    -StorageSyncServiceName $storageSyncServiceName `
    -Name $syncGroupName
Remove-AzStorageSyncService -ResourceGroupName $resourceGroup `
    -Name $storageSyncServiceName
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
