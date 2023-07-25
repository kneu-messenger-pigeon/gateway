#!/usr/bin/env sh
mkdir -p /ssl

[ -f /ssl/fullchain.pem ] && [ -f /ssl/privkey.pem ] && [ -f /ssl/dhparam.pem ] && exit 0


# reload nginx every day - this is a workaround for reload ssl certificates after update
nohup /bin/sh -c 'while :; do sleep 1d; nginx -t && nginx -s reload; done' >/dev/null 2>&1 &
