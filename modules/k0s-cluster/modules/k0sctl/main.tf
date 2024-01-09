resource "k0sctl_config" "cluster" {
  metadata {
    name = var.cluster_name
  }

  spec {
    dynamic "host" {
      for_each = var.cluster_nodes
      content {
        role = host.value.labels.role
        ssh {
          address = host.value.ipv4_address
          key_path = var.ssh_key_path
          port = 22
          user = "root"
        }
      }
    }

    k0s {
      version = var.k0s_version
      config = templatefile("${path.module}/../../templates/cluster-config.yaml.tpl", {
        external_ip = var.external_ip
        external_hostname = var.external_hostname
        pod_cidr = var.cluster_cidr
        service_cidr = lookup(var.network_cidr_blocks, "services", "1.0.0.0/16")
      })
    }
  }
}
