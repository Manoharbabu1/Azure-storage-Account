# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstoragetiers"
$containerName = "mytiercontainer"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create Blob Container
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
New-AzStorageContainer -Name $containerName -Context $context

# Upload a Blob to Hot Tier
Set-AzStorageBlobContent -File "C:\mydata\file.txt" `
    -Container $containerName `
    -Blob "file.txt" `
    -Context $context `
    -StandardBlobTier Hot

# Move Blob to Archive Tier
Set-AzStorageBlobTier -BlobName "file.txt" -Container $containerName `
    -Context $context -StandardBlobTier Archive

# Cleanup
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
