#!/bin/bash

# Install script for docker and docker-compose
printf "\n"
echo "#####################################"
echo "######### INSTALLING DOCKER #########"
echo "#####################################"
printf "\n"

curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sh get-docker.sh
sudo systemctl enable docker
sudo systemctl start docker
sudo apt install docker-compose
sudo usermod -aG docker ${USER}
su - ${USER}
