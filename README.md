# Debian + Nginx (EngineX) + MySQL + PHP
Just another LEMP script for Debian.<br><br>
Currently only for Debian 8! Comes with the latest stable or mainline nginx version (see below for options). You can either use PHP 5.6 or PHP 7.0.<br><br>
Options:<br>
```./demp.sh -stable```<br>
This will install DEMP with the latest stable version of nginx. The rest is MySQL 5.5 (Debian) and PHP 5.6 + modules (also from Debian).<br><br>
```./demp.sh -mainline```<br>
This will install DEMP with the latest mainline version of nginx. The rest is MySQL 5.5 (Debian) and PHP 5.6 + modules (also from Debian).<br><br>
```./demp.sh -stable -php7```<br>
This will install DEMP with the latest stable version of nginx. The rest is MySQL 5.5 (Debian) and PHP 7.0 + modules (from DotDeb).<br><br>
```./demp.sh -mainline -php7```<br>
This will install DEMP with the latest mainline version of nginx. The rest is MySQL 5.5 (Debian) and PHP 7.0 + modules (from DotDeb).<br><br>
