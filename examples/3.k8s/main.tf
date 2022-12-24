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

  # use env vars from secrets.env
  #pm_api_token_id = "blog_example@pam!new_token_id"
  #pm_api_token_secret = "<put your secret token here>"

  pm_tls_insecure = true

}

#
# deploy the server instances
#
module "k8s_servers" {
  source = "github.com/brianonn/proxmox-terraform"

  # the node in our proxmox cluster to target for VM creation
  target_node = "pve"

  # which ID to start at
  vm_id_start = 200

  # which template to clone VMs from
  template_name = "ubuntu-template"

  # 1 server VM
  vm_count = 1

  # what to name these server instances
  # each VM will get "k8s-server-N"
  vm_name = "k8s-server-"

  # memory and cores -- k8s servers are beefier than workers
  vm_memory = 4096
  vm_cores  = 4

  # ssh public key to use
  ssh_public_key = "~/.ssh/brian@pve-ed25519.pub"

  # disk
  disk = {
    size    = "32G"
    storage = "local"
    type    = "scsi"
  }

  vm_full_clone = true
}


#
# deploy the worker instances
#
module "k8s_workers" {
  source = "github.com/brianonn/proxmox-terraform"

  # the node in our proxmox cluster to target for VM creation
  target_node = "pve"

  # which ID to start at
  vm_id_start = 300

  # which template to clone VMs from
  template_name = "ubuntu-template"

  # set the count to 3 VMs
  vm_count = 3

  # what to name these server instances
  # each VM will get "k8s-worker-N"
  vm_name = "k8s-worker-"

  # memory and cores -- workers have less memory and fewer cores
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

  vm_full_clone = true
}

# outputs from the servers module
output "servers_instance_data" {
  value = module.k8s_servers
}

# outputs from the workers module
output "workers_instance_data" {
  value = module.k8s_workers
}
