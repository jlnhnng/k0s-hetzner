variable "cluster_name" {
  type        = string
  default     = "cluster"
  description = "Cluster name"
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

variable "name_prefix" {
  type = string
  default = ""
}

variable "hcloud_api_token" {
  type = string
}