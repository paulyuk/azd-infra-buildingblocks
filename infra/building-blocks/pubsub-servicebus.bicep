param name string
param location string
param topicName string

module pubsubServicebusResources '../resources/servicebus.bicep' = {
  name: name
  params:{
    name: name
    location: location
    topicName: topicName
  }
}
