FROM php:7.1-fpm
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libbz2-dev \ 
    libcurl4-gnutls-dev \
    libxml2-dev \
    libenchant-dev \
    && docker-php-ext-install -j$(nproc) bcmath bz2 calendar ctype curl dba dom enchant 
RUN docker-php-ext-install -j$(nproc) exif 
RUN docker-php-ext-install -j$(nproc) fileinfo 
#RUN docker-php-ext-install -j$(nproc) filter

RUN apt-get install -y libssl-dev

RUN docker-php-ext-install -j$(nproc) ftp
RUN docker-php-ext-install -j$(nproc)  gettext


#RUN docker-php-ext-install -j$(nproc)  gmp
# --with-gmp=/usr/include/x86_64-linux-gnu ?

RUN docker-php-ext-install -j$(nproc)  hash
RUN docker-php-ext-install -j$(nproc) iconv

RUN apt-get install -y libc-client-dev libkrb5-dev

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl 

RUN docker-php-ext-install -j$(nproc)  imap

#RUN docker-php-ext-install -j$(nproc)  interbase

RUN apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install -j$(nproc)  intl

# RUN apt-get install -y libldb-dev libldap2-dev
# RUN docker-php-ext-install -j$(nproc)  ldap

RUN docker-php-ext-install -j$(nproc)  mbstring
RUN docker-php-ext-install -j$(nproc)  mcrypt
RUN docker-php-ext-install -j$(nproc)  mysqli
#RUN docker-php-ext-install -j$(nproc)  oci8

# RUN apt-get install -y unixODBC-dev
# RUN set -x \
#     && cd /usr/src/php/ext/odbc \
#     && phpize \
#     && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
#     && ./configure --with-unixODBC=shared,/usr \
#     && docker-php-ext-install -j$(nproc) odbc

RUN docker-php-ext-install -j$(nproc)  opcache
RUN docker-php-ext-install -j$(nproc)  pcntl
RUN docker-php-ext-install -j$(nproc)  pdo

# RUN apt-get install -y         freetds-bin \
#         freetds-dev \
#         freetds-common 
# RUN docker-php-ext-install -j$(nproc)  pdo_dblib

#RUN docker-php-ext-install -j$(nproc)  pdo_firebird
RUN docker-php-ext-install -j$(nproc)  pdo_mysql
#RUN docker-php-ext-install -j$(nproc)  pdo_oci
#RUN docker-php-ext-install -j$(nproc) pdo_odbc
#RUN docker-php-ext-install -j$(nproc)  pdo_pgsql

RUN apt-get install -y libsqlite3-dev
RUN docker-php-ext-install -j$(nproc)  pdo_sqlite

#RUN docker-php-ext-install -j$(nproc)  pgsql
RUN docker-php-ext-install -j$(nproc)  phar
RUN docker-php-ext-install -j$(nproc)  posix

RUN apt-get install -y libpspell-dev
RUN docker-php-ext-install -j$(nproc)  pspell

RUN apt-get install -y libreadline-dev libedit-dev
RUN docker-php-ext-install -j$(nproc)  readline

RUN apt-get install -y librecode-dev 
RUN docker-php-ext-install -j$(nproc)  recode

#RUN docker-php-ext-install -j$(nproc)  reflection
RUN docker-php-ext-install -j$(nproc)  session
RUN docker-php-ext-install -j$(nproc)  shmop
RUN docker-php-ext-install -j$(nproc)  simplexml

RUN apt-get install -y libsnmp-dev libsnmp30
RUN docker-php-ext-install -j$(nproc)  snmp
RUN docker-php-ext-install -j$(nproc)  soap
RUN docker-php-ext-install -j$(nproc)  sockets
#RUN docker-php-ext-install -j$(nproc)  spl
#RUN docker-php-ext-install -j$(nproc) standard
RUN docker-php-ext-install -j$(nproc)  sysvmsg
RUN docker-php-ext-install -j$(nproc)  sysvsem
RUN docker-php-ext-install -j$(nproc)  sysvshm

RUN apt-get install -y libtidy-dev
RUN docker-php-ext-install -j$(nproc)  tidy
RUN docker-php-ext-install -j$(nproc)  tokenizer
RUN docker-php-ext-install -j$(nproc)  wddx
RUN docker-php-ext-install -j$(nproc)  xml
#RUN docker-php-ext-install -j$(nproc)  xmlreader
RUN docker-php-ext-install -j$(nproc)  xmlrpc
RUN docker-php-ext-install -j$(nproc)  xmlwriter

RUN apt-get install -y libxslt1.1 libxslt1-dev
RUN docker-php-ext-install -j$(nproc)  xsl
RUN docker-php-ext-install -j$(nproc)  zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd 

RUN rm -rf /var/lib/apt/lists/*