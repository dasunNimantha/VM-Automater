#!/bin/bash

printf "\n"
echo "#####################################"
echo "###### INSTALLING MOD-SECURITY ######"
echo "#####################################"
printf "\n"

sudo apt install bison make build-essential ca-certificates libxslt-dev curl dh-autoreconf doxygen flex gawk git iputils-ping libcurl4-gnutls-dev libexpat1-dev libgeoip-dev liblmdb-dev libpcre3-dev libpcre++-dev libssl-dev libtool libxml2 libxml2-dev libyajl-dev locales lua5.3-dev pkg-config wget zlib1g-dev zlibc libxslt libgd-dev

#Clone the ModSecurity Github repository from the /opt directory
cd /opt && sudo git clone https://github.com/SpiderLabs/ModSecurity
cd ModSecurity
sudo git submodule init
sudo git submodule update
sudo ./build.sh
sudo ./configure
sudo make
sudo make install

#clone the Nginx-connector from the /opt directory
cd /opt && sudo git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

# get the nginx version
command="sudo nginx -v"
nginxv=$(${command} 2>&1)
nginxlocal=$(echo "$nginxv" | grep -o '[0-9.]*$')

# download nginx
cd /opt && sudo wget http://nginx.org/download/nginx-"$nginxlocal".tar.gz
sudo tar -xvzmf nginx-"$nginxlocal".tar.gz
cd nginx-"$nginxlocal"

sudo ./configure --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-GkiujU/nginx-1.14.0=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-mail=dynamic --with-mail_ssl_module --add-dynamic-module=../ModSecurity-nginx
sudo make modules
sudo mkdir /etc/nginx/modules
sudo cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules

sudo rm -rf /usr/share/modsecurity-crs
sudo git clone https://github.com/coreruleset/coreruleset /usr/local/modsecurity-crs
sudo mv /usr/local/modsecurity-crs/crs-setup.conf.example /usr/local/modsecurity-crs/crs-setup.conf
sudo mv /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

sudo mkdir -p /etc/nginx/modsec
sudo cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec
sudo cp /opt/ModSecurity/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

TARGET_KEY="SecRuleEngine"
REPLACEMENT_VALUE="On"
CONFIG_FILE="/etc/modsecurity/modsecurity.conf"
sudo sed -c -i "s/\($TARGET_KEY * *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE

sudo cp nginx/main.conf /etc/nginx/modsec/
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo cp nginx/nginx.conf /etc/nginx/nginx.conf
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
sudo cp nginx/default /etc/nginx/sites-available/
