ARG DOCKER_VERSION
ARG PHP_VERSION
FROM docker:${DOCKER_VERSION} as docker
FROM ubirak/php:${PHP_VERSION}

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
