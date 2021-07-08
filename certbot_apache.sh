#!/bin/bash

printf "\n"
echo "#####################################"
echo "######### INSTALLING CERTBOT ########"
echo "#####################################"
printf "\n"

read -r -p "Enter your domain name (Eg: mydomain.com) : " DOMAIN

sudo apt install python-certbot-apache -y
sudo apache2ctl configtest && sudo systemctl reload apache2

printf "\n"
printf "\n"

sudo certbot --apache -d $DOMAIN -d www.$DOMAIN
