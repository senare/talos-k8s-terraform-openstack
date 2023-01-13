resource "openstack_networking_port_v2" "talos_control_plane" {
  count = var.control_plane_number

  name       = "talos-control-plane-${count.index}"
  network_id = var.network_uuid
  security_group_ids = [
    openstack_networking_secgroup_v2.talos_external["control_plane"].id,
    openstack_networking_secgroup_v2.talos_allow_internal.id,
  ]

  fixed_ip {
    subnet_id = var.subnet_uuid
  }
}

resource "openstack_networking_port_v2" "talos_worker" {
  count = var.worker_number

  name       = "talos-worker-${count.index}"
  network_id = var.network_uuid
  security_group_ids = [
    openstack_networking_secgroup_v2.talos_external["worker"].id,
    openstack_networking_secgroup_v2.talos_allow_internal.id,
  ]

  fixed_ip {
    subnet_id = var.subnet_uuid
  }
}

resource "openstack_networking_floatingip_v2" "talos_control_plane" {
  count   = var.use_fip == true ? var.control_plane_number : 0
  pool    = var.external_network_name
  port_id = openstack_networking_port_v2.talos_control_plane[count.index].id
}

resource "openstack_networking_floatingip_v2" "talos_worker" {
  count   = var.use_fip == true ? var.worker_number : 0
  pool    = var.external_network_name
  port_id = openstack_networking_port_v2.talos_worker[count.index].id
}

resource "openstack_compute_instance_v2" "talos_control_plane" {
  count = var.control_plane_number

  name        = "talos-control-plane-${count.index}"
  flavor_name = var.control_plane_flavor
  image_id    = var.image_uuid

  network {
    port = openstack_networking_port_v2.talos_control_plane[count.index].id
  }
}

resource "openstack_compute_instance_v2" "talos_worker" {
  count = var.worker_number

  name        = "talos-worker-${count.index}"
  flavor_name = var.worker_flavor
  image_id    = var.image_uuid

  network {
    port = openstack_networking_port_v2.talos_worker[count.index].id
  }
}
