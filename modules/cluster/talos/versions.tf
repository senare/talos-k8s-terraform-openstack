terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    local = {
      source = "hashicorp/local"
    }
    talos = {
      source = "siderolabs/talos"
    }
  }
}
