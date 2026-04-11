locals {
  enable_load_balancer = var.web_servers_count > 1

  web_server_names         = [for i in range(var.web_servers_count) : i == 0 ? "${var.project_name}-web" : "${var.project_name}-web-${i}"]
  accessories_server_names = [for i in range(var.accessories_count) : i == 0 ? "${var.project_name}-accessories" : "${var.project_name}-accessories-${i}"]
}
