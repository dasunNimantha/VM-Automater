#!/bin/bash

printf "\n"
echo "#####################################"
echo "######### INSTALLING CERTBOT ########"
echo "#####################################"
printf "\n"

read -r -p "Enter your domain name (Eg: mydomain.com) : " DOMAIN

sudo apt install python-certbot-nginx -y
sudo sed -i "s/server_name _;/server_name $DOMAIN www.$DOMAIN;/" /etc/nginx/sites-available/default
sudo nginx -t && sudo systemctl reload nginx

printf "\n"
printf "\n"

sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN
