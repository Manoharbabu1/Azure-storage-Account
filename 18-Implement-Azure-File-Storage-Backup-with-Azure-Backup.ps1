# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocstorageaccount"
$fileShareName = "myfileshare"
$backupVaultName = "mybackupvault"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create File Share
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
New-AzStorageShare -Name $fileShareName -Context $context

# Create Backup Vault
New-AzRecoveryServicesVault -ResourceGroupName $resourceGroup `
    -Name $backupVaultName `
    -Location $location

# Enable Backup for File Share
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroup -Name $backupVaultName
Enable-AzRecoveryServicesBackupProtection -VaultId $vault.ID `
    -ResourceGroupName $resourceGroup `
    -StorageAccountName $storageAccountName `
    -FileShareName $fileShareName

# Cleanup
Remove-AzRecoveryServicesVault -ResourceGroupName $resourceGroup -Name $backupVaultName -Force
Remove-AzStorageShare -Name $fileShareName -Context $context -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
