module "marmite" {
  source = "../../../modules/k0s-cluster"

  cluster_name      = "marmite"
  external_hostname = "marmite.pastis-hosting.net"

  hcloud_api_token = var.hcloud_api_token

  node_pools = {
    "controllers" = {
      server_type     = "cpx11"
      image           = "ubuntu-22.04"
      prefix          = "controller-0"
      num_nodes       = 1
      role            = "controller"
      cidrhost_prefix = 3
    },
    "workers" = {
      server_type     = "cpx11"
      image           = "ubuntu-22.04"
      prefix          = "worker-0"
      num_nodes       = 2
      role            = "worker"
      cidrhost_prefix = 6
    },
    "bastions" = {
      server_type     = "cax11"
      image           = "ubuntu-22.04"
      prefix          = "bastion-0"
      num_nodes       = 1
      role            = "bastion"
      cidrhost_prefix = 9
    }
  }
}