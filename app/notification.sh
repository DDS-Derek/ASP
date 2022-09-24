#!/bin/bash

function pt_qiandao {
	python3 /app/pt.py
	date
	echo 'PT站点签到成功'
}

function set_pm {
	chown -R abc:abc /00-asp
	chown -R abc:abc /01-asp
	chown -R abc:abc /02-asp
	chown -R abc:abc /03-asp
	chmod -R $CFVR /00-asp
	chmod -R $CFVR /01-asp
	chmod -R $CFVR /02-asp
	chmod -R $CFVR /03-asp
	date
	echo '权限设置完成'
}

function smtp {
	date
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
	date
	curl -s -k "https://api.telegram.org/bot$TGBOT_SEND_TOKEN/sendMessage" \
		--data-urlencode "chat_id=$TGBOT_SEND_CHATID" \
		--data-urlencode "text=设置权限成功 Set permissions successfully"
}

function serverchan {
	date
	curl -s "http://sc.ftqq.com/$SERVERCHAN_KEY.send?text=ASP" -d "&desp=设置权限成功 Set permissions successfully"
}
