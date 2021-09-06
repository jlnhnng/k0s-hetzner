variable "hcloud_token" {}

provider "hcloud" {
    token = var.hcloud_token
}

data "hcloud_ssh_key" "default" {
    fingerprint = "XXX"
}

data "template_file" "cloudinit" {
    template = file("cloudinit/cloud-init.yaml.cfg")
}

resource "hcloud_server" "manager0" {
    name = "manager0"
    image = "ubuntu-18.04"
    server_type = "cx41"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
}

resource "hcloud_server" "manager1" {
    name = "manager1"
    image = "ubuntu-18.04"
    server_type = "cx41"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
}

resource "hcloud_server" "manager2" {
    name = "manager2"
    image = "ubuntu-18.04"
    server_type = "cx41"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
} 

resource "hcloud_server" "worker0" {
    name = "worker0"
    image = "ubuntu-18.04"
    server_type = "cx51"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
}
resource "hcloud_volume" "worker0volume1" {
  name = "worker0volume1"
  size = 55
  server_id = hcloud_server.worker0.id
  automount = true
  format = "ext4"
}
 resource "hcloud_volume" "worker0volume2" {
  name = "worker0volume2"
  size = 55
  server_id = hcloud_server.worker0.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker0volume3" {
  name = "worker0volume3"
  size = 55
  server_id = hcloud_server.worker0.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker0volume4" {
  name = "worker0volume4"
  size = 55
  server_id = hcloud_server.worker0.id
  automount = true
  format = "ext4"
}

resource "hcloud_server" "worker1" {
    name = "worker1"
    image = "ubuntu-18.04"
    server_type = "cx51"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
}
resource "hcloud_volume" "worker1volume1" {
  name = "worker1volume1"
  size = 55
  server_id = hcloud_server.worker1.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker1volume2" {
  name = "worker1volume2"
  size = 55
  server_id = hcloud_server.worker1.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker1volume3" {
  name = "worker1volume3"
  size = 55
  server_id = hcloud_server.worker1.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker1volume4" {
  name = "worker1volume4"
  size = 55
  server_id = hcloud_server.worker1.id
  automount = true
  format = "ext4"
}

resource "hcloud_server" "worker2" {
    name = "worker2"
    image = "ubuntu-18.04"
    server_type = "cx51"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
}
resource "hcloud_volume" "worker2volume1" {
  name = "worker2volume1"
  size = 55
  server_id = hcloud_server.worker2.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker2volume2" {
  name = "worker2volume2"
  size = 55
  server_id = hcloud_server.worker2.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker2volume3" {
  name = "worker2volume3"
  size = 55
  server_id = hcloud_server.worker2.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker2volume4" {
  name = "worker2volume4"
  size = 55
  server_id = hcloud_server.worker2.id
  automount = true
  format = "ext4"
}

resource "hcloud_server" "worker3" {
    name = "worker3"
    image = "ubuntu-18.04"
    server_type = "cx51"
    location = "fsn1"
    ssh_keys = [data.hcloud_ssh_key.default.id]
    user_data = data.template_file.cloudinit.rendered
}
resource "hcloud_volume" "worker3volume1" {
  name = "worker3volume1"
  size = 55
  server_id = hcloud_server.worker3.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker3volume2" {
  name = "worker3volume2"
  size = 55
  server_id = hcloud_server.worker3.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker3volume3" {
  name = "worker3volume3"
  size = 55
  server_id = hcloud_server.worker3.id
  automount = true
  format = "ext4"
}
resource "hcloud_volume" "worker3volume4" {
  name = "worker3volume4"
  size = 55
  server_id = hcloud_server.worker3.id
  automount = true
  format = "ext4"
}

resource "hcloud_network" "network" {
    name = "network"
    ip_range = "10.0.0.0/8"
}

resource "hcloud_network_subnet" "subnet" {
  network_id = hcloud_network.network.id
  type = "cloud"
  network_zone = "eu-central"
  ip_range   = "10.240.0.0/24"
}

#Manager Nodes
resource "hcloud_server_network" "manager0-network" {
  server_id = hcloud_server.manager0.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.100"
}
resource "hcloud_server_network" "manager1-network" {
  server_id = hcloud_server.manager1.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.101"
}
resource "hcloud_server_network" "manager2-network" {
  server_id = hcloud_server.manager2.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.102"
}

#Worker Nodes
resource "hcloud_server_network" "worker0-network" {
  server_id = hcloud_server.worker0.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.200"
}
resource "hcloud_server_network" "worker1-network" {
  server_id = hcloud_server.worker1.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.201"
}
resource "hcloud_server_network" "worker2-network" {
  server_id = hcloud_server.worker2.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.202"
}
resource "hcloud_server_network" "worker3-network" {
  server_id = hcloud_server.worker3.id
  subnet_id = hcloud_network_subnet.subnet.id
  ip = "10.240.0.203"
}

output "server_ip_manager0" {
    value = hcloud_server.manager0.ipv4_address
}
output "server_ip_manager1" {
    value = hcloud_server.manager1.ipv4_address
}
output "server_ip_manager2" {
    value = hcloud_server.manager2.ipv4_address
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
output "server_ip_worker3" {
    value = hcloud_server.worker3.ipv4_address
}