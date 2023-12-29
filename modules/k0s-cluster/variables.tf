variable "cluster_name" {
  type        = string
  default     = "cluster"
  description = "Cluster name"
}

variable "ssh_keys" {
  type        = list(string)
  default     = []
  description = "List of SSH key names"
}

variable "node_pools" {
  type = map(object({
    server_type     = string
    image           = string
    prefix          = string
    num_nodes       = number
    role            = string
    cidrhost_prefix = number
  }))

  default = {}
}

variable "external_hostname" {
  type = string
}
