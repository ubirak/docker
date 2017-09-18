ARG FROM_FQIN
FROM ${FROM_FQIN}

COPY rmq-healthcheck /usr/local/bin/
COPY cluster-entrypoint.sh /usr/local/bin/
COPY definitions.json /etc/rabbitmq/rabbitmq_definitions.json
COPY config /etc/rabbitmq/rabbitmq.config

HEALTHCHECK CMD ["rmq-healthcheck"]
