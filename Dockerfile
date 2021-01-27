FROM golang:1.15.6-alpine as builder

ENV VERSION 1.9.25

RUN apk add --no-cache make gcc musl-dev linux-headers git

RUN git clone https://github.com/ethereum/go-ethereum.git /go-ethereum
WORKDIR /go-ethereum
RUN git checkout "v${VERSION}" && make geth

FROM alpine:latest as runner

ENV DATA_DIR /chain
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

RUN mkdir $DATA_DIR
VOLUME $DATA_DIR

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]