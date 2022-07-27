容器启动命令 CMD
==================

CMD可以用来设置容器启动时默认会执行的命令。

- 容器启动时默认执行的命令
- 如果docker container run启动容器时指定了其它命令，则CMD命令会被忽略
- 如果定义了多个CMD，只有最后一个会被执行。

.. code-block:: Dockerfile

    FROM ubuntu:20.04
    ENV VERSION=2.0.1
    RUN apt-get update && \
        apt-get install -y wget && \
        wget https://github.com/ipinfo/cli/releases/download/ipinfo-${VERSION}/ipinfo_${VERSION}_linux_amd64.tar.gz && \
        tar zxf ipinfo_${VERSION}_linux_amd64.tar.gz && \
        mv ipinfo_${VERSION}_linux_amd64 /usr/bin/ipinfo && \
        rm -rf ipinfo_${VERSION}_linux_amd64.tar.gz

.. code-block:: bash

    $ docker image build -t ipinfo .
    $ docker container run -it ipinfo
    root@8cea7e5e8da8:/#
    root@8cea7e5e8da8:/#
    root@8cea7e5e8da8:/#
    root@8cea7e5e8da8:/# pwd
    /
    root@8cea7e5e8da8:/#

默认进入到shell是因为在ubuntu的基础镜像里有定义CMD

.. code-block:: bash

    $docker image history ipinfo
    IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
    db75bff5e3ad   24 hours ago   RUN /bin/sh -c apt-get update &&     apt-get…   50MB      buildkit.dockerfile.v0
    <missing>      24 hours ago   ENV VERSION=2.0.1                               0B        buildkit.dockerfile.v0
    <missing>      7 days ago     /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
    <missing>      7 days ago     /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B
    <missing>      7 days ago     /bin/sh -c [ -z "$(apt-get indextargets)" ]     0B
    <missing>      7 days ago     /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   811B
    <missing>      7 days ago     /bin/sh -c #(nop) ADD file:d6b6ba642344138dc…   74.1MB
