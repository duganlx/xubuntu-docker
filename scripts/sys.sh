#!/bin/bash
#
# Author: duganlx
# Date: 2023-03-30
# Description: linux系统配置
#   
# 说明：
# 1. 运行该脚本需要在 root角色执行

apt-get update

############ vim中文乱码问题 ############
read -p "是否配置处理'vim中文乱码问题', 请输入(y/n): " op
if [ "$op" == "y" ]; then
    touch ~/.vimrc

cat > ~/.vimrc << EOF
set fileencodings=utf-8,cp936,gb2312,gbk,gb18030
set termencoding=utf-8
set fileformats=unix
set encoding=prc
EOF

    source ~/.vimrc

fi
