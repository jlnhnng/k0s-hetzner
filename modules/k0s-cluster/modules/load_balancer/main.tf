# resource "hcloud_load_balancer" "k0s_load_balancer" {
#   name               = var.name
#   load_balancer_type = var.load_balancer_type
#   location           = var.location
# }

# resource "hcloud_load_balancer_target" "load_balancer_target" {
#   type             = "label_selector"
#   load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
#   label_selector   = "role=controller"
# }

# resource "hcloud_load_balancer_service" "load_balancer_service_6443" {
#   load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
#   protocol         = "tcp"
#   listen_port      = 6443
#   destination_port = 6443
# }

# resource "hcloud_load_balancer_service" "load_balancer_service_9443" {
#   load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
#   protocol         = "tcp"
#   listen_port      = 9443
#   destination_port = 9443
# }

# resource "hcloud_load_balancer_service" "load_balancer_service_8132" {
#   load_balancer_id = hcloud_load_balancer.k0s_load_balancer.id
#   protocol         = "tcp"
#   listen_port      = 8132
#   destination_port = 8132
# }
