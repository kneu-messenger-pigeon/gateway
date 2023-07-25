FROM nginx:stable-alpine-slim

COPY ssl /ssl-default
COPY nginx-reload-ssl.sh /docker-entrypoint.d/40-nginx-reload-ssl.sh

# Copy the nginx configuration file
COPY default.conf  /etc/nginx/conf.d/default.conf

HEALTHCHECK  --interval=5m --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
