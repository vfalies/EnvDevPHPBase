FROM php:7.3-rc-fpm-alpine
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

RUN apk --update add ca-certificates && \
    echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --no-cache $PHPIZE_DEPS && \
    apk add -U \
        php7-intl \
        php7-openssl \
        php7-dba \
        php7-sqlite3 \
        php7-pear \
        php7-tokenizer \
        php7-phpdbg \
        cacti-php7 \
        xapian-bindings-php7 \
        php7-litespeed \
        php7-gmp \
        php7-pdo_mysql \
        php7-pcntl \
        php7-common \
        php7-xsl \
        php7-fpm \
        php7-imagick \
        php7-mysqlnd \
        php7-enchant \
        php7-pspell \
        php7-redis \
        php7-snmp \
        php7-doc \
        php7-fileinfo \
        php7-mbstring \
        php7-dev \
        php7-pear-mail_mime \
        php7-xmlrpc \
        php7-embed \
        php7-xmlreader \
        php7-pear-mdb2_driver_mysql \
        php7-pdo_sqlite \
        php7-pear-auth_sasl2 \
        php7-exif \
        php7-recode \
        php7-opcache \
        php7-ldap \
        php7-posix \
        php7-pear-net_socket \
        php7-session \
        php7-gd \
        php7-gettext \
        php7-mailparse \
        php7-json \
        php7-xml \
        php7 \
        php7-iconv \
        php7-sysvshm \
        php7-curl \
        php7-shmop \
        php7-odbc \
        php7-phar \
        php7-pdo_pgsql \
        php7-imap \
        php7-pear-mdb2_driver_pgsql \
        php7-pdo_dblib \
        php7-pgsql \
        php7-pdo_odbc \
        php7-xdebug \
        php7-zip \
        php7-apache2 \
        php7-cgi \
        php7-ctype \
        php7-amqp \
        php7-mcrypt \
        php7-wddx \
        php7-pear-net_smtp \
        php7-bcmath \
        php7-calendar \
        php7-tidy \
        php7-dom \
        php7-sockets \
        php7-zmq \
        php7-memcached \
        php7-soap \
        php7-apcu \
        php7-sysvmsg \
        php7-zlib \
        php7-imagick-dev \
        php7-ftp \
        php7-sysvsem \
        php7-pdo \
        php7-pear-auth_sasl \
        php7-bz2 \
        php7-mysqli \
        php7-pear-net_smtp-doc \
        php7-simplexml \
        php7-xmlwriter \
        libuv@edge-main \
        ssmtp \
        shadow \
        curl \
        git \
        composer@edge-community \
        mongodb@edge-main \
        unzip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && rm -rf /var/cache/apk/*

# # set up sendmail config
RUN echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf
RUN echo "root=vincent.falies@wolterskluwer.com" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev" >> /etc/ssmtp/ssmtp.conf
# The above 'maildev' is the name you used for the link command
# in your docker-compose file or docker link command.
# Docker automatically adds that name in the hosts file
# of the container you're linking MailDev to.

# # Set up php sendmail config
RUN echo "sendmail_path=sendmail -i -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini

# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost localhost.localdomain" >> /etc/hosts

# Set up XDebug
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

WORKDIR /var/www/html

# User creation
RUN useradd -U -m -r -o -u 1003 vfac

# install fixuid
RUN USER=vfac && \
    GROUP=vfac && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

ENTRYPOINT ["fixuid", "-q"]

USER vfac:vfac
RUN composer config --global repo.packagist composer https://packagist.org

CMD ["php-fpm"]
