terraform {
  source = "${get_parent_terragrunt_dir("root")}/../../modules//openstack/external"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
  ]
}

inputs = {
}

