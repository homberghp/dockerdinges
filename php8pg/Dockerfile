FROM php:8.0.9-apache

RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libpq-dev postgresql-client-13  && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql
COPY . /var/www/



