ARG ALPINE_VERSION=latest

FROM golang:alpine AS builder
ARG GOARCH=amd64
ARG GOARM=6

COPY . /go/src/github.com/JohannWeging/setup-mosquitto
WORKDIR /go/src/github.com/JohannWeging/setup-mosquitto

RUN set -x \
 && GOARCH=${GOARCH} GOARM=${GOARM} go build -o setup-mosquitto

FROM johannweging/base-alpine:${ALPINE_VERSION}

ENV CONFIG_FILE=/etc/mosquitto/mosquitto.conf MQ_PASSWORD_FILE=/etc/mosquitto/pwfile \
    MQ_PERSISTENCE_LOCATION=/var/lib/mosquitto/ MQ_PERSISTENCE_FILE=mosquitto.db

COPY --from=builder /go/src/github.com/JohannWeging/setup-mosquitto/setup-mosquitto /usr/bin
COPY run.sh /run.sh

RUN set -x \
 && apk add --update --no-cache mosquitto \
 && chmod +x /run.sh

EXPOSE 1883

ENTRYPOINT ["/usr/bin/dumb-init", "--rewrite", "15:2" "--"]
CMD ["/run.sh"]
