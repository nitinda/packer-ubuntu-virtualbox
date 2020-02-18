#!/bin/bash -eux

echo "Configure User Vagant ............. Starting $(date)"

pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub";
mkdir -p $HOME/.ssh;
if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O $HOME/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > $HOME/.ssh/authorized_keys;
else
    echo "Cannot download vagrant public key";
    exit 1;
fi
chown -R vagrant $HOME/.ssh;
chmod -R go-rwsx $HOME/.ssh;

echo "Configure User Vagant ............. End $(date)"
