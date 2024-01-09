module "subnets" {
  source  = "git::https://github.com/hashicorp/terraform-cidr-subnets?ref=52ca061aaea2e8f58c91ac03ca1fae45e44c28bf" # 1.0.0
  base_cidr_block = var.cluster_cidr
  networks = [for k,v in var.subnets : {
    name = k
    new_bits = v.new_bits
  }]
}

resource "hcloud_network" "network" {
  name = "${var.name_prefix}-network"
  ip_range = var.cluster_cidr
}

resource "hcloud_network_subnet" "subnets" {
  for_each = var.subnets

  type = each.value.type
  network_zone = var.zone
  ip_range   = module.subnets.network_cidr_blocks[each.key]

  network_id = hcloud_network.network.id
}