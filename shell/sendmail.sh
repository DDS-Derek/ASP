#!/bin/bash

sendEmail \
    -f $MAILER_USER \
    -s $MAILER_HOST \
    -t $TO_EMAIL \
    -xu $MAILER_USER \
    -xp $MAILER_PASSWORD \
    -o tls=$TLS \
    -u ASP Mial \
    -m 设置权限成功 \
    -o message-content-type=html \
    -o message-charset=utf-8