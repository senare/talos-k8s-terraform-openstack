
terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../modules//cluster/bootstrap"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "compute" {
  config_path = "../compute"
}

inputs = {
  controlplanes = dependency.compute.outputs.controlplanes
  workers = dependency.compute.outputs.workers

  machineconfig_controlplane = dependency.compute.outputs.machineconfig_controlplane
  machineconfig_worker = dependency.compute.outputs.machineconfig_worker
  talosconfig = dependency.compute.outputs.talosconfig
}
