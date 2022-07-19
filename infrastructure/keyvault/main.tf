resource "azurerm_key_vault" "cluster_vault" {
  name                        = "${var.cluster.name}-keyvault"
  location                    = var.cluster.location
  resource_group_name         = var.cluster.name
  enabled_for_disk_encryption = false
  tenant_id                   = var.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true 

  sku_name = "standard"
}

resource "azurerm_subnet" "vaultnet" {
  name = "${var.cluster.name}-vaultnet"
  enforce_private_link_endpoint_network_policies = true
  resource_group_name  = var.network.group
  virtual_network_name = var.network.name
  address_prefixes     = [ "10.0.3.128/26" ]
}

resource "azurerm_private_dns_zone" "vault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.cluster.name
}

resource "azurerm_private_endpoint" "vault_pe" {
  name                = "${var.cluster.name}-vault-endpoint"
  location            = var.cluster.location
  resource_group_name = var.cluster.name
  subnet_id           = azurerm_subnet.vaultnet.id

  private_dns_zone_group {
    name = "vault-zones"
    private_dns_zone_ids = [azurerm_private_dns_zone.vault_dns.id]
  }

  private_service_connection {
    name                              = "${var.cluster.name}-vault-psc"
    private_connection_resource_id    = azurerm_key_vault.cluster_vault.id
    subresource_names = ["vault"]
    is_manual_connection              = false
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vault_dns_link" {
  name                  = "${var.cluster.name}-link-${azurerm_key_vault.cluster_vault.name}"
  resource_group_name   = var.cluster.name
  private_dns_zone_name = azurerm_private_dns_zone.vault_dns.name
  virtual_network_id    = var.network.id
  registration_enabled  = false
}

output "keyavult_id" {
  value = azurerm_key_vault.cluster_vault.id
}