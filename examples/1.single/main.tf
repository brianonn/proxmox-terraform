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

module "proxmox_terraform" {
  source = "github.com/brianonn/proxmox-terraform"

  # the node in our proxmox cluster to target for VM creation
  target_node = "pve"

  # which ID to start at
  vm_id_start = 400

  vm_full_clone = false

  # which template to clone VMs from
  template_name = "ubuntu-template"

  # ssh public key to use
  ssh_public_key = "~/.ssh/brian@pve-ed25519.pub"

  # disk
  disk = {
    size    = "32G"
    storage = "local"
    type    = "scsi"
  }
}

# import all the outputs from the proxmox_terraform module
output "proxmox_terraform" {
  value = module.proxmox_terraform
}
