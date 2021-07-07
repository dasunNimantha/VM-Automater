#!/bin/bash
# Source:
# https://www.cloudflare.com/ips
# https://support.cloudflare.com/hc/en-us/articles/200169166-How-do-I-whitelist-CloudFlare-s-IP-addresses-in-iptables-
# https://gist.github.com/Manouchehri/cdd4e56db6596e7c3c5a#file-cloudflare-sh

# This script will only allow to clouflare ips to a http/https request and block all other requests

for i in $(curl https://www.cloudflare.com/ips-v4); do iptables -I INPUT -p tcp -m multiport --dports http,https -s "$i" -j ACCEPT; done
for i in $(curl https://www.cloudflare.com/ips-v6); do ip6tables -I INPUT -p tcp -m multiport --dports http,https -s "$i" -j ACCEPT; done

# Avoid racking up billing/attacks

iptables -A INPUT -p tcp -m multiport --dports http,https -j DROP
ip6tables -A INPUT -p tcp -m multiport --dports http,https -j DROP
