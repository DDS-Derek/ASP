#!/bin/bash

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
if [ ! -f "/app/logs" ]; then
    echo -e "\033[34m创建logs文件... \033[0m"
    touch /app/logs
fi

# 设置crontab
if [ ! -f "/run.lock" ]; then
    touch /run.lock
    echo -e "\033[34m设置定时任务中... \033[0m"
    (crontab -l ; echo "0 */2 * * * /shell/run.sh") | crontab -
fi

# 启动Cron
echo -e "\033[34m已启动 \033[0m"
bash /shell/040-start.sh