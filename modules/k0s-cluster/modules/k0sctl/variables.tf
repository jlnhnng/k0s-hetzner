variable "cluster_name" {
  type = string
  default = "cluster"
}

variable "external_ip" {
  type = string
}

variable "external_hostname" {
  type = string
  default = ""
}

variable "k0s_version" {
  type = string
  default = "v1.28.4+k0s.0"
}

variable "cluster_cidr" {
  type = string
}

variable "network_cidr_blocks" {
  type = any
}