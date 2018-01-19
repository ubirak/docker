FROM alpine:3.7 as raw

RUN printf "\
autoconf \
dpkg \
dpkg-dev \
file \
g++ \
gcc \
libc-dev \
make \
pkgconf \
re2c \
libressl \
ca-certificates" > /usr/local/builddeps.list \
    && apk add --no-cache $(cat /usr/local/builddeps.list)

ARG PHP_VERSION
RUN test -n "$PHP_VERSION" || (echo "PHP_VERSION build arg not set" && exit 1)
ARG PHP_URL
RUN test -n "$PHP_URL" || (echo "PHP_URL build arg not set" && exit 1)
ARG PHP_SHA256
RUN test -n "$PHP_SHA256" || (echo "PHP_SHA256 build arg not set" && exit 1)
RUN wget -O php.tar.xz "$PHP_URL" \
	&& echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -

RUN apk add --no-cache gnupg tar xz
ARG PHP_ASC_URL
RUN test -n "$PHP_ASC_URL" || (echo "PHP_ASC_URL build arg not set" && exit 1)
ARG GPG_KEY_LIST
RUN test -n "$GPG_KEY_LIST" || (echo "GPG_KEY_LIST build arg not set" && exit 1)
RUN for key in $GPG_KEY_LIST ; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done \
	&& wget -O php.tar.xz.asc "$PHP_ASC_URL" \
	&& gpg --batch --verify php.tar.xz.asc php.tar.xz \
    && mkdir -p php \
	&& tar -Jxf php.tar.xz -C /php --strip-components=1

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
ENV CFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2" \
    LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

RUN apk add --no-cache \
        curl-dev \
        icu-dev \
        libressl-dev \
        libxml2-dev \
        zlib-dev

ARG PHP_INI_DIR=/usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d \
    && cd /php \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
        --build="$gnuArch" \
        --disable-cgi \
        --disable-mysqlnd \
        --disable-pdo \
        --disable-session \
        --enable-bcmath \
        --enable-intl \
        --enable-maintainer-zts \
        --enable-mbstring \
        --enable-pcntl \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
        --with-curl \
        --with-openssl \
        --without-sqlite3 \
        --with-zlib

RUN cd /php \
    && make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
 	&& { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 	&& pecl update-channels \
    && printf "\
date.timezone=\"UTC\"\n\
request_order=GP\n\
expose_php=Off\n\
enable_dl=Off\n\
short_open_tag=Off\n\
zend.assertions=-1\n\
" > $PHP_INI_DIR/php.ini \
    && echo zend_extension=$(php -r "echo ini_get('extension_dir').'/opcache.so';") > $PHP_INI_DIR/conf.d/00-opcache.ini \
    && printf "\
opcache.max_accelerated_files=16229\n\
opcache.enable_file_override=1\n\
opcache.log_verbosity_level=0\n\
opcache.fast_shutdown=1\n\
" >> $PHP_INI_DIR/conf.d/00-opcache.ini

ARG APCUBC_VERSION
RUN if [ -z "$APCUBC_VERSION" ] ; then \
         echo "Don't installing apcu_bc extension"; \
    else \
        printf "\n" | pecl install apcu_bc-${APCUBC_VERSION} \
        && printf "\
extension=apcu.so\n\
extension=apc.so\n\
" > $PHP_INI_DIR/conf.d/100-apc.ini; \
    fi

ARG RAPHF_VERSION
RUN if [ -z "$RAPHF_VERSION" ] ; then \
         echo "Don't installing raphf extension"; \
    else \
        pecl install raphf-${RAPHF_VERSION} \
        && printf "\
extension=raphf.so\n\
" > $PHP_INI_DIR/conf.d/100-raphf.ini; \
    fi

ARG AMQP_VERSION
RUN if [ -z "$AMQP_VERSION" ] ; then \
         echo "Don't installing amqp extension"; \
    else \
        apk add --no-cache rabbitmq-c-dev \
        && printf "\n" | pecl install amqp-${AMQP_VERSION} \
        && printf "\
extension=amqp.so\n\
" > $PHP_INI_DIR/conf.d/100-amqp.ini; \
    fi

ARG AST_VERSION
RUN if [ -z "$AST_VERSION" ] ; then \
        echo "Don't installing ast extension"; \
    else \
        pecl install ast-${AST_VERSION}; \
    fi

RUN rm -rf \
        /usr/local/php/man \
        /usr/local/lib/perl5 \
        /usr/local/share/perl5 \
        /usr/local/lib/perl5 \
    & scanelf --needed --nobanner --recursive /usr/local \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u > /usr/local/rundeps.list

FROM raw
FROM alpine:3.7 as refined

COPY --from=raw /usr/local /usr/local

ARG COMPOSER_VERSION
RUN addgroup -g 1000 php \
    && adduser -u 1000 -G php -s /bin/ash -D php \
    && mkdir -p /home/php/app /home/php/bin \
    && chown php:php /home/php/app /home/php/bin \
    && apk add --no-cache $(cat /usr/local/rundeps.list) \
    && if [ -z "$COMPOSER_VERSION" ] ; then \
         echo "Don't installing composer"; \
    else \
        wget -O - https://getcomposer.org/installer | php -- --install-dir=/home/php/bin --filename=composer --version=${COMPOSER_VERSION} \
            && chown php:php /home/php/bin/composer; \
    fi

USER php
ENV PATH="$PATH:/home/php/bin" \
    COMPOSER_BIN_DIR=/home/php/bin

ARG PRESTISSIMO_VERSION
RUN if [ -z "$PRESTISSIMO_VERSION" ] || [ "$PRESTISSIMO_VERSION$COMPOSER_VERSION" == "$PRESTISSIMO_VERSION" ] ; then \
        echo "Don't installing prestissimo"; \
    else \
        composer global require hirak/prestissimo:$PRESTISSIMO_VERSION && composer global clear-cache -vvv; \
    fi

WORKDIR /home/php/app
