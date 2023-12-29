variable "name_prefix" {
  type = string
  default = "k0s"
}

variable "zone" {
  type = string
  default = "eu-central"
}

variable "cluster_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnets" {
  type = map(object({
    type = string
    new_bits = number
  }))
  default = {
    "infrastructure" = {
      type = "cloud"
      new_bits = 8
    }
    "services" = {
      type = "cloud"
      new_bits = 8
    }
  }
}