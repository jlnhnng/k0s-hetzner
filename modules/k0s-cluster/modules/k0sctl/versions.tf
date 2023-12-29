terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.44.1"
    }
    k0s = {
      source = "alessiodionisi/k0s"
      version = "0.2.2"
    }
    k0sctl = {
      source = "Mirantis/k0sctl"
      version = "0.0.2"
    }
  }
  required_version = ">= 0.13"
}


