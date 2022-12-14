## An example for deploying servers suitable for use as a k8s cluster

### Server config

This example deploys separate groups of 1 larger server VM and 3 smaller worker VMs on proxmox using the 
[proxmox terraform module](github.com/brianonn/proxmox-terraform) code from github,


The `main.tf` file is shown below.  We first initialize the proxmox provider from 
Telmate then invoke the proxmod-terraform module in two places.  The first is for 
creating servers with 4G memory and 4 cores, and the second time is for creating
3 workers, each with 2G of memory and 2 cores. This example is useful for deploying
the k8s control plane and worker VMs that can be provisioned for kubernetes.


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

  # set the count to 2 VMs
  vm_count = 2

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

  vm_full_clone = false
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

  vm_full_clone = false
}

# outputs from the servers module
output "servers_instance_data" {
  value = module.k8s_servers
}

# outputs from the workers module
output "workers_instance_data" {
  value = module.k8s_workers
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
$ terraform apply --auto-approve
module.k8s_workers.data.template_file.ssh_key: Reading...
module.k8s_servers.data.template_file.ssh_key: Reading...
module.k8s_servers.data.template_file.ssh_key: Read complete after 0s [id=904f53240b6c05c2322c2a52aea248008a2399d18c62d121d08619e0620b6427]
module.k8s_workers.data.template_file.ssh_key: Read complete after 0s [id=904f53240b6c05c2322c2a52aea248008a2399d18c62d121d08619e0620b6427]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

  Terraform will perform the following actions:

[ ... ] 

module.k8s_servers.proxmox_vm_qemu.server[0]: Creating...
module.k8s_servers.proxmox_vm_qemu.server[1]: Creating...
module.k8s_workers.proxmox_vm_qemu.server[2]: Creating...
module.k8s_workers.proxmox_vm_qemu.server[0]: Creating...
module.k8s_workers.proxmox_vm_qemu.server[1]: Creating...
module.k8s_servers.proxmox_vm_qemu.server[0]: Still creating... [10s elapsed]
module.k8s_workers.proxmox_vm_qemu.server[0]: Still creating... [10s elapsed]
module.k8s_workers.proxmox_vm_qemu.server[2]: Still creating... [10s elapsed]
module.k8s_workers.proxmox_vm_qemu.server[1]: Still creating... [10s elapsed]
module.k8s_servers.proxmox_vm_qemu.server[0]: Still creating... [20s elapsed]

[ ... ] 

module.k8s_workers.proxmox_vm_qemu.server[2]: Still creating... [1m10s elapsed]
module.k8s_workers.proxmox_vm_qemu.server[0]: Still creating... [1m10s elapsed]
module.k8s_workers.proxmox_vm_qemu.server[1]: Creation complete after 1m11s [id=pve/qemu/301]
module.k8s_workers.proxmox_vm_qemu.server[2]: Creation complete after 1m13s [id=pve/qemu/302]
module.k8s_servers.proxmox_vm_qemu.server[0]: Creation complete after 1m13s [id=pve/qemu/200]
module.k8s_workers.proxmox_vm_qemu.server[0]: Creation complete after 1m13s [id=pve/qemu/300]
module.k8s_servers.proxmox_vm_qemu.server[1]: Creation complete after 1m13s [id=pve/qemu/201]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

servers_instance_data = {
  "instance_ip_address" = [
    "192.168.0.148",
    "192.168.0.93",
  ]
  "instance_mac_address" = [
    "DA:FA:4D:E3:02:E5",
    "46:64:34:AD:C8:0F",
  ]
  "instance_name" = [
    "k8s-server-1",
    "k8s-server-2",
  ]
}
workers_instance_data = {
  "instance_ip_address" = [
    "192.168.0.80",
    "192.168.0.86",
    "192.168.0.83",
  ]
  "instance_mac_address" = [
    "CA:50:7B:41:9B:9D",
    "E6:8E:CA:64:C8:A7",
    "76:D7:1C:D9:6B:7E",
  ]
  "instance_name" = [
    "k8s-worker-1",
    "k8s-worker-2",
    "k8s-worker-3",
  ]
}

```

