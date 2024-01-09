output "name" {
  value = hcloud_ssh_key.this.name
}

output "path" {
  value = module.ssh-keypair-generator.private_key.filename
}
