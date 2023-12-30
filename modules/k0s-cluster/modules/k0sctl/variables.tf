variable "cluster_name" {
  type = string
  default = "cluster"
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
  default = "1.0.0.0/16"
}

variable "network_cidr_blocks" {
  type = any
  default = {}
}

variable "external_ip" {
  type = string
  default = ""
}

variable "bastion_node" {
  type = any
}

variable "cluster_nodes" {
  type = any
}

variable "ssh_key_path" {
  type = string
}