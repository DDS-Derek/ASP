#!/bin/bash

asp_log_file=/app/log/ASP.log
mv_log_name=ASP_$(date +%Y%m%d-%H%M%S)
mv_log_path=/app/log/$(echo $(date +%Y%m%d))

if [ "$asp_log_file" ]; then
    echo -e "\033[34m归档 logs 文件... \033[0m"
    mkdir -p $mv_log_path
    cp $asp_log_file $mv_log_path/$mv_log_name
    echo > $asp_log_file
fi