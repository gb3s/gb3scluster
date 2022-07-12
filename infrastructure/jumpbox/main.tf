

resource "azurerm_resource_group" "jumpbox" {
    name     = "${var.cluster_name}-jump"
    location = var.location
}

resource "azurerm_subnet" "jumpnet" {
  name                 = "internal"
  resource_group_name  = var.network.group
  virtual_network_name = var.network.name
  address_prefixes     = ["10.0.3.64/26"]
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${var.cluster_name}-jumpbox-nic"
  location            = azurerm_resource_group.jumpbox.location
  resource_group_name = azurerm_resource_group.jumpbox.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumpnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = "${var.cluster_name}-jumpbox"
  resource_group_name = azurerm_resource_group.jumpbox.name
  location            = azurerm_resource_group.jumpbox.location
  size                = "Standard_B2s"
  admin_username      = "${var.admin_user}"
  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id,
  ]

  admin_ssh_key {
    username   = "${var.admin_user}"
    public_key = file("./${var.admin_user}.pub")
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