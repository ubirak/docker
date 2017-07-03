FROM alpine:3.6

ARG FLOW_VERSION
ARG OCAML_VERSION

RUN apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        m4 \
        opam \
        lz4 \
        lz4-dev \
        libelf-dev \
        ncurses \
        inotify-tools \
        linux-headers \
        diffutils \
    && cd /tmp \
    && opam init --comp=$OCAML_VERSION \
    && eval `opam config env` \
    && opam install sedlex \
    && curl --compressed -SL https://github.com/facebook/flow/archive/v${FLOW_VERSION}.tar.gz -o /tmp/flow-${FLOW_VERSION}.tgz \
    && tar -C /tmp -xzpf /tmp/flow-${FLOW_VERSION}.tgz \
    && rm /tmp/flow-${FLOW_VERSION}.tgz \
    && cd /tmp/flow-${FLOW_VERSION} \
    && make -j"$(getconf _NPROCESSORS_ONLN)" \
    && cd / \
    && cp /tmp/flow-${FLOW_VERSION}/bin/flow /usr/local/bin \
    && rm -rf /tmp/* \
    && opam repository remove default \
    && rm -rf /root/.opam \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && echo $runDeps > /.flow-rundeps \
    && apk add --no-cache --virtual .flow-rundeps $runDeps \
    && apk del --no-cache .build-deps

CMD ["flow", "check"]
