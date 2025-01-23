FROM alpine:3.21

LABEL description="Simple forum software for building great communities" \
      maintainer="Magicalex <magicalex@mondedie.fr>"

ARG VERSION=v2.0.0-beta.2

ENV GID=991 \
    UID=991 \
    UPLOAD_MAX_SIZE=50M \
    PHP_MEMORY_LIMIT=128M \
    OPCACHE_MEMORY_LIMIT=128 \
    DB_HOST=mariadb \
    DB_USER=flarum \
    DB_NAME=flarum \
    DB_PORT=3306 \
    FLARUM_TITLE=Docker-Flarum \
    DEBUG=false \
    LOG_TO_STDOUT=false \
    FLARUM_PORT=8888

RUN apk update && apk add --no-progress --no-cache \
    curl \
    git \
    icu-data-full \
    libcap \
    nginx \
    php84 \
    php84-ctype \
    php84-curl \
    php84-dom \
    php84-exif \
    php84-fileinfo \
    php84-fpm \
    php84-gd \
    php84-gmp \
    php84-iconv \
    php84-intl \
    php84-mbstring \
    php84-mysqlnd \
    php84-opcache \
    php84-pecl-apcu \
    php84-openssl \
    php84-pdo \
    php84-pdo_mysql \
    php84-phar \
    php84-session \
    php84-tokenizer \
    php84-xmlwriter \
    php84-zip \
    php84-zlib \
    su-exec \
    s6 \
  && cd /tmp \
  && curl --progress-bar http://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && sed -i 's/memory_limit = .*/memory_limit = ${PHP_MEMORY_LIMIT}/' /etc/php84/php.ini \
  && chmod +x /usr/local/bin/composer \
  && mkdir -p /run/php /flarum/app \
  && COMPOSER_CACHE_DIR="/tmp" composer create-project flarum/flarum:$VERSION /flarum/app \
  && composer clear-cache \
  && rm -rf /flarum/.composer /tmp/* \
  && setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/nginx

COPY rootfs /
RUN chmod +x /usr/local/bin/* /etc/s6.d/*/run /etc/s6.d/.s6-svscan/*
VOLUME /etc/nginx/flarum /flarum/app/extensions /flarum/app/public/assets /flarum/app/storage/logs
CMD ["/usr/local/bin/startup"]
