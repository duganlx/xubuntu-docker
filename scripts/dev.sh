#!/bin/bash
#
# Author: duganlx
# Date: 2023-03-28
# Description: 开发环境配置
#   
# 说明：
# 1. 请在devs用户下执行

DOWNLOAD_DIR=/download
WORKSPACE_DIR=/workspace

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

cat << EOF

vim中文乱码问题解决

终端中文乱码问题 还需要以下配置：

    远程桌面控制 连接上去之后, 在终端中配置字符集为UTF-8, 再重开终端即可

说明: 直接终端显示的中文是GB2312, 如果文本是UTF-8 则需要手动去切换, 建议统一
EOF
fi

############ 远程桌面控制 ############
read -p "是否配置'远程桌面控制', 请输入(y/n): " op
if [ "$op" == "y" ]; then
    echo -e "即将开始配置'远程桌面控制'，其中有两处交互，推荐选项如下\n" 
    echo -e "\tCountry of origin for the keyboard: 19"
    echo -e "\tKeyboard layout: 1\n"
    read -p "按回车键开始..."

    sudo apt-get install -y xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
    sudo apt-get install -y xrdp
    sudo adduser xrdp ssl-cert
    sudo service xrdp start
    sudo echo "exec startxfce4" >> /etc/xrdp/xrdp.ini
    service xrdp restart

cat << EOF

'远程桌面控制'配置完成。目前即可通过Windows的'远程桌面控制'进行连接, 连接的配置信息如下:

    地址: ip:port
    账户: devs
    密码: devs (默认密码)

一些贴士：

EOF
fi

############ 中文输入法 ############
read -p "是否配置'中文输入法', 请输入(y/n): " op
if [ "$op" == "y" ]; then
    echo -e "即将开始配置'中文输入法'，其中有两处交互，推荐选项如下\n" 
    echo -e "\tConfiguring locales: 将zh_CN开头的都选择上, 即 489 490 491 492"
    echo -e "\ta default locale: 选择zh_CN, 即 3\n"
    read -p "按回车键开始..."

    sudo apt-get -y install locales xfonts-intl-chinese fonts-wqy-microhei
    sudo dpkg-reconfigure locales
    sudo apt-get install -y fcitx fcitx-googlepinyin

    echo -e "配置 "中文输入法" 已完成"
fi

############ google chrome ############
read -p "是否配置'google chrome', 请输入(y/n): " op
if [ "$op" == "y" ]; then
cat << EOF

配置"google chrome"

步骤（需要在远程桌面连接后进行）：

1. 右键点击默认浏览器(下方), 点击 "Properties", 会弹出Launcher
2. 点击 "Add New Item", 选中 Google Chrome
3. 右键点击该创建的item, 点击 "Edit Item", 修改其中 Command 内容, 如下

    /usr/bin/google-chrome-stable --disable-dev-shm-usage %U

EOF
fi

############ git ssh ############
# todo email改成输入形式
# read -p "是否配置'git ssh', 请输入(y/n): " op
# if [ "$op" == "y" ]; then
#     ssh-keygen -t rsa -C "840797783@qq.com"
#     echo "将 ~/.ssh/id_rsa.pub 拷贝到 github中的 'SSH and GPG keys' 中"
# fi

############ python ############
read -p "是否配置'jupyter', 请输入(y/n): " op
if [ "$op" == "y" ]; then
    conda init bash
    pip install jupyter

cat << EOF

一些贴士

1. jupyter notebook 修改保存文件的目录, 执行如下步骤

    jupyter notebook --generate-config 该命令会在'家目录'下生成 .jupyter/jupyter_notebook_config.py 
    修改该文件中的配置 
        NotebookApp.notebook_dir = '/workspace/py/jupyter'  # 设置保存文件的目录
        c.NotebookApp.ip = '*'  # 允许外网访问

EOF
fi

############ go ############
read -p "是否配置'go的kratos框架开发环境', 请输入(y/n): " op
if [ "$op" == "y" ]; then
    cd $DOWNLOAD_DIR
    wget https://github.com/protocolbuffers/protobuf/releases/download/v22.2/protoc-22.2-linux-x86_64.zip
    unzip -d $DOWNLOAD_DIR/tmp protoc-22.2-linux-x86_64.zip
    mv $DOWNLOAD_DIR/tmp/bin/protoc $WORKSPACE_DIR/go/bin/
    rm -rf $DOWNLOAD_DIR/tmp

    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
    go install github.com/go-kratos/kratos/cmd/kratos/v2@latest
    go install github.com/go-kratos/kratos/cmd/protoc-gen-go-http/v2@latest
    go install github.com/google/gnostic/cmd/protoc-gen-openapi@latest
    go install github.com/google/wire/cmd/wire@latest
fi