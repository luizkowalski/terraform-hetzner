variables {
  web_servers_count = 1
  project_name      = "myapp"
}

run "create_servers" {
  command = plan

  assert {
    condition     = hcloud_server.web_server.*.name == ["myapp-web"]
    error_message = "Server name is not correct"
  }

  assert {
    condition     = hcloud_load_balancer.web_load_balancer == []
    error_message = "Load balancer was created"
  }

  assert {
    condition     = can(regex("myapp-web", data.cloudinit_config.web_server_config[0].part[0].content))
    error_message = "Cloud-init config for web is not correct"
  }

  assert {
    condition     = can(regex("myapp-accessories", data.cloudinit_config.accessories_config[0].part[0].content))
    error_message = "Cloud-init config for accessories is not correct"
  }
}
