param location string
param tags object
param servicePrefix string
param workspaceId string
param abbreviation string
param resourceToken string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${abbreviation}${servicePrefix}-${location}-${resourceToken}'
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
  }
}

output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString
output applicationInsightsId string = applicationInsights.id
