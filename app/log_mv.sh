#!/bin/bash

Green="\033[32m"
Font="\033[0m"
Red="\033[31m" 
Blue="\033[34m"

asp_log_file=${CONFIG_DIR}/logs/ASP.log
mv_log_name=ASP_$(date +%Y%m%d-%H%M%S).log
mv_log_name_txt=${mv_log_name}.txt
mv_log_path=${CONFIG_DIR}/logs/$(echo $(date +%Y%m%d))

if [ "$asp_log_file" ]; then
    echo -e "${Blue}归档 logs 文件... ${Font}"
    mkdir -p $mv_log_path
    cp $asp_log_file $mv_log_path/$mv_log_name
    cp $mv_log_path/$mv_log_name $mv_log_path/$mv_log_name_txt
    echo > $asp_log_file
fi