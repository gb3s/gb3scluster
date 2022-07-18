variable "cluster" {
    description = "Cluster Details"
    type = object({
      name = string
      id = string
      location = string
    })
}

variable "admin_user" {
    type = string
}

variable "network" {
    type = object({
        name  = string
        group = string
        id    = string
    })
}

variable "current" {
  
}

variable "cluster_identity" {
  
}