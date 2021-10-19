docker compose 服务依赖和健康检查
===================================

Dockerfile healthcheck https://docs.docker.com/engine/reference/builder/#healthcheck

docker compose https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck


健康检查是容器运行状态的高级检查，主要是检查容器所运行的进程是否能正常的对外提供“服务”，比如一个数据库容器，我们不光
需要这个容器是up的状态，我们还要求这个容器的数据库进程能够正常对外提供服务，这就是所谓的健康检查。


容器的健康检查
-----------------------

容器本身有一个健康检查的功能，但是需要在Dockerfile里定义，或者在执行docker container run 的时候，通过下面的一些参数指定


.. code-block:: bash

    --health-cmd string              Command to run to check health
    --health-interval duration       Time between running the check
                                    (ms|s|m|h) (default 0s)
    --health-retries int             Consecutive failures needed to
                                    report unhealthy
    --health-start-period duration   Start period for the container to
                                    initialize before starting
                                    health-retries countdown
                                    (ms|s|m|h) (default 0s)
    --health-timeout duration        Maximum time to allow one check to


示例源码
~~~~~~~~~~~~~

我们以下面的这个flask容器为例，相关的代码如下

.. code-block:: powershell

    PS C:\Users\Peng Xiao\code-demo\compose-env\flask> dir


        目录: C:\Users\Peng Xiao\code-demo\compose-env\flask


    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a----         2021/7/13     15:52            448 app.py
    -a----         2021/7/14      0:32            471 Dockerfile


    PS C:\Users\Peng Xiao\code-demo\compose-env\flask> more .\app.py
    from flask import Flask
    from redis import StrictRedis
    import os
    import socket

    app = Flask(__name__)
    redis = StrictRedis(host=os.environ.get('REDIS_HOST', '127.0.0.1'),
                        port=6379, password=os.environ.get('REDIS_PASS'))


    @app.route('/')
    def hello():
        redis.incr('hits')
        return f"Hello Container World! I have been seen {redis.get('hits').decode('utf-8')} times and my hostname is {socket.gethostname()}.\n"

    PS C:\Users\Peng Xiao\code-demo\compose-env\flask> more .\Dockerfile
    FROM python:3.9.5-slim

    RUN pip install flask redis && \
        apt-get update && \
        apt-get install -y curl && \
        groupadd -r flask && useradd -r -g flask flask && \
        mkdir /src && \
        chown -R flask:flask /src

    USER flask

    COPY app.py /src/app.py

    WORKDIR /src

    ENV FLASK_APP=app.py REDIS_HOST=redis

    EXPOSE 5000

    HEALTHCHECK --interval=30s --timeout=3s \
        CMD curl -f http://localhost:5000/ || exit 1

    CMD ["flask", "run", "-h", "0.0.0.0"]

上面Dockerfili里的HEALTHCHECK 就是定义了一个健康检查。 会每隔30秒检查一次，如果失败就会退出，退出代码是1


构建镜像和创建容器
~~~~~~~~~~~~~~~~~~~~~~~~

构建镜像，创建一个bridge网络，然后启动容器连到bridge网络

.. code-block:: powershell

    $ docker image build -t flask-demo .
    $ docker network create mybridge
    $ docker container run -d --network mybridge --env REDIS_PASS=abc123 flask-demo

查看容器状态

.. code-block:: powershell

    $ docker container ls
    CONTAINER ID   IMAGE        COMMAND                  CREATED       STATUS                            PORTS      NAMES
    059c12486019   flask-demo   "flask run -h 0.0.0.0"   4 hours ago   Up 8 seconds (health: starting)   5000/tcp   dazzling_tereshkova

也可以通过docker container inspect 059 查看详情， 其中有有关health的

.. code-block:: powershell

    "Health": {
    "Status": "starting",
    "FailingStreak": 1,
    "Log": [
        {
            "Start": "2021-07-14T19:04:46.4054004Z",
            "End": "2021-07-14T19:04:49.4055393Z",
            "ExitCode": -1,
            "Output": "Health check exceeded timeout (3s)"
        }
    ]
    }

经过3次检查，一直是不通的，然后health的状态会从starting变为 unhealthy

.. code-block:: powershell

    docker container ls
    CONTAINER ID   IMAGE        COMMAND                  CREATED       STATUS                     PORTS      NAMES
    059c12486019   flask-demo   "flask run -h 0.0.0.0"   4 hours ago   Up 2 minutes (unhealthy)   5000/tcp   dazzling_tereshkova


启动redis服务器
~~~~~~~~~~~~~~~~~~~~~~

启动redis，连到mybridge上，name=redis， 注意密码

.. code-block:: powershell

    $ docker container run -d --network mybridge --name redis redis:latest redis-server --requirepass abc123

经过几秒钟，我们的flask 变成了healthy

.. code-block:: powershell

    $ docker container ls
    CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                   PORTS      NAMES
    bc4e826ee938   redis:latest   "docker-entrypoint.s…"   18 seconds ago   Up 16 seconds            6379/tcp   redis
    059c12486019   flask-demo     "flask run -h 0.0.0.0"   4 hours ago      Up 6 minutes (healthy)   5000/tcp   dazzling_tereshkova


docker-compose 健康检查
----------------------------

示例代码下载(flask healthcheck) :download:`本节源码 <compose-healthcheck-flask.zip>`

示例代码下载(flask + redis healthcheck) :download:`本节源码 <compose-healthcheck-redis.zip>`


一个healthcheck不错的例子 https://gist.github.com/phuysmans/4f67a7fa1b0c6809a86f014694ac6c3a