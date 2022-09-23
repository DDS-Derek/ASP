#!/bin/bash

. /app/notification.sh

if [[ ${SET_PM} = 'true' ]]; then
	set_pm
fi

if [[ ${PT_QIANDAO} = 'true' ]]; then
	pt_qiandao
fi

if [[ ${SMTP} = 'true' ]]; then
	smtp
fi

if [[ ${TGBOT} = 'true' ]]; then
	tgbot
fi

if [[ ${SERVERCHAN} = 'true' ]]; then
	serverchan
fi