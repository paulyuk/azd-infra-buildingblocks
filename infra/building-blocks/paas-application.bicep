@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string = ''

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var tags = {
  'azd-env-name': name
}

module containerAppsEnvResources './../resources/containerappsenv.bicep' = {
  name: 'containerapps-resources'
  params: {
    location: location
    tags: tags
    resourceToken: resourceToken
  }

  dependsOn: [
    logAnalyticsResources
  ]
}

module keyVaultResources './../resources/keyvault.bicep' = {
  name: 'keyvault-resources'
  params: {
    location: location
    tags: tags
    resourceToken: resourceToken
    principalId: principalId
  }
}

module appInsightsResources './../resources/appinsights.bicep' = {
  name: 'appinsights-resources'
  params: {
    location: location
    tags: tags
    resourceToken: resourceToken
  }
}

module logAnalyticsResources './../resources/loganalytics.bicep' = {
  name: 'loganalytics-resources'
  params: {
    location: location
    tags: tags
    resourceToken: resourceToken
  }
}


output KEY_VAULT_ENDPOINT string = keyVaultResources.outputs.KEY_VAULT_ENDPOINT
//output SERVICEBUS_ENDPOINT string = resources.outputs.SERVICEBUS_ENDPONT
output APPINSIGHTS_INSTRUMENTATIONKEY string = appInsightsResources.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
output CONTAINER_REGISTRY_ENDPOINT string = containerAppsEnvResources.outputs.CONTAINER_REGISTRY_ENDPOINT
output CONTAINER_REGISTRY_NAME string = containerAppsEnvResources.outputs.CONTAINER_REGISTRY_NAME
output RESOURCE_TOKEN string = resourceToken
