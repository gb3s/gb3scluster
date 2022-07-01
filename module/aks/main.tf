resource "azurerm_resource_group" "cluster_group" {
  name     = var.cluster_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "cluster_id" {
  resource_group_name = azurerm_resource_group.cluster_group.name
  location            = azurerm_resource_group.cluster_group.location

  name = "${var.cluster_name}-cluster"
}

resource "azurerm_virtual_network" "cluster_network" {
  name = "${var.cluster_name}-network"
  location = azurerm_resource_group.cluster_group.location
  resource_group_name = azurerm_resource_group.cluster_group.name
  address_space = [ "10.0.0.0/16" ]
}


resource "azurerm_subnet" "cluster_agentnet" {
  name = "${var.cluster_name}-agent-nodepool"
  enforce_private_link_endpoint_network_policies = true
  resource_group_name = azurerm_resource_group.cluster_group.name
  virtual_network_name = azurerm_virtual_network.cluster_network.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_private_dns_zone" "cluster_dns" {
  name                = "privatelink.${var.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.cluster_group.name
}

resource "azurerm_role_assignment" "k8s_dns_role_assignment" {
  scope                = azurerm_private_dns_zone.cluster_dns.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_role_assignment" "k8s_network_role_assignment" {
  scope                = azurerm_virtual_network.cluster_network.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_id.principal_id
}

resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name = var.cluster_name
  location = azurerm_resource_group.cluster_group.location
  resource_group_name = azurerm_resource_group.cluster_group.name
  private_cluster_enabled = true
  private_dns_zone_id = azurerm_private_dns_zone.cluster_dns.id
  dns_prefix_private_cluster = "${var.cluster_name}-cluster"
  node_resource_group = "${var.cluster_name}-nodes"

  default_node_pool {
    name       = "agents"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.cluster_agentnet.id
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

output network_name {
  value = azurerm_virtual_network.cluster_network.name
}
