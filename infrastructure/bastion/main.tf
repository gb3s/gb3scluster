
resource "azurerm_resource_group" "bastion" {
  name     = "${var.cluster_name}-bastion"
  location = var.location
}

resource azurerm_subnet bastnet {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.network.group
  virtual_network_name = var.network.name
  address_prefixes     = ["10.0.3.0/26"]
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "BastionHostIP"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource azurerm_bastion_host bastion {
  name                = "${var.cluster_name}-bastion"
  location            = azurerm_resource_group.bastion.location
  resource_group_name = azurerm_resource_group.bastion.name

  ip_configuration {
    name                 = "${var.cluster_name}-config"
    subnet_id            = azurerm_subnet.bastnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}

output "bast_access_group_name" {
  value = azurerm_resource_group.bastion.name
}

output "bast_access_group_location" {
  value = azurerm_resource_group.bastion.location
}