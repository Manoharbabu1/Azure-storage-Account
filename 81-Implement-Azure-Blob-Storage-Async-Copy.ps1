# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$sourceStorageAccountName = "sourceStorageAccount"
$destinationStorageAccountName = "destinationStorageAccount"
$containerName = "blobcontainer"
$blobName = "blob.txt"
$copyId = ""

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Source Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $sourceStorageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create Destination Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $destinationStorageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Upload a Blob to Source Account
$contextSource = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $sourceStorageAccountName).Context
Set-AzStorageBlobContent -File "C:\mydata\$blobName" `
    -Container $containerName `
    -Blob $blobName `
    -Context $contextSource

# Start Async Copy to Destination Account
$contextDestination = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $destinationStorageAccountName).Context
$copyId = Start-AzStorageBlobCopy -SrcBlobName $blobName `
    -SrcContainerName $containerName `
    -DestBlobName $blobName `
    -DestContainerName $containerName `
    -SrcContext $contextSource `
    -DestContext $contextDestination

Write-Output "Copy initiated with ID: $copyId"

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $sourceStorageAccountName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $destinationStorageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
