param location string
param principalId string = ''
param tags object
param servicePrefix string

var abbreviations = loadJsonContent('../assets/abbreviations.json')

module logAnalyticsWorkspace 'logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspace-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    abbreviation: abbreviations.logAnalyticsWorkspace
  }
}

module applicationInsightsResources 'applicationinsights.bicep' = {
  name: 'applicationinsights-resources'
  params: {
    location: location
    tags: tags
    workspaceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
    abbreviation: abbreviations.applicationInsights
    servicePrefix: servicePrefix
  }
}

module appServicePlan 'appServicePlan.bicep' = {
  name: 'appServicePlan-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    abbreviation: abbreviations.appServicePlan
    sku: 'F1'
    kind: 'app,windows'
  }
}

module appService 'appService.bicep' = {
  name: 'appService-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    abbreviation: abbreviations.webApp
    applicationInsightsConnectionString: applicationInsightsResources.outputs.applicationInsightsConnectionString
    appServicePlanId: appServicePlan.outputs.appServicePlanId
  }
}

output API_URI string = 'https://${appService.outputs.defaultHostName}'
