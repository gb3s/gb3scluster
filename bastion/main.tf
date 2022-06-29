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

data "azurerm_virtual_network" "gb3s_network" {
  name =  "gb3s-network"
  resource_group_name = "gb3s"
}

resource "azurerm_resource_group" "gb3s_bastion" {
  name = "gb3s-bastion"
  location = "East US"
}

resource azurerm_subnet gb3s_bastnet {
  name                 = "AzureBastionSubnet"
  resource_group_name  = "gb3s"
  virtual_network_name = data.azurerm_virtual_network.gb3s_network.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "gb3s_bastion_ip" {
  name                = "BastionHostIP"
  location            = azurerm_resource_group.gb3s_bastion.location
  resource_group_name = azurerm_resource_group.gb3s_bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource azurerm_bastion_host gb3s_bastion {
  name                = "gb3s-bastion"
  location            = azurerm_resource_group.gb3s_bastion.location
  resource_group_name = azurerm_resource_group.gb3s_bastion.name

  ip_configuration {
    name                 = "gb3s-config"
    subnet_id            = azurerm_subnet.gb3s_bastnet.id
    public_ip_address_id = azurerm_public_ip.gb3s_bastion_ip.id
  }
}
