#!/usr/bin/env sh
set -e
NAME=test-nginx
docker rm -f $NAME 2>/dev/null || true

sed -i.bak 's/--interval=[^ ]*/--interval=1s/g' Dockerfile

trap 'rm Dockerfile; mv Dockerfile.bak Dockerfile; docker rm -f $NAME > /dev/null' EXIT HUP INT QUIT PIPE TERM

docker build -t $NAME .
docker run -d --rm --add-host authorizer:127.0.0.1 --add-host host.docker.internal:host-gateway --name $NAME $NAME

docker logs $NAME
docker logs $NAME 2>&1 | grep "Use default ssl certificates from /ssl-default"

docker exec $NAME nginx -t

sleep 1
HEALTHY=$(docker ps -f name=$NAME -f health=healthy --quiet | wc -l)
if [ "$HEALTHY" -eq 1 ]; then
  echo "Container $NAME is healthy"
else
  echo "Container $NAME is not healthy"
  exit 1
fi
