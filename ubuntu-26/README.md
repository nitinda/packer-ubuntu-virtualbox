# Ubuntu 26.04 LTS — Packer VirtualBox Image

## Directory layout

```
.
├── ubuntu-26.04-virtualbox.pkr.hcl   # Main Packer template
├── http/
│   ├── user-data                      # Ubuntu autoinstall config
│   └── meta-data                      # cloud-init meta-data (required, can be empty)
└── README.md
```

## Prerequisites

| Tool | Minimum version |
|------|----------------|
| [Packer](https://developer.hashicorp.com/packer/install) | 1.9.0 |
| [VirtualBox](https://www.virtualbox.org/wiki/Downloads) | 7.0 |

## ⚠️ Before you build

1. **Update the ISO URL & checksum** in the `.pkr.hcl` file once Ubuntu 26.04 LTS is
   officially released (expected April 2026).  
   Find checksums at: `https://releases.ubuntu.com/26.04/SHA256SUMS`

2. **Update the password hash** in `http/user-data`.  
   Generate a new one:
   ```bash
   mkpasswd --method=SHA-512 your_password
   # or
   openssl passwd -6 your_password
   ```

3. **Change the default password** (`ubuntu`) before any production or shared use.

## Build

```bash
# Install the VirtualBox plugin
packer init ubuntu-26.04-virtualbox.pkr.hcl

# Validate the template
packer validate ubuntu-26.04-virtualbox.pkr.hcl

# Build the image (OVA exported to ./output-ubuntu-26.04/)
packer build ubuntu-26.04-virtualbox.pkr.hcl
```

### Override variables at build time

```bash
packer build \
  -var "vm_name=my-ubuntu" \
  -var "cpus=4" \
  -var "memory=4096" \
  -var "disk_size=81920" \
  -var "headless=false" \
  ubuntu-26.04-virtualbox.pkr.hcl
```

### Using a var-file

```bash
packer build -var-file=vars.pkrvars.hcl ubuntu-26.04-virtualbox.pkr.hcl
```

Example `vars.pkrvars.hcl`:
```hcl
cpus        = 4
memory      = 8192
disk_size   = 81920
ssh_password = "mysecretpassword"
```

## Output

The build produces:
- `output-ubuntu-26.04/<vm_name>.ova` — importable VirtualBox appliance
- `output-ubuntu-26.04/manifest.json` — build metadata

## Default credentials

| Field    | Value    |
|----------|----------|
| Username | `ubuntu` |
| Password | `ubuntu` |
| Sudo     | passwordless |

## Customization tips

- **Add provisioners** in the `build` block to install your own software.
- **Swap the storage layout** in `http/user-data` to `direct` for a non-LVM disk.
- **Enable clipboard/drag-and-drop** by adding `--clipboard bidirectional` to `vboxmanage`.
