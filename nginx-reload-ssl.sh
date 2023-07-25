#!/usr/bin/env sh
mkdir -p /ssl

[ -f /ssl/fullchain.pem ] || cp /ssl-default/fullchain.pem /ssl/fullchain.pem
[ -f /ssl/privkey.pem ] || cp /ssl-default/privkey.pem /ssl/privkey.pem
[ -f /ssl/dhparam.pem ] || cp /ssl-default/dhparam.pem /ssl/dhparam.pem

# reload nginx every day - this is a workaround for reload ssl certificates after update
nohup /bin/sh -c 'while :; do sleep 1d; nginx -t && nginx -s reload; done' >/dev/null 2>&1 &
