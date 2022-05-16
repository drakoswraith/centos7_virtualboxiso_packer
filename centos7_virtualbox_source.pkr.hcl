packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

#------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------

variable compression_level {
  type = number
  default = 6
}

variable cpu_count {
  type = number
  default = 1
}

variable disk_size {
  type = number
  default = 8000
}

variable hard_drive_discard {
  type = bool
  default = true
}

variable hard_drive_interfase {
  type = string
  default = "sata"
}

variable hard_drive_nonrotational {
  type = bool
  default = true
}

variable headless {
  type = bool
  default = false
}

variable iso_url {
  type = string
  default = "file://d:/iso/CentOS-7-x86_64-Minimal-2009.iso"
}
variable iso_checksum {
  type = string
  default = "md5:A4711C4FA6A1FB32BD555FAE8D885B12"
}

variable memory_size {
  type = number
  default = 2048
}

variable ssh_timeout {
  type = string
  default = "60m"
}

variable ssh_handshake_attempts {
  type = number
  default = 50
}

variable nic {
  type = string
  default = "nat"
}

variable nictype {
  type = string
  default = "virtio"
}

variable natnetwork {
  type = string
  default = "natnetwork"
}


#------------------------------------------------------------------------
# The source
#------------------------------------------------------------------------
source "virtualbox-iso" "centos7" {
  guest_os_type = "RedHat_64"

  iso_url = var.iso_url
  iso_checksum = var.iso_checksum
  
  communicator = "ssh"
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  #skip_nat_mapping = "true"
  #ssh_host = "192.168.0.79"
  #ssh_port = "22"
  ssh_handshake_attempts = var.ssh_handshake_attempts
  ssh_timeout = var.ssh_timeout

  cpus = var.cpu_count
  memory = var.memory_size
  disk_size = var.disk_size
  hard_drive_discard = var.hard_drive_discard
  hard_drive_nonrotational = var.hard_drive_nonrotational
  headless = var.headless
  http_directory = "http"
  guest_additions_mode = "upload"
  guest_additions_path = "/home/vagrant/VBoxGuestAdditions.iso"

  boot_wait = "5s"
  boot_command = [
    "<esc>",
    "<wait>",
    "linux inst.ks=http://{{.HTTPIP}}:{{.HTTPPort}}/ks.cfg biosdevname=0 net.ifnames=0",
    "<enter>"
  ]
    
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--rtcuseutc", "on"],
    ["modifyvm", "{{.Name}}", "--nic1", var.nic, "--nictype1", var.nictype],
    ["modifyvm", "{{.Name}}", "--nat-network1", var.natnetwork],
    # ["modifyvm", "{{.Name}}", "--nic1", "bridged"],
    # ["modifyvm", "{{.Name}}", "--bridgeadapter1", "Intel(R) Wi-Fi 6 AX201 160MHz"],
    # ["modifyvm", "{{.Name}}", "--macaddress1", "0800270AF728"],
  ]

  shutdown_command = "sudo systemctl poweroff"
  
  export_opts = [
    "--manifest",
    "--vsys", "0",
  ]
  format = "ova"
}

