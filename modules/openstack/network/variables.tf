variable "environment" {
  description = "Name of the environment we are creating i.e. dev,test,stage,production"
  type    = string
  default = "environment"
}

variable "name" {
  description = "Name of the the network to create"
  type    = string
  default = "name"
}

variable "subnet_pool_id" {
  description = "Id for subnet pool"
  type    = string
  default = null
}

variable "router_id" {
  description = "router uuid to enable access"
  type    = string
  default = null
}
