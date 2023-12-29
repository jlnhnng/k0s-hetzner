variable "name" {
  type = string
  default = "cloud"
  description = "Network name"
}

variable "zone" {
  type = string
  default = "eu-central"
  description = "Network zone"
}

variable "cluster_cidr" {
  type = string
  default = "10.0.0.0/16"
  description = "Network IP range"
}

variable "subnets" {
  type = map(object({
    type = string
    new_bits = number
  }))
  default = {
    "cloud" = {
      type = "cloud"
      new_bits = 8
    }
  }
  description = "Network subnets"
}