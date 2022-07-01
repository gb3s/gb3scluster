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

module "aks" {
  source = "./aks"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
}

module "jumpbox" {
  source = "./jumpbox"

  cluster_name = var.cluster_name
  location = var.location
  admin_user = var.admin_user
  network_name = module.aks.network_name
}

module "bastion" {
  source = "./bastion"

  cluster_name = var.cluster_name
  location = var.location
  network_name = module.aks.network_name
}