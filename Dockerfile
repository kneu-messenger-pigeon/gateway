FROM nginx:stable-alpine-slim

COPY ssl /ssl-default
COPY nginx-reload-ssl.sh /docker-entrypoint.d/40-nginx-reload-ssl.sh

# Copy the nginx configuration file
COPY default.conf  /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=15s --timeout=3s --start-period=2s \
  CMD wget --no-verbose --tries=1 --spider http://localhost/healthcheck || exit 1
