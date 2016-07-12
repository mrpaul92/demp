#!/bin/bash

############################################################################
# Debian + Nginx + MySQL + PHP                                             #
# Version: 0.6 Build 5                                                     #
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
  wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/nginx.conf --no-check-certificate # installing new nginx.conf configuration file
  /etc/init.d/nginx start # starting nginx with the new configuration
  update-rc.d nginx defaults # setting up the nginx daemon to start as a service
}

# Function to install MySQL
instmysql () {
  apt-get install mysql-server -y # installing MySQL (you will be asked to set a root password for the MySQL root user)
  /etc/init.d/mysql stop # stopping MySQl in case it is running
  mv /etc/mysql/my.cnf /etc/mysql/my.cnf.original # moving original my.cnf to my.cnf.original as a backup
  wget -O /etc/mysql/my.cnf https://raw.githubusercontent.com/hidden-refuge/demp/master/my.cnf --no-check-certificate # installing new low resource usage my.cnf configuration file
  /etc/init.d/mysql start # starting MySQL with the new configuration
  update-rc.d mysql defaults # setting up the MySQL daemon to start as a service
}

# Function to install PHP5-FPM with modules
instphp5 () {
  apt-get install php5-fpm php5-mysql php5-gd php5-mcrypt php5-curl curl php5-apcu -y # installing PHP5-FPM, PHP5-MYSQL to support MYSQL databases, PHP5-MCRYPT crypto module, curl & PHP5-CURL and PHP5-APCU for caching
  /etc/init.d/php5-fpm stop # stopping PHP5-FPM in case it is running
  echo "cgi.fix_pathinfo=0" >> /etc/php5/fpm/php.ini # fixing a possible security risk
  rm -rf /etc/php5/fpm/pool.d/www.conf # removing old www.conf pool configuration file
  wget -O /etc/php5/fpm/pool.d/www.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/www.conf --no-check-certificate # installing new www.conf pool configuration file
  /etc/init.d/php5-fpm start # starting PHP5-FPM with the new configuration
  update-rc.d php5-fpm defaults # setting up the PHP5-FPM daemon to start as a service
}

# Function to install a default Nginx vHost with PHP supported
instdefvhost () {
  rm -rf /etc/nginx/conf.d/default.conf # removing the old default vHost file
  wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/default-vhost.conf --no-check-certificate # installing new default vhost configuration
  touch /usr/share/nginx/html/phpinfo.php # creating a empty phpinfo php file
  echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/phpinfo.php # pushing phpinfo content to file
  /etc/init.d/nginx restart # restarting to apply the new default vHost
}

# Function with misc information
miscinf () {
  clear
  echo "Thank you for using my Debian + Nginx + MySQL + PHP (DEMP) web stack installer script!"
  echo ""
  echo "You've successfully installed nginx$1 with MySQL 5.5.49 and PHP 5.6.22 + modules through PHP5-FPM."
  echo "The following additional PHP modules have been installed:"
  echo "-php5-gd (This package provides a module for handling graphics directly from PHP scripts.)"
  echo "-php5-mysql (This package provides modules for MySQL database connections directly from PHP scripts.)"
  echo "-php5-mcrypt (This package provides a module for MCrypt functions in PHP scripts.)" 
  echo "-php5-curl (CURL is a library for getting files from FTP, GOPHER, HTTP server.)"
  echo "-php5-apcu (The APCu is userland caching: APC stripped of opcode caching after the deployment of Zend OpCache.)"
  echo ""
  echo "For your convenience the script created a phpinfo() page. It is available at the address(es) below:"
  echo "http://yourserverip/phpinfo.php or http://yourdomain.ext/phpinfo.php"
  echo "The latter only works if you only have the default vHost and no other vHost with your domain as server_name."
  echo ""
  echo ""
  echo "Enjoy yourself and your new web server setup! Regards, Hidden Refuge (https://hiddenrefuge.eu.org/)"
}

case $1 in 
  '-stable') # if $1 is -stable run the installation routine below
    instnginx; confnginx; instmysql; instphp5; instdefvhost; miscinf;; # installation routine for stable nginx version
  '-mainline') # if $1 is -mainline run the installation routine below
    instnginxml; confnginx; instmysql; instphp5; instdefvhost; miscinf;; # installtion routine for mainline nginx version
  * )
    echo ""
    echo "DEMP - Debian + Nginx + MySQL + PHP - 0.6 Dev"
    echo ""
    echo "Options:"
    echo "-stable     - Stable Nginx (1.10.*) + MySQL 5.5.49 + PHP 5.6.14"
    echo "-mainline   - Mainline Nginx version (1.11.*) + MySQL 5.5.49 + PHP 5.6.14"
    echo ""
    echo "Copyright 2016 - Hidden Refuge (licensed under MIT)"
    echo "";;
esac
