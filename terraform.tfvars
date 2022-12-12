/*
 * DO NOT PUT ANY SENSITIVE VALUES HERE
 * Put all sensitive values into a file named 'secrets.auto.tfvars'
 *
 * The file 'secrets.auto.tfvars' will be auto-loaded just like
 * the file 'terraform.tfvars' and it is also in the .gitignore file
 * so that you cannot accidentally check-in any sensitive values.
 *
 */

vm_count = 3

ssh_public_key  = "/home/brian/.ssh/brian@pve-ed25519.pub"
template_name   = "ubuntu-template"
target_node     = "pve"
start_on_boot   = false
vm_id_start     = 500
vm_cores        = 2
vm_sockets      = 1
vm_name         = "k8s-"
vm_memory       = 2048
vm_full_clone   = false
agent           = true

disk            = {
    storage = "vz-disks"
    size    = "32G"
    type    = "scsi"
}

