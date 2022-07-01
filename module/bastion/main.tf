resource "azurerm_resource_group" "cluster_bastion" {
  name = "${var.cluster_name}-bastion"
  location = "East US"
}

resource azurerm_subnet cluster_bastnet {
  name                 = "AzureBastionSubnet"
  resource_group_name  = "${var.cluster_name}"
  virtual_network_name = var.network_name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "cluster_bastion_ip" {
  name                = "BastionHostIP"
  location            = azurerm_resource_group.cluster_bastion.location
  resource_group_name = azurerm_resource_group.cluster_bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource azurerm_bastion_host cluster_bastion {
  name                = "${var.cluster_name}-bastion"
  location            = azurerm_resource_group.cluster_bastion.location
  resource_group_name = azurerm_resource_group.cluster_bastion.name

  ip_configuration {
    name                 = "${var.cluster_name}-config"
    subnet_id            = azurerm_subnet.cluster_bastnet.id
    public_ip_address_id = azurerm_public_ip.cluster_bastion_ip.id
  }
}
