FROM php:8.4-fpm-alpine

# Build deps for PECL extensions, then install required PHP extensions.
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS linux-headers \
    && docker-php-ext-install pdo_mysql \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
