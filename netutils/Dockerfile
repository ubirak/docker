ARG FROM_FQIN
FROM ${FROM_FQIN}

RUN apk add --update bind-tools curl tcpdump \
        && rm -rf /var/cache/apk/*

CMD ["ash"]