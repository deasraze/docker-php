FROM php:7.4.16-fpm

ARG USER_ID
ARG GROUP_ID

ADD ./conf.d $PHP_INI_DIR/conf.d

RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

WORKDIR /var/www

USER "${USER_ID}:${GROUP_ID}"

CMD ["php-fpm"]