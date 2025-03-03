packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_username" {
  type = string
  default = "root@pam"
}

variable "proxmox_password" {
  type = string
  default = ""
}


source "proxmox-iso" "kali" {
   


  boot_command = [
  "<esc><wait>",
  "install <wait>",
  " auto=true priority=critical",
  " debian-installer/locale=en_US",
  " keyboard-configuration/layoutcode=us",
  " keyboard-configuration/xkb-keymap=us",
  " console-setup/layoutcode=us",
  " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kali-preseed.cfg <enter>"

  ]

  disks {
      disk_size         = "40G"
      storage_pool      = "local-lvm"
      type              = "scsi"
    }
 

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }


    boot_iso {
      type = "scsi"
      iso_url = "https://cdimage.kali.org/kali-2024.4/kali-linux-2024.4-installer-amd64.iso"
      iso_storage_pool = "local"
      iso_checksum = "file:https://cdimage.kali.org/kali-2024.4/SHA256SUMS"
      unmount = "true"
    }

  username = var.proxmox_username
  password = var.proxmox_password
  qemu_agent = "true"
  node             = "pve"
  http_directory   = "http"
  proxmox_url      =  "https://192.168.50.20:8006/api2/json"
  insecure_skip_tls_verify ="true"
  template_description = "kali-template"
  template_name         = "kali-template"

  ssh_username = "root"
  ssh_password = "kali"
  ssh_timeout = "20m"

  memory = "8192"
  cores = "2"
  sockets = "2"
  os = "l26"

 } 

build {
  sources = ["source.proxmox-iso.kali"]


}



