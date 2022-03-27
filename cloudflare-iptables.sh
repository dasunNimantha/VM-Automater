#!/bin/bash
# Source:
# https://www.cloudflare.com/ips
# https://support.cloudflare.com/hc/en-us/articles/200169166-How-do-I-whitelist-CloudFlare-s-IP-addresses-in-iptables-
# https://gist.github.com/Manouchehri/cdd4e56db6596e7c3c5a#file-cloudflare-sh

# This script will only allow to clouflare ips to a http/https request and block all other requests

printf "########## Warning !!! You need to have a cloudflare A record point to this server.Otherwise the webserver would't be accessible. ##########"

for i in $(curl https://www.cloudflare.com/ips-v4); do sudo iptables -I INPUT -p tcp -m multiport --dports http,https -s "$i" -j ACCEPT; done
for i in $(curl https://www.cloudflare.com/ips-v6); do sudo ip6tables -I INPUT -p tcp -m multiport --dports http,https -s "$i" -j ACCEPT; done

# Avoid racking up billing/attacks

sudo iptables -A INPUT -p tcp -m multiport --dports http,https -j DROP
sudo ip6tables -A INPUT -p tcp -m multiport --dports http,https -j DROP

for i in `curl https://www.cloudflare.com/ips-v4`; do sudo iptables -I DOCKER-USER -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done
for i in `curl https://www.cloudflare.com/ips-v6`; do sudo ip6tables -I DOCKER-USER -p tcp -m multiport --dports http,https -s $i -j ACCEPT; done

sudo iptables -A DOCKER-USER -p tcp -m multiport --dports http,https -j DROP
sudo ip6tables -A DOCKER-USER -p tcp -m multiport --dports http,https -j DROP
