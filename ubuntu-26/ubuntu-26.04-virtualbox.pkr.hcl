packer {
  required_version = ">= 1.9.0"

  required_plugins {
    virtualbox = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

# ─────────────────────────────────────────────
# Variables
# ─────────────────────────────────────────────

variable "vm_name" {
  type    = string
  default = "ubuntu-26.04"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = number
  default = 40960 # 40 GB in MB
}

variable "headless" {
  type    = bool
  default = true
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_password" {
  type      = string
  default   = "ubuntu"
  sensitive = true
}

# Ubuntu 26.04 LTS (Noble Numbat successor — update ISO URL when released)
variable "iso_url" {
  type    = string
  default = "https://releases.ubuntu.com/26.04/ubuntu-26.04-live-server-amd64.iso"
}

variable "iso_checksum" {
  type    = string
  # Update this with the official SHA-256 checksum once the ISO is published.
  # Run: sha256sum ubuntu-26.04-live-server-amd64.iso
  default = "sha256:dec49008a71f6098d0bcfc822021f4d042d5f2db279e4d75bdd981304f1ca5d9"
}

variable "output_directory" {
  type    = string
  default = "output-ubuntu-26.04"
}

# ─────────────────────────────────────────────
# Source
# ─────────────────────────────────────────────

source "virtualbox-iso" "ubuntu" {
  # ── VM metadata ──────────────────────────────
  vm_name          = var.vm_name
  guest_os_type    = "Ubuntu_64"
  headless         = var.headless
  output_directory = var.output_directory

  # ── Hardware ─────────────────────────────────
  cpus      = var.cpus
  memory    = var.memory
  disk_size = var.disk_size

  # ── ISO ──────────────────────────────────────
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # ── Boot ─────────────────────────────────────
  # Ubuntu 22.04+ live-server ISO shows a GRUB menu first.
  # We wait for GRUB to appear, press 'e' to edit the default entry,
  # navigate to the linux line and append autoinstall + nocloud seed URL,
  # then boot with Ctrl-x.  This bypasses the interactive language screen
  # entirely because autoinstall is signalled at the kernel level.
  boot_wait = "3s"
  boot_command = [
    # Wait for GRUB menu, then open the editor for the first entry
    "<wait3>e<wait2>",

    # In the GRUB editor, navigate to the end of the 'linux' line.
    # The live-server ISO linux line ends with '---'; we move down to it
    # and use End to reach the end of that line.
    "<down><down><down><end>",

    # Remove the trailing '---' (3 chars) and replace with autoinstall params.
    # Note: 'autoinstall' keyword + nocloud-net datasource with HTTP seed URL.
    # We use '<bs>' to delete characters if needed, then append our params.
    " autoinstall ds=nocloud-net\\;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",

    # Boot the edited entry
    "<leftCtrlOn>x<leftCtrlOff>"
  ]

  # ── Autoinstall HTTP server ───────────────────
  # Packer will serve files from http/ on a random local port.
  http_directory = "http"

  # ── SSH communicator ─────────────────────────
  communicator            = "ssh"
  ssh_username            = var.ssh_username
  ssh_password            = var.ssh_password
  ssh_timeout             = "60m"
  ssh_handshake_attempts  = 500
  ssh_keep_alive_interval = "90s"

  # ── VirtualBox extras ────────────────────────
  guest_additions_mode = "upload"   # upload ISO then install via provisioner
  virtualbox_version_file = "/tmp/.vbox_version"

  # ── Export format ────────────────────────────
  format = "ova"

  # ── VBoxManage tweaks ────────────────────────
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--vram", "16"],
    ["modifyvm", "{{.Name}}", "--audio", "none"],
    ["modifyvm", "{{.Name}}", "--usb", "off"],
  ]

  # Graceful shutdown command so VirtualBox can export cleanly
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
}

# ─────────────────────────────────────────────
# Build
# ─────────────────────────────────────────────

build {
  name    = "ubuntu-26.04-virtualbox"
  sources = ["source.virtualbox-iso.ubuntu"]

  # ── Wait for cloud-init / autoinstall to finish ──
  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init to finish...'",
      "sudo cloud-init status --wait || true"
    ]
  }

  # ── System updates ───────────────────────────
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get dist-upgrade -y",
      "sudo apt-get autoremove -y",
      "sudo apt-get clean"
    ]
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  # ── VirtualBox Guest Additions ───────────────
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt-get install -y build-essential dkms linux-headers-$(uname -r)",
      "VBOX_VERSION=$(cat /tmp/.vbox_version)",
      "sudo mount -o loop /home/${var.ssh_username}/VBoxGuestAdditions_$${VBOX_VERSION}.iso /mnt",
      "sudo /mnt/VBoxLinuxAdditions.run --nox11 || true",
      "sudo umount /mnt",
      "rm -f /home/${var.ssh_username}/VBoxGuestAdditions_$${VBOX_VERSION}.iso"
    ]
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  # ── Useful base packages ─────────────────────
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "sudo apt-get install -y curl wget git vim nano htop net-tools unzip"
    ]
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  # ── Minimize disk footprint ──────────────────
  provisioner "shell" {
    inline = [
      "sudo apt-get autoremove -y",
      "sudo apt-get clean",
      "sudo rm -rf /var/lib/apt/lists/*",
      "sudo dd if=/dev/zero of=/EMPTY bs=1M || true",
      "sudo rm -f /EMPTY",
      "sync"
    ]
  }

  # ── Artifact metadata ────────────────────────
  post-processor "manifest" {
    output     = "${var.output_directory}/manifest.json"
    strip_path = true
  }
}
