locals {
  index = var.router_id != null ? 1 : 0
}

module "network_cluster" {
  count = local.index

  providers = {
    openstack = openstack
  }

  source = "../../openstack/network"

  environment = var.environment
  name = "talos"
  router_id = var.router_id
  subnet_pool_id = var.subnet_pool_id
}

module "compute_cluster" {
  providers = {
    openstack = openstack
  }

  depends_on = [module.network_cluster]

  source = "../compute"

  network_uuid  = var.network_uuid != null ? var.network_uuid : element(module.network_cluster, local.index).network_uuid
  subnet_uuid   = var.subnet_uuid != null ? var.subnet_uuid : element(module.network_cluster, local.index).subnet_uuid

  image_uuid = var.image_uuid
  control_plane_flavor = var.control_plane_flavor
  worker_flavor = var.worker_flavor
  use_fip = var.use_fip

  environment = var.environment
  external_network_name = var.external_network_name
  external_network_id = var.external_network_id
}

module "talos_cluster" {
  providers = {
    openstack = openstack
  }

  depends_on = [module.compute_cluster]
  source = "../talos"

  cluster_name = var.cluster_name
  domain = var.domain
  controlplanes = module.compute_cluster.controlplanes
  workers = module.compute_cluster.workers
}