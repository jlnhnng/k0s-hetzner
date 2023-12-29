data "hcloud_server_type" "node" {
  name = var.server_type
}

data "hcloud_image" "node" {
  name              = var.image
  with_architecture = data.hcloud_server_type.node.architecture
}

resource "hcloud_server" "node" {
  count = var.quantity

  image       = data.hcloud_image.node.name
  labels      = {
    role = var.role,
    nodepool = var.nodepool,
    ip_private = cidrhost(var.subnets["cloud"].ip_range, format("%d%d", var.cidrhost_prefix, count.index + 1))
  }
  location    = var.location
  name        = "${var.prefix}${count.index + 1}"
  server_type = var.server_type
  ssh_keys    = var.ssh_keys
  user_data   = file("${path.module}/cloud-init.yaml")

  public_net { ipv6_enabled = var.ipv6_enabled }
}

resource "hcloud_server_network" "node" {
  count = var.quantity

  server_id = hcloud_server.node[count.index].id
  subnet_id = var.subnets["cloud"].id
  ip = hcloud_server.node[count.index].labels.ip_private
}
