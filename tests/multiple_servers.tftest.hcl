variables {
  web_servers_count = 2
}

run "create_servers" {
  command = plan

  assert {
    condition = hcloud_server.web.*.name == ["web-1", "web-2"]
    error_message = "Server name is not correct"
  }

  assert {
    condition = hcloud_load_balancer.web_load_balancer[0].name != null
    error_message = "Load balancer was not created"
  }
}
