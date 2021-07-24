swarm stack 部署多 service 应用
==================================


先在swarm manager节点上安装一下 docker-compose

.. code-block:: bash

    vagrant@swarm-manager:~$ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    vagrant@swarm-manager:~$ sudo chmod +x /usr/local/bin/docker-compose

clone我们的代码仓库

.. code-block:: bash

    vagrant@swarm-manager:~$ git clone https://github.com/xiaopeng163/flask-redis
    Cloning into 'flask-redis'...
    remote: Enumerating objects: 22, done.
    remote: Counting objects: 100% (22/22), done.
    remote: Compressing objects: 100% (19/19), done.
    remote: Total 22 (delta 9), reused 7 (delta 2), pack-reused 0
    Unpacking objects: 100% (22/22), 8.60 KiB | 1.07 MiB/s, done.
    vagrant@swarm-manager:~$ cd flask-redis
    vagrant@swarm-manager:~/flask-redis$ ls
    Dockerfile  LICENSE  README.md  app.py  docker-compose.yml
    vagrant@swarm-manager:~/flask-redis$

环境清理

.. code-block:: bash

    vagrant@swarm-manager:~/flask-redis$ docker system prune -a -f

镜像构建和提交， 如果你想做这一步，可以把docker-compose.yml里的  ``xiaopeng163/flask-redis`` 改成你的dockerhub id

.. code-block:: bash

    vagrant@swarm-manager:~/flask-redis$ docker-compose build
    vagrant@swarm-manager:~/flask-redis$ docker image ls
    REPOSITORY                TAG          IMAGE ID       CREATED         SIZE
    xiaopeng163/flask-redis   latest       5efb4fcbcfc3   6 seconds ago   126MB
    python                    3.9.5-slim   c71955050276   3 weeks ago     115MB

提交镜像到dockerhub

.. code-block:: bash

    vagrant@swarm-manager:~/flask-redis$ docker login
    Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
    Username: xiaopeng163
    Password:
    WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store

    Login Succeeded
    vagrant@swarm-manager:~/flask-redis$ docker-compose push
    WARNING: The REDIS_PASSWORD variable is not set. Defaulting to a blank string.
    Pushing flask (xiaopeng163/flask-redis:latest)...
    The push refers to repository [docker.io/xiaopeng163/flask-redis]
    f447d33c161b: Pushed
    f7395da2fd9c: Pushed
    5b156295b5a3: Layer already exists
    115e0863702d: Layer already exists
    e10857b94a57: Layer already exists
    8d418cbfaf25: Layer already exists
    764055ebc9a7: Layer already exists
    latest: digest: sha256:c909100fda2f4160b593b4e0fb692b89046cebb909ae90546627deca9827b676 size: 1788
    vagrant@swarm-manager:~/flask-redis$


通过stack启动服务


.. code-block:: bash

    vagrant@swarm-manager:~/flask-redis$ env REDIS_PASSWORD=ABC123 docker stack deploy --compose-file docker-compose.yml flask-demo
    Ignoring unsupported options: build

    Creating network flask-demo_default
    Creating service flask-demo_flask
    Creating service flask-demo_redis-server
    vagrant@swarm-manager:~/flask-redis$
    vagrant@swarm-manager:~/flask-redis$ docker stack ls
    NAME         SERVICES   ORCHESTRATOR
    flask-demo   2          Swarm
    vagrant@swarm-manager:~/flask-redis$ docker stack ps flask-demo
    ID             NAME                        IMAGE                            NODE            DESIRED STATE   CURRENT STATE
    ERROR     PORTS
    lzm6i9inoa8e   flask-demo_flask.1          xiaopeng163/flask-redis:latest   swarm-manager   Running         Running 23 seconds ago

    ejojb0o5lbu0   flask-demo_redis-server.1   redis:latest                     swarm-worker2   Running         Running 21 seconds ago

    vagrant@swarm-manager:~/flask-redis$ docker stack services flask-demo
    ID             NAME                      MODE         REPLICAS   IMAGE                            PORTS
    mpx75z1rrlwn   flask-demo_flask          replicated   1/1        xiaopeng163/flask-redis:latest   *:8080->5000/tcp
    z85n16zsldr1   flask-demo_redis-server   replicated   1/1        redis:latest
    vagrant@swarm-manager:~/flask-redis$ docker service ls
    ID             NAME                      MODE         REPLICAS   IMAGE                            PORTS
    mpx75z1rrlwn   flask-demo_flask          replicated   1/1        xiaopeng163/flask-redis:latest   *:8080->5000/tcp
    z85n16zsldr1   flask-demo_redis-server   replicated   1/1        redis:latest
    vagrant@swarm-manager:~/flask-redis$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 1 times and my hostname is 21d63a8bfb57.
    vagrant@swarm-manager:~/flask-redis$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 2 times and my hostname is 21d63a8bfb57.
    vagrant@swarm-manager:~/flask-redis$ curl 127.0.0.1:8080
    Hello Container World! I have been seen 3 times and my hostname is 21d63a8bfb57.
    vagrant@swarm-manager:~/flask-redis$