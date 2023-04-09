# Xubuntu-docker

<a href="https://github.com/duganlx/xubuntu/blob/main/LICENSE"><img src="https://img.shields.io/github/license/gameservermanagers/LinuxGSM?style=flat-square" alt="MIT License"></a>

Translations: [English](README.md) | [简体中文](README_zh.md)

该工具是在docker中搭建一个可视化的ubuntu开发环境

目前，该ubuntu开发环境具备以下功能

- golang 及 kratos 开发环境
- python 及 miniconda
- 支持远程桌面连接 及 中文输入法

## 使用说明

**前提**  

在ubuntu系统中，安装好docker，并且可以执行`sudo`命令即可

**使用**

执行build.sh脚本（`bash build.sh`）会有指引信息，如下所示。按照指引进行操作即可。

```sh
操作指引:
 0 [构建镜像]
 1 [创建容器]
 2 [清理无效镜像]
 3 [清理停止的容器]
 4 [重启容器]
```

**提示**

1. 进行"创建容器"前，请务必进行"构建镜像"
2. 建议使用devs用户进行开发，root用户仅负责系统配置

**待办事项**

- [ ] 中文乱码问题（将编码全部统一为GB2312）
- [ ] 编写"验证是否满足使用条件"的脚本
- [ ] 安装配置GPU使用
- [ ] 脚本支持英文版

## 使用场景

- 在Windows操作系统的个人电脑上，使用`WSL+docker`的方式来创建一个ubuntu系统来使用
- 在多人使用的工作站/服务器上，给每个人分配一个彼此独立的ubuntu系统来使用
