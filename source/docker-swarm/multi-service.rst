部署多 service 应用
====================


如何像docker-compose一样部署多服务应用，这一节我们先看手动的方式

本节课所用的源码文件 https://github.com/xiaopeng163/flask-redis


创建一个mynet的overlay网络

.. code-block:: bash

    vagrant@swarm-manager:~$ docker network ls
    NETWORK ID     NAME              DRIVER    SCOPE
    afc8f54c1d07   bridge            bridge    local
    128fd1cb0fae   docker_gwbridge   bridge    local
    0ea68b0d28b9   host              host      local
    14fy2l7a4mci   ingress           overlay   swarm
    lpirdge00y3j   mynet             overlay   swarm
    a8edf1804fb6   none              null      local
    vagrant@swarm-manager:~$


创建一个redis的service

.. code-block:: bash

    vagrant@swarm-manager:~$ docker service create --network mynet --name redis redis:latest redis-server --requirepass ABC123
    qh3nfeth3wc7uoz9ozvzta5ea
    overall progress: 1 out of 1 tasks
    1/1: running   [==================================================>]
    verify: Service converged
    vagrant@swarm-manager:~$ docker servce ls
    docker: 'servce' is not a docker command.
    See 'docker --help'
    vagrant@swarm-manager:~$ docker service ls
    ID             NAME      MODE         REPLICAS   IMAGE          PORTS
    qh3nfeth3wc7   redis     replicated   1/1        redis:latest
    vagrant@swarm-manager:~$ docker service ps redis
    ID             NAME      IMAGE          NODE            DESIRED STATE   CURRENT STATE            ERROR     PORTS
    111cpkjn4a0k   redis.1   redis:latest   swarm-worker2   Running         Running 19 seconds ago
    vagrant@swarm-manager:~$

创建一个flask的service

.. code-block:: bash

    vagrant@swarm-manager:~$ docker service create --network mynet --name flask --env REDIS_HOST=redis --env REDIS_PASS=ABC123 -p 8080
    :5000 xiaopeng163/flask-redis:latest
    y7garhvlxah592j5lmqv8a3xj
    overall progress: 1 out of 1 tasks
    1/1: running   [==================================================>]
    verify: Service converged
    vagrant@swarm-manager:~$ docker service ls
    ID             NAME      MODE         REPLICAS   IMAGE                            PORTS
    y7garhvlxah5   flask     replicated   1/1        xiaopeng163/flask-redis:latest   *:8080->5000/tcp
    qh3nfeth3wc7   redis     replicated   1/1        redis:latest
    vagrant@swarm-manager:~$ docker service ps flask
    ID             NAME      IMAGE                            NODE            DESIRED STATE   CURRENT STATE            ERROR     PORTS
    quptcq7vb48w   flask.1   xiaopeng163/flask-redis:latest   swarm-worker1   Running         Running 15 seconds ago
    vagrant@swarm-manager:~$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 1 times and my hostname is d4de54036614.
    vagrant@swarm-manager:~$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 2 times and my hostname is d4de54036614.
    vagrant@swarm-manager:~$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 3 times and my hostname is d4de54036614.
    vagrant@swarm-manager:~$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 4 times and my hostname is d4de54036614.
    vagrant@swarm-manager:~$