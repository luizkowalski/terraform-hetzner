variable "hetzner_api_key" {
  description = "The Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

# Hetzner locations
# https://docs.hetzner.com/cloud/general/locations#what-locations-are-there
variable "region" {
  type    = string
  default = "nbg1"
}

# Hetnzer Server types:
# https://www.hetzner.com/cloud/#pricing
variable "server_type" {
  type        = string
  default     = "cx22"
}

variable "operating_system" {
  type    = string
  default = "ubuntu-24.04"
}

variable "web_servers_count" {
  type    = number
  default = 1
}

variable "accessories_count" {
  type    = number
  default = 1
}

variable "username" {
  type    = string
  default = "kamal"
}
