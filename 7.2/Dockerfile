FROM alpine:3.7
LABEL maintainer="Vincent Faliès <vincent@vfac.fr>"

ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates\
    && echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "@cast https://php.codecasts.rocks/v3.7/php-7.2" >> /etc/apk/repositories \
    && apk add -U \
        tini \
        php7@cast \
        php7-fpm@cast \
        php7-bcmath@cast \
        php7-bz2@cast \
        php7-calendar@cast \
        php7-ctype@cast \
        php7-curl@cast \
        php7-dba@cast \
        php7-dom@cast \
        php7-embed@cast \
        php7-enchant@cast \
        php7-exif@cast \
        php7-ftp@cast \
        php7-gd@cast \
        php7-gettext@cast \
        php7-gmp@cast \
        php7-iconv@cast \
        php7-imap@cast \
        php7-intl@cast \
        php7-json@cast \
        php7-ldap@cast \
        php7-litespeed@cast \
        php7-mbstring@cast \
        php7-mysqli@cast \
        php7-mysqlnd@cast \
        php7-odbc@cast \
        php7-opcache@cast \
        php7-openssl@cast \
        php7-pcntl@cast \
        php7-pdo@cast \
        php7-pdo_dblib@cast \
        php7-pdo_mysql@cast \
        php7-pdo_pgsql@cast \
        php7-pdo_sqlite@cast \
        php7-pear@cast \
        php7-pgsql@cast \
        php7-phar@cast \
        php7-phpdbg@cast \
        php7-posix@cast \
        php7-pspell@cast \
        php7-session@cast \
        php7-shmop@cast \
        php7-snmp@cast \
        php7-soap@cast \
        php7-sockets@cast \
        php7-sqlite3@cast \
        php7-sysvmsg@cast \
        php7-sysvsem@cast \
        php7-sysvshm@cast \
        php7-tidy@cast \
        php7-wddx@cast \
        php7-xml@cast \
        php7-xmlreader@cast \
        php7-xmlrpc@cast \
        php7-xsl@cast \
        php7-zip@cast \
        php7-zlib@cast \
        php7-xdebug@cast \
        git \
        ssmtp \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && rm -rf /var/cache/apk/*

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

# Composer installation
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer
RUN composer config --global repo.packagist composer https://packagist.org

WORKDIR /var/www/html

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/php-fpm7", "-R", "--nodaemonize"]