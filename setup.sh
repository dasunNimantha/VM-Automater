#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

printf "\n"
echo "#####################################"
echo "### INSTALLING NECESSARY PACKAGES ###"
echo "#####################################"
printf "\n"

sudo apt install git zip ufw iptables openssh-server

printf "\n"
echo "#####################################"
echo "###### INSTALLING WEB SERVERS  ######"
echo "#####################################"
printf "\n"

printf "\n"
echo "Available Web Servers"
printf "\n"

printf "[1] Apache\n"
printf "[2] Nginx\n"

read -r -p "Select the server type that you want to configure or 0 to skip : " WEBSERVER
inputValidator "$WEBSERVER"

if [ "$WEBSERVER" == 1 ]; then
     echo "Configuring Apache Server"
     sudo apt install apache2 -y
     sudo systemctl enable apache2
     sudo systemctl start apache2
elif [ "$WEBSERVER" == 2 ]; then
     echo "Configuring Nginx Server"
     sudo apt install nginx -y
     sudo systemctl enable nginx
     sudo systemctl start nginx
elif [ "$WEBSERVER" == 0 ]; then
     echo "Skipping web server installation"
fi
