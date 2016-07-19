# Debian + Nginx (EngineX) + MySQL + PHP
Just another LEMP script for Debian.<br><br>
Currently only for Debian 8! Comes with the latest stable or mainline nginx version (see below for options).<br><br>
Options:<br>
```./demp.sh -stable```<br>
This will install DEMP with the latest stable version of nginx (currently 1.10.1). The rest is MySQL 5.5.49 (Debian) and PHP 5.6.22 + modules (also from Debian).<br><br>
```./demp.sh -mainline```<br>
This will install DEMP with the latest mainline version of nginx (currently 1.11.2). The rest is MySQL 5.5.49 (Debian) and PHP 5.6.22 + modules (also from Debian).<br><br>
```./demp.sh -stable -php7```<br>
This will install DEMP with the latest stable version of nginx (currently 1.10.1). The rest is MySQL 5.5.49 (Debian) and PHP 7.0.8 + modules (from DotDeb).<br><br>
```./demp.sh -mainline -php7```<br>
This will install DEMP with the latest mainline version of nginx (currently 1.11.2). The rest is MySQL 5.5.49 (Debian) and PHP 7.0.8 + modules (from DotDeb).<br><br>
