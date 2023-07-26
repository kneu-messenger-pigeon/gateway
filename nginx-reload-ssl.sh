#!/usr/bin/env sh

mkdir -p "$SSL_FOLDER"
set -e

[ -L /ssl-enabled ] && rm /ssl-enabled

if [ -f "$SSL_FOLDER/fullchain.pem" ] && [ -f "$SSL_FOLDER/ssl/privkey.pem" ]; then
  echo "Use custom ssl certificates from $SSL_FOLDER"
  ln -s "$SSL_FOLDER" /ssl-enabled
else
  echo "Use default ssl certificates from /ssl-default"
  ln -s /ssl-default /ssl-enabled
fi

if [ -f "$SSL_FOLDER/dhparam.pem" ]; then
  echo "Use custom dhparam.pem from $SSL_FOLDER"
  ln -s "$SSL_FOLDER/dhparam.pem" /dhparam.pem
else
  echo "Use default dhparam.pem from /ssl-default"
  ln -s /ssl-default/dhparam.pem /dhparam.pem
fi

# reload nginx every day - this is a workaround for reload ssl certificates after update
nohup /bin/sh -c 'while :; do sleep 1d; nginx -t && nginx -s reload; done' >/dev/null 2>&1 &
