targetScope = 'subscription'

@minLength(1)
@maxLength(50)
@description('Name of the the environment')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Azure resource tags')
param tags object

@description('Service prefix which is assigned to every resource name')
param servicePrefix string

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var combinedTags = union(tags, { 'azd-env-name': name })

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
    name: 'rg-${name}'
    location: location
    tags: combinedTags
}

module resources './modules/resources.bicep' = {
    name: 'resources'
    scope: resourceGroup
    params: {
        location: location
        tags: combinedTags
        servicePrefix: servicePrefix
        resourceToken: resourceToken
    }
}

output APP_WEB_BASE_URL string = resources.outputs.API_URI
output AZURE_LOCATION string = location
