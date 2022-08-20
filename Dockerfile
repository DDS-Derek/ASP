FROM alpine:3.16

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Shanghai

ADD ./shell /shell

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk add --no-cache --update tzdata shadow bash && \
    addgroup -S abc && \
    adduser -S abc -G abc -h /home/abc && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    rm -rf /tmp/* && \
    chmod -R 755 /shell && \
    mkdir -p /app && \
    mkdir -p /00-asp && \
    mkdir -p /01-asp && \
    mkdir -p /02-asp && \
    mkdir -p /03-asp

CMD [ "/shell/000-start.sh" ]