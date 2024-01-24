data "cloudinit_config" "cloud_config_web" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/web.yml")
  }
}

data "cloudinit_config" "cloud_config_accessories" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloudinit/accessories.yml")
  }
}
