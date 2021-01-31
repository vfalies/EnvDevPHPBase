FROM php:8.0-fpm-alpine
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

RUN apk --update add ca-certificates && \
    echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@3.10-community http://dl-cdn.alpinelinux.org/alpine/v3.10/community" >> /etc/apk/repositories && \
    echo "@3.9-community http://dl-cdn.alpinelinux.org/alpine/v3.9/community" >> /etc/apk/repositories && \
    echo "@3.8-community http://dl-cdn.alpinelinux.org/alpine/v3.8/community" >> /etc/apk/repositories && \
    apk add --no-cache $PHPIZE_DEPS && \
    apk add -U \
    php8-intl \
    php8-openssl \
    php8-dba \
    php8-sqlite3 \
    php8-pear \
    php8-phpdbg \
    php8-litespeed \
    php8-gmp \
    php8-pdo_mysql \
    php8-pcntl \
    php8-common \
    php8-xsl \
    php8-fpm \
    # php8-imagick \
    php8-mysqlnd \
    php8-enchant \
    php8-pspell \
    # php8-redis \
    php8-snmp \
    php8-doc \
    php8-dev \
    # php8-pear-mail_mime@3.10-community \
    # php8-xmlrpc \
    php8-embed \
    # php8-pear-mdb2_driver_mysql@3.10-community \
    # php8-pear-auth_sasl2@3.10-community \
    php8-exif \
    # php8-recode \
    php8-opcache \
    php8-ldap \
    php8-posix \
    # php8-pear-net_socket \
    php8-gd \
    php8-gettext \
    # php8-mailparse \
    php8 \
    php8-sysvshm \
    php8-shmop \
    php8-odbc \
    php8-phar \
    php8-pdo_pgsql \
    php8-imap \
    # php8-pear-mdb2_driver_pgsql@3.10-community \
    php8-pdo_dblib \
    php8-pgsql \
    php8-pdo_odbc \
    # php8-xdebug \
    php8-apache2 \
    php8-cgi \
    php8-ctype \
    # php8-wddx \
    # php8-pear-net_smtp@3.10-community \
    php8-bcmath \
    php8-calendar \
    php8-tidy \
    php8-sockets \
    # php8-zmq \
    # php8-memcached \
    php8-soap \
    # php8-apcu \
    php8-sysvmsg \
    # php8-zlib \
    # php8-imagick-dev \
    php8-ftp \
    php8-sysvsem \
    # php8-pear-auth_sasl@3.10-community \
    php8-bz2 \
    php8-mysqli \
    # php8-pear-net_smtp-doc@3.10-community \
    libuv@edge-main \
    ssmtp \
    shadow \
    curl \
    git \
    composer@edge-community \
    # php8-imagick-dev@3.8-community \
    php8-pecl-mongodb \
    unzip \
    # && pecl install xdebug \
    # && docker-php-ext-enable xdebug \
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
# RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
#     echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

WORKDIR /var/www/html

# User creation
RUN useradd -U -m -r -o -u 1003 vfac

# install fixuid
RUN USER=vfac && \
    GROUP=vfac && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5/fixuid-0.5-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

ENTRYPOINT ["fixuid", "-q"]

USER vfac:vfac
RUN composer config --global repo.packagist composer https://packagist.org

CMD ["php-fpm"]
