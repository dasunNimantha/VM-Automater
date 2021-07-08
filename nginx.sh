#!/bin/bash

echo "Configuring Nginx Server"
sudo apt install nginx apache2-utils -y
sudo systemctl enable nginx
sudo systemctl start nginx

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
        chmod +x certbot_nginx.sh
        ./certbot_nginx.sh
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n." ;;
    esac
done
