resource "openstack_networking_network_v2" "network" {
  name           = "${var.name}-network-${var.environment}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = "${var.name}-subnet-${var.environment}"
  network_id      = openstack_networking_network_v2.network.id
  subnetpool_id   = var.subnet_pool_id
  prefix_length   = 24
  ip_version      = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
}

resource "openstack_networking_router_interface_v2" "port" {
  router_id = var.router_id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}
