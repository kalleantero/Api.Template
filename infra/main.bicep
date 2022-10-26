targetScope = 'subscription'

@minLength(1)
@maxLength(50)
@description('Name of the the environment')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign app roles')
param principalId string = ''

@description('Azure resource tags')
param tags object

@description('Service prefix which is assigned to every resource name')
param servicePrefix string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
    name: 'rg-${name}'
    location: location
    tags: tags
}

module resources './modules/resources.bicep' = {
    name: 'resources'
    scope: resourceGroup
    params: {
        location: location
        principalId: principalId
        tags: tags
        servicePrefix: servicePrefix
    }
}

output APP_WEB_BASE_URL string = resources.outputs.API_URI
output AZURE_LOCATION string = location

