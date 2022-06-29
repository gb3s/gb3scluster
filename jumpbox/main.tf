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

resource "azurerm_resource_group" "jumpbox" {
    name = "gb3s-jump"
    location = "East US"
}

data "azurerm_virtual_network" "gb3s_network" {
    resource_group_name = "gb3s"
    name = "gb3s-network"
}
resource "azurerm_subnet" "gb3s_jumpnet" {
  name                 = "internal"
  resource_group_name  = "gb3s"
  virtual_network_name = "gb3s-network"
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "gb3_jumpbox_nic" {
  name                = "gb3s-jumpbox-nic"
  location            = azurerm_resource_group.jumpbox.location
  resource_group_name = azurerm_resource_group.jumpbox.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.gb3s_jumpnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "gb3s_jumpbox" {
  name                = "gb3s-jumpbox"
  resource_group_name = azurerm_resource_group.jumpbox.name
  location            = azurerm_resource_group.jumpbox.location
  size                = "Standard_B2s"
  admin_username      = "gbabes"
  network_interface_ids = [
    azurerm_network_interface.gb3_jumpbox_nic.id,
  ]

  admin_ssh_key {
    username   = "gbabes"
    public_key = file("~/.ssh/gb3s.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}