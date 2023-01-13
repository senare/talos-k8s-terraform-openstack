terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../modules//cluster/cluster"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  router_id = dependency.network.outputs.router_id
  subnet_pool_id = dependency.network.outputs.subnet_pool_id
}
