#!/usr/bin/env sh
set -e
NAME=test-nginx
docker rm -f $NAME || true

sed -i.bak 's/--interval=[^ ]*/--interval=1s/g' Dockerfile
docker build -t $NAME .

docker run -d --rm --add-host authorizer:127.0.0.1 --add-host host.docker.internal:host-gateway --name $NAME $NAME
trap "docker rm -f $NAME" EXIT HUP INT QUIT PIPE TERM

docker exec $NAME nginx -t

sleep 1
docker ps -f name=$NAME -f health=healthy | grep $NAME
docker down $NAME
