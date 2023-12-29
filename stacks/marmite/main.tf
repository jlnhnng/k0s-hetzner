locals {
  nodepools = {
    "controllers" = {
      server_type = "cx21"
      image       = "ubuntu-22.04"
      prefix      = "controller-0"
      quantity    = 3
      role        = "controller"
      cidrhost_prefix  = 3
    },
    "workers" = {
      server_type = "cpx11"
      image       = "ubuntu-22.04"
      prefix      = "worker-0"
      quantity    = 3
      role        = "worker"
      cidrhost_prefix  = 6
    },
    "bastions" = {
      server_type = "cax11"
      image       = "ubuntu-22.04"
      prefix      = "bastion-0"
      quantity    = 1
      role        = "bastion"
      cidrhost_prefix  = 9
    }
  }
}

module "network" {
  source = "../../modules/k0s/network"
  name = var.cluster_name
}

module "nodepools" {
  for_each = tomap(local.nodepools)

  source = "../../modules/k0s/nodepool"

  role     = each.value.role
  image    = each.value.image
  prefix   = each.value.prefix
  quantity = each.value.quantity
  network  = module.network.id
  nodepool = each.key
  subnets  = module.network.subnets
  cidrhost_prefix = each.value.cidrhost_prefix
}

module "cluster" {
  source = "../../modules/k0s/cluster"

  name = var.cluster_name
  # load_balancer = module.load_balancers.loadx_balancer

  depends_on = [module.nodepools]
}