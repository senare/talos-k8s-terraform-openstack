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

variable "machineconfig_controlplane" {
}

variable "machineconfig_worker" {
}

variable "talosconfig" {
}
