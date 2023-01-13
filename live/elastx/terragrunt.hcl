# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket     = "elastx-talos-poc"
    key        = "${path_relative_to_include()}/terraform.tfstate"
    region     = "${get_env("OS_S3_REGION_NAME", "no_def_region")}"
    endpoint   = "${get_env("OS_S3_ENDPOINT", "no_def_endpoint")}"
    skip_credentials_validation =true
    skip_region_validation = true
    skip_metadata_api_check = true
    force_path_style = true
    encrypt = "${get_env("OS_S3_ENCRYPT", "false")}"
    access_key = "${get_env("OS_S3_ACCESS_KEY", "no_def_access_key")}"
    secret_key = "${get_env("OS_S3_SECRET_KEY", "no_def_secret_key")}"
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF

provider "openstack" {
  auth_url = "${get_env("OS_AUTH_URL", "no_def_auth_url")}"
  user_domain_name = "${get_env("OS_USER_DOMAIN_NAME", "no_def_user_domain_name")}"
  project_domain_name = "${get_env("OS_PROJECT_NAME", "no_def_project_domain_name")}"
  region = "${get_env("OS_REGION_NAME", "no_def_region")}"
  tenant_name = "${get_env("OS_PROJECT_NAME", "no_def_tenent_name")}"
  user_name = "${get_env("OS_USERNAME", "no_def_username")}"
  password = "${get_env("OS_PASSWORD", "no_def_password")}"
}
EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  # Configure Terragrunt to use common vars encoded as yaml to help you keep often-repeated variables (e.g., account ID)
  # DRY. We use yamldecode to merge the maps into the inputs, as opposed to using varfiles due to a restriction in
  # Terraform >=0.12 that all vars must be defined as variable blocks in modules. Terragrunt inputs are not affected by
  # this restriction.
  yamldecode(
    file(find_in_parent_folders("environment.yaml", find_in_parent_folders("empty.yaml")))
  ),
)
