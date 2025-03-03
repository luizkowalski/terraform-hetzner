# Print the volume's mount path
# output "volume_mountpoint" {
#   value = "/mnt/HC_Volume_${split("HC_Volume_", hcloud_volume.data_volume.linux_device)[1]}"
# }

# output "ipv4_web_address" {
#   value = { for s in hcloud_server.web : s.name => s.ipv4_address }
# }

# output "ipv4_accessories_address" {
#   value = { for s in hcloud_server.accessories : s.name => s.ipv4_address }
# }

output "ssh_01_web_config" {
  value = join("\n", [
    for server in hcloud_server.web[*] :
    format("Host %s\n  HostName %s\n  User %s", server.name, server.ipv4_address, var.username)
  ])
}

output "ssh_02_accessories_config" {
  value = join("\n", [
    for server in hcloud_server.accessories[*] :
    format("Host %s\n  HostName %s\n  User %s\n  ProxyJump %s", server.name, server.ipv4_address, var.username, hcloud_server.web[0].name)
  ])
}
