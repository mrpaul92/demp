#!/bin/bash

############################################################################
# Debian + Nginx + MySQL + PHP                                             #
# Version: 0.4                                                             #
# Branch: Dev                                                              #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Author: Hidden Refuge (© 2016)                                           #
# License: MIT License                                                     #
############################################################################


# Function to install the latest stable Nginx version
instnginx ()  {
  wget -O /tmp/nginx_signing.key http://nginx.org/keys/nginx_signing.key # downloading nginx GPG key
  apt-key add /tmp/nginx_signing.key # installing nginx GPG key
  rm -rf /tmp/nginx_signing.key # removing downloaded GPG key file
  echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list # adding official nginx stable version repository
  # uncomment the line below if you need the source code for the latest stable nginx version
  #echo "deb-src http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list # adding source for official nginx stable version
  apt-get update # updating apt-get package database and sources
  apt-get install nginx -y # installing nginx stable
}

# Function to install the latest mainline Nginx version
instnginxml () {
  wget -O /tmp/nginx_signing.key http://nginx.org/keys/nginx_signing.key # downloading nginx GPG key
  apt-key add /tmp/nginx_signing.key # installing nginx GPG key
  rm -rf /tmp/nginx_signing.key # removing downloaded GPG key file
  echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list # adding official nginx mainline  version repository
  # uncomment the line below if you need the source code for the latest stable nginx version
  #echo "deb-src http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list # adding source for official nginx mainline version
  apt-get update # updating apt-get package database and sources
  apt-get install nginx -y # installing nginx mainline
}

# Function to configure Nginx
confnginx () {
  /etc/init.d/nginx stop # stopping nginx in case it is running
  mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original # moving original nginx.config to nginx.conf.original as a backup
  touch /etc/nginx/nginx.conf # creating a new empty nginx.conf
  # installing new nginx.conf configuration
  cat > /etc/nginx/nginx.conf <<END
  user www-data;
  worker_processes 1;
  pid /var/run/nginx.pid;

  events {
    worker_connections 2048;
    multi_accept on;
  }

  http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
        
    keepalive_timeout 5 5;
    reset_timedout_connection on;  
    client_body_timeout   10; 
    client_header_timeout 10; 
    send_timeout          10;
        
    server_tokens off;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
        
    client_body_buffer_size 1k;
    client_header_buffer_size 1k;
    client_max_body_size 16M;
    large_client_header_buffers 2 1k;
        
    gzip on;
    gzip_disable "msie6";
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
      
    error_log /var/log/nginx/error.log crit;
    access_log /var/log/nginx/access.log;
        
    include /etc/nginx/conf.d/*.conf;
  }
  END
  /etc/init.d/nginx start # starting nginx with the new configuration
}
