docker container run 背后发生了什么？
==================================================


``$ docker container run -d --publish 80:80 --name webhost nginx``


* 1. 在本地查找是否有nginx这个image镜像，但是没有发现
* 2. 去远程的image registry查找nginx镜像（默认的registry是Docker Hub)
* 3. 下载最新版本的nginx镜像 （nginx:latest 默认)
* 4. 基于nginx镜像来创建一个新的容器，并且准备运行
* 5. docker engine分配给这个容器一个虚拟IP地址
* 6. 在宿主机上打开80端口并把容器的80端口转发到宿主机上
* 7. 启动容器，运行指定的命令（这里是一个shell脚本去启动nginx）




