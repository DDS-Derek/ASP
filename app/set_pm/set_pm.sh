#!/bin/bash

function set_pm {
	echo
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
	echo
}

if [[ ${SET_PM} = 'true' ]]; then

	set_pm

    if [[ ${SMTP} = 'true' ]]; then
	    bash /app/message/channel/smtp
    fi

    if [[ ${TGBOT} = 'true' ]]; then
        bash /app/message/channel/tgbot
    fi

    if [[ ${SERVERCHAN} = 'true' ]]; then
        bash /app/message/channel/serverchan
    fi

fi