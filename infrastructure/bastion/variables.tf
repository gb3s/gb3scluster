variable "cluster_name" {
    type = string
}
variable "location" {
    type = string
}
variable "network" {
    type = object({
        group = string
        name  = string
    })
}