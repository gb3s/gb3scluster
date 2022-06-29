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

resource "azurerm_resource_group" "gb3s_group" {
  name     = "gb3s"
  location = "East US"
}

resource "azurerm_user_assigned_identity" "gb3s_cluster_id" {
  resource_group_name = azurerm_resource_group.gb3s_group.name
  location            = azurerm_resource_group.gb3s_group.location

  name = "gb3s-cluster"
}

resource "azurerm_virtual_network" "gb3s_cluster_network" {
  name = "gb3s-network"
  location = azurerm_resource_group.gb3s_group.location
  resource_group_name = azurerm_resource_group.gb3s_group.name
  address_space = [ "10.0.0.0/16" ]
}


resource "azurerm_subnet" "gb3s_agentnet" {
  name = "agent-nodepool"
  enforce_private_link_endpoint_network_policies = true
  resource_group_name = azurerm_resource_group.gb3s_group.name
  virtual_network_name = azurerm_virtual_network.gb3s_cluster_network.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_private_dns_zone" "gb3s_cluster_dns" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = azurerm_resource_group.gb3s_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "${azurerm_kubernetes_cluster.gb3s_cluster.name}-link-${azurerm_virtual_network.gb3s_cluster_network.name}"
  resource_group_name   = azurerm_resource_group.gb3s_group.name
  private_dns_zone_name = azurerm_private_dns_zone.gb3s_cluster_dns.name
  virtual_network_id    = azurerm_virtual_network.gb3s_cluster_network.id
  registration_enabled = true
}

resource "azurerm_role_assignment" "gb3s_dns_role_assignment" {
  scope                = azurerm_private_dns_zone.gb3s_cluster_dns.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.gb3s_cluster_id.principal_id
}

resource "azurerm_role_assignment" "gb3s_network_role_assignment" {
  scope                = azurerm_virtual_network.gb3s_cluster_network.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.gb3s_cluster_id.principal_id
}

resource "azurerm_kubernetes_cluster" "gb3s_cluster" {
  name = "gb3s"
  location = azurerm_resource_group.gb3s_group.location
  resource_group_name = azurerm_resource_group.gb3s_group.name
  private_cluster_enabled = true
  private_dns_zone_id = azurerm_private_dns_zone.gb3s_cluster_dns.id
  dns_prefix_private_cluster = "gb3s-cluster"
  node_resource_group = "gb3s-nodes"

  default_node_pool {
    name       = "agents"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.gb3s_agentnet.id
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
    identity_ids = [ azurerm_user_assigned_identity.gb3s_cluster_id.id ]
  }

}

