variable "keyvault_id" {
  
}

variable "cluster_group" {
  
}

variable "cluster_name" {
  
}

variable "location" {
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