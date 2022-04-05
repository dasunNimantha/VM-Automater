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

## nginx conf file configurations
sudo sed -i "s/# server_tokens off;/server_tokens off;/" /etc/nginx/nginx.conf
sudo sed -i "/server_tokens off;/a\\
\\tproxy_hide_header X-Powered-By;\\
\\tadd_header X-Frame-Options SAMEORIGIN;\\
\\tadd_header X-Content-Type-Options nosniff;\\
\\tadd_header X-XSS-Protection \"1; mode=block\";\\
\\tadd_header Strict-Transport-Security 'max-age=31536000' always;" /etc/nginx/nginx.conf


while true; do
    printf "\n"
    read -r -p "Do you want to install ModSecurity WAF ? (Y/N) : " isModSec
    case $isModSec in
    [Yy]*)
        chmod +x modsecurity.sh
        sudo ./modsecurity.sh
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n." ;;
    esac
done

sudo systemctl restart nginx