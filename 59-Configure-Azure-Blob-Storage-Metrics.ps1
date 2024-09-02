# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocmetricsblobaccount"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Enable Metrics for Blob Storage
Set-AzStorageServiceMetricsProperty -ServiceType Blob `
    -Context (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context `
    -MetricsLevel Service `
    -MetricsRetentionDays 7

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
