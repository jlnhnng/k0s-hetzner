variable "name" {
  type = string
  default = "cluster"
  description = "Cluster name"
}

variable "external_address" {
  type = string
}

variable "k0s_version" {
  type = string
  default = "v1.28.4+k0s.0"
}