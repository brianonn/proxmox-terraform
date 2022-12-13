variable "ssh_public_key" {
    type        = string
    description = "The SSH public key that will be set on the VM when it's created"
}

variable "target_node" {
    type        = string
    description = "The target node where all VMs will be created"
}

variable "template_name" {
    type        = string
    description = "The name of the template that will be cloned to make VMs"
}

variable "agent" {
    type        = bool
    default     = true
    description = "Whether or not to enable the QEMU agent in Proxmox. This also requires the agent to be running in the VM"
}

variable "start_on_boot" {
    type        = bool
    default     = true
    description = "Start this VM on server boot"
}

variable "vm_count" {
    type        = number
    default     = 1
    description = "Set this number to the number of VMs you want to create. Set it to '0' to destroy all resources"
}

variable "vm_id_start" {
    type        = number
    description = "The number to start VM id at. Multiple VM's will increment from here"
}

variable "vm_name" {
    type        = string
    default     = "vm"
    description = "The name of the VM created. If there is more than 1 then this will be a basename"
}

variable "vm_full_clone" {
    type        = bool
    default     = true
    description = "Do a full clone when true, linked clone when false"
}

variable "vm_cores" {
    type        = number
    default     = 2
    description = "How many cores for the VM"
}

variable "vm_sockets" {
    type        = number
    default     = 1
    description = "How many sockets for the VM"
}

variable "vm_memory" {
    type        = number
    default     = 512
    description = "The amount of memory to allocate to the VM"
}

variable "disk" {
    type        = map
    default     = {
      storage = "local"
      size    = "10G"
      type    = "scsi"
    }
    description = "The disk storage parameters to attach to the VM"
}

variable "ipconfig0" {
    type        = string
    default     = "ip=dhcp,ip6=dhcp"
    description = "Sets the IP configuration for the first ethernet NIC of each VM"
}
