variable "environment" {
  description = "Name of the environment we are creating i.e. dev,test,stage,production"
  type    = string
  default = "environment"
}

variable "domain" {
  type = string
}

variable "external_network_id" {
  description = "Id for the the external/public network i.e. use openstack network list --external"
  type    = string
  default = null
}

variable "external_network_name" {
  description = "Name for the the external/public network i.e. use openstack network list --external"
  type    = string
  default = null
}

variable "network_uuid" {
  description = ""
  type    = string
  default = null
}

variable "subnet_uuid" {
  description = ""
  type    = string
  default = null
}

variable "security_group_bastion" {
  type = set(string)
  description = "A security group uuid for bastion access."
  default = []
}

variable "security_groups_sweet" {
  type = map(set(string))
  description = "An map of account => security group uuid to allow access from sweet to API service."
  default = {}
}

variable "router_id" {
  description = "router uuid to enable access"
  type    = string
  default = null
}

variable "subnet_pool_id" {
  description = "Id for subnet pool"
  type    = string
  default = null
}

variable "image_uuid" {
  type = string
  description = "UUID of image"
}

variable "control_plane_number" {
  description = "Number of control plane nodes"
  default     = 3
}

variable "control_plane_flavor" {
  description = "Flavor of a control plane node"
  type        = string
}

variable "worker_number" {
  description = "Number of worker nodes"
  default     = 1
}

variable "worker_flavor" {
  description = "Flavor of a worker node"
  type        = string
}

variable "use_fip" {
  description = ""
  type        = bool
  default = false
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}
