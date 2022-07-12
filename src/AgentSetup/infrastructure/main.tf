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

data "azurerm_api_management" "agents_gateway" {
  name = "${var.cluster_name}-apim"
  resource_group_name = "${var.cluster_name}"
}

data "azurerm_api_management_gateway" "agents_internal_gateway" {
  name              = "${var.cluster_name}-internal-gateway"
  api_management_id = data.azurerm_api_management.agents_gateway.id
}

resource "azurerm_api_management_api" "agents_api" {
  name                = "${var.cluster_name}-api"
  resource_group_name = var.cluster_name
  api_management_name = data.azurerm_api_management.agents_gateway.name
  revision            = "1"
  display_name        = "${var.cluster_name} API"
  path                = "agents"
  protocols           = ["https","http"]
  subscription_required = false

  service_url         = "http://10.0.3.69:8080/webhooks"
}

resource "azurerm_api_management_api_operation" "agnets_api_org" {
  operation_id          = "org-webhook"
  api_name              = azurerm_api_management_api.agents_api.name
  api_management_name   = azurerm_api_management_api.agents_api.api_management_name
  resource_group_name   = azurerm_api_management_api.agents_api.resource_group_name
  display_name          = "Forward Request"
  method                = "*"
  url_template          = "org"
  description           = "This can only be done by the logged in user."
}

resource "azurerm_api_management_api" "internal_org_agents_api" {
  name                = "${var.cluster_name}-api-internal"
  resource_group_name = var.cluster_name
  api_management_name = data.azurerm_api_management.agents_gateway.name
  revision            = "1"
  display_name        = "${var.cluster_name} Internal API"
  path                = "webhooks"
  protocols           = ["https","http"]
  subscription_required = false

  service_url         = "http://actions-runner-controller-github-webhook-server.actions-runner-system.svc.cluster.local"
}

resource "azurerm_api_management_api_operation" "internal_org_webhookg" {
  operation_id          = "internal-org-webhook"
  api_name              = azurerm_api_management_api.internal_org_agents_api.name
  api_management_name   = azurerm_api_management_api.internal_org_agents_api.api_management_name
  resource_group_name   = azurerm_api_management_api.internal_org_agents_api.resource_group_name
  display_name          = "Forward Request"
  method                = "*"
  url_template          = "/org/*"
  description           = "This can only be done by the logged in user."
}

resource "azurerm_api_management_gateway_api" "internal_api" {
  gateway_id = data.azurerm_api_management_gateway.agents_internal_gateway.id
  api_id     = azurerm_api_management_api.internal_org_agents_api.id
}