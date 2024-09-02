# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypoctagsaccount"
$containerName = "tagscontainer"
$blobName = "myblob.txt"
$tags = @{"Project"="ProjectA";"Environment"="Prod"}

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

# Set Tags on the Blob
Set-AzStorageBlobTag -Context $context `
    -Container $containerName `
    -Blob $blobName `
    -Tags $tags

# Cleanup
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
