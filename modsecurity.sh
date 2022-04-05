#!/bin/bash
c='\e[32m' # Coloured echo (Green)
r='tput sgr0' #Reset colour after echo

printf "\n"
echo "#####################################"
echo "###### INSTALLING MOD-SECURITY ######"
echo "#####################################"
printf "\n"

sudo apt-get install bison build-essential ca-certificates curl dh-autoreconf doxygen \
  flex gawk git iputils-ping libcurl4-gnutls-dev libexpat1-dev libgeoip-dev liblmdb-dev \
  libpcre3-dev libpcre++-dev libssl-dev libtool libxml2 libxml2-dev libyajl-dev locales \
  lua5.3-dev pkg-config wget zlib1g-dev zlibc libxslt-dev libgd-dev -y

#Clone the ModSecurity Github repository from the /opt directory
cd /opt && sudo git clone https://github.com/SpiderLabs/ModSecurity ModSecurity
cd ModSecurity
sudo git submodule init
sudo git submodule update
sudo ./build.sh
sudo ./configure
sudo make
sudo make install

#clone the Nginx-connector from the /opt directory
cd /opt && sudo git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

# download nginx
nginxvnumber=$(nginx -v 2>&1 | grep -o '[0-9.]*')
echo -e "${c} Current version of nginx is: " "$nginxvnumber"; $r
sudo wget http://nginx.org/download/nginx-"$nginxvnumber".tar.gz
sudo tar zxvf nginx-"$nginxvnumber".tar.gz
sudo rm -rf nginx-"$nginxvnumber".tar.gz
cd nginx-"$nginxvnumber"

nginx_params=$(nginx -V 2>&1 | grep -o ' --with-cc-opt.*')
execute_code="sudo ./configure $nginx_params  --add-dynamic-module=../ModSecurity-nginx"
eval "$execute_code" && sudo make modules && sudo mkdir /etc/nginx/modules
sudo cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules

#load module in nginx.conf
sudo sed -i -e '5iload_module /etc/nginx/modules/ngx_http_modsecurity_module.so;\' /etc/nginx/nginx.conf

sudo rm -rf /usr/share/modsecurity-crs
sudo git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs
sudo cp /usr/local/modsecurity-crs/crs-setup.conf.example /usr/local/modsecurity-crs/crs-setup.conf
sudo cp /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

#enabling ModSecurity
sudo mkdir -p /etc/nginx/modsec
sudo cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec
sudo cp /opt/ModSecurity/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf

#change SecRule from Detection Only to ON (Important)
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf

#SecRule ARGS:scope "@contains https://www.googleapis.com/auth/userinfo.profile" "id:'9000000',phase:2,t:none,t:lowercase,pass,nolog,ctl:ruleRemoveById=930120"

#create main config file
sudo sh -c 'echo Include /etc/nginx/modsec/modsecurity.conf >> /etc/nginx/modsec/main.conf'
sudo sh -c 'echo Include /usr/local/modsecurity-crs/crs-setup.conf >> /etc/nginx/modsec/main.conf'
sudo sh -c 'echo Include /usr/local/modsecurity-crs/rules/\*.conf >> /etc/nginx/modsec/main.conf'

# enable ModSecurity in sites-available/default
if grep -q "modsecurity on;" "/etc/nginx/sites-available/default"; then
  echo "Modsecurity already enabled on /etc/nginx/sites-available/default"
else
  sudo sed -i "/root \/var\/www\/html;/a\\
  \\tmodsecurity on;\\
  \\tmodsecurity_rules_file \/etc\/nginx\/modsec\/main.conf;" /etc/nginx/sites-available/default
fi


sudo nginx -t
sudo systemctl restart nginx
