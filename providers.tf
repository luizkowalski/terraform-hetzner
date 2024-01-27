terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.3"
    }
  }
}

provider "hcloud" {
  token = var.hetzner_api_key
}
