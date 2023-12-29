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
  nodepool = each.key
  subnets  = module.network.subnets
  cidrhost_prefix = each.value.cidrhost_prefix
}

module "load_balancer" {
  source = "../../modules/k0s/load_balancer"
}

module "cluster" {
  source = "../../modules/k0s/cluster"

  name = var.cluster_name
  external_address = module.load_balancer.ip

  depends_on = [module.nodepools]
}