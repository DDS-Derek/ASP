#!/bin/bash

. /app/settings.sh

cat /app/ASP

lock

set_tz

adduser

logs

set_supervisord

set_pm

pt_qiandao

test_notification

cat_cron

exec /usr/bin/supervisord -n -c /app/supervisord.conf