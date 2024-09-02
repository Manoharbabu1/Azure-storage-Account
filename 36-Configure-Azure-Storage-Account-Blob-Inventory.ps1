# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocinventoryaccount"
$containerName = "inventorycontainer"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account with Blob Inventory Enabled
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create Blob Container
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
New-AzStorageContainer -Name $containerName -Context $context

# Configure Blob Inventory
Set-AzStorageBlobInventoryPolicy -Context $context `
    -Container $containerName `
    -Enabled $true `
    -Schedule Daily `
    -Fields @("Name", "Last-Modified", "Tier", "Access-Tier-Change-Time")

# Cleanup
Remove-AzStorageBlobInventoryPolicy -Context $context -Container $containerName -Force
Remove-AzStorageContainer -Name $containerName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
