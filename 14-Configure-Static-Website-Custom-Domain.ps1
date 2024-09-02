# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$customDomainName = "www.mywebsite.com"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Configure Custom Domain for Static Website
Set-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -CustomDomainName $customDomainName `
    -UseSubDomain $true

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
