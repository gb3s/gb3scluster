terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "gb3s_group" {
  name     = "gb3s"
  location = "East US"
}

# resource "azurerm_managed_identity" "gb3s_cluster_id" {
#   name  = "gb3s"
# }

# resource "azurerm_kubernetes_cluster" "gb3s_cluster" {
#   name = "gb3s"
#   location = azurerm_resource_group.gb3s_group.location
#   resource_group_name = azurerm_resource_group.gb3s_group.id

# }

