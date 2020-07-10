#!/bin/bash -eux

echo "Configure User Vagant ............. Starting $(date)"

# groupadd vagrant
# useradd -m -g vagrant -G sudo -c vagrant -p $(openssl passwd -1 vagrant) --shell /bin/bash vagrant
# echo 'Defaults:vagrant !requiretty' > /etc/sudoers.d/vagrant
# echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
# chmod 440 /etc/sudoers.d/vagrant

pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub";
mkdir -m 700 /home/vagrant/.ssh

if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O /home/vagrant/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > /home/vagrant/.ssh/authorized_keys;
else
    echo "Cannot download vagrant public key";
    exit 1;
fi

chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh;
chmod -R go-rwsx /home/vagrant/.ssh;

ls -lrt /home/vagrant/.ssh/authorized_keys /home/vagrant/.ssh

echo "Configure User Vagant ............. End $(date)"