terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "gb3s_infra"
    workspaces = {
      name = "gb3scluster"
    }
  }
}

resource "azurerm_resource_group" "gb3s_group" {
  name     = "gb3s"
  location = "East US"
}

# resource "azurerm_kubernetes_cluster" "gb3s_cluster" {
#   name = "gb3s"
#   location = azurerm_resource_group.gb3s_group.location
#   resource_group_name = azurerm_resource_group.gb3s_group.id

# }

