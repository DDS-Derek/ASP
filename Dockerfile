FROM alpine:3.16

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Shanghai \
    CFVR=755 \
    PT_QIANDAO=true \
    SET_PM=true \
    SMTP=false \
    FROM_EMAIL=test@test.com \
    MAILER_HOST=smtp.test.com:25 \
    TO_EMAIL=test@test.com \
    MAILER_USER=test@test.com \
    MAILER_PASSWORD=test \
    TLS=yes \
    TGBOT=false \
    TGBOT_SEND_TOKEN= \
    TGBOT_SEND_CHATID= \
    SERVERCHAN=false \
    SERVERCHAN_KEY= \
    IYUU_API=IYUU13547Tbs7e4d6ef8a4bee3afce47f24ed954af0bd25exx

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk add --no-cache --update \
    python3-dev \
    py3-pip \
    tzdata \
    shadow \
    bash \
    curl \
    coreutils \
    jq \
    perl \
    perl-net-ssleay \
    perl-io-socket-ssl \
    supervisor && \
    python3 -m pip install requests && \
    wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz -P /tmp/ && \
    tar -xzvf /tmp/sendEmail-v1.56.tar.gz -C /tmp/ && \
    cp -a /tmp/sendEmail-v1.56/sendEmail /usr/local/bin && \
    sed -i "1906s/.*/if (\! IO::Socket::SSL->start_SSL(\$SERVER, SSL_version => \'SSLv23:\!SSLv2\', SSL_verify_mode => 0)) {/" /usr/local/bin/sendEmail && \ 
    addgroup -S abc && \
    adduser -S abc -G abc -h /home/abc && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*

COPY --chmod=755 ./app /app

CMD [ "/app/run.sh" ]

VOLUME [ "/app/log" ]
VOLUME [ "/app/pt_qiandao" ]