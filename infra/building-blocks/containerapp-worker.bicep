@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@minLength(1)
@description('name used to derive service, container and dapr appid')
param containerName string

@description('image name used to pull')
param imageName string = ''

module containerAppWorker '../resources/containerapp.bicep' = {
  name: name
  params:{
    name: name
    location: location
    containerName: containerName
    imageName: imageName
  }
}
