FROM alpine:3.19 as builder

RUN apk add --no-cache build-base openssl-dev zlib-dev libssh2-dev nghttp2-dev \
    && wget https://curl.se/download/curl-8.6.0.tar.gz \
    && tar -xzf curl-8.6.0.tar.gz \
    && cd curl-8.6.0 \
    && ./configure --with-ssl \
    && make \
    && make install

FROM alpine:3.19

RUN apk add --no-cache bash=4.3.48-r1 grep sed jq
COPY --from=builder /usr/local/bin/curl /usr/bin/curl

COPY crawling.sh /app/crawling.sh
WORKDIR /app

RUN chmod +x crawling.sh

ENTRYPOINT ["./crawling.sh"]
