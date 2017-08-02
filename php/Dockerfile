ARG FROM_FQIN
FROM ${FROM_FQIN}

ARG COMPOSER_VERSION
ARG PRESTISSIMO_VERSION
ARG APCUBC_VERSION
ARG RAPHF_VERSION
ARG AMQP_VERSION

ENV COMPOSER_HOME=/.composer \
    PATH="$PATH:/.composer/vendor/bin"

RUN env \
    && printf "\
date.timezone=\"UTC\"\n\
request_order=GP\n\
expose_php=Off\n\
enable_dl=Off\n\
short_open_tag=Off\n\
zend.assertions=-1\n\
" > /usr/local/etc/php/php.ini \
    && docker-php-ext-enable --ini-name 00-opcache.ini opcache \
    && sed -i -e 's/extension=/zend_extension=/' /usr/local/etc/php/conf.d/00-opcache.ini \
    && printf "\
opcache.max_accelerated_files=16229\n\
opcache.enable_file_override=1\n\
opcache.log_verbosity_level=0\n\
opcache.fast_shutdown=1\n\
" >> /usr/local/etc/php/conf.d/00-opcache.ini \
    && apk add --no-cache zlib-dev icu-dev curl-dev binutils linux-headers \
    && docker-php-ext-install \
        intl \
        curl \
        iconv \
        mbstring \
        zip \
        bcmath \
        pcntl \
    && docker-php-source extract \
    && apk add --no-cache git \
    && apk add --no-cache --virtual .phpize-deps ${PHPIZE_DEPS} \
    && printf "\n" | pecl install apcu_bc-${APCUBC_VERSION} \
    && docker-php-ext-enable --ini-name 100-apc.ini apcu apc \
    && pecl install raphf-${RAPHF_VERSION} \
    && docker-php-ext-enable --ini-name 100-raphf.ini raphf \
    && echo -e "@v3.6 http://nl.alpinelinux.org/alpine/v3.6/main\n@v3.6 http://nl.alpinelinux.org/alpine/v3.6/community" >> /etc/apk/repositories \
    && apk update --no-cache \
    && apk add --no-cache rabbitmq-c-dev@v3.6 curl@v3.6 libssh2@v3.6 curl-dev@v3.6 \
    && pecl install amqp-${AMQP_VERSION} \
    && docker-php-ext-enable --ini-name 100-amqp.ini amqp \
    && addgroup -g 1000 php \
    && adduser -u 1000 -G php -s /bin/ash -D php \
    && mkdir -p /home/php/app \
    && chown php:php /home/php/app \
    && mkdir -p ${COMPOSER_HOME} \
    && chown php:php ${COMPOSER_HOME} \
    && curl -sL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && apk del --no-cache .phpize-deps \
    && apk del --no-cache zlib-dev icu-dev curl-dev binutils linux-headers \
    && apk add --no-cache icu \
    && docker-php-source delete \
    && rm -rf \
        /usr/src \
        /tmp/* \
        /usr/share/doc \
        /usr/share/man \
        /usr/share/doc \
        /var/cache/apk/*

USER php
RUN composer global require hirak/prestissimo:${PRESTISSIMO_VERSION} \
    && composer global clear-cache -vvv

WORKDIR /home/php/app
