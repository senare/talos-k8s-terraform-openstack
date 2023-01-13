resource "openstack_networking_router_v2" "router" {
  count               = var.router_id == null ? 1 : 0
  name                = "router-${var.environment}"
  admin_state_up      = "true"
  external_network_id = var.external_network_id
}

data "openstack_networking_router_v2" "router" {
  count = var.router_id == null ? 0 : 1
  router_id = var.router_id
}

resource "openstack_networking_subnetpool_v2" "subnetpool" {
  name     = "subnetpool"
  prefixes = ["172.16.0.0/16"]
  shared = false
}


