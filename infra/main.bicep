targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Optional parameters to override the default azd resource naming conventions. Update the main.parameters.json file to provide values. e.g.,
// "resourceGroupName": {
//      "value": "myGroupName"
// }
param applicationInsightsDashboardName string = ''
param applicationInsightsName string = ''
param appServicePlanName string = ''
param keyVaultName string = ''
param logAnalyticsName string = ''
param resourceGroupName string = ''
param webServiceName string = ''


@description('Id of the user or app to assign application roles')
param principalId string = ''


param useVirtualNetworkPrivateEndpoint bool = true
param virtualNetworkAddressSpacePrefix string = '10.1.0.0/16'
param virtualNetworkIntegrationSubnetAddressSpacePrefix string = '10.1.1.0/24'
param virtualNetworkPrivateEndpointSubnetAddressSpacePrefix string = '10.1.2.0/24'

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }
var useVirtualNetwork = true
var virtualNetworkName = '${abbrs.networkVirtualNetworks}${resourceToken}'
var virtualNetworkIntegrationSubnetName = '${abbrs.networkVirtualNetworksSubnets}${resourceToken}-int'
var virtualNetworkPrivateEndpointSubnetName = '${abbrs.networkVirtualNetworksSubnets}${resourceToken}-pe'

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

// Create an App Service Plan to group applications under the same payment plan and SKU
module appServicePlan './core/host/appserviceplan.bicep' = {
  name: 'appserviceplan'
  scope: rg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : '${abbrs.webServerFarms}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: 'B3'
    }
  }
}

// Store secrets in a keyvault
module keyVault './core/security/keyvault.bicep' = {
  name: 'keyvault'
  scope: rg
  params: {
    name: !empty(keyVaultName) ? keyVaultName : '${abbrs.keyVaultVaults}${resourceToken}'
    location: location
    tags: tags
    principalId: principalId
    useVirtualNetworkPrivateEndpoint: useVirtualNetworkPrivateEndpoint
  }
}

// Monitor application with Azure Monitor
module monitoring './core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  scope: rg
  params: {
    location: location
    tags: tags
    logAnalyticsName: !empty(logAnalyticsName) ? logAnalyticsName : '${abbrs.operationalInsightsWorkspaces}${resourceToken}'
    applicationInsightsName: !empty(applicationInsightsName) ? applicationInsightsName : '${abbrs.insightsComponents}${resourceToken}'
    applicationInsightsDashboardName: !empty(applicationInsightsDashboardName) ? applicationInsightsDashboardName : '${abbrs.portalDashboards}${resourceToken}'
  }
}

// The application frontend
module web './app/web.bicep' = {
  name: 'web'
  scope: rg
  params: {
    name: !empty(webServiceName) ? webServiceName : '${abbrs.webSitesAppService}web-${resourceToken}'
    location: location
    tags: tags
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    appServicePlanId: appServicePlan.outputs.id
  }
}

// Virtual Network and Subnets
module integrationSubnetNsg './core/networking/network-security-group.bicep' = if (useVirtualNetwork) {
  name: 'integrationSubnetNsg'
  scope: rg
  params: {
    name: '${abbrs.networkNetworkSecurityGroups}${resourceToken}-integration-subnet'
    location: location
  }
}

module privateEndpointSubnetNsg './core/networking/network-security-group.bicep' = if (useVirtualNetwork) {
  name: 'privateEndpointSubnetNsg'
  scope: rg
  params: {
    name: '${abbrs.networkNetworkSecurityGroups}${resourceToken}-private-endpoint-subnet'
    location: location
  }
}

module vnet './core/networking/virtual-network.bicep' = if (useVirtualNetwork) {
  name: 'vnet'
  scope: rg
  params: {
    name: virtualNetworkName
    location: location
    tags: tags
    virtualNetworkAddressSpacePrefix: virtualNetworkAddressSpacePrefix
    subnets: [
      {
        name: virtualNetworkIntegrationSubnetName
        addressPrefix: virtualNetworkIntegrationSubnetAddressSpacePrefix
        networkSecurityGroupId: integrationSubnetNsg.outputs.id
        delegations: [
          {
            name: 'delegation'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }
          }
        ]
      }
      {
        name: virtualNetworkPrivateEndpointSubnetName
        addressPrefix: virtualNetworkPrivateEndpointSubnetAddressSpacePrefix
        networkSecurityGroupId: privateEndpointSubnetNsg.outputs.id
        privateEndpointNetworkPolicies: 'Disabled'
      }
    ]
  }
}

// App outputs
output APPLICATIONINSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.endpoint
output AZURE_KEY_VAULT_NAME string = keyVault.outputs.name
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output REACT_APP_WEB_BASE_URL string = web.outputs.SERVICE_WEB_URI

