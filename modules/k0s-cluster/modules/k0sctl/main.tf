data "hcloud_server" "bastion" {
  with_selector = "role=bastion"
}

data "hcloud_servers" "cluster_nodes" {
  with_selector = "role in (controller, worker)"
}

resource "k0s_cluster" "cluster" {
  name = var.cluster_name
  version = var.k0s_version
  concurrency = 3

  hosts = [for node in data.hcloud_servers.cluster_nodes.servers : {
    role = node.labels.role
    ssh = {
      address = node.ipv4_address
      port = 22
      user = "root"
      bastion = {
        address = data.hcloud_server.bastion.ipv4_address
        port = 22
        user = "root"
        keyPath = "~/.ssh/id_rsa"
      }
      privateAddress = node.labels.ip_private
      installFlags = "--kubelet-extra-args=--cloud-provider=external"
    }
  }]

  config = templatefile("${path.module}/../templates/cluster-config.yaml.tpl", {
    external_ip = var.external_ip
    external_hostname = var.external_hostname
    pod_cidr = var.cluster_cidr
    service_cidr = lookup(var.network_cidr_blocks, "service")
  })
}

# resource "k0s_cluster" "cluster" {
#   name = var.name
#   version = var.k0s_version

#   hosts = [for node in data.hcloud_servers.cluster_nodes.servers : {
#     role = node.labels.role
#     ssh = {
#       address = node.ipv4_address
#       port = 22
#       user = "root"
#       bastion = {
#         address = data.hcloud_server.bastion.ipv4_address
#         port = 22
#         user = "root"
#         keyPath = "~/.ssh/id_rsa"
#       }
#       privateAddress = node.labels.ip_private
#       installFlags = "--kubelet-extra-args=--cloud-provider=external"
#     }
#   }]

  # config = templatefile("${path.module}/../templates/cluster-config.yaml.tpl", {
  #   external_ip = var.external_ip
  #   external_hostname = var.external_hostname
  #   pod_cidr = var.cluster_cidr
  #   service_cidr = lookup(var.network_cidr_blocks, "service")
  # })
# }
