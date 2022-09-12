#!/bin/bash

. /app/notification.sh

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
	smtp
fi

if [[ ${TGBOT} = 'true' ]]; then
	tgbot
fi

if [[ ${SERVERCHAN} = 'true' ]]; then
	serverchan
fi