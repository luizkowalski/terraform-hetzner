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
}
