variable "hcloud_token" {
  description = "Hetzner API token"
}

provider "hcloud" {
  token = var.hcloud_token
}

variable "ssh_key" {
  default = []
}

variable "location" {
  default = "fsn1"
}

variable "image" {
  default = "ubuntu-24.04"
}

variable "controller_type" {
  default = "cx22"
}

variable "worker_type" {
  default = "cx22"
}

variable "network_zone" {
  default = "eu-central"
}

variable "controller_count" {
  description = "Number of controller servers"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of worker servers"
  type        = number
  default     = 3
}

variable "k0s_version" {
  description = "The k0s version to deploy"
  type        = string
  default     = "1.32.1+k0s.0"
}

resource "hcloud_server" "controller" {
  count       = var.controller_count
  name        = "controller${count.index}"
  image       = var.image
  server_type = var.controller_type
  location    = var.location
  ssh_keys    = var.ssh_key
  user_data   = file("cloudinit/cloud-init.yaml.cfg")
  labels = {
    role = "controller"
  }
}

resource "hcloud_server" "worker" {
  count       = var.worker_count
  name        = "worker${count.index}"
  image       = var.image
  server_type = var.worker_type
  location    = var.location
  ssh_keys    = var.ssh_key
  user_data   = file("cloudinit/cloud-init.yaml.cfg")
  labels = {
    role = "worker"
  }
}

resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = "10.250.0.0/24"
}

resource "hcloud_server_network" "controller_network" {
  count     = var.controller_count
  server_id = hcloud_server.controller[count.index].id
  subnet_id = hcloud_network_subnet.subnet.id
  ip        = format("10.250.0.%d", 100 + count.index)
}

resource "hcloud_server_network" "worker_network" {
  count     = var.worker_count
  server_id = hcloud_server.worker[count.index].id
  subnet_id = hcloud_network_subnet.subnet.id
  ip        = format("10.250.0.%d", 200 + count.index)
}

resource "hcloud_load_balancer" "k0s_load_balancer" {
  name               = "k0s-load-balancer"
  load_balancer_type = "lb11"
  location           = var.location
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
  label_selector   = "role=controller"
}

resource "hcloud_load_balancer_service" "load_balancer_service_6443" {
  load_balancer_id  = hcloud_load_balancer.k0s_load_balancer.id
  protocol          = "tcp"
  listen_port       = 6443
  destination_port  = 6443
}

resource "hcloud_load_balancer_service" "load_balancer_service_9443" {
  load_balancer_id  = hcloud_load_balancer.k0s_load_balancer.id
  protocol          = "tcp"
  listen_port       = 9443
  destination_port  = 9443
}

resource "hcloud_load_balancer_service" "load_balancer_service_8132" {
  load_balancer_id  = hcloud_load_balancer.k0s_load_balancer.id
  protocol          = "tcp"
  listen_port       = 8132
  destination_port  = 8132
}

locals {
  controller_external_ips = [
    for s in hcloud_server.controller : s.ipv4_address
  ]
  controller_internal_ips = [
    for net in hcloud_server_network.controller_network : net.ip
  ]
  worker_external_ips = [
    for s in hcloud_server.worker : s.ipv4_address
  ]
  worker_internal_ips = [
    for net in hcloud_server_network.worker_network : net.ip
  ]

  k0sctl_config = templatefile("${path.module}/k0sctl.tpl.yaml", {
    controller_external_ips = local.controller_external_ips
    controller_internal_ips = local.controller_internal_ips
    worker_external_ips     = local.worker_external_ips
    worker_internal_ips     = local.worker_internal_ips
    loadbalancer_ip         = hcloud_load_balancer.k0s_load_balancer.ipv4
    k0s_version             = var.k0s_version
  })
}


resource "local_file" "k0sctl_config" {
  content  = local.k0sctl_config
  filename = "${path.module}/k0sctl.yaml"
}

output "controller_ips" {
  value = [for s in hcloud_server.controller : s.ipv4_address]
}

output "worker_ips" {
  value = [for s in hcloud_server.worker : s.ipv4_address]
}

output "k0s_load_balancer_ip" {
  value = hcloud_load_balancer.k0s_load_balancer.ipv4
}
