variable "hetzner_api_key" {
  description = "The Hetzner Cloud API Token"
  type        = string
}

# Hetzner locations
# https://docs.hetzner.com/cloud/general/locations#what-locations-are-there
variable "region" {
  type    = string
  default = "nbg1"
}

# Hetnzer Server types:
# https://docs.hetzner.com/cloud/servers/overview/#shared-vcpu
variable "server_type" {
  type    = string
  default = "cpx11"
}

variable "operating_system" {
  type    = string
  default = "ubuntu-24.04"
}

variable "servers_count" {
  type    = number
  default = 1
}

variable "accessories_count" {
  type    = number
  default = 1
}
