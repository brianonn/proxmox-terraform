terraform {
  required_providers {
    proxmox   = {
      source  = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}


provider "proxmox" {
  pm_api_url = "https://pve.lan:8006/api2/json"

  # use env vars from .secret.env
  #pm_api_token_id = "blog_example@pam!new_token_id"
  #pm_api_token_secret = "<put your secret token here>"

  pm_tls_insecure = true

}

# read the SSH key.  TODO - make this work for a list of keys
data "template_file" "ssh_key" {
  template = "${file(var.ssh_public_key)}"
}

resource "proxmox_vm_qemu" "server" {
  count = var.vm_count

  # count.index starts at 0
  name = "${var.vm_name}${count.index + 1}"
  vmid = var.vm_id_start + count.index

  target_node = var.target_node
  clone       = var.template_name
  full_clone  = var.vm_full_clone
  onboot      = var.start_on_boot
  tags        = var.vm_tags

  # agent is the qemu guest agent. 
  # This setting only enables it in Proxmox.  The guest still needs it installed.
  agent    = lookup({false=0,true=1},var.agent,0)

  cores    = var.vm_cores
  sockets  = var.vm_sockets
  memory   = var.vm_memory
  os_type  = "cloud-init"
  cpu      = "host"

  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    storage  = var.disk["storage"]
    size     = var.disk["size"]
    type     = var.disk["type"]
    slot     = 0
    iothread = 1
  }

  # duplicate this network block for multiple NICs 
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = var.ipconfig0

  # use the following to assign multiple incrementing IP's from count.index
  #ipconfig0 = "ip=10.121.3.10${count.index + 1}/24,gw=10.121.3.1"

  # sshkeys is a newline separated string with multiple ssh keys permitted.
  sshkeys = "${data.template_file.ssh_key.rendered}"

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
