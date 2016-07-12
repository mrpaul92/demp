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
  mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original # moving original nginx.conf to nginx.conf.original as a backup
  wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/nginx.conf # installing new nginx.conf configuration file
  /etc/init.d/nginx start # starting nginx with the new configuration
}

case $1 in 
  '-stable') # if $1 is -stable run the installation routine below
    instnginx; confnginx;; # installation routine for stable nginx version
  '-mainline') # if $1 is -mainline run the installation routine below
    instnginxml, confnginx;; # installtion routine for mainline nginx version
  * )
    echo ""
    echo "DEMP - Debian + Nginx + MySQL + PHP - 0.4 Dev"
    echo ""
    echo "Options:"
    echo "-stable     - Latest stable Nginx version (1.10.*)"
    echo "-mainline   - Latest mainline Nginx version (1.11.*)"
    echo "";;
esac
