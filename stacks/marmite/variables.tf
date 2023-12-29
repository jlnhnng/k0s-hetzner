variable "hcloud_api_token" {
  description = "Hetzner API token"
  type        = string
}

variable "cluster_name" {
  type = string
  default = "cluster"
  description = "Cluster name. It will ne used for prefixing resources names."
}