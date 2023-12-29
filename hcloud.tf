

resource "hcloud_server" "controller0" {
    name = "controller0"
    image = var.image
    server_type = var.controller_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "controller"
    }
}

resource "hcloud_server" "controller1" {
    name = "controller1"
    image = var.image
    server_type = var.controller_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "controller"
    }
}

resource "hcloud_server" "controller2" {
    name = "controller2"
    image = var.image
    server_type = var.controller_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "controller"
    }
} 

resource "hcloud_server" "worker0" {
    name = "worker0"
    image = var.image
    server_type = var.worker_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "worker"
    }
}

resource "hcloud_server" "worker1" {
    name = "worker1"
    image = var.image
    server_type = var.worker_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "worker"
    }
}

resource "hcloud_server" "worker2" {
    name = "worker2"
    image = var.image
    server_type = var.worker_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "worker"
    }
}

resource "hcloud_server" "bastionhost" {
    name = "bastionhost"
    image = var.image
    server_type = var.bastion_type
    location = var.location
    ssh_keys = var.ssh_keys
    user_data = templatefile("${path.root}/templates/cloud-init.yaml.tpl", {})
    public_net {
      ipv6_enabled = var.ipv6_enabled
    }
    labels = {
        role = "bastion"
    }
}

resource "hcloud_network" "cloud" {
    name = "cloud"
    ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "servers" {
  network_id = hcloud_network.cloud.id
  type = "cloud"
  network_zone = var.network_zone
  ip_range   = "10.0.1.0/24"
}

resource "hcloud_server_network" "controller0-network" {
  server_id = hcloud_server.controller0.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.1"
}
resource "hcloud_server_network" "controller1-network" {
  server_id = hcloud_server.controller1.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.2"
}
resource "hcloud_server_network" "controller2-network" {
  server_id = hcloud_server.controller2.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.3"
}
resource "hcloud_server_network" "worker0-network" {
  server_id = hcloud_server.worker0.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.10"
}
resource "hcloud_server_network" "worker1-network" {
  server_id = hcloud_server.worker1.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.11"
}
resource "hcloud_server_network" "worker2-network" {
  server_id = hcloud_server.worker2.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.12"
}

resource "hcloud_server_network" "bastionhost-network" {
  server_id = hcloud_server.bastionhost.id
  subnet_id = hcloud_network_subnet.servers.id
  ip = "10.0.1.20"
}

resource "hcloud_load_balancer" "k0s_load_balancer" {
  name       = "k0s-load-balancer"
  load_balancer_type = "lb11"
  location   = var.location
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
  label_selector = "role=controller"
}

resource "hcloud_load_balancer_service" "load_balancer_service_6443" {
    load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
    protocol = "tcp"
    listen_port = 6443
    destination_port = 6443
}

resource "hcloud_load_balancer_service" "load_balancer_service_9443" {
    load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
    protocol = "tcp"
    listen_port = 9443
    destination_port = 9443
}

resource "hcloud_load_balancer_service" "load_balancer_service_8132" {
    load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
    protocol = "tcp"
    listen_port = 8132
    destination_port = 8132
}

resource "local_file" "k0ctl-yaml" {
  content = templatefile("${path.root}/templates/k0sctl.yaml.tpl", {
    public-bastionhost-address = hcloud_server.bastionhost.ipv4_address,
    loadbalancer-address = hcloud_load_balancer.k0s_load_balancer.ipv4
  })
  filename = "${path.root}/var/k0sctl.yaml"
}

resource "local_file" "hcloud-secret" {
  content = templatefile("${path.root}/templates/hetzner/hcloud-secret.yaml.tpl", {
    hcloud_token = var.hcloud_token
    network = hcloud_network.cloud.id
  })
  filename = "${path.root}/var/hetzner/hcloud-secret.yaml"
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
    value = hcloud_load_balancer.k0s_load_balancer.ipv4
}