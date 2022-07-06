resource "azurerm_resource_group" "group" {
  name     = "${var.cluster_name}"
  location = var.location
}

resource "azurerm_user_assigned_identity" "cluster_id" {
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location

  name = "${var.cluster_name}-cluster"
}

resource "azurerm_subnet" "agentnet" {
  name = "agent-nodepool"
  enforce_private_link_endpoint_network_policies = true
  resource_group_name = var.network.group
  virtual_network_name = var.network.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_private_dns_zone" "cluster_dns" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = azurerm_resource_group.group.name
}

resource "azurerm_role_assignment" "dns_role_assignment" {
  scope                = azurerm_private_dns_zone.cluster_dns.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_role_assignment" "network_role_assignment" {
  scope                = var.network.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_role_assignment" "node_group_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_kubernetes_cluster.cluster.node_resource_group}"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_role_assignment" "cluster_group_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.group.name}"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_role_assignment" "keyvault_role_assignment" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_role_assignment" "sub_read_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_kubernetes_cluster.cluster.node_resource_group}"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name = "${var.cluster_name}"
  location = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  private_cluster_enabled = true
  private_dns_zone_id = azurerm_private_dns_zone.cluster_dns.id
  dns_prefix_private_cluster = "${var.cluster_name}-cluster"
  node_resource_group = "${var.cluster_name}-nodes"

  kubelet_identity {
    client_id = azurerm_user_assigned_identity.cluster_id.client_id
    object_id = azurerm_user_assigned_identity.cluster_id.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.cluster_id.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  default_node_pool {
    name       = "agents"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.agentnet.id

  }

  network_profile {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    dns_service_ip     = "10.0.12.10"
    service_cidr       = "10.0.12.0/22"
    pod_cidr           = "10.0.4.0/22"
    docker_bridge_cidr = "10.0.8.0/22"  
  }

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.cluster_id.id ]
  }

}

