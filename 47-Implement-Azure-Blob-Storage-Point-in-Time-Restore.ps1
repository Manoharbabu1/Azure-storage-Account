# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocrestoreblobaccount"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account with Point-in-Time Restore Enabled
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableBlobRestore `
    -Location $location

# Upload a Blob
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
Set-AzStorageBlobContent -File "C:\mydata\file.txt" `
    -Container "mycontainer" `
    -Blob "file.txt" `
    -Context $context

# Perform Point-in-Time Restore
Invoke-AzStorageBlobRestore -ResourceGroupName $resourceGroup `
    -AccountName $storageAccountName `
    -StartDateTime (Get-Date).AddHours(-1) `
    -EndDateTime (Get-Date).AddMinutes(-5)

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
