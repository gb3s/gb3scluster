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

resource "azurerm_resource_group" "group" {
  name     = "${var.cluster_name}"
  location = var.location
}

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

  location = var.location
  admin_user = var.admin_user
  subscription_id = data.azurerm_client_config.current.subscription_id
  keyvault_id = module.keyvault.keyavult_id

  cluster = {
    name     = azurerm_resource_group.group.name 
    id       = azurerm_resource_group.group.id
    location = azurerm_resource_group.group.location
  }

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

  cluster = {
    name     = azurerm_resource_group.group.name 
    id       = azurerm_resource_group.group.id
    location = azurerm_resource_group.group.location
  }

  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
    id    = azurerm_virtual_network.network.id
  }
}

module "keyvault" {
  source = "./keyvault"

  current = data.azurerm_client_config.current

  cluster = {
    name     = azurerm_resource_group.group.name 
    id       = azurerm_resource_group.group.id
    location = azurerm_resource_group.group.location
  }

  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
    id    = azurerm_virtual_network.network.id
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


module "jumpbox" {
  source = "./jumpbox"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user

  bast_bast_access_group = {
    name = module.bastion.bast_access_group_name
    location = module.bastion.bast_access_group_location
  }
   
  network = {
    name  = azurerm_virtual_network.network.name
    group = azurerm_resource_group.network.name
  }
}


