FROM alpine:3.5
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

RUN apk update \
    && apk upgrade \
    && apk add \
        tini \
        php5 \
        php5-fpm \
        php5-bcmath \
        php5-bz2 \
        php5-calendar \
        php5-ctype \
        php5-curl \
        php5-dba \
        php5-dom \
        php5-embed \
        php5-enchant \
        php5-exif \
        php5-ftp \
        php5-gd \
        php5-gettext \
        php5-gmp \
        php5-iconv \
        php5-imap \
        php5-intl \
        php5-json \
        php5-ldap \
        php5-mcrypt \
        php5-mysqli \
        php5-odbc \
        php5-opcache \
        php5-openssl \
        php5-pcntl \
        php5-pdo \
        php5-pdo_dblib \
        php5-pdo_mysql \
        php5-pdo_pgsql \
        php5-pdo_sqlite \
        php5-pear \
        php5-pgsql \
        php5-phar \
        php5-phpdbg \
        php5-posix \
        php5-pspell \
        php5-shmop \
        php5-snmp \
        php5-soap \
        php5-sockets \
        php5-sqlite3 \
        php5-sysvmsg \
        php5-sysvsem \
        php5-sysvshm \
        php5-wddx \
        php5-xml \
        php5-xmlreader \
        php5-xmlrpc \
        php5-xsl \
        php5-zip \
        php5-zlib \
        php5-xdebug \
        git \
        ssmtp

# Set environment
RUN sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php5/php-fpm.conf && \
  	sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php5/php-fpm.conf && \
  	sed -i "s|;*listen\s*=\s*/||g" /etc/php5/php-fpm.conf && \
    sed -i "s|;*;clear_env\s*=\s*no|clear_env = no|g" /etc/php7/php-fpm.d/www.conf 

EXPOSE 9000

# Set up sendmail config
RUN echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf
RUN echo "root=<your email address>" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev" >> /etc/ssmtp/ssmtp.conf
# The above 'maildev' is the name you used for the link command
# in your docker-compose file or docker link command.
# Docker automatically adds that name in the hosts file
# of the container you're linking MailDev to.

# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost localhost.localdomain" >> /etc/hosts

# Composer installation
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer
RUN composer config --global repo.packagist composer https://packagist.org

RUN rm -rf /var/cache/apk/*

WORKDIR /var/www/html

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/bin/php-fpm", "-R", "--nodaemonize"]