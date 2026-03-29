FROM php:8.3-fpm-alpine

RUN apk add --no-cache nginx libzip-dev \
    && docker-php-ext-install zip opcache \
    && mkdir -p /run/nginx

WORKDIR /var/www/html

COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/php/zz-local.conf /usr/local/etc/php-fpm.d/zz-local.conf
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf
COPY docker/start.sh /usr/local/bin/start-container.sh

RUN chmod +x /usr/local/bin/start-container.sh

EXPOSE 80 443

CMD ["/usr/local/bin/start-container.sh"]
