# Public Docker image

## Features 

 * PHP 8.2 via deb.sury.org
 * PHP GRPC module
 * PHP Protobuf module
 * PHP composer 2.7.9
 * Apache mod\_php

Currently built on Debian bookworm

See also: https://hub.docker.com/r/socialsigninapp/docker-debian-gcp-php82/

## Building

( http\_proxy stuff is optional. )

```bash
docker build \
    --build-arg=http_proxy="http://192.168.86.66:3128" \
    --build-arg=https_proxy="http://192.168.86.66:3128" \
    --no-cache \
    --rm \
    -t socialsigninapp/docker-debian-gcp-php82:latest \
    -t socialsigninapp/docker-debian-gcp-php82:$(date +%F) \
    --pull \
    .
```

## Todo

 * Link better to Debian/Debsury.org so we rebuild on change of those files
