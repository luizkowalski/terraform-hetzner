variables {
  project_name = "facebook"
}

run "server_names_are_prefixed_with_project_name" {
  command = plan

  assert {
    condition     = hcloud_server.web_server[0].name == "facebook-web"
    error_message = "Web server name should be prefixed with project name"
  }

  assert {
    condition     = hcloud_server.accessory_server[0].name == "facebook-accessories"
    error_message = "Accessory server name should be prefixed with project name"
  }

  assert {
    condition     = can(regex("hostname: facebook-web\\n", data.cloudinit_config.web_server_config[0].part[0].content))
    error_message = "Cloud-init hostname for web should be prefixed with project name"
  }

  assert {
    condition     = can(regex("hostname: facebook-accessories\\n", data.cloudinit_config.accessories_config[0].part[0].content))
    error_message = "Cloud-init hostname for accessories should be prefixed with project name"
  }
}

run "multiple_web_servers_are_prefixed_with_project_name" {
  command = plan

  variables {
    web_servers_count = 2
  }

  assert {
    condition     = hcloud_server.web_server.*.name == ["facebook-web", "facebook-web-1"]
    error_message = "Multiple web server names should be prefixed with project name"
  }

  assert {
    condition     = can(regex("hostname: facebook-web-1\\n", data.cloudinit_config.web_server_config[1].part[0].content))
    error_message = "Cloud-init hostname for web-1 should be prefixed with project name"
  }
}
