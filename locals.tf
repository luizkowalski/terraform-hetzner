locals {
  web_server_ips = [
    for i in range(var.web_servers_count) :
    "10.0.0.${i + 2}"
  ]
  accessories_server_ips = [
    for i in range(var.accessories_count) :
    "10.0.0.${i + var.web_servers_count + 2}"
  ]
}