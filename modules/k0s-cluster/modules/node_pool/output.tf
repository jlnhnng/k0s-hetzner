output "nodes" {
  value = [for pool in hcloud_server.node : pool ]
}
