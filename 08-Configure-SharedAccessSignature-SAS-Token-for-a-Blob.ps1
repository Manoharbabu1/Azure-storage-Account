# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$containerName = "mypoccontainer"

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

# Generate SAS Token for Blob
$sasToken = New-AzStorageBlobSASToken -Container $containerName `
    -Blob "file.txt" `
    -Context $context `
    -Permission "r" `
    -ExpiryTime (Get-Date).AddHours(4)

Write-Output "SAS Token: $sasToken"

# Cleanup
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
