FROM php/pgsql:v1.0
LABEL Author=hombergh
# enable pg with php
RUN apt-get update && apt-get install -y apt-utils libpq-dev postgresql-client-13  && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql

COPY . /var/www/

#CMD ["apache2ctl","restart"]

