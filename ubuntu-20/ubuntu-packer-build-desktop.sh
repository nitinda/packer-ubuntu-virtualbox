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
 
 
cd /c/BitBucket/ubuntu-VagrantBox-Packer/ubuntu-20.04
 
# Create vagrant-cloud Token
# Creating temporary data.json file
 
echo -e "{\n    \"token\": {\n        \"description\": \"Login from cURL\"\n    },\n    \"user\": {\n        \"login\": \"${TOKENUSER}\",\n        \"password\": \"${TOKENPASS}\"\n    }\n}" > data.json

ATLAS_TOKEN_GEN=$(curl --header "Content-Type: application/json" https://app.vagrantup.com/api/v1/authenticate --data @data.json|sed 's/\(.*\)"token":"\(.*\)","token_\(.*\)/\2/g')

#  Check Status
Status $?

# Export Env Variable
export VAGRANT_CLOUD_TOKEN=$ATLAS_TOKEN_GEN
 
# Run Packer validate
packer validate ubuntu-20.04-live-server.json

#  Check Status
Status $?

# Run Packer
export PACKER_LOG=0
packer build -color=false -timestamp-ui -force ubuntu-20.04-live-server.json

# Delete Token
curl --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" --request DELETE https://app.vagrantup.com/api/v1/authenticate

# Remove Files
rm -f data.json