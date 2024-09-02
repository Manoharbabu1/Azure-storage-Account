# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocsnapshotaccount"
$containerName = "snapshotcontainer"
$blobName = "myblob.txt"

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

# Upload a Blob
Set-AzStorageBlobContent -File "C:\mydata\$blobName" `
    -Container $containerName `
    -Blob $blobName `
    -Context $context

# Create Snapshot of the Blob
$blobSnapshot = New-AzStorageBlobSnapshot -Context $context `
    -Container $containerName `
    -Blob $blobName

Write-Output "Snapshot created: $blobSnapshot.Snapshot"

# Cleanup
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
