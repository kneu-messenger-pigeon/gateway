#!/usr/bin/env sh

mkdir -p /ssl
set -e

[ -L /ssl-enabled ] && rm /ssl-enabled

if [ -f /ssl/fullchain.pem ] && [ -f /ssl/privkey.pem ]; then
  echo "Use custom ssl certificates from /ssl"
  ln -s /ssl /ssl-enabled
else
  echo "Use default ssl certificates from /ssl-default"
  ln -s /ssl-default /ssl-enabled
fi

if [ -f /ssl/dhparam.pem ]; then
  echo "Use custom dhparam.pem from /ssl"
  ln -s /ssl/dhparam.pem /dhparam.pem
else
  echo "Use default dhparam.pem from /ssl-default"
  ln -s /ssl-default/dhparam.pem /dhparam.pem
fi

# reload nginx every day - this is a workaround for reload ssl certificates after update
nohup /bin/sh -c 'while :; do sleep 1d; nginx -t && nginx -s reload; done' >/dev/null 2>&1 &
