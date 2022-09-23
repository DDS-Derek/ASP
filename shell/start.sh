#!/bin/bash

cat /shell/ASP

# 设置时区
if [ ! -f "/tz.lock" ]; then
    echo -e "\033[34m设置时区... \033[0m"
    ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
    echo $TZ > /etc/timezone
    touch /tz.lock
    echo "设置完成" > /tz.lock
fi

# 设置用户UID GID
if [ ! -f "/adduser.lock" ]; then
    touch /adduser.lock
    echo -e "\033[34m设置PUID PGID... \033[0m"
    groupmod -o -g "$PGID" abc
    usermod -o -u "$PUID" abc
fi

# 设置supervisord
if [ ! -f "/supervisord.lock" ]; then
    touch /supervisord.lock
    cp /shell/asp.ini /app/supervisord.conf
fi

# 创建文件夹
if [ ! -d "/app/log" ]; then
    mkdir -p /app/log
fi

if [ ! -d "/app/pt_qiandao" ]; then
    mkdir -p /app/pt_qiandao
fi

if [ ! -d "/var/log/supervisor" ]; then
    mkdir -p /var/log/supervisor
fi

if [ ! -d "/etc/supervisor.d/" ]; then
    mkdir -p /etc/supervisor.d/
fi

if [ ! -d "/00-asp" ]; then
    mkdir -p /00-asp
fi

if [ ! -d "/01-asp" ]; then
    mkdir -p /01-asp
fi

if [ ! -d "/02-asp" ]; then
    mkdir -p /02-asp
fi

if [ ! -d "/03-asp" ]; then
    mkdir -p /03-asp
fi

# 创建logs文件
if [ ! -f "/app/log/ASP.log" ]; then
    echo -e "\033[34m创建logs文件... \033[0m"
    touch /app/log/ASP.log
fi

# 设置pt签到
if [[ ${PT_QIANDAO} = 'true' ]]; then
    # 创建pt_site_qiaodao_settings文件
    if [ ! -f "/app/pt_qiandao/site.json" ]; then
        echo -e "\033[34m创建pt_site_qiaodao_settings文件... \033[0m"
        touch /app/pt_qiandao/site.json
    fi

    # 创建pt_site_qiaodao_app文件
    if [ ! -f "/app/pt_qiandao/pt.py" ]; then
        echo -e "\033[34m创建pt_site_qiaodao_app文件... \033[0m"
        cp /app/pt.py /app/pt_qiandao/pt.py
    fi
fi

# 设置crontab
if [ ! -f "/run.lock" ]; then
    touch /run.lock
    echo -e "\033[34m设置定时任务中... \033[0m"
    (crontab -l ; echo "0 */2 * * * /app/run.sh") | crontab -
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

# 测试TG机器人
if [[ ${TGBOT} = 'true' ]]; then
    curl -s -k "https://api.telegram.org/bot$TGBOT_SEND_TOKEN/sendMessage" \
        --data-urlencode "chat_id=$TGBOT_SEND_CHATID" \
        --data-urlencode "text=这是一条测试消息 This is a test message"
fi

# 测试Server酱
if [[ ${SERVERCHAN} = 'true' ]]; then
    curl -s "http://sc.ftqq.com/$SERVERCHAN_KEY.send?text=ASP" -d "&desp=这是一条测试消息 This is a test message"
fi

# 启动
exec /usr/bin/supervisord -n -c /app/supervisord.conf
