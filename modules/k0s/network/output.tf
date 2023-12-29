output "id" {
  value = hcloud_network.network.id
  description = "Network ID"
}

output "cluster_cidr" {
  value = hcloud_network.network.ip_range
}

output "subnets" {
  value = tomap(hcloud_network_subnet.subnets)
}

output "network_cidr_blocks" {
  value = module.subnets.network_cidr_blocks
}