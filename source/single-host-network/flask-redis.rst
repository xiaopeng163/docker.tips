Python Flask + Redis 练习
===========================


.. image:: ../_static/flask-redis.png
    :alt: flask-redis



程序准备
-------------


准备一个Python文件，名字为 ``app.py`` 内容如下：

.. code-block:: Python

    from flask import Flask
    from redis import Redis
    import os
    import socket

    app = Flask(__name__)
    redis = Redis(host=os.environ.get('REDIS_HOST', '127.0.0.1'), port=6379)


    @app.route('/')
    def hello():
        redis.incr('hits')
        return f"Hello Container World! I have been seen {redis.get('hits').decode('utf-8')} times and my hostname is {socket.gethostname()}.\n"


准备一个Dockerfile

.. code-block:: dockerfile

    FROM python:3.9.5-slim

    RUN pip install flask redis && \
        groupadd -r flask && useradd -r -g flask flask && \
        mkdir /src && \
        chown -R flask:flask /src

    USER flask

    COPY app.py /src/app.py

    WORKDIR /src

    ENV FLASK_APP=app.py REDIS_HOST=redis

    EXPOSE 5000

    CMD ["flask", "run", "-h", "0.0.0.0"]

镜像准备
------------


构建flask镜像，准备一个redis镜像。

.. code-block:: bash

    $ docker image pull redis
    $ docker image build -t flask-demo .
    $ docker image ls
    REPOSITORY   TAG          IMAGE ID       CREATED              SIZE
    flask-demo   latest       4778411a24c5   About a minute ago   126MB
    python       3.9.5-slim   c71955050276   8 days ago           115MB
    redis        latest       08502081bff6   2 weeks ago          105MB
    

创建一个docker bridge
-----------------------

.. code-block:: bash

    $ docker network create -d bridge demo-network
    8005f4348c44ffe3cdcbbda165beea2b0cb520179d3745b24e8f9e05a3e6456d
    $ docker network ls
    NETWORK ID     NAME           DRIVER    SCOPE
    2a464c0b8ec7   bridge         bridge    local
    8005f4348c44   demo-network   bridge    local
    80b63f711a37   host           host      local
    fae746a75be1   none           null      local
    $


创建redis container
---------------------------

创建一个叫 ``redis-server`` 的container，连到 demo-network上

.. code-block:: bash

    $ docker container run -d --name redis-server --network demo-network redis
    002800c265020310231d689e6fd35bc084a0fa015e8b0a3174aa2c5e29824c0e
    $ docker container ls
    CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS      NAMES
    002800c26502   redis     "docker-entrypoint.s…"   4 seconds ago   Up 3 seconds   6379/tcp   redis-server
    $

创建flask container
---------------------

.. code-block:: bash

    $ docker container run -d --network demo-network --name flask-demo --env REDIS_HOST=redis-server -p 5000:5000 flask-demo


打开浏览器访问 http://127.0.0.1:5000

应该能看到类似下面的内容，每次刷新页面，计数加1

Hello Container World! I have been seen 36 times and my hostname is 925ecb8d111a.



总结
----

如果把上面的步骤合并到一起，成为一个部署脚本

.. code-block:: bash


    # prepare image
    docker image pull redis
    docker image build -t flask-demo .

    # create network
    docker network create -d bridge demo-network

    # create container
    docker container run -d --name redis-server --network demo-network redis
    docker container run -d --network demo-network --name flask-demo --env REDIS_HOST=redis-server -p 5000:5000 flask-demo