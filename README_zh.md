# Xubuntu-docker

<a href="https://github.com/duganlx/xubuntu/blob/main/LICENSE"><img src="https://img.shields.io/github/license/gameservermanagers/LinuxGSM?style=flat-square" alt="MIT License"></a>

Translations: [English](README.md) | [简体中文](README_zh.md)

该工具是在docker中搭建一个可视化的ubuntu开发环境

目前，该ubuntu开发环境具备以下功能

- golang 及 kratos 开发环境
- python 及 miniconda
- 支持远程桌面连接 及 中文输入法

## 使用说明

**场景**

- 在个人电脑（Windows系统）中，利用 `wsl+docker` 创建ubuntu系统进行使用
- 在多人使用的工作站（Linux系统）上，给每个人分配一个彼此独立的ubuntu系统来使用
- 在个人使用的服务器上，创建独立的ubuntu系统进行使用

**前提**  

在ubuntu系统中，安装好docker，并且可以执行`sudo`命令即可

**使用**

执行build.sh脚本（`bash build.sh`）会有指引信息，如下所示。按照指引进行操作即可。（如果需要详细教程，请参看[使用教程](./docs/guide_zh.md)）

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
2. "创建容器"请务必仔细阅读并遵照**提示信息**
3. 建议使用devs用户进行开发，root用户仅负责系统配置

**待办事项**

- [ ] 中文乱码问题（将编码全部统一为GB2312）
- [ ] 编写"验证是否满足使用条件"的脚本
- [ ] 安装配置GPU使用
- [ ] 脚本支持英文版
- [ ] Dockerfile 中补充 java、javaScript的配置
- [ ] 将常见问题1做成自动处理
- [ ] docker重启之后，使用容器的配置

**常见问题**

**问题1：$'\r': command not found**

问题原因：wins和linux的文件换行符不一致

解决办法：利用命令`vim xxx.sh` 进入脚本后，输入`:set ff=unix`并回车，接着利用命令`:wq`


## 开发说明

todo 