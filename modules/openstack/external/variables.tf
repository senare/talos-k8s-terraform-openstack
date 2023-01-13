variable "environment" {
  description = "Name of the environment we are creating i.e. dev,test,stage,production"
  type    = string
  default = "environment"
}

variable "external_network_id" {
  description = "Id for the the external/public network i.e. use openstack network list --external"
  type    = string
  default = null
}

variable "router_id" {
  description = "router uuid to enable access"
  type    = string
  default = null
}
