resource "azurerm_user_assigned_identity" "apim_id" {
  resource_group_name = var.cluster_group
  location            = var.location

  name = "${var.cluster_name}-apim"
}

resource "azurerm_subnet" "apimnet" {
  name = "external-apim"
  resource_group_name  = var.network.group
  virtual_network_name = var.network.name
  address_prefixes     = [ "10.0.2.0/26" ]
}

resource "azurerm_role_assignment" "keyvault_role_assignment" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.apim_id.principal_id
}

resource "azurerm_role_assignment" "system_keyvault_role_assignment" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_api_management.apim.identity[0].principal_id
}

resource "azurerm_api_management" "apim" {
  name                 = "${var.cluster_name}-apim"
  location             = var.location
  resource_group_name  = var.cluster_group
  publisher_name       = "GB3s Org"
  publisher_email      = "geborgeson@gmail.com"
  virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = azurerm_subnet.apimnet.id
  }

  sku_name = "Developer_1"

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.apim_id.id ]
  }
}

resource "azurerm_api_management_gateway" "cluster_internal" {
  name              = "${var.cluster_name}-internal-gateway"
  api_management_id = azurerm_api_management.apim.id
  description       = "GB3s API Management gateway"

  location_data {
    name     = "GB3s cluster"
  }
}

resource "azurerm_key_vault_certificate" "gb3s_cert" {
  name         = "gb3s-certificate"
  key_vault_id = var.keyvault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=agents.gbabes.org"
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [
          "agents.gbabes.org",
        ]
      }
    }
  }
}

resource "azurerm_api_management_custom_domain" "gb3s_domain" {
  api_management_id = azurerm_api_management.apim.id

  gateway {
    host_name    = "agents.gbabes.org"
    key_vault_id = azurerm_key_vault_certificate.gb3s_cert.secret_id
  }
}

