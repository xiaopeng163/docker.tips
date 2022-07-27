构建参数和环境变量 (ARG vs ENV)
===============================

``ARG`` 和 ``ENV`` 是经常容易被混淆的两个Dockerfile的语法，都可以用来设置一个“变量”。 但实际上两者有很多的不同。


.. code-block:: Dockerfile

    FROM ubuntu:20.04
    RUN apt-get update && \
        apt-get install -y wget && \
        wget https://github.com/ipinfo/cli/releases/download/ipinfo-2.0.1/ipinfo_2.0.1_linux_amd64.tar.gz && \
        tar zxf ipinfo_2.0.1_linux_amd64.tar.gz && \
        mv ipinfo_2.0.1_linux_amd64 /usr/bin/ipinfo && \
        rm -rf ipinfo_2.0.1_linux_amd64.tar.gz


ENV
-----

.. code-block:: Dockerfile

    FROM ubuntu:20.04
    ENV VERSION=2.0.1
    RUN apt-get update && \
        apt-get install -y wget && \
        wget https://github.com/ipinfo/cli/releases/download/ipinfo-${VERSION}/ipinfo_${VERSION}_linux_amd64.tar.gz && \
        tar zxf ipinfo_${VERSION}_linux_amd64.tar.gz && \
        mv ipinfo_${VERSION}_linux_amd64 /usr/bin/ipinfo && \
        rm -rf ipinfo_${VERSION}_linux_amd64.tar.gz


ARG
-----


.. code-block:: Dockerfile

    FROM ubuntu:20.04
    ARG VERSION=2.0.1
    RUN apt-get update && \
        apt-get install -y wget && \
        wget https://github.com/ipinfo/cli/releases/download/ipinfo-${VERSION}/ipinfo_${VERSION}_linux_amd64.tar.gz && \
        tar zxf ipinfo_${VERSION}_linux_amd64.tar.gz && \
        mv ipinfo_${VERSION}_linux_amd64 /usr/bin/ipinfo && \
        rm -rf ipinfo_${VERSION}_linux_amd64.tar.gz

区别
-------

.. image:: ../_static/docker_environment_build_args.png
    :alt: docker-image


ARG 可以在镜像build的时候动态修改value, 通过 ``--build-arg``

.. code-block:: bash

    $ docker image build -f .\Dockerfile-arg -t ipinfo-arg-2.0.0 --build-arg VERSION=2.0.0 .
    $ docker image ls
    REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
    ipinfo-arg-2.0.0   latest    0d9c964947e2   6 seconds ago    124MB
    $ docker container run -it ipinfo-arg-2.0.0
    root@b64285579756:/#
    root@b64285579756:/# ipinfo version
    2.0.0
    root@b64285579756:/#

ENV 设置的变量可以在Image中保持，并在容器中的环境变量里
