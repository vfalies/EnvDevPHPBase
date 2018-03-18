FROM alpine:3.5
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

RUN apk update \
    && apk upgrade \
    && apk add \
        tini \
        php7 \
        php7-fpm \
        php7-bcmath \
        php7-bz2 \
        php7-calendar \
        php7-ctype \
        php7-curl \
        php7-dba \
        php7-dom \
        php7-embed \
        php7-enchant \
        php7-exif \
        php7-ftp \
        php7-gd \
        php7-gettext \
        php7-gmp \
        php7-iconv \
        php7-imap \
        php7-intl \
        php7-json \
        php7-ldap \
        php7-litespeed \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-mysqlnd \
        php7-odbc \
        php7-opcache \
        php7-openssl \
        php7-pcntl \
        php7-pdo \
        php7-pdo_dblib \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-pear \
        php7-pgsql \
        php7-phar \
        php7-phpdbg \
        php7-posix \
        php7-pspell \
        php7-session \
        php7-shmop \
        php7-snmp \
        php7-soap \
        php7-sockets \
        php7-sqlite3 \
        php7-sysvmsg \
        php7-sysvsem \
        php7-sysvshm \
        php7-tidy \
        php7-wddx \
        php7-xml \
        php7-xmlreader \
        php7-xmlrpc \
        php7-xsl \
        php7-zip \
        php7-zlib \
        php7-xdebug \
        git \
        ssmtp \
        curl \
        shadow

# Set environment
RUN sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf && \
	sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php7/php-fpm.d/www.conf && \
	sed -i "s|;*listen\s*=\s*/||g" /etc/php7/php-fpm.d/www.conf && \
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

# PHP CLI
COPY --from=php:7.0.26-cli-alpine /usr/local/bin/php /usr/local/bin/php
COPY --from=php:7.0.26-cli-alpine /usr/lib/libssl.so.1.0.0 /usr/lib/libssl.so.1.0.0
COPY --from=php:7.0.26-cli-alpine /usr/lib/libcrypto.so.1.0.0 /usr/lib/libcrypto.so.1.0.0

# Composer installation
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# User creation
RUN useradd -U -m -r -o -u 1003 vfac

# install fixuid
RUN USER=vfac && \
    GROUP=vfac && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.3/fixuid-0.3-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

ENTRYPOINT ["fixuid"]

USER vfac:vfac
RUN composer config --global repo.packagist composer https://packagist.org

CMD ["/bin/sh"]