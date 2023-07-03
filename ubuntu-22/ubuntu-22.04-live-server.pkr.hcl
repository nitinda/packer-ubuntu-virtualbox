
variable "ServerBaseVersion" {
  type    = string
  default = "22.04.2"
}

variable "box_tag" {
  type    = string
  default = "nitindas/ubuntu-22"
}

variable "vagrantcloud_token" {
  type    = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

variable "os_name" {
  type        = string
  description = "OS Brand Name"
  default     = "ubuntu"
}

variable "os_version" {
  type        = string
  description = "OS version number"
  default     = "22.04"
}

variable "os_arch" {
  type        = string
  description = "OS architecture type, x86_64 or aarch64"
  default     = "x86_64"
}

# locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

locals {
  timestamp                 = formatdate("YYYYMM.DD.0", timestamp())
  guest_additions_path      = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_additions_interface = "sata"
  guest_os_type             = "Ubuntu_64"
  virtualbox_version_file   = ".vbox_version"
  headless                  = false
  disk_size                 = 56320
  memory                    = 2048
  http_directory            = "subiquity/http"
  iso_checksum              = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
  iso_url                   = "https://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
  boot_wait                 = "10s"
  osdetails                 = "ubuntu-${local.vboxversion}-amd64"
  vboxversion               = var.ServerBaseVersion
  version                   = local.timestamp
  virtualbox_version        = "7.0.6"
  version_desc              = "Ubuntu 22.04 Vagrant box version ${local.timestamp}. Built with: virtualbox: ${local.virtualbox_version}, packer: '${packer.version}'"
  shutdown_command          = "echo 'vagrant'|sudo -S shutdown -P now"
  shutdown_timeout          = "15m"
  ssh_timeout               = "60m"
  ssh_password              = "vagrant"
  ssh_username              = "vagrant"
  vm_name                   = "${var.os_name}-${var.os_version}-amd64"
  output_directory          = "c:/vagrant-box"

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "4096"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--audio", "none"],
  ]
}

# could not parse template for following block: "template: hcl2_upgrade:2: bad character U+0060 '`'"
source "virtualbox-iso" "virtualbox" {

  boot_command = [
    "<wait>c<wait>",
    "set gfxpayload=keep<enter><wait>",
    "linux /casper/vmlinuz autoinstall ds='nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/' ---<enter><wait>",
    "initrd /casper/initrd<wait><enter><wait>",
    "boot<enter><wait>"
  ]

  boot_wait                 = local.boot_wait
  http_directory            = local.http_directory
  guest_additions_path      = local.guest_additions_path
  guest_additions_interface = local.guest_additions_interface
  guest_os_type             = local.guest_os_type
  virtualbox_version_file   = local.virtualbox_version_file
  headless                  = local.headless
  iso_checksum              = local.iso_checksum
  iso_url                   = local.iso_url
  memory                    = local.memory
  disk_size                 = local.disk_size
  output_directory          = local.output_directory
  shutdown_command          = local.shutdown_command
  shutdown_timeout          = local.shutdown_timeout
  ssh_handshake_attempts    = "1000"
  ssh_keep_alive_interval   = "90s"
  ssh_password              = local.ssh_password
  ssh_timeout               = local.ssh_timeout
  ssh_username              = local.ssh_username
  ssh_wait_timeout          = "30m"
  vm_name                   = local.vm_name
  vboxmanage                = local.vboxmanage
}

build {
  sources = ["source.virtualbox-iso.virtualbox"]

  provisioner "shell" {
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "scripts/update.sh",
      "scripts/motd.sh",
      "scripts/sshd.sh",
      "scripts/networking.sh",
      "scripts/sudoers.sh",
      "scripts/vagrant.sh",
      "scripts/systemd.sh",
      "scripts/virtualbox.sh",
      "scripts/cleanup.sh",
      "scripts/minimize.sh",
    ]
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      compression_level   = 9
      provider_override   = "virtualbox"
      output               = "${path.root}/../builds/${var.os_name}-${var.os_version}-${var.os_arch}.{{ .Provider }}.box"
    }
    post-processor "vagrant-cloud" {
      access_token        = "${var.vagrantcloud_token}"
      box_tag             = "${var.box_tag}"
      version             = "${local.vboxversion}-${local.version}"
      version_description = "${local.version_desc}"
    }
  }
}
