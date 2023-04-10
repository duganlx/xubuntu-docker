# 新手指引

## 环境准备

- ubuntu（[WSL安装教程](https://learn.microsoft.com/zh-cn/windows/wsl/install)）
- docker（[安装教程（Docker Engine）](https://docs.docker.com/engine/install/ubuntu/)）
- sudo命令

## 配置步骤

步骤1：切换成root用户（`su root`），并且进入到xubuntu-docker目录中（`cd xubuntu-docker`），给build.sh脚本添加执行权限（`chmod 775 build.sh`）。

步骤2：执行build.sh脚本（`bash build.sh`），在操作指引中选择`0 [构建镜像]`。如果构建失败，九成九是网络问题，建议修改apt的下载使用清华源。

- 提示：如果执行 build.sh脚本时出现错误`$'\r': command not found`，则需要执行如下命令
    - 打开 build.sh脚本（`vim build.sh`），输入`:set ff=unix`并回车，接着输入`:wq`并回车
    - 重新执行 build.sh脚本（`bash build.sh`）

步骤3：镜像构建完成之后，再次执行build.sh脚本（`bash build.sh`），在操作指引中选择`1 [创建容器]`。

- 步骤3.1：输入容器名称，例如 `lvxws`
- 步骤3.2：选择映射的端口，例如 `10000:3389 5000:22 8200:8888`
- 步骤3.3：要求输入回车键，就敲击`回车键`

步骤4：容器创建完成，由于有些配置需要人机交互，所以没有做成自动化执行。先进入容器（例如 进入名为`lvxws`的容器，`docker exec -it lvxws /bin/bash`），接着执行 main.sh脚本（`bash /download/scripts/main.sh`）。

- 提示：如果执行 main.sh脚本时出现错误`$'\r': command not found`，则需要执行如下命令
    - 打开 main.sh脚本（`vim /download/scripts/main.sh`），输入`:set ff=unix`并回车，接着输入`:wq`并回车
    - 打开 dev.sh脚本（`vim /download/scripts/dev.sh`），输入`:set ff=unix`并回车，接着输入`:wq`并回车
    - 打开 sys.sh脚本（`vim /download/scripts/sys.sh`），输入`:set ff=unix`并回车，接着输入`:wq`并回车
    - 重新执行 main.sh脚本（`bash /download/scripts/main.sh`）

步骤5：提示"是否进行系统配置"，输入`y`并回车

步骤6：提示"是否配置处理vim中文乱码问题"，输入`y`并回车

步骤7：目前，仅仅完成root用户的配置，接着需要配置devs用户。因为，我是希望root用户用于管理系统, devs用户用于日常开发等场景使用。所以切换成devs用户（`su devs`），接着执行 dev.sh脚本（例如 `bash /download/scripts/dev.sh`）。devs中会包含如下配置内容（所有的配置都是可选的）：

- vim中文乱码问题
- 远程桌面控制
- 中文输入法
- chrome浏览器
- git ssh（暂时不能）
- miniconda、jupyter配置
- go的kratos以及protoc配置

步骤8：提示"是否配置处理 vim中文乱码问题"，输入`y`即可。

步骤9：提示"是否配置 远程桌面控制"，输入`y`。在安装的过程中会需要选择国家`Country of origin for the keyboard`，选择`19`。接着需要选择键盘布局`Keyboard layout`，选择`1`。（如果没有选择，也不用慌，实测不影响最终效果^_^）

步骤10：提示"是否配置 中文输入法"，输入`y`。在安装的过程中会需要选择语言`Configuring locales`，将zh_CN开头的都选择上, 即 `489 490 491 492`。在选择默认语言`default locale`，选择zh_CN，即`3`

步骤11：提示"是否配置 google chrome"，输入`y`。还需要自己远程桌面连接之后，进行一些配置，具体如下：

- 步骤11.1 远程桌面连接，使用 本地的ip地址加映射的端口，比如wsl的ubuntu系统的ip为`10.10.22.3`，而容器的3389端口映射到了`10000`，则连接的地址为`10.10.22.3:10000`，账号为`devs`，默认密码为`devs`。
- 步骤11.2 登录系统之后，右键点击默认浏览器(下方), 点击 "Properties", 会弹出Launcher
- 步骤11.3 点击 "Add New Item", 选中 Google Chrome
- 步骤11.4 右键点击该创建的item, 点击 "Edit Item", 修改其中 Command 内容为`/usr/bin/google-chrome-stable --disable-dev-shm-usage %U`


步骤12：提示"是否配置 python"，输入`y`。

步骤13：提示"是否配置 go"，输入`n`。（不用go就不需要进行配置了）

---

到这里，所以配置就完成了，使用愉快 ^_^

## 贴士

1. 如果重启了docker，使用命令`docker start lvxws`启动容器（`lvxws`是容器名称），启动之后还不能直接使用ssh和远程桌面连接服务，需要先进入容器（`docker exec -it lvxws /bin/bash`），接着执行`service ssh restart`和`service xrdp restart`两条命令来启动ssh和远程桌面连接服务。（TODO 可做成脚本）

2. 该系统中有两个角色，分别是root和devs。我的设想是root用户仅仅用于系统的管理，一般日常使用都是用devs用户。另外，root的默认密码为root，devs的默认密码是devs。建议初始化完成之后去修改密码（`passwd`）

3. 远程桌面连接后，如果打开终端没有反应，可以执行以下步骤。首先，点击桌面左上角 application, 选择 settings, 再选择 settings manager。接着，在 Settings框内 选择 Default Applications, 并切换到 Utilities 选项卡。最后修改其中的File Manager 和 Terminal Emulator为`Thunar`和`Xfce Terminal`。

4. 远程桌面连接后，如果在终端（terminal）上出现乱码问题，可以配置字符集为UTF-8，再重新打开终端。

5. 远程桌面连接后，没有中文输入法的话，可以在桌面点击右键选择'应用applications', 选择 '系统', 再选择 'Fcitx' 在Input Method中搜索添加`Google拼音`。如果找不到，可以重启下该容器^_^