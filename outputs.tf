# Print the volume's mount path
# output "volume_mountpoint" {
#   value = "/mnt/HC_Volume_${split("HC_Volume_", hcloud_volume.data_volume.linux_device)[1]}"
# }

output "ipv4_web_address" {
  value = { for s in hcloud_server.web_server : s.name => s.ipv4_address }
}

output "ipv4_accessories_address" {
  value = { for s in hcloud_server.accessory_server : s.name => s.ipv4_address }
}

output "ssh_web_server_config" {
  description = "SSH configuration for web servers."
  value = join("\n", [
    for server in hcloud_server.web_server[*] :
    format("Host %s\n  HostName %s\n  User %s", server.name, server.ipv4_address, var.username)
  ])
}

output "ssh_accessory_server_config" {
  description = "SSH configuration for accessory servers, with ProxyJump through the first web server."
  value = join("\n", [
    for server in hcloud_server.accessory_server[*] :
    format("Host %s\n  HostName %s\n  User %s\n  ProxyJump %s", server.name, server.ipv4_address, var.username, hcloud_server.web_server[0].name)
  ])
}
