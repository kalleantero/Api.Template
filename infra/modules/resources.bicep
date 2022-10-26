param location string
param tags object
param servicePrefix string
param resourceToken string

var abbreviations = loadJsonContent('../assets/abbreviations.json')

module logAnalyticsWorkspace 'logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspace-resources'
  params: {
    location: location
    tags: tags
    servicePrefix: servicePrefix
    abbreviation: abbreviations.logAnalyticsWorkspace
    resourceToken: resourceToken
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
    resourceToken: resourceToken
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
    resourceToken: resourceToken
  }
}

module appService 'appService.bicep' = {
  name: 'appService-resources'
  params: {
    location: location
    tags: union(tags, { 'azd-service-name': 'appService' })
    servicePrefix: servicePrefix
    abbreviation: abbreviations.webApp
    applicationInsightsConnectionString: applicationInsightsResources.outputs.applicationInsightsConnectionString
    appServicePlanId: appServicePlan.outputs.appServicePlanId
    resourceToken: resourceToken
  }
}

output API_URI string = 'https://${appService.outputs.defaultHostName}'
