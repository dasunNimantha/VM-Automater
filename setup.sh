#!/bin/bash

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

########################################
############# MAIN CODE   ##############
########################################

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
echo "########## FAIL2BAN SETUP  ##########"
echo "#####################################"
printf "\n"

chmod +x fail2ban.sh
./fail2ban.sh

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

if [ "$WEBSERVER" == 1 ]; then
     chmod +x apache.sh
     sudo ./apache.sh
elif [ "$WEBSERVER" == 2 ]; then
     chmod +x nginx.sh
     sudo ./nginx.sh
fi

while true; do
     printf "\n"
     read -r -p "Do you want to enable cloudflare ip blocking ? (Y/N) : " isDocker
     case $isDocker in
     [Yy]*)
          chmod +x cloudflare-iptables.sh
          ./cloudflare-iptables.sh
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done

while true; do
     printf "\n"
     read -r -p "Do you want to install docker & docker-compose ? (Y/N) : " isDocker
     case $isDocker in
     [Yy]*)
          chmod +x docker.sh
          ./docker.sh
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done

while true; do
     printf "\n"
     read -r -p "Do you want to install Pi-Hole (Network wide ad-blocker) ? (Y/N) : " isDocker
     case $isDocker in
     [Yy]*)
          chmod +x pi-hole.sh
          ./pi-hole.sh
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done
