output "controlplanes" {
  value = var.use_fip == false ? [ for instance in openstack_compute_instance_v2.talos_control_plane : instance.access_ip_v4  ] : [ for fip in openstack_networking_floatingip_v2.talos_control_plane : fip.address ]
}

output "workers" {
  value =   var.use_fip == false ? [ for instance in openstack_compute_instance_v2.talos_worker : instance.access_ip_v4 ] : [ for fip in openstack_networking_floatingip_v2.talos_worker : fip.address ]
}
