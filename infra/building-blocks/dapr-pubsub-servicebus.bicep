param name string
param location string
param topicName string

param resourceToken string = toLower(uniqueString(subscription().id, name, location))
param tags object = {
  'azd-env-name': name
}

module daprPubsubServicebusResources '../resources/servicebus.bicep' = {
  name: name
  params:{
    name: name
    location: location
    topicName: topicName
    resourceToken: resourceToken
    tags: tags
  }
}
