Dockerfile 技巧——尽量使用非root用户
========================================

.. note:: 

    本节课需要一个Linux的Docker环境。


Root的危险性
-------------

docker的root权限一直是其遭受诟病的地方，docker的root权限有那么危险么？我们举个例子。

假如我们有一个用户，叫demo，它本身不具有sudo的权限，所以就有很多文件无法进行读写操作，比如/root目录它是无法查看的。

.. code-block:: bash

    [demo@docker-host ~]$ sudo ls /root
    [sudo] password for demo:
    demo is not in the sudoers file.  This incident will be reported.
    [demo@docker-host ~]$

但是这个用户有执行docker的权限，也就是它在docker这个group里。

.. code-block:: bash

    [demo@docker-host ~]$ groups
    demo docker
    [demo@docker-host ~]$ docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
    busybox      latest    a9d583973f65   2 days ago   1.23MB
    [demo@docker-host ~]$

这时，我们就可以通过Docker做很多越权的事情了，比如，我们可以把这个无法查看的/root目录映射到docker container里，你就可以自由进行查看了。

.. code-block:: bash

    [demo@docker-host vagrant]$ docker run -it -v /root/:/root/tmp busybox sh
    / # cd /root/tmp
    ~/tmp # ls
    anaconda-ks.cfg  original-ks.cfg
    ~/tmp # ls -l
    total 16
    -rw-------    1 root     root          5570 Apr 30  2020 anaconda-ks.cfg
    -rw-------    1 root     root          5300 Apr 30  2020 original-ks.cfg
    ~/tmp #

更甚至我们可以给我们自己加sudo权限。我们现在没有sudo权限

.. code-block:: bash

    [demo@docker-host ~]$ sudo vim /etc/sudoers
    [sudo] password for demo:
    demo is not in the sudoers file.  This incident will be reported.
    [demo@docker-host ~]$

但是我可以给自己添加。

.. code-block:: bash

    [demo@docker-host ~]$ docker run -it -v /etc/sudoers:/root/sudoers busybox sh
    / # echo "demo    ALL=(ALL)       ALL" >> /root/sudoers
    / # more /root/sudoers | grep demo
    demo    ALL=(ALL)       ALL

然后退出container，bingo，我们有sudo权限了。

.. code-block:: bash

    [demo@docker-host ~]$ sudo more /etc/sudoers | grep demo
    demo    ALL=(ALL)       ALL
    [demo@docker-host ~]$

如何使用非root用户
-----------------------

我们准备两个Dockerfile，第一个Dockerfile如下，其中app.py文件源码请参考 :ref:`一起构建一个 Python Flask 镜像` ：

.. code-block:: dockerfile

    FROM python:3.9.5-slim

    RUN pip install flask

    COPY app.py /src/app.py

    WORKDIR /src
    ENV FLASK_APP=app.py

    EXPOSE 5000

    CMD ["flask", "run", "-h", "0.0.0.0"]

假设构建的镜像名字为 ``flask-demo``

第二个Dockerfile，使用非root用户来构建这个镜像，名字叫 ``flask-no-root`` Dockerfile如下：

- 通过groupadd和useradd创建一个flask的组和用户
- 通过USER指定后面的命令要以flask这个用户的身份运行

.. code-block:: dockerfile

    FROM python:3.9.5-slim

    RUN pip install flask && \
        groupadd -r flask && useradd -r -g flask flask && \
        mkdir /src && \
        chown -R flask:flask /src

    USER flask

    COPY app.py /src/app.py

    WORKDIR /src
    ENV FLASK_APP=app.py

    EXPOSE 5000

    CMD ["flask", "run", "-h", "0.0.0.0"]


.. code-block:: bash


    $ docker image ls
    REPOSITORY      TAG          IMAGE ID       CREATED          SIZE
    flask-no-root   latest       80996843356e   41 minutes ago   126MB
    flask-demo      latest       2696c68b51ce   49 minutes ago   125MB
    python          3.9.5-slim   609da079b03a   2 weeks ago      115MB

分别使用这两个镜像创建两个容器

.. code-block:: bash

    $ docker run -d --name flask-root flask-demo
    b31588bae216951e7981ce14290d74d377eef477f71e1506b17ee505d7994774
    $ docker run -d --name flask-no-root flask-no-root
    83aaa4a116608ec98afff2a142392119b7efe53617db213e8c7276ab0ae0aaa0
    $ docker container ps
    CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS      NAMES
    83aaa4a11660   flask-no-root   "flask run -h 0.0.0.0"   4 seconds ago    Up 3 seconds    5000/tcp   flask-no-root
    b31588bae216   flask-demo      "flask run -h 0.0.0.0"   16 seconds ago   Up 15 seconds   5000/tcp   flask-root

