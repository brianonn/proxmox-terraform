## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.7.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.7.4 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.server](https://registry.terraform.io/providers/telmate/proxmox/2.7.4/docs/resources/vm_qemu) | resource |
| [template_file.ssh_key](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent"></a> [agent](#input\_agent) | Whether or not to enable the QEMU agent in Proxmox. This also requires the agent to be running in the VM | `bool` | `true` | no |
| <a name="input_disk"></a> [disk](#input\_disk) | The disk storage parameters to attach to the VM | `map` | <pre>{<br>  "size": "10G",<br>  "storage": "local",<br>  "type": "scsi"<br>}</pre> | no |
| <a name="input_ipconfig0"></a> [ipconfig0](#input\_ipconfig0) | Sets the IP configuration for the first ethernet NIC of each VM | `string` | `"ip=dhcp,ip6=dhcp"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The SSH public key that will be set on the VM when it's created | `string` | `"id_rsa.pub"` | no |
| <a name="input_start_on_boot"></a> [start\_on\_boot](#input\_start\_on\_boot) | Start this VM on server boot | `bool` | `true` | no |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | The target node where all VMs will be created | `string` | n/a | yes |
| <a name="input_template_name"></a> [template\_name](#input\_template\_name) | The name of the template that will be cloned to make VMs | `string` | n/a | yes |
| <a name="input_vm_cores"></a> [vm\_cores](#input\_vm\_cores) | How many cores for the VM | `number` | `2` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | Set this number to the number of VMs you want to create. Set it to '0' to destroy all resources | `number` | `1` | no |
| <a name="input_vm_full_clone"></a> [vm\_full\_clone](#input\_vm\_full\_clone) | Do a full clone when true, linked clone when false | `bool` | `true` | no |
| <a name="input_vm_id_start"></a> [vm\_id\_start](#input\_vm\_id\_start) | The number to start VM id at. Multiple VM's will increment from here | `number` | n/a | yes |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | The amount of memory to allocate to the VM | `number` | `512` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the VM created. If there is more than 1 then this will be a basename | `string` | `"vm"` | no |
| <a name="input_vm_sockets"></a> [vm\_sockets](#input\_vm\_sockets) | How many sockets for the VM | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The IPV4 address of the VM created |
| <a name="output_instance_mac_address"></a> [instance\_mac\_address](#output\_instance\_mac\_address) | The MAC address of the VM created |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The name of the VM created |
