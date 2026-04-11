terraform {
  required_version = ">= 1.12.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.56"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
