#!/bin/sh
set -eu

SSL_CERT=/var/www/html/ssl/fullchain.pem
SSL_KEY=/var/www/html/ssl/privkey.pem

if [ ! -f "$SSL_CERT" ]; then
    echo "missing certificate file: $SSL_CERT" >&2
    exit 1
fi

if [ ! -f "$SSL_KEY" ]; then
    echo "missing private key file: $SSL_KEY" >&2
    exit 1
fi

php-fpm -F &
PHP_PID=$!

nginx -g 'daemon off;' &
NGINX_PID=$!

term_handler() {
    kill -TERM "$PHP_PID" "$NGINX_PID" 2>/dev/null || true
    wait "$PHP_PID" "$NGINX_PID" 2>/dev/null || true
}

trap term_handler INT TERM QUIT

while kill -0 "$PHP_PID" 2>/dev/null && kill -0 "$NGINX_PID" 2>/dev/null; do
    sleep 1
done

term_handler
exit 1
