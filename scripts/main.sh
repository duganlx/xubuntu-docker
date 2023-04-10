#!/bin/bash
#
# Author: duganlx
# Date: 2023-03-28
# Description: 环境配置的入口文件

SCRIPT_DIR=$(dirname "$0")

apt-get update

# 系统配置
read -p "'是否进行系统配置', 请输入(y/n): " op
if [ "$op" == "y" ]; then
    bash $SCRIPT_DIR/sys.sh
fi

# 开发环境配置

cat << EOF

ubuntu系统配置完成，接下来请执行如下命令进行开发配置

    su devs
    bash $SCRIPT_DIR/dev.sh


一些贴士

1. root用户的密码为 root, devs用户的密码为 devs

2. root用户用于管理系统, devs用户用于日常开发等场景使用

EOF