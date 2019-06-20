FROM php:7.2-fpm

WORKDIR /code
RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

RUN mkdir -p /code/storage/tinx
# RUN chown -R www-data:www-data /code
# RUN chmod 755 -R /code/storage

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libicu-dev \
    libmcrypt-dev \
    libpq-dev \
    libsqlite3-dev \
    openssl \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libgmp-dev \
    libldap2-dev \
    zip \
    unzip \
    git \
    nodejs \
    mysql-client --no-install-recommends \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-webp-dir=/usr/include/  --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mbstring exif bcmath intl soap zip pdo pdo_mysql pdo_pgsql gd \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
