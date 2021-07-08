#!/bin/bash

echo "Configuring Apache Server"
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

printf "\n"
echo "#####################################"
echo "####### SECURING YOUR SERVER  #######"
echo "#####################################"
printf "\n"

while true; do
    printf "\n"
    read -r -p "Do you want to add SSL certificate via letsencrypt ? (Y/N) : " isSSL
    case $isSSL in
    [Yy]*)
        chmod +x certbot_apache.sh
        ./certbot_apache.sh
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n." ;;
    esac
done
