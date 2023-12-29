terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.44.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.1"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }

  required_version = "~> 1.5"
}
