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
        group = string
        name  = string
    })
}