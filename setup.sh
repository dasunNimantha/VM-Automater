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

while true; do
     printf "\n"
     read -r -p "Do you want to secure ssh ? (Y/N) : " isSSH
     case $isSSH in
     [Yy]*)
          chmod +x ssh.sh
          sudo ./ssh.sh
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done


printf "\n"
echo "#####################################"
echo "########## FAIL2BAN SETUP  ##########"
echo "#####################################"
printf "\n"

chmod +x fail2ban.sh
./fail2ban.sh

while true; do
     printf "\n"
     read -r -p "Do you want to install CyberPannel ? (Y/N) : " isCyberPannel
     case $isCyberPannel in
     [Yy]*)
          sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done


printf "\n"
echo "#####################################"
echo "###### INSTALLING WEB SERVERS  ######"
echo "#####################################"
printf "\n"

echo "Available Web Servers"
printf "\n"

printf "[1] Apache\n"
printf "[2] Nginx\n\n"

while true; do
     printf "\n"
     read -r -p "Select the server type that you want to configure or 0 to skip :" WEBSERVER
     case $WEBSERVER in
     [1]*)
          chmod +x apache.sh
          sudo ./apache.sh
          break
          ;;
     [2]*)
          chmod +x nginx.sh
          sudo ./nginx.sh
          break ;;
     [0]*)
          break ;;

     *) echo "Invalid Input.Please try again [1/2/0] : " ;;
     esac
done

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
     read -r -p "Do you want to install nodejs ? (Y/N) : " isNodejs
     case $isNodejs in
     [Yy]*)
          chmod +x nodejs.sh
          ./nodejs.sh
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
     read -r -p "Do you want to install and configure Open-VPN ? (Y/N) : " isOpenVPN
     case $isOpenVPN in
     [Yy]*)
          chmod +x open-vpn.sh
          ./open-vpn.sh
          sudo mv /root/thinkpad.ovpn /home/${USER}
          sudo chown ${USER} /home/${USER}/thinkpad.ovpn
          sudo sed -i "s/verb 3/verb 0/" /etc/openvpn/server/server.conf
          sudo systemctl restart openvpn-server@server.service

          printf "\n"
          echo "Open Vpn server configured successfully.You can download the configuration file on your home directory [thinkpad.ovpn]"
          printf "\n"
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
          printf "\n"
          echo "#####################################"
          echo "######### INSTALLING PIHOLE #########"
          echo "#####################################"
          printf "\n"

          curl -sSL https://install.pi-hole.net | bash
          break
          ;;
     [Nn]*) break ;;
     *) echo "Please answer y or n." ;;
     esac
done
