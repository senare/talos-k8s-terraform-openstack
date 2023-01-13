terraform {

  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
    local = {
      source = "hashicorp/local"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}
