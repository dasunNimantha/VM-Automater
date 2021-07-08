#!/bin/bash

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo cp configs/ssh/sshd_config /etc/ssh/sshd_config

## change default ssh port
read -r -p "Enter a custom SSH Port (1025-30000) : " SSHPORT
sudo sed -i "s/#Port 22/Port $SSHPORT/" /etc/ssh/sshd_config
printf "\n"
echo "######## SSH Port changed to $SSHPORT successfully.Allow this port in your firewall ########"
printf "\n"
## add pulic key and disable password authentication

while true; do
    printf "\n"
    read -p"Do you want to add a public key and disable password authentication ? (Y/N) : " isPubOnly
    case $isPubOnly in
    [Yy]*)
        sudo touch ~/.ssh/authorized_keys
        sudo nano ~/.ssh/authorized_keys && sudo sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
        sudo sshd -t && sudo service sshd reload

        printf "\n\n Aded public key"
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n." ;;
    esac
done
