#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

printf "\n"
echo "#####################################"
echo "### INSTALLING NECESSARY PACKAGES ###"
echo "#####################################"
printf "\n"

sudo apt install git nano zip ufw iptables curl openssh-server -y


printf "\n"
echo "#####################################"
echo "######## SSH CONFIGURATIONS  ########"
echo "#####################################"
printf "\n"

chmod +x ssh.sh
sudo ./ssh.sh

printf "\n"
echo "#####################################"
echo "###### INSTALLING WEB SERVERS  ######"
echo "#####################################"
printf "\n"

echo "Available Web Servers"
printf "\n"

printf "[1] Apache\n"
printf "[2] Nginx\n\n"

read -r -p "Select the server type that you want to configure or 0 to skip : " WEBSERVER

########################################
######### REQUIRED FUNCTIONS  ##########
########################################

get_distribution() {
     lsb_dist=""
     # Every system that we officially support has /etc/os-release
     if [ -r /etc/os-release ]; then
          lsb_dist="$(. /etc/os-release && echo "$ID")"
     fi
     # Returning an empty string here should be alright since the
     # case statements don't act unless you provide an actual value
     echo "$lsb_dist"
}

if [ "$WEBSERVER" == 1 ]; then
     chmod +x apache.sh
     sudo ./apache.sh
elif [ "$WEBSERVER" == 2 ]; then
     chmod +x nginx.sh
     sudo ./nginx.sh
fi
