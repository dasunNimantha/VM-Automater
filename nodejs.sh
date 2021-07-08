#!/bin/bash

printf "\n"
echo "#####################################"
echo "######### INSTALLING NODEJS #########"
echo "#####################################"
printf "\n"

curl -sL https://deb.nodesource.com/setup_14.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs
sudo apt install build-essential
sudo npm i -g pm2
