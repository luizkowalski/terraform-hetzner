locals {
  # Web servers: 10.0.0.2 - 10.0.0.127 (max 126 servers)
  web_server_ips = [
    for i in range(var.web_servers_count) :
    "10.0.0.${i + 2}"
  ]

  # Accessories: 10.0.0.128 - 10.0.0.253 (max 126 servers)
  # Load balancer uses 10.0.0.254
  accessories_server_ips = [
    for i in range(var.accessories_count) :
    "10.0.0.${i + 128}"
  ]
}
