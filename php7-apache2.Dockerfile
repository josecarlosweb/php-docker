ARG UID=root
ARG GID=root
ARG USER

FROM php:7.3-apache

RUN docker-php-ext-install \
    bcmath calendar curl dom fileinfo gd hash json ldap mbstring mcrypt \
    mysqli pgsql pdo pdo_dblib pdo_mysql pdo_pgsql sockets xml xsl zip

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