data "cloudinit_config" "cloud_config_web" {
  gzip          = false
  base64_encode = false
  count         = var.web_servers_count
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloudinit/base.yml", {
      hostname = var.web_servers_count > 1 ? "web-${count.index + 1}" : "web"
      username = var.username
    })
  }

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/web.yml")
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

data "cloudinit_config" "cloud_config_accessories" {
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
