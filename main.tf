terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

data "azurerm_resource_group" "valheim" {
  name     = "valheim"
  location = "EastUS"
}

resource "azurerm_kubernetes_cluster" "gb3cluster" {
  name                = "gb3scluster"
  location            = data.azurerm_resource_group.valheim.location
  resource_group_name = data.azurerm_resource_group.valheim.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}