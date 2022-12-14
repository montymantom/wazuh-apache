#! /bin/bash

#Update linux
sudo apt-get update

#Download and install apache
sudo apt-get install apache2 -y

#Allow HTTP traffic through the firewall 
sudo ufw enable
sudo ufw allow 'Apache'

#Clone wazuh git repository
git clone https://github.com/wazuh/wazuh-docker.git -b v4.3.10
cd wazuh-docker/single-node

##If you have not installed docker, uncommented the following lines:
#sudo apt install gnome-terminal
#sudo apt remove docker-desktop
#sudo apt-get update
#sudo apt-get install docker.io
#sudo snap install docker

#Generate desired certificates
sudo docker-compose -f generate-indexer-certs.yml run --rm generator
sudo docker-compose up -desired

# Install GPG keys
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

#Add repository
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
sudo apt-get update

#Deploy wazuh agent
ip4=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
WAZUH_MANAGER="$ip4" apt-get install wazuh-agent

#Start the wazuh agent service
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent


