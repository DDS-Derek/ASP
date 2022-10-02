#!/bin/bash

function pt_qiandao {
	echo
	python3 /app/sites/pt.py
	date
	echo 'PT站点签到成功'
	echo
}

if [[ ${PT_QIANDAO} = 'true' ]]; then
    sleep $[ ( $RANDOM % 3600 ) + 1 ]
	pt_qiandao
fi