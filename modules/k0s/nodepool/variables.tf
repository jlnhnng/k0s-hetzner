variable "server_type" {
  type = string
  default = "cx11"
  description = "Node VM variant"
}

variable "location" {
  type = string
  default = "nbg1"
  description = "Node location in zone"
}

variable "image" {
  type = string
  default = "ubuntu-22.04"
  description = "Node base image"
}

variable "ssh_keys" {
  type = list(string)
  default = []
  description = "List of SSH key names"
}

variable "ipv6_enabled" {
  type = bool
  default = false
  description = "Creates and links an IPv6 public IP to the node"
}

variable "quantity" {
  type = number
  default = 1
  description = "Number of nodes to be generated"
}

variable "role" {
  type = string
  default = "worker"
  description = "Node role in cluster"
}

variable "prefix" {
  type = string
  default = "node-0"
  description = "Node name prefix"
}

variable "nodepool" {
  type = string
  default = ""
}

variable "subnets" {
  type = any
  default = []
  description = "Network subnets"
}

variable "cidrhost_prefix" {
  type = number
  default = "1"
}