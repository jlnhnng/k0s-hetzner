resource "k0s_cluster" "cluster" {
  name = var.cluster_name
  version = var.k0s_version
  concurrency = 3

  hosts = [for node in var.cluster_nodes : {
    role = node.labels.role
    ssh = {
      address = node.ipv4_address
      port = 22
      user = "root"
      bastion = {
        address = var.bastion_node.ipv4_address
        port = 22
        user = "root"
        keyPath = var.ssh_key_path
      }
    }
    privateAddress = node.labels.ip_private
    installFlags = "--kubelet-extra-args=--cloud-provider=external"
    }]

  config = templatefile("${path.module}/../../templates/cluster-config.yaml.tpl", {
    external_ip = var.external_ip
    external_hostname = var.external_hostname
    pod_cidr = var.cluster_cidr
    service_cidr = lookup(var.network_cidr_blocks, "services", "1.0.0.0/24")
  })
}

resource "local_file" "k0sctl_config" {
  filename = "${path.root}/dist/k0sctl_config.yaml"

  content =  templatefile(
    "${path.module}/../../templates/cluster.yaml.tpl", {
      cluster_name = var.cluster_name
      k0s_version = var.k0s_version

      hosts = ""

      cluster_config = templatefile("${path.module}/../../templates/cluster-config.yaml.tpl", {
        external_ip = var.external_ip
        external_hostname = var.external_hostname
        pod_cidr = var.cluster_cidr
        service_cidr = lookup(var.network_cidr_blocks, "services", "1.0.0.0/16")
      })
  })
}

# resource "k0s_cluster" "cluster" {

#   name = var.name
#   version = var.k0s_version

#   hosts = [for node in var.cluster_nodes.servers : {
#     role = node.labels.role
#     ssh = {
#       address = node.ipv4_address
#       port = 22
#       user = "root"
#       bastion = {
#         address = var.bastion_node.ipv4_address
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
