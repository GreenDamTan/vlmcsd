FROM alpine:latest as builder
COPY . /root/vlmcsd/
WORKDIR /root
RUN apk add --no-cache git make build-base && \
    cd vlmcsd/ && \
    make

FROM alpine:latest
WORKDIR /root/
RUN apk add --no-cache bash busybox &&\
    /bin/busybox --install
COPY --from=builder /root/vlmcsd/bin/vlmcsd /vlmcsd
COPY --from=builder /root/vlmcsd/etc/vlmcsd.kmd /vlmcsd.kmd
EXPOSE 1688/tcp
CMD ["/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]
