#!/bin/bash

. /app/notification.sh

if [[ ${PT_QIANDAO} = 'true' ]]; then
    sleep $[ ( $RANDOM % 3600 ) + 1 ]
	pt_qiandao
fi