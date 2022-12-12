output "instance_name" {
    value = proxmox_vm_qemu.server.*.name
    description = "The name of the VM created"
}

output "instance_mac_address" {
    value = proxmox_vm_qemu.server.*.network.0.macaddr
    description = "The MAC address of the VM created"
}

output "instance_ip_address" {
    value = proxmox_vm_qemu.server.*.default_ipv4_address
    description = "The IPV4 address of the VM created"
}
