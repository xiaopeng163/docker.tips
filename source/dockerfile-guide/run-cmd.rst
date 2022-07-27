通过 RUN 执行指令
=================

``RUN`` 主要用于在Image里执行指令，比如安装软件，下载文件等。


.. code-block:: bash

    $ apt-get update
    $ apt-get install wget
    $ wget https://github.com/ipinfo/cli/releases/download/ipinfo-2.0.1/ipinfo_2.0.1_linux_amd64.tar.gz
    $ tar zxf ipinfo_2.0.1_linux_amd64.tar.gz
    $ mv ipinfo_2.0.1_linux_amd64 /usr/bin/ipinfo
    $ rm -rf ipinfo_2.0.1_linux_amd64.tar.gz


Dockerfile
--------------

.. code-block:: Dockerfile

    FROM ubuntu:20.04
    RUN apt-get update
    RUN apt-get install -y wget
    RUN wget https://github.com/ipinfo/cli/releases/download/ipinfo-2.0.1/ipinfo_2.0.1_linux_amd64.tar.gz
    RUN tar zxf ipinfo_2.0.1_linux_amd64.tar.gz
    RUN mv ipinfo_2.0.1_linux_amd64 /usr/bin/ipinfo
    RUN rm -rf ipinfo_2.0.1_linux_amd64.tar.gz


镜像的大小和分层

.. code-block:: bash

    $ docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
    ipinfo       latest    97bb429363fb   4 minutes ago   138MB
    ubuntu       21.04     478aa0080b60   4 days ago      74.1MB
    $ docker image history 97b
    IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
    97bb429363fb   4 minutes ago   RUN /bin/sh -c rm -rf ipinfo_2.0.1_linux_amd…   0B        buildkit.dockerfile.v0
    <missing>      4 minutes ago   RUN /bin/sh -c mv ipinfo_2.0.1_linux_amd64 /…   9.36MB    buildkit.dockerfile.v0
    <missing>      4 minutes ago   RUN /bin/sh -c tar zxf ipinfo_2.0.1_linux_am…   9.36MB    buildkit.dockerfile.v0
    <missing>      4 minutes ago   RUN /bin/sh -c wget https://github.com/ipinf…   4.85MB    buildkit.dockerfile.v0
    <missing>      4 minutes ago   RUN /bin/sh -c apt-get install -y wget # bui…   7.58MB    buildkit.dockerfile.v0
    <missing>      4 minutes ago   RUN /bin/sh -c apt-get update # buildkit        33MB      buildkit.dockerfile.v0
    <missing>      4 days ago      /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
    <missing>      4 days ago      /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B
    <missing>      4 days ago      /bin/sh -c [ -z "$(apt-get indextargets)" ]     0B
    <missing>      4 days ago      /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   811B
    <missing>      4 days ago      /bin/sh -c #(nop) ADD file:d6b6ba642344138dc…   74.1MB


每一行的RUN命令都会产生一层image layer, 导致镜像的臃肿。

改进版Dockerfile
-------------------

.. code-block:: Dockerfile

    FROM ubuntu:20.04
    RUN apt-get update && \
        apt-get install -y wget && \
        wget https://github.com/ipinfo/cli/releases/download/ipinfo-2.0.1/ipinfo_2.0.1_linux_amd64.tar.gz && \
        tar zxf ipinfo_2.0.1_linux_amd64.tar.gz && \
        mv ipinfo_2.0.1_linux_amd64 /usr/bin/ipinfo && \
        rm -rf ipinfo_2.0.1_linux_amd64.tar.gz

.. code-block:: bash

    $ docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
    ipinfo-new   latest    fe551bc26b92   5 seconds ago    124MB
    ipinfo       latest    97bb429363fb   16 minutes ago   138MB
    ubuntu       21.04     478aa0080b60   4 days ago       74.1MB
    $ docker image history fe5
    IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
    fe551bc26b92   16 seconds ago   RUN /bin/sh -c apt-get update &&     apt-get…   49.9MB    buildkit.dockerfile.v0
    <missing>      4 days ago       /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
    <missing>      4 days ago       /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B
    <missing>      4 days ago       /bin/sh -c [ -z "$(apt-get indextargets)" ]     0B
    <missing>      4 days ago       /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   811B
    <missing>      4 days ago       /bin/sh -c #(nop) ADD file:d6b6ba642344138dc…   74.1MB
    $
