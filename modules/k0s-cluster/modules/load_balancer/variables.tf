variable "location" {
  type = string
  default = "nbg1"
  description = "Node location in zone"
}

variable "load_balancer_type" {
  type = string
  default = "lb11"
  description = "Load Balancer type"
}

variable "name" {
  type = string
  default = "k0s-load-balancer"
}