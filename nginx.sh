#!/bin/bash

echo "Configuring Nginx Server"
sudo apt install nginx apache2-utils -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

printf "\n"
echo "#####################################"
echo "####### SECURING YOUR SERVER  #######"
echo "#####################################"
printf "\n"
