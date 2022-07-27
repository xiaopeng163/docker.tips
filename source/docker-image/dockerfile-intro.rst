Dockerfile 介绍
========================

Docker can build images automatically by reading the instructions from a ``Dockerfile``. A Dockerfile is a ``text`` document that contains all the commands
a user could call on the command line to assemble an image. Using docker build users can create an automated build that executes several command-line
instructions in succession.


https://docs.docker.com/engine/reference/builder/

- Dockerfile是用于构建docker镜像的文件
- Dockerfile里包含了构建镜像所需的“指令”
- Dockerfile有其特定的语法规则


举例：执行一个Python程序
---------------------------

容器及进程，所以镜像就是一个运行这个进程所需要的环境。

假如我们要在一台ubuntu 21.04上运行下面这个hello.py的Python程序

hello.py的文件内容：

.. code-block:: python

    print("hello docker")

第一步，准备Python环境

.. code-block:: bash

    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y python3.9 python3-pip python3.9-dev

第一步，运行hello.py

.. code-block:: bash

    $ python3 hello.py
    hello docker

--------------------------------------------------------------------------------


一个Dockerfile的基本结构
---------------------------


Dockerfile


.. code-block:: bash

    FROM ubuntu:20.04
    RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y python3.9 python3-pip python3.9-dev
    ADD hello.py /
    CMD ["python3", "/hello.py"]
