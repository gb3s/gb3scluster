variable "cluster_name" {
    type = string
}

variable "location" {
    type = string
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