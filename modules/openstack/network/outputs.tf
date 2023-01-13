output "network_uuid" {
  value = openstack_networking_network_v2.network.id
}

output "subnet_uuid" {
  value = openstack_networking_subnet_v2.subnet.id
}