data "hcloud_server_type" "node" {
  name = var.spec.server_type
}

data "hcloud_image" "node" {
  name              = var.spec.image
  with_architecture = data.hcloud_server_type.node.architecture
}

resource "hcloud_server" "node" {
  count = var.spec.num_nodes

  # Common to all node_pools
  location    = var.location
  ssh_keys    = [ var.ssh_key_name ]
  user_data   = file("${path.module}/../../templates/cloud-init.yaml")

  public_net { ipv6_enabled = var.ipv6_enabled }

  # Node pool specification
  name        = "${var.name_prefix}-${var.spec.name}-0${count.index + 1}"
  image       = data.hcloud_image.node.name
  server_type = var.spec.server_type

  labels      = {
    role = var.spec.role,
    nodepool = var.spec.name,
    ip_private = cidrhost(var.subnet.ip_range, format("%d%d", var.spec.cidrhost_prefix, count.index + 1))
  }
}

resource "hcloud_server_network" "node" {
  count = var.spec.num_nodes

  server_id = hcloud_server.node[count.index].id
  subnet_id = var.subnet.id

  ip = hcloud_server.node[count.index].labels.ip_private
}

