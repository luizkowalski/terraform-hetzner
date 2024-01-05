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
  default = "ubuntu-20.04"
}

# Later: create more servers
variable "web_servers" {
  type = number
  default = 2
}
