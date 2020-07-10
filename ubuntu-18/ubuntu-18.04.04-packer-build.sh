#!/bin/bash
 
TOKENUSER=${1:?}
shift
TOKENPASS=${1:?}
shift
 
# Function
Status () {
  if [[ $1 -ne 0 ]]
  then
      echo ">>>>>>>>>>>>>>>>> Ended with Errors <<<<<<<<<<<<<<<<<<<<<<"
      exit 1
  fi
}
 
 
cd /c/BitBucket/ubuntu-VagrantBox-Packer
 
# Create vagrant-cloud Token
# Creating temporary data.json file
 
echo -e "{\n    \"token\": {\n        \"description\": \"Login from cURL\"\n    },\n    \"user\": {\n        \"login\": \"${TOKENUSER}\",\n        \"password\": \"${TOKENPASS}\"\n    }\n}" > data.json

ATLAS_TOKEN_GEN=$(curl --header "Content-Type: application/json" https://app.vagrantup.com/api/v1/authenticate --data @data.json|sed 's/\(.*\)"token":"\(.*\)","token_\(.*\)/\2/g')

#  Check Status
Status $?
 
# Export Env Variable
export VAGRANT_CLOUD_TOKEN=$ATLAS_TOKEN_GEN
 
# Run Packer validate
packer validate ubuntu-18.04.04-amd64.json
 
#  Check Status
Status $?
 
# Run Packer
packer build ubuntu-18.04.04-amd64.json
 
 
# Remove Files
rm -f data.json