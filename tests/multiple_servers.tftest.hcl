variables {
  web_servers_count = 2
}

run "create_servers" {
  command = plan

  assert {
    condition = hcloud_server.web_server.*.name == ["web-1", "web-2"]
    error_message = "Server name is not correct"
  }

  assert {
    condition = hcloud_load_balancer.web_load_balancer[0].name != null
    error_message = "Load balancer was not created"
  }

  assert {
    condition = can(regex("web-1", data.cloudinit_config.web_server_config[0].part[0].content))
    error_message = "Cloud-init config for web-1 is not correct"
  }

  assert {
    condition = can(regex("web-2", data.cloudinit_config.web_server_config[1].part[0].content))
    error_message = "Cloud-init config for web-2 is not correct"
  }
}
