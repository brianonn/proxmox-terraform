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

module "proxmox" {
  source = "github.com/brianonn/proxmox-terraform"

  # the node in our proxmox cluster to target for VM creation
  target_node = "pve"

  # which ID to start at
  vm_id_start = 400

  # which template to clone VMs from
  template_name = "ubuntu-template"

  # set the count to 3 VMs
  vm_count = 3

  # memory and cores
  vm_memory = 2048
  vm_cores  = 2

  # ssh public key to use
  ssh_public_key = "~/.ssh/brian@pve-ed25519.pub"

  # disk
  disk = {
    size    = "32G"
    storage = "local"
    type    = "scsi"
  }
}
