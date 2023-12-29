variable "spec" {
  type = object({
    server_type     = string
    image           = string
    num_nodes        = number
    role            = string
    cidrhost_prefix = number
    name            = string
  })
}
variable "location" {
  type        = string
  default     = "nbg1"
  description = "Node location in zone"
}

variable "ssh_keys" {
  type        = list(string)
  default     = []
  description = "List of SSH key names"
}

variable "ipv6_enabled" {
  type        = bool
  default     = false
  description = "Creates and links an IPv6 public IP to the node"
}

variable "subnet" {
  type    = any
}

variable "cidrhost_prefix" {
  type = number
}

variable "name_prefix" {
  type    = string
  default = "k0s-"
}
