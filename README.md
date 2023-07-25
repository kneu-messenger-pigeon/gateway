### Run test
```shell
docker build -t test-nginx . && \
docker run --rm --add-host authorizer:127.0.0.1 --add-host host.docker.internal:host-gateway test-nginx nginx -t
```

### Run container
```shell
docker build -t test-nginx . && \
docker run -it --rm --add-host authorizer:127.0.0.1 --add-host host.docker.internal:host-gateway test-nginx
```


### Docker-compose example
```yaml
services:
  gateway:
    image: ghcr.io/kneu-messenger-pigeon/gateway:main
    restart: always
    ports:
      - "8083:80"
      - "8443:443"

    volumes:
      - type: bind
        source: /etc/letsencrypt/live/example.org
        target: /ssl
        read_only: true
```
