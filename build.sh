#!/bin/bash

IMAGE_NAME=lvx_dev
IMAGE_TAG=v1_2

echo -e "操作指引:\n 0 [构建镜像]\n 1 [创建容器]\n 2 [清理无效镜像]\n 3 [清理停止的容器]\n 4 [重启容器]"
read -p "选择进行的操作: " op

if (( $op == 0 )); then
    read -p "即将构建镜像$IMAGE_NAME:$IMAGE_TAG, 按回车键开始..."

    echo "删除原先镜像$IMAGE_NAME:$IMAGE_TAG 存在的容器..."
    container_ids=$(docker ps -aq)

    for id in $container_ids; do
        container_image=$(docker inspect --format='{{.Config.Image}}' $id)

        if [ "$container_image" == "$IMAGE_NAME:$IMAGE_TAG" ]; then
            echo "删除容器 $id"
            docker rm -f $id
        fi
    done

    echo "根据Dockerfile构建镜像$IMAGE_NAME:$IMAGE_TAG..."
    docker build -t $IMAGE_NAME:$IMAGE_TAG .

elif (( $op == 1 )); then
    read -p "即将创建镜像$IMAGE_NAME:$IMAGE_TAG 的容器, 按回车键开始..."

    read -p "请输入容器名称: " container_name

    if docker ps -a --format '{{.Names}}' | grep -q $container_name; then
        read -p "容器$container_name 已存在, 按回车键将进行删除..."
        docker rm -f $container_name
    fi

    echo -e "端口映射内容 常见的配置规则如下\n"
    echo -e "\t远程桌面连接: 10000:3389"
    echo -e "\tssh: 5000:22"
    echo -e "\tkratos服务: 8000:8000 8100:9000"
    echo -e "\tjupter服务: 8200:8888"
    echo ""
    read -p "请输入容器$container_name 的端口映射配置(使用空格分隔): " ports_map

    port_map_array=($ports_map)

    docker_run_cmd="docker run -itd --name $container_name --privileged=true"
    for port_map in ${port_map_array[@]}; do
        docker_run_cmd="$docker_run_cmd -p $port_map"
    done
    docker_run_cmd="$docker_run_cmd $IMAGE_NAME:$IMAGE_TAG /bin/bash"

    echo -e "将执行的命令如下所示\n\n\t$docker_run_cmd\n"
    read -p "按回车键开始执行该命令创建容器..."
    $docker_run_cmd

    docker cp scripts $container_name:/download/scripts
    docker exec -it $container_name /bin/bash -c 'chmod 750 /download/scripts/*'

    echo -e "容器$container_name 创建完成，容器内的一些初始化工作，请按照以下命令执行\n"
    echo -e "\tdocker exec -it $container_name /bin/bash"
    echo -e "\tbash /download/scripts/main.sh"

elif (( $op == 2 )); then
    read -p "即将清理tag=none的镜像, 按回车键开始..."
    
    image_ids=$(docker images -f "dangling=true" -q)
    num=$(docker images -f "dangling=true" -q | wc -l)
    
    if [[ $num == 0 ]]; then
        echo "没有无效镜像需要清除"
    else
        echo "清除无效镜像个数为$num"
        docker rmi -f $images 
    fi

elif (( $op == 3 )); then
    read -p "即将清理停止运行的容器, 按回车键开始..."
    
    container_ids=$(docker ps -aqf "status=exited")
    num=$(docker ps -q -f status=exited | wc -l)
    
    if [[ $num == 0 ]]; then
        echo "没有停止的容器需要清除"
    else
        echo "清除的停止容器个数为$num"
        docker rm $container_ids
    fi

elif (( $op == 4 )); then
    read -p "即将运行容器的重启, 按回车键开始..."

    read -p "请输入容器名称: " container_name

    service docker start
    docker restart $container_name
    docker exec $container_name service xrdp restart
    docker exec $container_name service ssh restart
    echo -e "\n继续使用愉快^_^"
else
    echo "未知操作, 结束"
fi 