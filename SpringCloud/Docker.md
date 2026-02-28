# Docker

## 1.认识Docker

**Docker: 快速构建、运行、管理应用的工具**

当我们利用Docker安装应用时，Docker会自动搜索并下载应用**镜像(image)** 。镜像不仅包含应用本身，还包含应用运行所需要的环境、配置、系统函数库。Docker会在运行镜像时创建一个隔离环境，称为**容器(container)**。

**镜像仓库:** 存储和管理镜像的平台，Docker官方维护了一个公共仓库: https://hub.docker.com/

![](assets/docker镜像和容器.png)

## 2.快速入门

解读一段安装mysql的命令:

```docker
docker run -d \
  --name mysql \
  -p 3306:3306 \
  -e TZ=Asia/Shanghai \
  -e MYSQL_ROOT_PASSWORD=123 \
  mysql
```

- docker run : 创建并运行一个容器，-d是让容器在后台运行

- --name mysql：给容器起个名字，必须唯一

- -p 3306:3306：设置端口映射

- -e KEY=VALUE：设置环境变量

- mysql：指定运行的镜像的名字

<font color="red">镜像命名规范:</font>

- 镜像名称一般分两部分组成:[repository]:[tag]
  
  其中repository就是镜像名
  
  tag是镜像的版本

- 在没有指定tag时，默认是lastest,代表最新版本的镜像

![](assets/镜像命名规范.png)

## 3.Docker基础

Docker最常见的命令就是操作镜像、容器的命令，详见官方文档: https://docs.docker.com/

![](assets/docker常见命令.png)

## 4.命名别名

`linux中 ~/.bashrc`目录中藏着各种命名别名，方便我们使用

![](assets/命名别名.png)

我们修改完之后输入`source ~/.bashrc`就可以输入命名别名了

## 5.数据卷

**数据卷(volume)** 是一个虚拟目录，是**容器内目录**与**宿主机目录**之间映射的桥梁

![](assets/数据卷.png)

| 命令                      | 说明         | 文档地址                                                                        |
| ----------------------- | ---------- | --------------------------------------------------------------------------- |
| `docker volume create`  | 创建数据卷      | [docker volume create](https://www.qianwen.com/chat/docker_volume_create)   |
| `docker volume ls`      | 查看所有数据卷    | [docker volume ls](https://www.qianwen.com/chat/docker_volume_ls)           |
| `docker volume rm`      | 删除指定数据卷    | [docker volume rm](https://www.qianwen.com/chat/docker_volume_rm)           |
| `docker volume inspect` | 查看某个数据卷的详情 | [docker volume inspect](https://www.qianwen.com/chat/docker_volume_inspect) |
| `docker volume prune`   | 清除未使用的数据卷  | [docker volume prune](https://www.qianwen.com/chat/docker_volume_prune)     |

<font color="red"> 在执行docker run命令时，使用 `-v 数据卷:容器内目录` 可以完成数据卷挂载</font>

<font color="red">在创建容器时，如果挂载了数据卷且数据卷不存在，会自动创建数据卷 </font>






