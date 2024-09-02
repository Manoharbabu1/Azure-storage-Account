# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$customerProvidedKey = "your-customer-provided-key"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account with Customer-Provided Key
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location `
    -EncryptionKeySource "Microsoft.Keyvault" `
    -EncryptionKeyVaultProperties @{"KeyName"="MyKey";"KeyVersion"="keyversion";"KeyVaultUri"="https://your-keyvault-uri"}

# Upload Blob with Customer-Provided Key
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
Set-AzStorageBlobContent -File "C:\mydata\file.txt" `
    -Container "mycontainer" `
    -Blob "file.txt" `
    -Context $context `
    -CustomerProvidedKey $customerProvidedKey

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
