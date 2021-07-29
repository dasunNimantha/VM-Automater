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
sudo apt install docker-compose -y
sudo usermod -aG docker ${USER}
su - ${USER}

# additional packages

#portainer

while true; do
     printf "\n"
     read -r -p "Do you want to install portainer [Container management Web-UI] ? (Y/N) : " isPortainer
     case $isPortainer in
     [Yy]*)
          docker volume create portainer-data
          docker run -d --name portainer -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer-data:/data portainer/portainer-ce
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done


 