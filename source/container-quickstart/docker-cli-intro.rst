Docker CLI 命令行介绍
=======================


Docker Version
------------------

Windows (Intel芯片)

.. code-block:: bash

    $ docker version
    Client: Docker Engine - Community
    Cloud integration: 1.0.12
    Version:           20.10.5
    API version:       1.41
    Go version:        go1.13.15
    Git commit:        55c4c88
    Built:             Tue Mar  2 20:14:53 2021
    OS/Arch:           windows/amd64
    Context:           default
    Experimental:      true

    Server: Docker Engine - Community
    Engine:
    Version:          20.10.5
    API version:      1.41 (minimum version 1.12)
    Go version:       go1.13.15
    Git commit:       363e9a8
    Built:            Tue Mar  2 20:15:47 2021
    OS/Arch:          linux/amd64
    Experimental:     false
    containerd:
    Version:          1.4.4
    GitCommit:        05f951a3781f4f2c1911b05e61c160e9c30eaa8e
    runc:
    Version:          1.0.0-rc93
    GitCommit:        12644e614e25b05da6fd08a38ffa0cfe1903fdec
    docker-init:
    Version:          0.19.0
    GitCommit:        de40ad0

Linux（Intel芯片）

.. code-block:: bash

    ￥ docker version
    Client: Docker Engine - Community
    Version:           20.10.0
    API version:       1.41
    Go version:        go1.13.15
    Git commit:        7287ab3
    Built:             Tue Dec  8 18:59:40 2020
    OS/Arch:           linux/amd64
    Context:           default
    Experimental:      true

    Server: Docker Engine - Community
    Engine:
    Version:          20.10.0
    API version:      1.41 (minimum version 1.12)
    Go version:       go1.13.15
    Git commit:       eeddea2
    Built:            Tue Dec  8 18:57:45 2020
    OS/Arch:          linux/amd64
    Experimental:     false
    containerd:
    Version:          1.4.3
    GitCommit:        269548fa27e0089a8b8278fc4fc781d7f65a939b
    runc:
    Version:          1.0.0-rc92
    GitCommit:        ff819c7e9184c13b7c2607fe6c30ae19403a7aff
    docker-init:
    Version:          0.19.0
    GitCommit:        de40ad0

Mac （Intel芯片）

.. code-block:: bash


    $ docker version
    Client: Docker Engine - Community
    Cloud integration: 1.0.9
    Version: 20.10.5
    API version: 1.41
    Go version: go1.13.15
    Git commit: 55c4c88
    Built: Tue Mar 2 20:13:00 2021
    OS/Arch: darwin/amd64
    Context: default
    Experimental: true

    Server: Docker Engine - Community
    Engine:
    Version: 20.10.5
    API version: 1.41 (minimum version 1.12)
    Go version: go1.13.15
    Git commit: 363e9a8
    Built: Tue Mar 2 20:15:47 2021
    OS/Arch: linux/amd64
    Experimental: false
    containerd:
    Version: 1.4.3
    GitCommit: 269548fa27e0089a8b8278fc4fc781d7f65a939b
    runc:
    Version: 1.0.0-rc92
    GitCommit: ff819c7e9184c13b7c2607fe6c30ae19403a7aff
    docker-init:
    Version: 0.19.0
    GitCommit: de40ad0

docker命令行的基本使用
-----------------------------

docker + 管理的对象（比如容器，镜像） + 具体操作（比如创建，启动，停止，删除）

例如

- ``docker image pull nginx`` 拉取一个叫nginx的docker image镜像
- ``docker container stop web`` 停止一个叫web的docker container容器