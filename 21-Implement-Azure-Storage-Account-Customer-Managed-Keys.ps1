# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$keyVaultName = "myKeyVault"
$keyName = "myKey"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Key Vault
New-AzKeyVault -ResourceGroupName $resourceGroup `
    -VaultName $keyVaultName `
    -Location $location

# Create a Key in Key Vault
$key = Add-AzKeyVaultKey -VaultName $keyVaultName `
    -Name $keyName `
    -Destination "Software"

# Create Storage Account with Customer-Managed Key
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location `
    -EncryptionKeySource "Microsoft.Keyvault" `
    -EncryptionKeyVaultProperties @{"KeyName"=$keyName;"KeyVaultUri"=$key.VaultUri;"KeyVersion"=$key.Version}

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroup -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
