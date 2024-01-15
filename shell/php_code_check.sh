#!/usr/bin
# 对指定目录下的所有PHP文件进行语法检查
# 使用方式 eg: `sh php_code_check.sh ./` or `bash php_code_check.sh ./`

# 需要查找的文件深度
max_depth=1000

# 进度条
function process_bar() {
  now=$1
  all=$2
  percent=$(awk BEGIN'{printf "%f", ('$now'/'$all')}')
  len=$(awk BEGIN'{printf "%d", (100*'$percent')}')
  nnn=$(awk BEGIN'{printf "%d", ('$len'/2)}')
  bar='>'
  for ((i = 0; i < $nnn - 1; i++)); do
    bar="="$bar
  done
  printf "[%-50s][%03d/%03d]\r" $bar $len 100
}

echo "start..."$(date)
work_dir="./"
if [ $# -eq 1 ]; then
  work_dir=$1
fi

# 统计 `*.php` 文件数量
file_num=$(find $work_dir -maxdepth $max_depth -type f -name "*.php" | wc -l)
if [ $file_num -eq 0 ]; then
  echo "No PHP file."
  exit 0
fi

i=0
n=0
err_num=0
err_msg=""
for line in $(find $work_dir -maxdepth $max_depth -type f -name "*.php"); do
  let n++
  i=$n
  process_bar $i $file_num
  # 仅对指定 PHP 代码进行语法检查，详见：https://www.php.net/manual/zh/features.commandline.options.php
  msg=$(php -l $line | grep -v 'No syntax errors detected in')
  # 如果存在错误时
  if [ ${#msg} -ne 0 ]; then
    let err_num++
    err_msg=$(echo -e "$err_msg\n$msg")
  fi
done
printf "\n"
echo "end....."$(date)
printf "\n"

if [ ${#err_msg} -eq 0 ]; then
  echo "恭喜你，没有任何错误！"
else
  echo -e "错误的文件数:"$err_num
  echo -e "${err_msg:2}"
fi
