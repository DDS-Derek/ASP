#!/bin/bash

function lock {

    if [ ! -d "/app/lock" ]; then
        mkdir -p /app/lock
    fi

    if [ ! -d "${CONFIG_DIR}" ]; then
        mkdir -p ${CONFIG_DIR}
    fi

}

function logs {

    if [ ! -d "${CONFIG_DIR}/logs" ]; then
        mkdir -p ${CONFIG_DIR}/logs
    fi

    if [ ! -f "${CONFIG_DIR}/logs/ASP.log" ]; then
        echo -e "\033[34m创建 logs 文件... \033[0m"
        touch ${CONFIG_DIR}/logs/ASP.log
    fi

    if [ ! -f "/app/lock/log_mv.lock" ]; then
        touch /app/lock/log_mv.lock
        echo -e "\033[34m设置 自动整理Logs文件 定时任务中... \033[0m"
        (crontab -l ; echo "0 3 * * * /app/log_mv.sh") | crontab -
    fi

}

function pt_qiandao {

    if [[ ${PT_QIANDAO} = 'true' ]]; then

        if [ ! -d "${CONFIG_DIR}/pt_qiandao" ]; then
            mkdir -p ${CONFIG_DIR}/pt_qiandao
        fi

        if [ ! -f "${CONFIG_DIR}/pt_qiandao/site.json" ]; then
            echo -e "\033[34m创建 pt_site_qiaodao_settings 文件... \033[0m"
            touch ${CONFIG_DIR}/pt_qiandao/site.json
        fi

        if [ ! -f "/app/lock/pt_qiandao.lock" ]; then
            touch /app/lock/pt_qiandao.lock
            echo -e "\033[34m设置 PT签到 定时任务中... \033[0m"
            (crontab -l ; echo "0 8 * * * /app/sites/pt_qiandao.sh") | crontab -
            echo -e "\033[34m设置 PT签到消息通知 中... \033[0m"
            sed -i "/.*api = */c\    api = 'http://iyuu.cn/$IYUU_API.send'" /app/sites/pt.py
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
            (crontab -l ; echo "0 */2 * * * /app/set_pm/set_pm.sh") | crontab -
        fi
    fi

}

function test_notification {

    if [[ ${SMTP} = 'true' ]]; then
        bash /app/message/test/smtp
    fi

    if [[ ${TGBOT} = 'true' ]]; then
        bash /app/message/test/tgbot
    fi

    if [[ ${SERVERCHAN} = 'true' ]]; then
        bash /app/message/test/serverchan
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

    if [ ! -d "${CONFIG_DIR}/logs/supervisor" ]; then
        mkdir -p ${CONFIG_DIR}/logs/supervisor
    fi

}

function set_tz {

    if [ ! -f "/app/lock/tz.lock" ]; then
        touch /app/lock/tz.lock
        echo -e "\033[34m设置时区... \033[0m"
        ln -sf /usr/share/zoneinfo/$TZ   /etc/localtime
        echo $TZ > /etc/timezone
        echo -e "\033[32m时区 ${TZ} \033[0m"
    fi

}

function adduser {

    if [ ! -f "/app/lock/adduser.lock" ]; then
        touch /app/lock/adduser.lock
        echo -e "\033[34m设置PUID PGID... \033[0m"
        groupmod -o -g "$PGID" asp
        usermod -o -u "$PUID" asp
        echo -e "\033[32m用户ID ${PUID} 用户组ID ${PGID} \033[0m"
    fi

}

function cat_cron {

    echo -e "\033[32mCron 定时任务预览\033[0m"
    echo -e "\033[32m##########################################################################\033[0m"
    crontab -l
    echo -e "\033[32m##########################################################################\033[0m"

}