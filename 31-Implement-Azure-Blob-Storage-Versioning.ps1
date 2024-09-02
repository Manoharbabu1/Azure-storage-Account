# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocversioningaccount"
$containerName = "versionedcontainer"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account with Versioning Enabled
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableBlobVersioning $true `
    -Location $location

# Create Blob Container
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
New-AzStorageContainer -Name $containerName -Context $context

# Upload a Blob to the Container
Set-AzStorageBlobContent -File "C:\mydata\file.txt" `
    -Container $containerName `
    -Blob "file.txt" `
    -Context $context

# Cleanup
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
