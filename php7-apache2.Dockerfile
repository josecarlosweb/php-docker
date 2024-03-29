ARG UID=root
ARG GID=root
ARG USER

FROM php:7.3-apache

RUN apt-get update && apt-get install -y \
    libpng-dev \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libgd3 \
    libxpm4

RUN docker-php-ext-install pdo pdo_mysql zip

RUN docker-php-ext-configure gd && \
    docker-php-ext-install gd

RUN pecl install xdebug && docker-php-ext-enable xdebug

# Instalando o Composer
RUN php -r "copy('http://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Setando o user:group do conteiner para o user:group da máquina host (ver arquivo .env e docker-compose.yml)
# Assim, o Composer passa a usar o mesmo user:group do usuário do host
# Configura também as pastas para o novo usuário
RUN chown -R ${UID}:${GID} /var/www/html
RUN chown -R ${UID}:${GID} /root/.composer
RUN mkdir -p /.composer && chown -R ${UID}:${GID} /.composer
RUN mkdir -p /.config && chown -R ${UID}:${GID} /.config
VOLUME /var/www/html
VOLUME /root/.composer
VOLUME /.composer
VOLUME /.config
USER ${UID}

RUN a2enmod rewrite