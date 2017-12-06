ARG PHP_VERSION=7.2

FROM php:${PHP_VERSION}-fpm
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libsqlite3-dev \
        libssl-dev \
        libcurl3-dev \
        libxml2-dev \
        libzzip-dev \
        ssmtp \
        mailutils \
        zlib1g-dev libicu-dev g++
RUN docker-php-ext-install \
        bcmath calendar ctype curl dba dom exif fileinfo ftp gd gettext \
        hash iconv json mbstring mysqli opcache \ 
        pcntl pdo pdo_mysql pdo_sqlite \
        phar posix 
RUN docker-php-ext-install \
        session simplexml soap sockets \
        xml xmlrpc xmlwriter zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
RUN apt-get install -y libgmp-dev re2c libmhash-dev libmcrypt-dev file \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install gmp    
RUN apt-get install -y libc-client-dev libkrb5-dev \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap    
# RUN apt-get install -y libldap2-dev \
#     && docker-php-ext-configure ldap \
#     && docker-php-ext-install ldap    
RUN docker-php-ext-install -j$(nproc) intl

# Set up sendmail config
RUN echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf
RUN echo "root=<your email address>" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev" >> /etc/ssmtp/ssmtp.conf
# The above 'maildev' is the name you used for the link command
# in your docker-compose file or docker link command.
# Docker automatically adds that name in the hosts file
# of the container you're linking MailDev to.

# Set up php sendmail config
RUN echo "sendmail_path=sendmail -i -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini

# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost localhost.localdomain" >> /etc/hosts

# Set up XDebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Composer installation
RUN curl -sL https://getcomposer.org/composer.phar -o composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer config --global repo.packagist composer https://packagist.org

WORKDIR /var/www

CMD ["php-fpm"]
