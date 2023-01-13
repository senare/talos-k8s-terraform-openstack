terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../modules//cluster/cluster"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "external" {
  config_path = "../external"
}

inputs = {
  router_id = dependency.external.outputs.router_id
  subnet_pool_id = dependency.external.outputs.subnet_pool_id
}
