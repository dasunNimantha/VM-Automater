#!/bin/bash

printf "\n"
echo "#####################################"
echo "######## INSTALLING CROWDSEC ########"
echo "#####################################"
printf "\n"

curl -s https://packagecloud.io/install/repositories/crowdsec/crowdsec/script.deb.sh | sudo bash
sudo apt-get update -y
sudo apt-get install crowdsec -y
sudo cscli collections install crowdsecurity/nginx