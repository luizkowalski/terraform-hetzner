data "cloudinit_config" "web_server_config" {
  count         = var.web_servers_count
  gzip          = true
  base64_encode = true

  # Base system configuration
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloudinit/base.yml", {
      hostname = var.web_servers_count > 1 ? "web-${count.index + 1}" : "web"
      username = var.username
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
  gzip          = false
  base64_encode = false
  count         = var.accessories_count
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloudinit/base.yml", {
      hostname = var.accessories_count > 1 ? "accessories-${count.index + 1}" : "accessories"
      username = var.username
    })
  }

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/accessories.yml")
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}
