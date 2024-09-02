# Variables
$resourceGroup = "StoragePoCResourceGroup"
$location = "EastUS"
$storageAccountName = "mypoceventgrid"
$topicName = "myeventgridtopic"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Storage Account
New-AzStorageAccount -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -Location $location

# Create Event Grid Topic
New-AzEventGridTopic -ResourceGroupName $resourceGroup `
    -Name $topicName `
    -Location $location

# Configure Event Grid Subscription for Blob Storage
New-AzEventGridSubscription -ResourceGroupName $resourceGroup `
    -TopicName $topicName `
    -Name "BlobCreatedSubscription" `
    -EndpointType "WebHook" `
    -Endpoint "https://myendpoint.com/webhook"

# Cleanup
Remove-AzEventGridSubscription -ResourceGroupName $resourceGroup `
    -TopicName $topicName `
    -Name "BlobCreatedSubscription" -Force
Remove-AzEventGridTopic -ResourceGroupName $resourceGroup -Name $topicName -Force
Remove-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Force
Remove-AzResourceGroup -Name $resourceGroup -Force
