data "http" "github_ssh_keys" {
  url = "https://github.com/${var.github_username}.keys"
}

data "cloudinit_config" "web_server_config" {
  count         = var.web_servers_count
  gzip          = true
  base64_encode = true

  # Base system configuration
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloudinit/base.yml", {
      hostname        = local.web_server_names[count.index]
      username        = var.username
      github_username = var.github_username
    })
  }

  # Web-specific configuration
  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/web.yml")
    merge_type   = "list(append)+dict(no_replace,recurse_list)+str()"
  }
}

data "cloudinit_config" "accessories_config" {
  gzip          = true
  base64_encode = true
  count         = var.accessories_count
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloudinit/base.yml", {
      hostname        = local.accessories_server_names[count.index]
      username        = var.username
      github_username = var.github_username
    })
  }

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/accessories.yml")
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}
