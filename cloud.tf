terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.44.1"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

data "cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit.yml")
  }

  # Used as an example of how to add a file to the user_data
  # part {
  #   content_type = "text/x-shellscript"
  #   filename     = "hello.sh"
  #   content      = file("${path.module}/hello.sh")
  # }
}

variable "hetzner_api_key" {
  description = "The Hetzner Cloud API Token"
  type        = string
}

provider "hcloud" {
  token = var.hetzner_api_key
}

resource "hcloud_ssh_key" "passwordless_key" {
  name       = "passwordless-key-do"
  public_key = file("~/.ssh/digitalocean.pub")
}

resource "hcloud_network" "network" {
  name     = "private-sumiu-network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/16"
}

resource "hcloud_server" "web" {
  name        = "web"
  image       = "ubuntu-20.04"
  server_type = "cx11"
  location    = "nbg1"
  labels = {
    "type" = "server",
    "http" = "yes"
  }

  user_data = data.cloudinit_config.cloud_config.rendered

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.2"
  }

  ssh_keys = [
    hcloud_ssh_key.passwordless_key.id
  ]

  depends_on = [
    hcloud_network.network
  ]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_server" "accessories" {
  name        = "accessories"
  image       = "ubuntu-20.04"
  server_type = "cpx11"
  location    = "nbg1"
  labels = {
    "type" = "server",
    "http" = "no"
  }

  user_data = data.cloudinit_config.cloud_config.rendered

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.3"
  }

  ssh_keys = [
    hcloud_ssh_key.passwordless_key.id
  ]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  depends_on = [
    hcloud_network.network
  ]
}

resource "hcloud_volume" "data_volume" {
  name              = "data_volume"
  automount         = true
  size              = 30
  format            = "ext4"
  delete_protection = false
  server_id         = hcloud_server.accessories.id
}

resource "hcloud_firewall" "block_all_except_ssh" {
  name = "block-all-except-ssh"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  apply_to {
    label_selector = "type=server"
  }
}

resource "hcloud_firewall" "allow_http_https" {
  name = "allow-http-https"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  apply_to {
    label_selector = "http=yes"
  }
}

# Print the volumen's mount path
output "volume_mountpoint" {
  value = "/mnt/HC_Volume_${split("HC_Volume_", hcloud_volume.data_volume.linux_device)[1]}"
}

output "ipv6_address" {
  value = hcloud_server.web.ipv6_address
}

output "ipv4_address" {
  value = hcloud_server.web.ipv4_address
}
