
terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../modules//cluster/bootstrap"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "cluster" {
  config_path = "../cluster"
}

inputs = {
  controlplanes = dependency.cluster.outputs.controlplanes
  workers = dependency.cluster.outputs.workers

  machineconfig_controlplane = dependency.cluster.outputs.machineconfig_controlplane
  machineconfig_worker = dependency.cluster.outputs.machineconfig_worker
  talosconfig = dependency.cluster.outputs.talosconfig
}
