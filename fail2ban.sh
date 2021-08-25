#!/bin/bash

sudo apt install fail2ban -y
sudo sed -i "s/loglevel = INFO/loglevel = 1/" /etc/fail2ban/fail2ban.conf
sudo systemctl enable fail2ban --now

## enable fail2ban to send logs to gmail
while true; do
    printf "\n"
    read -r -p "Do you want to enable fail2ban to send logs via email to you ? (Y/N) : " isSMTP
    case $isSMTP in
    [Yy]*)
        chmod +x mail_client.sh
        ./mail_client.sh
        sudo systemctl restart fail2ban
        break
        ;;
    [Nn]*) break ;;
    *) echo "Please answer y or n." ;;
    esac
done
