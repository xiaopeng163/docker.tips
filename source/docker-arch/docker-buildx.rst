使用 buildx 构建多架构镜像
============================

Windows和Mac的桌面版Docker自带buildx命令，但是Linux环境下的Docker需要自行安装buildx （https://github.com/docker/buildx）

https://docs.docker.com/buildx/working-with-buildx/


本节课使用的源码 https://github.com/xiaopeng163/flask-redis



登录dockerhub

.. code-block:: bash

    docker login


进入源码目录（Dockerfile所在目录）

.. code-block:: bash

    git clone https://github.com/xiaopeng163/flask-redis
    cd flask-redis


构建

.. code-block:: powershell

    PS C:\Users\Peng Xiao\flask-redis> docker login
    Authenticating with existing credentials...
    Login Succeeded
    PS C:\Users\Peng Xiao\flask-redis> docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t xiaopeng163/flask-redis:latest .
    [+] Building 0.0s (0/0)
    error: multiple platforms feature is currently not supported for docker driver. Please switch to a different driver (eg. "docker buildx create --use")
    PS C:\Users\Peng Xiao\flask-redis>
    PS C:\Users\Peng Xiao\flask-redis> docker buildx ls
    NAME/NODE       DRIVER/ENDPOINT STATUS  PLATFORMS
    desktop-linux   docker
    desktop-linux desktop-linux   running linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
    default *       docker
    default       default         running linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
    PS C:\Users\Peng Xiao\flask-redis> docker buildx create --name mybuilder --use
    mybuilder
    PS C:\Users\Peng Xiao\flask-redis> docker buildx ls
    NAME/NODE       DRIVER/ENDPOINT                STATUS   PLATFORMS
    mybuilder *     docker-container
    mybuilder0    npipe:////./pipe/docker_engine inactive
    desktop-linux   docker
    desktop-linux desktop-linux                  running  linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
    default         docker
    default       default                        running  linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
    PS C:\Users\Peng Xiao\flask-redis> docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 -t xiaopeng163/flask-redis:latest .