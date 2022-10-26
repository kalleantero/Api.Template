param location string
param tags object
param servicePrefix string
param abbreviation string
param sku string
param kind string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${abbreviation}${servicePrefix}-${location}-001'
  location: location
  tags: tags
  kind: kind
  sku: {
    name: sku
  }
}

output appServicePlanId string = appServicePlan.id
