# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypoclifecycleaccount"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Define Lifecycle Management Policy
$lifecyclePolicy = @{
    Rules = @(
        @{
            Name = "DeleteAfter180Days"
            Enabled = $true
            Definition = @{
                Filters = @{
                    BlobTypes = @("blockBlob")
                }
                Actions = @{
                    BaseBlob = @{
                        Delete = @{
                            DaysAfterModificationGreaterThan = 180
                        }
                    }
                }
            }
        }
    )
}

Set-AzStorageAccountManagementPolicy -ResourceGroupName $resourceGroup `
    -AccountName $storageAccountName `
    -Policy $lifecyclePolicy

# Cleanup
Remove-AzStorageAccountManagementPolicy -ResourceGroupName $resourceGroup -AccountName $storageAccountName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
