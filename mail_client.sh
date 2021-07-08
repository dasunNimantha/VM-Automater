#!/bin/bash

sudo apt install msmtp-mta -y

printf "\nEnter the email credentials of your smtp client email (Don't add your personal email)\n\n"
read -r -p "Email Address : " smtpMail
read -r -p "Password (Use a gmail app password) : " smtpPass
read -r -p "Email address that you want to receive mails :" smtpDest

sudo cp configs/.msmtprc ~/.msmtprc
sudo chown $USER:$USER ~/.msmtprc
sudo chmod 600 ~/.msmtprc
sed -i "s/from        yourmail@gmail.com/from        $smtpMail/" ~/.msmtprc
sed -i "s/password    password/password    $smtpPass/" ~/.msmtprc
sed -i "s/user        username/user        $smtpMail/" ~/.msmtprc
sudo cp ~/.msmtprc /root/

sudo cp configs/fail2ban_local.conf /etc/fail2ban/jail.d/local.conf
sudo sed -i "s/destemail = dest@mail.com/destemail = $smtpDest/" /etc/fail2ban/jail.d/local.conf
sudo sed -i "s/sender = me@gmail.com/sender = $smtpMail/" /etc/fail2ban/jail.d/local.conf
