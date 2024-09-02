# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypocmetricslogging"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account with Metrics and Logging Enabled
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableMetrics `
    -EnableLogging `
    -Location $location

# Configure Logging
$context = (Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName).Context
Set-AzStorageServiceLoggingProperty -ServiceType Blob `
    -Context $context `
    -LoggingOperations "Read,Write,Delete" `
    -RetentionDays 7

# Configure Metrics
Set-AzStorageServiceMetricsProperty -ServiceType Blob `
    -Context $context `
    -MetricsLevel Service `
    -MetricsRetentionDays 7

# Cleanup
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
