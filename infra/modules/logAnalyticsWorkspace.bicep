param location string
param tags object
param servicePrefix string
param abbreviation string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${abbreviation}${servicePrefix}-${location}-001'
  location: location
  tags: tags
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
