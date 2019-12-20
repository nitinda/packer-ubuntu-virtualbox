# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.2.6"

Vagrant.configure("2") do |config|

  config.vm.box          = "nitindas/ubuntu-18"
   config.vm.box_version = "04.3-1576803201"
   
   config.vm.box_check_update = true
   config.vm.boot_timeout     = 6000
   
   config.vm.provider "virtualbox" do |v|
    # Customize Name of VM:
     v.name = "ubuntu-18.04.3-1576803201-amd64"
    # Display the VirtualBox GUI when booting the machine
     v.gui = true
    # Customize the amount of memory on the VM:
     v.memory = "8192"
    # Customize the amount of cpu on the VM:
     v.cpus = 2
    # Customize video memory
     v.customize ["modifyvm", :id, "--vram", "128"]
    # Shared Clipboard
     v.customize ['modifyvm', :id, '--clipboard', 'bidirectional'] 
    # Enable Drag and Drop
     v.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
    # Enable Remote Display
     v.customize ["modifyvm", :id, "--vrde", "on"]
     v.customize ["modifyvm", :id, "--vrdeport", "5000,5010-5012"]
   end
   
   config.vm.provision "shell", inline: <<-SHELL
    # Install visual studio code
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get install apt-transport-https
    sudo apt-get install -y code

    # Install Docker
    sudo apt-get install ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" 
    sudo apt-get install -y docker-ce

    # Instal NodeJs    
    curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install -y yarn

    # Add local user
    sudo groupadd nitindas
    sudo useradd -m -g nitindas -G sudo,docker -c notdefined -p $(openssl passwd -1 nitindas) --shell /bin/bash nitindas

    # HoueKeping
    sudo dpkg --list | awk '{ print $2 }' | egrep -i -- 'simple-scan|-sudoku|Aisleriot|-Mahjongg|-Mines|Thunderbird|libreoffice-|shotwell|remmina' | sudo xargs apt-get -y purge
    sudo apt-get -y clean
    sudo apt-get -y autoremove

   SHELL
   
   # Running Provisioners Always
   config.vm.provision "shell", run: "always", inline: <<-SHELL
    date
   SHELL
end