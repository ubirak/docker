ARG FROM_FQIN
FROM ${FROM_FQIN}

COPY rmq-healthcheck /usr/local/bin/
COPY cluster-entrypoint.sh /usr/local/bin/

HEALTHCHECK CMD ["rmq-healthcheck"]
