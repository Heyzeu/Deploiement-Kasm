packer {
  required_plugins {
    virtualbox-iso = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variable "vm_name" {
  default = "debian12-vm"
}

source "virtualbox-iso" "debian" {
  iso_url           = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso"
  iso_checksum      = "sha512:069d47e9013cb1d651d30540fe8ef6765e5d60c8a14c8854dfb82e50bbb171255d2e02517024a392e46255dcdd18774f5cbd7e9f3a47aa1b489189475de62675"

  vm_name           = var.vm_name
  guest_os_type     = "Debian_64"

  ssh_username      = "ansible"
  ssh_password      = "ansible" # C'est le mot de passe que votre preseed.cfg configure pour l'utilisateur 'ansible'
  ssh_wait_timeout  = "10s"
  ssh_timeout       = "10s"                # Maintenu pour la durée des tentatives individuelles
  pause_before_connecting = "2m"          # Ajout du tempo de pause avant la 1ère tentative SSH


  disk_size         = 90000
  memory            = 5096
  cpus              = 1

  headless          = false

  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US locale=en_US ",
    "keyboard-configuration/modelcode=pc105 ",
    "keyboard-configuration/layout=us ",
    "keyboard-configuration/variant= ",
    "netcfg/get_hostname=debian ",
    "fb=false debconf/frontend=noninteractive ",
    "<enter><wait5>"
  ]

  # La commande d'arrêt est simplifiée car 'ansible' aura les droits sudo sans mot de passe après le provisioner
  # (maintenant configuré via preseed.cfg)
  shutdown_command  = "sudo shutdown -P now"
  http_directory    = "http"
}

build {
  sources = ["source.virtualbox-iso.debian"]
  

}
