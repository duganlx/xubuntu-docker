# Xubuntu-docker

<a href="https://github.com/duganlx/xubuntu/blob/main/LICENSE"><img src="https://img.shields.io/github/license/gameservermanagers/LinuxGSM?style=flat-square" alt="MIT License"></a>

Translations: [English](README.md) | [简体中文](README_zh.md)

This tool sets up a visual Ubuntu development environment in Docker.

At present, the Ubuntu development environment has the following functions:

- Development environment for golang and kratos.
- Python and Miniconda
- It supports remote desktop connection and Chinese input method.

## Usage Instructions

**Prerequisite**  

To use this tool, you need to have a Ubuntu system installed with Docker and be able to execute the sudo command.

**Use**

Running the build.sh script (bash build.sh) will display instructions as shown below. Follow the instructions to proceed.

```sh
操作指引:
 0 [构建镜像]
 1 [创建容器]
 2 [清理无效镜像]
 3 [清理停止的容器]
 4 [重启容器]
```

**TIP**

1. Before "creating the container", please make sure to "build the image".
2. It is recommended to use the "devs" user for development, while the "root" user is only responsible for system configuration.

**TODO**

- [ ] Chinese garbled characters issue (changing encoding to GB2312 for all)
- [ ] Write a script to "verify if the usage conditions are met".
- [ ] Installing and configuring GPU
- [ ] The script supports the English version.

## Usage Scenarios

- To use the tool on a personal computer running Windows operating system, you can create an Ubuntu system using "WSL+docker" approach.
- On a shared workstation/server that is used by multiple users, allocate an independent Ubuntu system for each person to use.