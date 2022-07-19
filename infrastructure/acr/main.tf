resource "azurerm_user_assigned_identity" "registry_identity" {
  resource_group_name = var.cluster.name
  location            = var.cluster.location

  name = "${var.cluster.name}-registry-id"
}

resource "azurerm_container_registry" "registry" {
  name                = "${var.cluster.name}acr"
  resource_group_name = var.cluster.name
  location            = var.cluster.location
  public_network_access_enabled = false
  sku                 = "Premium"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.registry_identity.id
    ]
  }
}

resource "azurerm_subnet" "regnet" {
  name                 = "${var.cluster.name}-regnet"
  enforce_private_link_endpoint_network_policies = true
  resource_group_name  = var.network.group
  virtual_network_name = var.network.name
  address_prefixes     = [ "10.0.3.192/26" ]
}

resource "azurerm_private_dns_zone" "registry_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.cluster.name
}

resource "azurerm_private_endpoint" "registry_pe" {
  name                = "${var.cluster.name}-registry-endpoint"
  location            = var.cluster.location
  resource_group_name = var.cluster.name
  subnet_id           = azurerm_subnet.regnet.id

  private_dns_zone_group {
    name                 = "registry-zones"
    private_dns_zone_ids = [azurerm_private_dns_zone.registry_dns.id]
  }

  private_service_connection {
    name                           = "${var.cluster.name}-registry-psc"
    private_connection_resource_id = azurerm_container_registry.registry.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "registry_dns_link" {
  name                  = "${var.cluster.name}-link-${azurerm_container_registry.registry.name}"
  resource_group_name   = var.cluster.name
  private_dns_zone_name = azurerm_private_dns_zone.registry_dns.name
  virtual_network_id    = var.network.id
  registration_enabled  = false
}

resource "azurerm_role_assignment" "cluster_registry_role_assignment" {
  principal_id                     = var.cluster_identity
  role_definition_name             = "Owner"
  scope                            = azurerm_container_registry.registry.id
  skip_service_principal_aad_check = true
}