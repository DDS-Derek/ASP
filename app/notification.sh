#!/bin/bash

function smtp {
sendEmail \
	-f $FROM_EMAIL \
	-s $MAILER_HOST \
	-t $TO_EMAIL \
	-xu $MAILER_USER \
	-xp $MAILER_PASSWORD \
	-o tls=$TLS \
	-u ASP Mial \
	-m 设置权限成功 \
	Set permissions successfully \
	-o message-content-type=html \
	-o message-charset=utf-8
}


function tgbot {
curl -s -k "https://api.telegram.org/bot$TGBOT_SEND_TOKEN/sendMessage" \
    --data-urlencode "chat_id=$TGBOT_SEND_CHATID" \
    --data-urlencode "text=设置权限成功 Set permissions successfully"
}


function serverchan {
curl -s "http://sc.ftqq.com/$SERVERCHAN_KEY.send?text=ASP" -d "&desp=设置权限成功 Set permissions successfully"
}