resource "talos_machine_configuration_apply" "cp_config_apply" {
  talos_config          = var.talosconfig
  machine_configuration = var.machineconfig_controlplane
  for_each              = var.controlplanes
  endpoint              = each.value
  node                  = each.value
}

resource "talos_machine_configuration_apply" "worker_config_apply" {
  talos_config          = var.talosconfig
  machine_configuration = var.machineconfig_worker
  for_each              = var.workers
  endpoint              = each.value
  node                  = each.value
}

locals {
  ip = tolist(var.controlplanes)[0]
}

resource "talos_machine_bootstrap" "bootstrap" {
  talos_config = var.talosconfig
  endpoint     = local.ip
  node         = local.ip
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  talos_config = var.talosconfig
  endpoint     = local.ip
  node         = local.ip
}

resource "local_sensitive_file" "kubeconfig" {
  content = talos_cluster_kubeconfig.kubeconfig.kube_config
  filename = "/root/.kube/config"
  file_permission = "0755"
}