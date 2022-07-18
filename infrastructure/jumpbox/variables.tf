variable "cluster_name" {
    type = string
}

variable "location" {
    type = string
}

variable "admin_user" {
    type = string
}

variable "bast_access_group" {
    type = object({
        name = string
        location = string
    })
}

variable "network" {
    type = object({
        group = string
        name  = string
    })
}