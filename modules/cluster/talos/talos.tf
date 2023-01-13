locals {
  cluster_endpoint = format("https://%s.%s:6443", var.cluster_name, var.domain)
}

resource "talos_machine_secrets" "machine_secrets" {}

resource "talos_machine_configuration_controlplane" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_machine_configuration_worker" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

resource "talos_client_configuration" "talosconfig" {
  cluster_name    = var.cluster_name
  machine_secrets = talos_machine_secrets.machine_secrets.machine_secrets
  endpoints       = var.controlplanes
}

resource "local_sensitive_file" "talosconfig" {
  content = talos_client_configuration.talosconfig.talos_config
  filename = "/root/.talos/config"
  file_permission = "0755"
}

resource "local_sensitive_file" "machineconfig_worker" {
  content = talos_machine_configuration_worker.machineconfig_worker.machine_config
  filename = "/root/machineconfig_worker"
  file_permission = "0755"
}

resource "local_sensitive_file" "machineconfig_controlplane" {
  content = talos_machine_configuration_controlplane.machineconfig_cp.machine_config
  filename = "/root/machineconfig_controlplane"
  file_permission = "0755"
}
