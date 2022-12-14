## An example for deploying a single server on Proxmox

### Server config

This example deploys a single server on proxmox using the 
[proxmox terraform module](github.com/brianonn/proxmox-terraform) code from github,


The `main.tf` file is shown below.  We first initialize the proxmox provider from 
Telmate then setup the proxmod-terraform module and the required input variables. 


```hcl

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
  vm_id_start = 300

  # which template to clone VMs from
  template_name = "ubuntu-template"

  # ssh public key to use
  ssh_public_key = "~/.ssh/ubuntu@pve-ed25519.pub"

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

```

### Running the main.tf 

You must first download the providers and modules needed.. 
```shell
$ terraform init 
```
Then run `terraform plan` to see what the result will be.  Edit the input variables in the module block until you are satisfied. 
For documentation on the input variables, see the [proxmox-terraform module documentation.](github.com/brianonn/proxmox-terraform/docs/docs.html)

Finally, run `terraform apply` to apply the plan.

```shell
[694] $ terraform apply
module.proxmox.data.template_file.ssh_key: Reading...
module.proxmox.data.template_file.ssh_key: Read complete after 0s [id=904f53240b6c05c2322c2a52aea248008a2399d18c62d121d08619e0620b6427]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.proxmox.proxmox_vm_qemu.server[0] will be created
  + resource "proxmox_vm_qemu" "server" {
      + additional_wait           = 15
      + agent                     = 1
      + balloon                   = 0
      + bios                      = "seabios"
      + boot                      = "cdn"
      + bootdisk                  = "scsi0"
      + clone                     = "ubuntu-template"
      + clone_wait                = 15
      + cores                     = 2
      + cpu                       = "host"
      + default_ipv4_address      = (known after apply)
      + define_connection_info    = true
      + force_create              = false
      + full_clone                = true
      + guest_agent_ready_timeout = 600
      + hotplug                   = "network,disk,usb"
      + id                        = (known after apply)
      + ipconfig0                 = "ip=dhcp,ip6=dhcp"
      + kvm                       = true
      + memory                    = 512
      + name                      = "vm1"
      + nameserver                = (known after apply)
      + numa                      = false
      + onboot                    = true
      + os_type                   = "cloud-init"
      + preprovision              = true
      + reboot_required           = (known after apply)
      + scsihw                    = "virtio-scsi-pci"
      + searchdomain              = (known after apply)
      + sockets                   = 1
      + ssh_host                  = (known after apply)
      + ssh_port                  = (known after apply)
      + sshkeys                   = <<-EOT
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIlskflFLKAFlfoeiflT83457347sd:JLLAJDKAIEJdd4 ubuntu@pve 
        EOT
      + target_node               = "pve"
      + unused_disk               = (known after apply)
      + vcpus                     = 0
      + vlan                      = -1
      + vmid                      = 300

      + disk {
          + backup       = 0
          + cache        = "none"
          + file         = (known after apply)
          + format       = (known after apply)
          + iothread     = 1
          + mbps         = 0
          + mbps_rd      = 0
          + mbps_rd_max  = 0
          + mbps_wr      = 0
          + mbps_wr_max  = 0
          + media        = (known after apply)
          + replicate    = 0
          + size         = "32G"
          + slot         = 0
          + ssd          = 0
          + storage      = "local"
          + storage_type = (known after apply)
          + type         = "scsi"
          + volume       = (known after apply)
        }

      + network {
          + bridge    = "vmbr0"
          + firewall  = false
          + link_down = false
          + macaddr   = (known after apply)
          + model     = "virtio"
          + queues    = (known after apply)
          + rate      = (known after apply)
          + tag       = -1
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.proxmox.proxmox_vm_qemu.server[0]: Creating...
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [10s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [20s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [30s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [40s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [50s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [1m0s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [1m10s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [1m20s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [1m30s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [1m40s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [1m50s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [2m0s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [2m10s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Creation complete after 2m13s [id=pve/qemu/300]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

proxmox_terraform = {
  "instance_ip_address" = [
    "192.168.0.80",
  ]
  "instance_mac_address" = [
    "3A:EF:49:7B:17:8F",
  ]
  "instance_name" = [
    "vm1",
  ]
}
```

