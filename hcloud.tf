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
    default = "ubuntu-18.04"
}

variable "controller_type" {
    default = "cx21"
}

variable "worker_type" {
    default = "cx21"
}

variable "bastion_type" {
    default = "cx11"
}

variable "network_zone" {
    default = "eu-central"
}

data "template_file" "cloudinit" {
    template = file("cloudinit/cloud-init.yaml.cfg")
}

resource "hcloud_server" "controller0" {
    name = "controller0"
    image = var.image
    server_type = var.controller_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "controller"
    }
}

resource "hcloud_server" "controller1" {
    name = "controller1"
    image = var.image
    server_type = var.controller_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "controller"
    }
}

resource "hcloud_server" "controller2" {
    name = "controller2"
    image = var.image
    server_type = var.controller_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "controller"
    }
} 

resource "hcloud_server" "worker0" {
    name = "worker0"
    image = var.image
    server_type = var.worker_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "worker"
    }
}

resource "hcloud_server" "worker1" {
    name = "worker1"
    image = var.image
    server_type = var.worker_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "worker"
    }
}

resource "hcloud_server" "worker2" {
    name = "worker2"
    image = var.image
    server_type = var.worker_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "worker"
    }
}

resource "hcloud_server" "bastionhost" {
    name = "bastionhost"
    image = var.image
    server_type = var.bastion_type
    location = var.location
    ssh_keys = var.ssh_key
    user_data = data.template_file.cloudinit.rendered
    labels = {
        role = "bastion"
    }
}

resource "hcloud_network" "network" {
    name = "network"
    ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "subnet" {
  network_id = hcloud_network.network.id
  type = "cloud"
  network_zone = var.network_zone
  ip_range   = "10.250.0.0/24"
}

resource "hcloud_server_network" "controller0-network" {
  server_id = hcloud_server.controller0.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.100"
}
resource "hcloud_server_network" "controller1-network" {
  server_id = hcloud_server.controller1.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.101"
}
resource "hcloud_server_network" "controller2-network" {
  server_id = hcloud_server.controller2.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.102"
}
resource "hcloud_server_network" "worker0-network" {
  server_id = hcloud_server.worker0.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.200"
}
resource "hcloud_server_network" "worker1-network" {
  server_id = hcloud_server.worker1.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.201"
}
resource "hcloud_server_network" "worker2-network" {
  server_id = hcloud_server.worker2.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.202"
}

resource "hcloud_server_network" "bastionhost-network" {
  server_id = hcloud_server.bastionhost.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.250.0.50"
}

resource "hcloud_load_balancer" "k0s_load_balancer" {
  name       = "k0s-load-balancer"
  load_balancer_type = "lb11"
  location   = var.location
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  label_selector = "role=controller"
}

resource "hcloud_load_balancer_service" "load_balancer_service_6443" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol = "tcp"
    listen_port = 6443
    destination_port = 6443
}

resource "hcloud_load_balancer_service" "load_balancer_service_9443" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol = "tcp"
    listen_port = 9443
    destination_port = 9443
}

resource "hcloud_load_balancer_service" "load_balancer_service_8132" {
    load_balancer_id = hcloud_load_balancer.load_balancer.id
    protocol = "tcp"
    listen_port = 8132
    destination_port = 8132
}

output "server_ip_controller0" {
    value = hcloud_server.controller0.ipv4_address
}
output "server_ip_controller1" {
    value = hcloud_server.controller1.ipv4_address
}
output "server_ip_controller2" {
    value = hcloud_server.controller2.ipv4_address
}
output "server_ip_worker0" {
    value = hcloud_server.worker0.ipv4_address
}
output "server_ip_worker1" {
    value = hcloud_server.worker1.ipv4_address
}
output "server_ip_worker2" {
    value = hcloud_server.worker2.ipv4_address
}
output "server_ip_bastionhost" {
    value = hcloud_server.bastionhost.ipv4_address
}
output "k0s_load_balancer_ip" {
    value = hcloud_load_balancer.k0s_load_balancer.ipv4_address
}