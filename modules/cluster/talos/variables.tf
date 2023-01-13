variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "domain" {
  type        = string
}

variable "controlplanes" {
  description = "CTRL IP"
  type        = set(string)
  default = []
}

variable "workers" {
  description = "WRK IP"
  type        = set(string)
  default = []
}
