variable "hetzner_api_key" {
  description = "The Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "The public SSH key content to be used for server access."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The Hetzner Cloud region where resources will be provisioned. See https://docs.hetzner.com/cloud/general/locations for available locations."
  type        = string
  default     = "nbg1"

  validation {
    condition     = contains(["fsn1", "nbg1", "hel1", "ash", "hil", "sin"], var.region)
    error_message = "The region must be one of fsn1, nbg1, hel1, ash, hil, or sin."
  }
}

variable "server_type" {
  description = "The type of server to deploy. See https://www.hetzner.com/cloud/#pricing for available server types."
  type        = string
  default     = "cx22"

  validation {
    condition = contains(
      [
        "cx11", "cx22", "cx32", "cx42", "cx52",
        "cpx11", "cpx21", "cpx31", "cpx41", "cpx51",
        "cax11", "cax21", "cax31", "cax41",
        "ccx13", "ccx23", "ccx33", "ccx43", "ccx53", "ccx63"
    ], var.server_type)
    error_message = "The server_type must be valid. See https://www.hetzner.com/cloud/#pricing for available server types."
  }
}

variable "operating_system" {
  description = "The operating system image to use for the servers."
  type        = string
  default     = "ubuntu-24.04"
}

variable "web_servers_count" {
  description = "The number of web servers to deploy."
  type        = number
  default     = 1

  validation {
    condition     = var.web_servers_count >= 0
    error_message = "The number of web servers must be a non-negative integer."
  }
}

variable "accessories_count" {
  description = "The number of accessory servers to deploy."
  type        = number
  default     = 1

  validation {
    condition     = var.accessories_count >= 0
    error_message = "The number of accessory servers must be a non-negative integer."
  }
}

variable "username" {
  description = "The username for SSH access to the servers."
  type        = string
  default     = "kamal"
}

variable "github_username" {
  description = "The GitHub username of the user to be used for SSH access. This is used to fetch SSH keys from GitHub."
  type        = string
}
