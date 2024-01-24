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

resource "hcloud_ssh_key" "ssh_key_for_hetzner" {
  name       = "ssh-key-for-hetzner"
  public_key = file("~/.ssh/hetzner.pub")
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
  image       = var.operating_system
  server_type = var.server_type
  location    = var.region
  labels = {
    "ssh"  = "yes",
    "http" = "yes"
  }

  user_data = data.cloudinit_config.cloud_config_web.rendered

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.2"
  }

  ssh_keys = [
    hcloud_ssh_key.ssh_key_for_hetzner.id
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
  image       = var.operating_system
  server_type = var.server_type
  location    = var.region
  labels = {
    "type" = "server",
    "http" = "no"
    "ssh"  = "no"
  }

  user_data = data.cloudinit_config.cloud_config_accessories.rendered

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.0.3"
  }

  ssh_keys = [
    hcloud_ssh_key.ssh_key_for_hetzner.id
  ]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  depends_on = [
    hcloud_network.network
  ]
}

# resource "hcloud_volume" "data_volume" {
#   name              = "data_volume"
#   automount         = true
#   size              = 30
#   format            = "ext4"
#   delete_protection = false
#   server_id         = hcloud_server.accessories.id
# }

resource "hcloud_firewall" "block_all_except_ssh" {
  name = "allow-ssh"
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
    label_selector = "ssh=yes"
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

resource "hcloud_firewall" "block_all_inboud_traffic" {
  name = "block-inboud_traffic"
  # Empty rule list blocks all inbound traffic
  apply_to {
    label_selector = "ssh=no"
  }
}
