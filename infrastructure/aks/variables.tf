variable "cluster" {
    description = "Cluster Details"
    type = object({
      name = string
      id = string
      location = string
    })
}

variable "cluster_group" {

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

