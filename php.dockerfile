#FROM php:8.1-fpm-alpine
FROM php:8.2-fpm-alpine
#FROM php:8.3-fpm-alpine

RUN touch /var/log/error_log

ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN addgroup -g 1000 wp && adduser -G wp -g wp -s /bin/sh -D wp

RUN mkdir -p /var/www/html
RUN chown wp:wp /var/www/html

WORKDIR /var/www/html

RUN apk add --no-cache libpng libpng-dev libjpeg-turbo libjpeg-turbo-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd \
    && apk del --no-cache libpng-dev libjpeg-turbo-dev

RUN apk add --no-cache libzip-dev \
    && docker-php-ext-install zip

RUN apk add --no-cache icu-dev \
    && docker-php-ext-install intl

RUN apk add --no-cache libexif-dev \
    && docker-php-ext-install exif

RUN apk add --no-cache imagemagick-dev libtool autoconf build-base \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN docker-php-ext-install mysqli pdo pdo_mysql opcache && docker-php-ext-enable pdo_mysql opcache
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Add the path to preload.php in php.ini
RUN echo "opcache.preload_user=www-data" >> /usr/local/etc/php/php.ini
RUN echo "opcache.preload=/var/www/html/preload.php" >> /usr/local/etc/php/php.ini

# Configure OPCache
RUN echo "opcache.enable=1" >> /usr/local/etc/php/php.ini
RUN echo "opcache.memory_consumption=1024" >> /usr/local/etc/php/php.ini
RUN echo "opcache.interned_strings_buffer=64" >> /usr/local/etc/php/php.ini
RUN echo "opcache.max_accelerated_files=16000" >> /usr/local/etc/php/php.ini
RUN echo "opcache.max_wasted_percentage=10" >> /usr/local/etc/php/php.ini
RUN echo "opcache.revalidate_freq=5" >> /usr/local/etc/php/php.ini
RUN echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/php.ini
RUN echo "opcache.enable_cli=1" >> /usr/local/etc/php/php.ini
RUN echo "opcache.validate_timestamps=0" >> /usr/local/etc/php/php.ini

# Configure PHP
RUN echo "max_input_vars=5000" >> /usr/local/etc/php/php.ini
RUN echo "max_execution_time=300" >> /usr/local/etc/php/php.ini
RUN echo "memory_limit=512M" >> /usr/local/etc/php/php.ini
RUN echo "max_input_time=60" >> /usr/local/etc/php/php.ini
RUN echo "upload_max_filesize=64M" >> /usr/local/etc/php/php.ini
RUN echo "post_max_size=128M" >> /usr/local/etc/php/php.ini
RUN echo "allow_url_include=On" >> /usr/local/etc/php/php.ini