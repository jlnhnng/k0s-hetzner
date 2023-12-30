locals {
  key_name = "${var.name_prefix}-cluster"
}

module "ssh-keypair-generator" {
  source  = "jd4883/ssh-keypair-generator/hashicorp"
  version = "1.0.0"

  key_name = local.key_name
}

resource "hcloud_ssh_key" "this" {
  name = "${var.name_prefix}-cluster"
  public_key = module.ssh-keypair-generator.public_key.content
}
