
### Introduction

This is a terraform module for making VMs in Proxmox

It uses the Proxmox API and the [Telmate Terraform provider for Proxmox](https://github.com/Telmate/terraform-provider-proxmox) 

1. run `make secrets` first to create a file `secrets.env` from the sample file. 
1. edit the `secrets.env` file to add your own ID and TOKEN for authentication to the proxmox server. 
1. then source the env file in your shell: `source secrets.env`

See the instructions at the [Telmate provider documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) for setting up the Proxmox user and roles needed for creating Proxmox VMs via the API.

### Storing secrets.env in Hashicorp Vault (optional)
A good practice is to store your secrets in an encrypted vault.
[Hashicorp Vault](https://registry.terraform.io/providers/hashicorp/vault/latest/docs) is a great tool
for storing all your secrets and it's worth getting to know how Hashicorp Vault works. 
There is a [tutorial](https://developer.hashicorp.com/vault/tutorials/getting-started) available online and plenty of [YouTube](https://youtube.com/) videos too. 

If you decide that you want to store your `secrets.env` into Hashicorp Vault, you 
must already be authenticated to the vault and have a valid `VAULT_TOKEN` or `~/.vault-token` 
```shell
vault kv put -mount=secret /path/to/secret file=$( base64 secrets.env )
```
This writes the entire `secrets.env` file as a base64 blob.   

To extract the secrets from vault, use:
```shell
vault kv get -format=json -mount=secret /path/to/secret |\
       jq -r .data.data.file |\
       base64 -d > secrets.env
```
If you just wanted to do this inside of the terraform HCL, you can use the [Terraform provider for Hashicorp Vault](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret) to get the id and token directly from the vault and skip the base64 blob and `secrets.env` altogether. 

### Variables you can set 
You will also need to edit the file `terraform.tfvars` to your liking.  See the tfvars documentation at [documentation/documentation.html](file://documentation/documentation.html)

Finally, you can run `make plan` and if you like what you see, then run `make apply` (these make targets simply run `terraform plan` and `terraform apply` respectively.)


You can run `terraform apply -var vm_count=5` to create 5 VMs

You can run `terraform apply -var vm_count=0` to destroy all VMs


### Sample output

here's the output from running `terraform apply -var vm_count=6`

```shell
$ terraform apply -var vm_count=6
proxmox_vm_qemu.server[3]: Creating...
proxmox_vm_qemu.server[2]: Creating...
proxmox_vm_qemu.server[4]: Creating...
proxmox_vm_qemu.server[0]: Creating...
proxmox_vm_qemu.server[1]: Creating...
proxmox_vm_qemu.server[5]: Creating...
proxmox_vm_qemu.server[3]: Still creating... [10s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [10s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [10s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [10s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [10s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [10s elapsed]
proxmox_vm_qemu.server[3]: Still creating... [20s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [20s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [20s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [20s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [20s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [20s elapsed]
proxmox_vm_qemu.server[3]: Still creating... [30s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [30s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [30s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [30s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [30s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [30s elapsed]
proxmox_vm_qemu.server[3]: Still creating... [40s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [40s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [40s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [40s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [40s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [40s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [50s elapsed]
proxmox_vm_qemu.server[3]: Still creating... [50s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [50s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [50s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [50s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [50s elapsed]
proxmox_vm_qemu.server[3]: Still creating... [1m0s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [1m0s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [1m0s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [1m0s elapsed]
proxmox_vm_qemu.server[3]: Creation complete after 1m1s [id=pve/qemu/503]
proxmox_vm_qemu.server[5]: Still creating... [1m0s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [1m0s elapsed]
proxmox_vm_qemu.server[2]: Still creating... [1m10s elapsed]
proxmox_vm_qemu.server[4]: Still creating... [1m10s elapsed]
proxmox_vm_qemu.server[0]: Still creating... [1m10s elapsed]
proxmox_vm_qemu.server[2]: Creation complete after 1m11s [id=pve/qemu/502]
proxmox_vm_qemu.server[5]: Still creating... [1m10s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [1m10s elapsed]
proxmox_vm_qemu.server[0]: Creation complete after 1m16s [id=pve/qemu/500]
proxmox_vm_qemu.server[4]: Creation complete after 1m16s [id=pve/qemu/504]
proxmox_vm_qemu.server[5]: Still creating... [1m20s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [1m20s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [1m30s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [1m30s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [1m40s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [1m40s elapsed]
proxmox_vm_qemu.server[5]: Still creating... [1m50s elapsed]
proxmox_vm_qemu.server[1]: Still creating... [1m50s elapsed]
proxmox_vm_qemu.server[1]: Creation complete after 1m57s [id=pve/qemu/501]
proxmox_vm_qemu.server[5]: Still creating... [2m0s elapsed]
proxmox_vm_qemu.server[5]: Creation complete after 2m7s [id=pve/qemu/505]

Apply complete! Resources: 6 added, 0 changed, 6 destroyed.

Outputs:

instance_ip_address = [
  "192.168.0.94",
  "192.168.0.84",
  "192.168.0.77",
  "192.168.0.79",
  "192.168.0.88",
  "192.168.0.90",
]
instance_mac_address = [
  "9A:5C:C4:65:7D:E7",
  "56:A9:83:60:35:E3",
  "BA:B4:43:96:16:C9",
  "5E:AE:45:4A:D5:CA",
  "BE:C9:48:E9:22:2B",
  "12:99:C1:3E:BA:C9",
]
instance_name = [
  "k8s-1",
  "k8s-2",
  "k8s-3",
  "k8s-4",
  "k8s-5",
  "k8s-6",
]
```
