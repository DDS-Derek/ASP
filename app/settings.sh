#!/bin/bash

function lock {

    if [ ! -d "/app/lock" ]; then
        mkdir -p /app/lock
    fi

}

function logs {

    if [ ! -d "/app/log" ]; then
        mkdir -p /app/log
    fi

    if [ ! -f "/app/log/ASP.log" ]; then
        echo -e "\033[34m创建 logs 文件... \033[0m"
        touch /app/log/ASP.log
    fi

}

function pt_qiandao {

    if [[ ${PT_QIANDAO} = 'true' ]]; then

        if [ ! -d "/app/pt_qiandao" ]; then
            mkdir -p /app/pt_qiandao
        fi

        if [ ! -f "/app/pt_qiandao/site.json" ]; then
            echo -e "\033[34m创建pt_site_qiaodao_settings文件... \033[0m"
            touch /app/pt_qiandao/site.json
        fi

        if [ ! -f "/app/lock/pt_qiandao.lock" ]; then
            touch /app/lock/pt_qiandao.lock
            echo -e "\033[34m设置 PT签到 定时任务中... \033[0m"
            (crontab -l ; echo "0 8 * * * /app/pt_qiandao.sh") | crontab -
            echo -e "\033[34m设置 PT签到消息通知 中... \033[0m"
            sed -i "/.*api = */c\    api = 'http://iyuu.cn/$IYUU_API.send'" /app/pt.py
        fi

    fi

}

function set_pm {

    if [[ ${SET_PM} = 'true' ]]; then

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

        if [ ! -f "/app/lock/set_pm.lock" ]; then
            touch /app/lock/set_pm.lock
            echo -e "\033[34m设置 自动设置文件权限 定时任务中... \033[0m"
            (crontab -l ; echo "0 */2 * * * /app/set_pm.sh") | crontab -
        fi
    fi

}

function test_notification {

    if [[ ${SMTP} = 'true' ]]; then
        echo -e "\033[34m测试 SMTP 中... \033[0m"
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
        echo
    fi

    if [[ ${TGBOT} = 'true' ]]; then
        echo -e "\033[34m测试 Telegram Bot 中... \033[0m"
        curl -s -k "https://api.telegram.org/bot$TGBOT_SEND_TOKEN/sendMessage" \
            --data-urlencode "chat_id=$TGBOT_SEND_CHATID" \
            --data-urlencode "text=这是一条测试消息 This is a test message"
        echo
    fi

    if [[ ${SERVERCHAN} = 'true' ]]; then
        echo -e "\033[34m测试 Server酱 中... \033[0m"
        curl -s "http://sc.ftqq.com/$SERVERCHAN_KEY.send?text=ASP" -d "&desp=这是一条测试消息 This is a test message"
        echo
    fi

}

function set_supervisord {

    if [ ! -f "/app/lock/supervisord.lock" ]; then
        touch /app/lock/supervisord.lock
        cp /app/asp.ini /app/supervisord.conf
    fi

    if [ ! -d "/etc/supervisor.d/" ]; then
        mkdir -p /etc/supervisor.d/
    fi

    if [ ! -d "/var/log/supervisor" ]; then
        mkdir -p /var/log/supervisor
    fi

}

function set_tz {

    if [ ! -f "/app/lock/tz.lock" ]; then
        touch /app/lock/tz.lock
        echo -e "\033[34m设置时区... \033[0m"
        ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
        echo $TZ > /etc/timezone
    fi

}

function adduser {

    if [ ! -f "/app/lock/adduser.lock" ]; then
        touch /app/lock/adduser.lock
        echo -e "\033[34m设置PUID PGID... \033[0m"
        groupmod -o -g "$PGID" abc
        usermod -o -u "$PUID" abc
    fi

}

function cat_cron {

    echo -e "\033[32mCron 定时任务预览\033[0m"
    echo -e "\033[32m##########################################################################\033[0m"
    crontab -l
    echo -e "\033[32m##########################################################################\033[0m"

}