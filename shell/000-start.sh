#!/bin/bash

echo /shell/ASP

# 设置时区
if [ ! -f "/tz.lock" ]; then
    echo -e "\033[34m设置时区... \033[0m"
    bash /shell/010-tz.sh
fi

if [ ! -f "/adduser.lock" ]; then
    touch /adduser.lock
    echo -e "\033[34m设置PUID PGID... \033[0m"
    bash /shell/011-adduser.sh
fi

# 创建logs文件
if [ ! -f "/app/log/ASP.log" ]; then
    echo -e "\033[34m创建logs文件... \033[0m"
    touch /app/log/ASP.log
fi

# 设置crontab
if [ ! -f "/run.lock" ]; then
    touch /run.lock
    echo -e "\033[34m设置定时任务中... \033[0m"
    (crontab -l ; echo "0 */2 * * * /shell/run.sh") | crontab -
fi

# 测试SMTP
if [[ ${SMTP} = 'true' ]]; then
    echo -e "\033[34m测试SMTP中... \033[0m"
    sendEmail \
        -f $FROM_EMAIL \
        -s $MAILER_HOST \
        -t $TO_EMAIL \
        -xu $MAILER_USER \
        -xp $MAILER_PASSWORD \
        -o tls=$TLS \
        -u ASP Mial \
        -m 这是一件测试邮件 \
        This is a test email \
        -o message-content-type=html \
        -o message-charset=utf-8
fi

# 启动
exec /usr/bin/supervisord -n -c /app/supervisord.conf
