# Print the volume's mount path
# output "volume_mountpoint" {
#   value = "/mnt/HC_Volume_${split("HC_Volume_", hcloud_volume.data_volume.linux_device)[1]}"
# }

output "ipv6_address" {
  value = hcloud_server.web.ipv6_address
}

output "ipv4_address" {
  value = hcloud_server.web.ipv4_address
}
