FROM alpine:3.16

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Shanghai \
    CFVR=755 \
    SMTP=false \
    FROM_EMAIL=test@test.com \
    MAILER_HOST=smtp.test.com:25 \
    TO_EMAIL=test@test.com \
    MAILER_USER=test@test.com \
    MAILER_PASSWORD=test \
    TLS=yes \
    TGBOT=false \
    TGBOT_SEND_TOKEN= \
    TGBOT_SEND_CHATID=
    

ADD ./shell /shell

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk add --no-cache --update tzdata shadow bash perl perl-net-ssleay perl-io-socket-ssl supervisor && \
    wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz -P /tmp/ && \
    tar -xzvf /tmp/sendEmail-v1.56.tar.gz -C /tmp/ && \
    cp -a /tmp/sendEmail-v1.56/sendEmail /usr/local/bin && \
    sed -i "1906s/.*/if (\! IO::Socket::SSL->start_SSL(\$SERVER, SSL_version => \'SSLv23:\!SSLv2\', SSL_verify_mode => 0)) {/" /usr/local/bin/sendEmail && \ 
    addgroup -S abc && \
    adduser -S abc -G abc -h /home/abc && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    rm -rf /tmp/* && \
    chmod -R 755 /shell && \
    mkdir -p /app/log && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor.d/ && \
    mkdir -p /00-asp && \
    mkdir -p /01-asp && \
    mkdir -p /02-asp && \
    mkdir -p /03-asp && \
    cp /shell/asp.ini /app/supervisord.conf

CMD [ "/shell/000-start.sh" ]
