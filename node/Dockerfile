ARG FROM_FLOW_FQIN
ARG FROM_NODE_FQIN

FROM ${FROM_FLOW_FQIN} as flow
FROM ${FROM_NODE_FQIN}

COPY --from=flow /usr/local/bin/flow /usr/local/bin/flow

RUN apk add --no-cache --virtual .build-app-deps \
        bash \
        tar \
        curl \
        git

USER node

WORKDIR /home/node
