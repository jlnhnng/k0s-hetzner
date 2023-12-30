output "key_name" {
  value = hcloud_ssh_key.this.name
}

output "key_path" {
  value = module.ssh-keypair-generator.private_key.filename
}
