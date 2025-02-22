variables {
  web_servers_count = 1
}

run "create_servers" {
  command = plan

  assert {
    condition = hcloud_server.web.*.name == ["web"]
    error_message = "Server name is not correct"
  }

  assert {
    condition = hcloud_load_balancer.web_load_balancer == []
    error_message = "Load balancer was created"
  }

  assert {
    condition = can(regex("web", data.cloudinit_config.cloud_config_web[0].rendered))
    error_message = "Cloud-init config for web is not correct"
  }

  assert {
    condition = can(regex("accessories", data.cloudinit_config.cloud_config_accessories[0].rendered))
    error_message = "Cloud-init config for accessories is not correct"
  }
}
