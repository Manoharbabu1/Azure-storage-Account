# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocversioningpolicyaccount"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account with Versioning Enabled
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableBlobVersioning $true `
    -Location $location

# Define Versioning Policy
$versioningPolicy = @{
    Enabled = $true
    Retention = @{
        Days = 90
    }
}

Set-AzStorageAccountManagementPolicy -ResourceGroupName $resourceGroup `
    -AccountName $storageAccountName `
    -Policy $versioningPolicy

# Cleanup
Remove-AzStorageAccountManagementPolicy -ResourceGroupName $resourceGroup -AccountName $storageAccountName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
