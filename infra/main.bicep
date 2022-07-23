targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${name}-rg'
  location: location
}

module application 'building-blocks/paas-application.bicep' = {
  name: 'pubsub-dapr-aca-servicebus'
  params: {
    name: name
    location: location
  }
  scope: resourceGroup
  dependsOn:[
    pubsub
  ]
}

module checkoutContainerApp 'building-blocks/containerapp-worker.bicep' = {
  name: 'ca-checkout'
  params:{
    name: name
    location: location
    containerName: 'checkout'
  }
  scope: resourceGroup
  dependsOn:[
    application
  ]
}

module ordersContainerApp 'building-blocks/containerapp-http.bicep' = {
  name: 'ca-orders'
  params:{
    name: name
    location: location
    containerName: 'orders'
    ingressPort: 5001
  }
  scope: resourceGroup
  dependsOn:[
    application
  ]
}

module pubsub 'building-blocks/dapr-pubsub-servicebus.bicep' = {
  name: 'pubsub-sb-orders'
  params: {
    name: name
    location: location
    topicName: 'orders'
  }
  scope: resourceGroup
}
