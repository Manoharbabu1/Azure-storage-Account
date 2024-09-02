# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$sourceStorageAccountName = "mysourcesourceblobaccount"
$destinationStorageAccountName = "mydestblobaccount"
$containerName = "myreplicationcontainer"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Source Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $sourceStorageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create Destination Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $destinationStorageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Enable Object Replication
$contextSource = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $sourceStorageAccountName).Context
$contextDestination = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $destinationStorageAccountName).Context

Set-AzStorageAccountObjectReplicationPolicy -SourceAccount $sourceStorageAccountName `
    -DestinationAccount $destinationStorageAccountName `
    -PolicyId "myPolicyId" `
    -RuleId "myRuleId" `
    -SourceContainer $containerName `
    -DestinationContainer $containerName

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $sourceStorageAccountName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $destinationStorageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
