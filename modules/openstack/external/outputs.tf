output "router_id" {
  value = one(var.router_id == null ? openstack_networking_router_v2.router.*.id :  data.openstack_networking_router_v2.router.*.id)
}

output "subnet_pool_name" {
  value = openstack_networking_subnetpool_v2.subnetpool.name
}

output "subnet_pool_id" {
  value = openstack_networking_subnetpool_v2.subnetpool.id
}
