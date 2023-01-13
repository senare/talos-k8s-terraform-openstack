output "dns" {
    value = format("%s.%s", var.cluster_name, var.domain)
}

output "controlplanes" {
  value = module.compute_cluster.controlplanes
}

output "workers" {
  value = module.compute_cluster.workers
}

output "machineconfig_controlplane" {
  sensitive = true
  value     = module.talos_cluster.machineconfig_controlplane
}

output "machineconfig_worker" {
  sensitive = true
  value     = module.talos_cluster.machineconfig_worker
}

output "talosconfig" {
  sensitive = true
  value     = module.talos_cluster.talosconfig
}
