## An example for deploying a group of 3 servers on Proxmox

### Server config

This example deploys 3 servers on proxmox using the 
[proxmox terraform module](github.com/brianonn/proxmox-terraform) code from github, 
These 3 servers can then be used with ansible to provision them into a cluster as needed. 


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
  ssh_public_key = "~/.ssh/ubuntu@pve-ed25519.pub"

  # disk
  disk = {
    size    = "32G"
    storage = "local"
    type    = "scsi"
  }
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

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

  Terraform will perform the following actions:

[ ...not shown ... ]

module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [9m40s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [9m50s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [10m0s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [10m10s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [10m20s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [10m30s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Still creating... [10m40s elapsed]
module.proxmox.proxmox_vm_qemu.server[0]: Creation complete after 10m50s [id=pve/qemu/402]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

```

