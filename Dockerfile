FROM alpine:3.16

ENV CONFIG_DIR=/config

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Shanghai \
    PS1="\u@\h:\w \$ " \
    CFVR=755 \
    PT_QIANDAO=true \
    SET_PM=true \
    SMTP=false \
    SMTP_FROM_EMAIL=test@test.com \
    SMTP_MAILER_HOST=smtp.test.com:25 \
    SMTP_TO_EMAIL=test@test.com \
    SMTP_MAILER_USER=test@test.com \
    SMTP_MAILER_PASSWORD=test \
    SMTP_TLS=yes \
    TGBOT=false \
    TGBOT_SEND_TOKEN= \
    TGBOT_SEND_CHATID= \
    SERVERCHAN=false \
    SERVERCHAN_KEY= \
    IYUU_API=IYUU13547Tbs7e4d6ef8a4bee3afce47f24ed954af0bd25exx \
    Service_Sync=false

RUN \
    # 软件安装
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
        git \
        supervisor \
    && \
    # Python库 安装
    pip install \
        -r https://raw.githubusercontent.com/DDS-Derek/ASP/main/requirement.txt \
    && \
    # SendEmail 安装
    wget \
        http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz \
        -P /tmp/ \
    && \
    tar -xzvf \
        /tmp/sendEmail-v1.56.tar.gz \
        -C /tmp/ \
    && \
    cp \
        -a /tmp/sendEmail-v1.56/sendEmail \
        /usr/local/bin \
    && \
    sed -i \
        "1906s/.*/if (\! IO::Socket::SSL->start_SSL(\$SERVER, SSL_version => \'SSLv23:\!SSLv2\', SSL_verify_mode => 0)) {/" \
        /usr/local/bin/sendEmail \
    && \ 
    # appotry/PTtool 安装
    git clone \
        https://github.com/appotry/PTtool.git \
        /app/appotry_PTtool \
    && \
    curl \
        -o /app/Service_Sync.sh \
        https://github.com/DDS-Derek/VideoLab/raw/master/scripts/Service_Sync.sh \
    && \
    chmod -R 755 \
        /app/appotry_PTtool \
    && \
    # 创建用户
    addgroup \
        -S asp \
        -g 1000 \
    && \
    adduser \
        -S asp \
        -G asp \
        -h /home/asp \
        -u 1000 \
    && \
    # 清理
    rm -rf \
        /var/cache/apk/* \
        /root/.cache \
        /tmp/*

COPY --chmod=755 ./app /app

ENTRYPOINT [ "/app/run.sh" ]

VOLUME [ "/config" ]
