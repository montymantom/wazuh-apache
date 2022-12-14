#! /bin/bash

#Update linux
sudo apt-get update

#Download and install apache
sudo apt-get install apache2 -y

#Allow HTTP traffic through the firewall 
sudo ufw enable
sudo ufw allow 'Apache'

# Install GPG keys
sudo apt-get install gnupg apt-transport-https


#Clone wazuh git repository
git clone https://github.com/wazuh/wazuh-docker.git -b v4.3.10
cd wazuh-docker/single-node

#Generate desired certificates
sudo docker-compose -f generate-indexer-certs.yml run --rm generator
