FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
        libmagickwand-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        git

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install mysqli

RUN pecl install imagick && docker-php-ext-enable imagick
RUN echo $PATH

RUN rm /etc/apache2/apache2.conf && rm -rf /etc/apache2/sites-enabled/*
COPY conf/webapp.conf /etc/apache2/sites-enabled
COPY conf/apache2.conf /etc/apache2
COPY conf/php.ini /usr/local/etc/php

RUN a2enmod rewrite
