FROM php:7.1-cli
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
    libssl-dev \
    libc-client-dev \
    libkrb5-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    git \
    libsqlite3-dev \
    libpspell-dev \
    libreadline-dev \
    libedit-dev \
    librecode-dev \
    libsnmp-dev \
    libsnmp30 \
    libtidy-dev \
    libxslt1.1 \
    libxslt1-dev \
    ssmtp \
    snmp \
    gnupg2 \
    libgmp-dev \
    libldb-dev \
    libldap2-dev \
    wget \
    unzip \
    mibrabbitmq-dev \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install -j$(nproc) bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo ftp gettext gmp hash iconv \
                                         mbstring mysqli mcrypt opcache pcntl pdo pdo_mysql pdo_sqlite phar posix pspell readline recode \
                                         session shmop simplexml snmp soap sockets sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlrpc \
                                         xmlwriter xsl zip \
    && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# set up sendmail config
RUN echo "hostname=localhost.localdomain" > /etc/ssmtp/ssmtp.conf
RUN echo "root=vincent.falies@wolterskluwer.com" >> /etc/ssmtp/ssmtp.conf
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

# Install MongoDB extension
RUN yes | pecl install mongodb \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongo.ini

# Install AMQP extension
RUN pecl install amqp && docker-php-ext-enable amqp

# Composer installation
ADD scripts/composer.sh /tmp/composer.sh
RUN chmod +x /tmp/composer.sh \
    && sync \
    && /tmp/composer.sh \
    && mv composer.phar /usr/local/bin/composer

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

CMD ["/bin/sh"]
