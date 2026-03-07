#!/bin/sh
set -eu

envsubst '${TZ}' < /usr/local/etc/php/php.ini.template > /usr/local/etc/php/conf.d/zz-app.ini
envsubst '${XDEBUG_MODE} ${XDEBUG_CLIENT_HOST} ${XDEBUG_CLIENT_PORT}' \
  < /usr/local/etc/php/xdebug.ini.template \
  > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

exec docker-php-entrypoint "$@"
