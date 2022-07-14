terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "network" {
  name = "${var.cluster_name}-network"
  location = var.location
}

resource "azurerm_virtual_network" "network" {
  name = "${var.cluster_name}-network"
  location = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space = [ "10.0.0.0/16" ]
}

module "aks" {
  source = "./aks"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  subscription_id = data.azurerm_client_config.current.subscription_id
  keyvault_id = module.keyvault.keyavult_id

  network = {
    group = azurerm_resource_group.network.name
    name  = azurerm_virtual_network.network.name
    id    = azurerm_virtual_network.network.id
  }
}

module "acr" {
  source = "./acr"
  
  cluster_identity = module.aks.cluster_identity
  current = data.azurerm_client_config.current
  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
    id    = azurerm_virtual_network.network.id
  }
}

module "jumpbox" {
  source = "./jumpbox"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
  }
}

module "bastion" {
  source = "./bastion"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
  }
}

module "keyvault" {
  source = "./keyvault"

  current = data.azurerm_client_config.current
  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
    id    = azurerm_virtual_network.network.id
  }
}