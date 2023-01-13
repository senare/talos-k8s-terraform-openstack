terraform {
  required_version = "1.3.4"

  required_providers {
    openstack = {
      version = "1.49.0"
      source = "terraform-provider-openstack/openstack"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.2.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.2"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    time = {
      source = "hashicorp/time"
      version = "0.8.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.1.0"
    }
  }
}

provider "random" {
}

provider "tls" {
}

provider "local" {
}

provider "time" {
}

provider "talos" {}
