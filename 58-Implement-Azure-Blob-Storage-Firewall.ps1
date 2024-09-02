# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocfirewallblobaccount"
$allowedIpAddress = "192.168.0.1"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableHttpsTrafficOnly $true `
    -Location $location

# Configure Firewall for Storage Account
Set-AzStorageAccountNetworkRuleSet -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -DefaultAction Deny `
    -Bypass AzureServices

Add-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -IPAddressOrRange $allowedIpAddress

# Cleanup
Remove-AzStorageAccountNetworkRule -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -IPAddressOrRange $allowedIpAddress
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
