FROM alpine:latest as openssl

RUN apk add --no-cache openssl

RUN mkdir /ssl-default
RUN openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
    -keyout '/ssl-default/privkey.pem' \
    -out '/ssl-default/fullchain.pem' \
    -subj '/CN=localhost'

RUN openssl dhparam -out /ssl-default/dhparam.pem 2048

FROM nginx:stable-alpine-slim

ENV SSL_FOLDER=/ssl

COPY --from=openssl /ssl-default /ssl-default
COPY nginx-reload-ssl.sh /docker-entrypoint.d/40-nginx-reload-ssl.sh

# Copy the nginx configuration file
COPY default.conf  /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s \
  CMD wget --no-verbose --tries=1 --spider http://localhost/healthcheck || exit 1
