variable "cluster_name" {
    type = string
}

variable "location" {
    type = string
}

variable "admin_user" {
    type = string
}

variable "keyvault_id" {
    type = string
}

variable "network" {
  description = "Values for Subnets, and network resources"
  type = object({
    id = string 
    name = string
    group = string
  })
}

variable "subscription_id" {
}