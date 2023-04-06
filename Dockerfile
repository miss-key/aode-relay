FROM rust:1-alpine3.17 AS builder

RUN apk add --no-cache openssl libc-dev openssl-dev protobuf protobuf-dev

RUN mkdir -p /opt/aode-relay
WORKDIR /opt/aode-relay

ADD . /opt/aode-relay

RUN cargo build --release


FROM alpine:3.17

RUN apk add --no-cache openssl ca-certificates tini

ENTRYPOINT ["/sbin/tini", "--"]

COPY --from=builder /opt/aode-relay/target/release/relay /usr/bin/aode-relay

CMD ["/usr/bin/aode-relay"]
