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
  current = data.azurerm_client_config.current
  network_id = azurerm_virtual_network.network.id
  keyavult_id = module.keyvault.keyavult_id
}

module "jumpbox" {
  source = "./jumpbox"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = azurerm_virtual_network.network.name
}

module "bastion" {
  source = "./bastion"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = azurerm_virtual_network.network
}

module "keyvault" {
  source = "./keyvault"

  current = data.azurerm_client_config.current
  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network = azurerm_virtual_network.network.

}