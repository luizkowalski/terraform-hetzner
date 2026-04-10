run "rejects_spaces_in_project_name" {
  command = plan

  variables {
    project_name = "my project"
  }

  expect_failures = [var.project_name]
}

run "rejects_uppercase_in_project_name" {
  command = plan

  variables {
    project_name = "MyProject"
  }

  expect_failures = [var.project_name]
}

run "rejects_special_characters_in_project_name" {
  command = plan

  variables {
    project_name = "my_project!"
  }

  expect_failures = [var.project_name]
}

run "accepts_valid_project_name" {
  command = plan

  variables {
    project_name = "my-project-123"
  }

  assert {
    condition     = hcloud_server.web_server[0].name == "my-project-123-web"
    error_message = "Valid project name should be accepted and used as prefix"
  }
}
