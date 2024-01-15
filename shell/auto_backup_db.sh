#!/bin/bash
#备份自定表数据，因为加了 -t 参数，如果需要备份表字段直接去掉 -t 参数即可。

# 数据库相关配置信息
host='127.0.0.1'
port=3306
username='root'
password='password'
database='sample_api'
tables='menus users'

# 当前时间
current_time=`date +"%Y-%m-%d_%H:%M:%S"`

# sql 备份目录
sql_backup_path=$(cd `dirname $0`; pwd)

# sql 文件
file_name="${sql_backup_path}/back_up_${current_time}.sql"

# 目录存在，删除修改时间为 7 天前的文件
if [ -d "${sql_backup_path}" ]; then
        find "${sql_backup_path}"/* -name '*.sql' -mtime +1 -exec rm -rf {} \;
fi

# 执行 sql 备份
mysqldump --host=${host} --port=${port} --user=${username} --password=${password} -t ${database} ${tables} > "${file_name}"