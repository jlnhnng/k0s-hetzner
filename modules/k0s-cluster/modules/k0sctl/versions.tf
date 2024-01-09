terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.44.1"
    }
    k0sctl = {
      source = "Mirantis/k0sctl"
      version = "0.0.2"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.1"
    }
  }
}


