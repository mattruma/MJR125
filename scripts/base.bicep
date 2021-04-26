param productId string 
param servicePrincipalId string
param linuxFxVersion string  = 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${productId}log'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: '${productId}st'
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: '${productId}acr'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource webAppPlan 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: '${productId}plan' 
  location: resourceGroup().location
  sku: {
    name: 'B1'
    capacity: 1  
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webAppAppInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '${productId}appappi'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logWorkspace.id
  }
}

resource webApp 'Microsoft.Web/sites@2018-11-01' = {
  name: '${productId}app'
  location: resourceGroup().location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: webAppPlan.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      minTlsVersion: '1.2'
      linuxFxVersion: linuxFxVersion   
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 35
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': webAppAppInsights.properties.InstrumentationKey
        }
        {
          'name': 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          'value': webAppAppInsights.properties.ConnectionString
        }
        {
          'name': 'DOCKER_REGISTRY_SERVER_PASSWORD'
          'value': listCredentials(acr.id, acr.apiVersion).passwords[0].value
        }
        {
          'name': 'DOCKER_REGISTRY_SERVER_USERNAME'
          'value': acr.name
        }
        {
          'name': 'DOCKER_REGISTRY_SERVER_URL'
          'value': 'https://${acr.properties.loginServer}'
        }
      ]
    }
  }
}
