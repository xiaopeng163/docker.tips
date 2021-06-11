Dockerfile技巧——尽量使用非root用户
========================================

.. note:: 

    本节课需要一个Linux的Docker环境，本文使用的Dockerfile和app.py源码请参考 :ref:`一起构建一个Python Flask镜像`

Docker默认会使用root来启动它需要启动的进程，比如下面的Dockerfile所build的镜像。


.. code-block:: dockerfile

    FROM python:3.9.5-slim

    RUN pip install flask

    COPY app.py /src/app.py

    WORKDIR /src
    ENV FLASK=app.py

    EXPOSE 5000

    CMD ["flask", "run", "-h", "0.0.0.0"]

假设构建的镜像名字为 ``flask-demo``

然后再使用非root用户来构建这个镜像，名字叫 ``flask-no-root`` Dockerfile如下：

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
    ENV FLASK=app.py

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

