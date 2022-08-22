#!/bin/bash

chown -R abc:abc /00-asp
chown -R abc:abc /01-asp
chown -R abc:abc /02-asp
chown -R abc:abc /03-asp
chmod -R $CFVR /00-asp
chmod -R $CFVR /01-asp
chmod -R $CFVR /02-asp
chmod -R $CFVR /03-asp
echo '设置完成'
if [[ ${SMTP} = 'true' ]]; then
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
fi