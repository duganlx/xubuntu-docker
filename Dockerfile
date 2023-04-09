FROM ubuntu:jammy-20230308
LABEL author=duganlx email=840797783@qq.com
# default use /bin/sh
SHELL ["/bin/bash", "-c"]

# 设想:
# linux系统中一共有两个用户，分别是root和devs。
# 其中，root主要用于linux系统的管理，而devs主要用于日常的开发等任务

# 系统配置的变量 --> root 用户
# DOWNLOAD_DIR 作为资源下载存放位置
ENV DOWNLOAD_DIR=/download
# ROOT_DEFAULT_PASSWD root默认的密码
ENV ROOT_DEFAULT_PASSWD=root

# 开发环境的变量 --> devs 用户
# WORKSPACE_DIR 工作区，代码的存放位置
ENV WORKSPACE_DIR=/workspace
# DEVS_HOME devs的home目录
ENV DEVS_HOME_DIR=/home/devs
# DEVS_DEFAULT_PASSWD devs默认的密码
ENV DEVS_DEFAULT_PASSWD=devs
# DEVS_BASHRC devs环境变量配置文件
ENV DEVS_BASHRC=${DEVS_HOME_DIR}/.bashrc

RUN mkdir ${DOWNLOAD_DIR} ${WORKSPACE_DIR}

############################### common ###############################
RUN apt-get update
RUN apt-get install -y sudo vim net-tools iputils-ping wget
RUN apt-get install -y git
RUN apt-get install -y autoconf automake libtool curl make g++ unzip
RUN apt-get install -y libxcb-icccm4 libxkbcommon-x11-0

# tips:
#  root只是用于linux管理，devs用户用于平常使用
RUN echo root:${ROOT_DEFAULT_PASSWD} | chpasswd
RUN useradd -s /bin/bash -d ${DEVS_HOME_DIR} -m -G sudo,root devs
RUN echo devs:${DEVS_DEFAULT_PASSWD} | chpasswd
# devs可以通过进入root组而在workspace_dir文件夹中进行读写
RUN chmod g+rwx -R ${WORKSPACE_DIR} ${DOWNLOAD_DIR}
# 解决输入命令终端出现如下提示问题: To run a command as administrator (user "root"), use "sudo <command>".
RUN touch ${DEVS_HOME_DIR}/.sudo_as_admin_successful

# ssh
RUN apt-get install -y openssh-server
RUN echo PermitRootLogin yes >> /etc/ssh/sshd_config

# chrome
RUN apt-get install -y fonts-wqy-zenhei fonts-wqy-microhei
RUN cd ${DOWNLOAD_DIR} && wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y /download/google-chrome-stable_current_amd64.deb

# tips:
#  默认dockerfile的shell脚本是/bin/sh，在该脚本下
#  1. docker exec -it CONTAINER_NAME /bin/bash -c 'source /etc/profile'之后的后续的docker exec /bin/bash -c '...'仍然不生效。
#  2. 直接在Dockerfile中RUN source /etc/profile会出现 source命令不存在
#  3. 在Dockerfile写成 RUN /bin/bash -c "source /etc/profile"执行成功，但未生效
#  所以目前如下代码，每次启动终端都执行一次
# 
# 目前分为root和devs两个用户，不再往/etc/profile中写东西，而是直接使用devs的.bashrc文件
# RUN echo 'source /etc/profile' >> ~/.bashrc

WORKDIR ${WORKSPACE_DIR}

############################### go ###############################
RUN cd ${DOWNLOAD_DIR} && wget https://golang.google.cn/dl/go1.20.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf ${DOWNLOAD_DIR}/go1.20.2.linux-amd64.tar.gz
RUN mkdir -p ${WORKSPACE_DIR}/go/bin ${WORKSPACE_DIR}/go/pkg
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> ${DEVS_BASHRC}
RUN echo 'export GOPATH=/workspace/go' >> ${DEVS_BASHRC}
RUN echo 'export GOBIN=$GOPATH/bin' >> ${DEVS_BASHRC}
RUN echo 'export GOPROXY=https://goproxy.cn,direct' >> ${DEVS_BASHRC}
RUN echo 'export GOSUMDB=sum.golang.google.cn' >> ${DEVS_BASHRC}
RUN echo 'export PATH=$PATH:$GOBIN' >> ${DEVS_BASHRC}

# go workspace
RUN mkdir -p ${WORKSPACE_DIR}/go/src

############################## python ###############################
ENV MINICONDA_DIR=/usr/local/miniconda
RUN cd ${DOWNLOAD_DIR} && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod u+x ${DOWNLOAD_DIR}/Miniconda3-latest-Linux-x86_64.sh
RUN bash ${DOWNLOAD_DIR}/Miniconda3-latest-Linux-x86_64.sh -b -p ${MINICONDA_DIR}
RUN echo 'export PATH=$PATH':${MINICONDA_DIR}/bin >> ${DEVS_BASHRC}
# 家目录.local 目录通常是用于存储用户自定义的应用程序和配置数据的目录
RUN echo 'export PATH=$PATH':${DEVS_HOME_DIR}/.local/bin >> ${DEVS_BASHRC}

# python workspace
RUN mkdir -p ${WORKSPACE_DIR}/py

# js

# java