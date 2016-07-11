#!/bin/bash

############################################################################
# Debian + Nginx + MySQL + PHP                                             #
# Version: 0.3                                                             #
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
