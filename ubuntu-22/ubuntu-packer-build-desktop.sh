#!/bin/bash

# Function
Status () {
  if [[ $1 -ne 0 ]]
  then
      echo ">>>>>>>>>>>>>>>>> Ended with Errors <<<<<<<<<<<<<<<<<<<<<<"
      exit 1
  fi
}
 
 
cd /C/vscode/packer-ubuntu-virtualbox/ubuntu-20
 
# Create vagrant-cloud Token
# Creating temporary data.json file
 
ATLAS_TOKEN_GEN=""

#  Check Status
Status $?

# Export Env Variable
export VAGRANT_CLOUD_TOKEN=$ATLAS_TOKEN_GEN
 
# Run Packer validate
/c/Packer/packer validate ubuntu-22.04-live-server.pkr.hcl

#  Check Status
Status $?

# Run Packer
export PACKER_LOG=0
/c/Packer/packer build -color=false -timestamp-ui -force ubuntu-22.04-live-server.pkr.hcl