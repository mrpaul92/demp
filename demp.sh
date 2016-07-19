#!/bin/bash

############################################################################
# Debian + Nginx + MySQL + PHP                                             #
# Version: 0.7 Build 2                                                     #
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
  echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list # adding official nginx mainline version repository
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
instphp56 () {
  apt-get install php5-fpm php5-mysql php5-gd php5-mcrypt php5-curl curl php5-apcu -y # installing PHP5-FPM, PHP5-MYSQL to support MYSQL databases, PHP5-MCRYPT crypto module, curl & PHP5-CURL and PHP5-APCU for caching
  /etc/init.d/php5-fpm stop # stopping PHP5-FPM in case it is running
  echo "cgi.fix_pathinfo=0" >> /etc/php5/fpm/php.ini # fixing a possible security risk
  rm -rf /etc/php5/fpm/pool.d/www.conf # removing old www.conf pool configuration file
  wget -O /etc/php5/fpm/pool.d/www.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/www.conf --no-check-certificate # installing new www.conf pool configuration file
  /etc/init.d/php5-fpm start # starting PHP5-FPM with the new configuration
  update-rc.d php5-fpm defaults # setting up the PHP5-FPM daemon to start as a service
}

# Function to install PHP7-FPM with modules
instphp70 () {
  wget -O /tmp/dotdeb.gpg https://www.dotdeb.org/dotdeb.gpg --no-check-certificate # downloading DotDeb GPG key
  apt-key add /tmp/dotdeb.gpg # installing DotDeb GPG key
  rm -rf /tmp/dotdeb.gpg # removing DotDeb GPG key file
  echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list # adding official DotDeb PHP 7.0 repository
  apt-get update # updating apt-get package database
  apt-get install php7.0-fpm php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-mbstring php7.0-curl curl php7.0-bz2 php7.0-xml php7.0-zip php7.0-apcu # installing PHP7.0-FPM, PHP7.0-MYSQL to support MYSQL databases, PHP7.0-MCRYPT crypto module, PHP7.0-MBSTRING for multi-byte string operations, curl & PHP7.0-CURL , PHP7.0-XML for xml processing, PHP7.0-BZ2/ZIP for archive processing and PHP7.0-APCU for caching
  /etc/init.d/php7.0-fpm stop # stopping PHP7.0-FPM in case it is 
  echo "cgi.fix_pathinfo=0" >> /etc/php/7.0/fpm/php.ini # fixing a possible security risk
  rm -rf /etc/php/7.0/fpm/pool.d/www.conf # removing old www.conf pool configuration file
  wget -O /etc/php/7.0/fpm/pool.d/www.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/www.conf --no-check-certificate # installing new www.conf pool configuration file
  /etc/init.d/php7.0-fpm start # starting PHP7.0-FPM with the new configuration
  update-rc.d php7.0-fpm defaults  # setting up the PHP7.0-FPM daemon to start as a service
}

# Function to install a default Nginx vHost with PHP supported
instdefvhost () {
  rm -rf /etc/nginx/conf.d/default.conf # removing the old default vHost file
  wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/hidden-refuge/demp/master/default-vhost.conf --no-check-certificate # installing new default vhost configuration
  touch /usr/share/nginx/html/phpinfo.php # creating a empty phpinfo php file
  echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/phpinfo.php # pushing phpinfo content to file
  /etc/init.d/nginx restart # restarting to apply the new default vHost
}

case $1 in 
  '-stable') # if $1 is -stable run the installation routine below
    case $2 in # if $2 is -php7 run installation routine beblow + PHP 7.0 otherwise with PHP 5.6 
      '-php7')
        instnginx; confnginx; instmysql; instphp70; instdefvhost;; # installation routine for stable nginx version with PHP 7.0
      *)
        instnginx; confnginx; instmysql; instphp56; instdefvhost;; # installation routine for stable nginx version with PHP 5.6
    esac;;
  '-mainline') # if $1 is -mainline run the installation routine below
    case $2 in # if $2 is -php7 run installation routine beblow + PHP 7.0 otherwise with PHP 5.6 
      '-php7')
        instnginxml; confnginx; instmysql; instphp70; instdefvhost;; # installtion routine for mainline nginx version with PHP 7.0
      *)
        instnginxml; confnginx; instmysql; instphp56; instdefvhost;; # installtion routine for mainline nginx version with PHP 5.6
    esac;;
  * )
    echo ""
    echo "DEMP - Debian + Nginx + MySQL + PHP - 0.7 Dev"
    echo ""
    echo "Options:"
    echo "-stable         - Stable Nginx (1.10.*) + MySQL 5.5.49 + PHP 5.6.14"
    echo "-mainline       - Mainline Nginx (1.11.*) + MySQL 5.5.49 + PHP 5.6.14"
    echo "-stable -php7   - Stable Nginx (1.10.*) + MySQL 5.5.49 + PHP 7.0.8"
    echo "-mainline -php7 - Mainline Nginx (1.11.*) + MySQL 5.5.49 + PHP 7.0.8"
    echo ""
    echo "Copyright 2016 - Hidden Refuge (licensed under MIT)"
    echo "";;
esac
