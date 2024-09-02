# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$containerName = "mypoccontainer"
$localFilePath = "C:\mydata\file.txt"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create a Blob Container
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
New-AzStorageContainer -Name $containerName -Context $context -Permission blob

# Upload a File to Blob Storage
Set-AzStorageBlobContent -File $localFilePath `
    -Container $containerName `
    -Blob "file.txt" `
    -Context $context

# Cleanup
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
