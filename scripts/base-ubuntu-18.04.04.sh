#!/bin/bash -eux

# # Disable daily apt unattended updates.
# echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

## Install updates
apt-get --assume-yes update
apt-get --assume-yes upgrade
apt --assume-yes update
apt --assume-yes upgrade

echo "=================== Start $(date) ==============================="
apt install --assume-yes tasksel perl gcc make git

tasksel install ubuntu-desktop-minimal

echo "===================== End $(date) ============================="