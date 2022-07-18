variable "current" {}

variable "cluster" {
    description = "Cluster Details"
    type = object({
      name = string
      id = string
      location = string
    })
}

variable "network" {
    type = object({
        name  = string
        group = string
        id    = string
    })
}

