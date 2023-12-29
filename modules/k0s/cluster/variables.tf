variable "name" {
  type = string
  default = "cluster"
  description = "Cluster name"
}

# variable "load_balancer" {
#   type = map(any)
# }

variable "k0s_version" {
  type = string
  default = "v1.28.4+k0s.0"
}