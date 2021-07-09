compose 文件的结构和版本
==========================


docker compose文件的语法说明 https://docs.docker.com/compose/compose-file/



基本语法结构
-------------

.. code-block:: yaml

    version: "3.8"

    services: # 容器
      servicename: # 服务名字，这个名字也是内部 bridge网络可以使用的 DNS name
        image: # 镜像的名字
        command: # 可选，如果设置，则会覆盖默认镜像里的 CMD命令
        environment: # 可选，相当于 docker run里的 --env
        volumes: # 可选，相当于docker run里的 -v
        networks: # 可选，相当于 docker run里的 --network
        ports: # 可选，相当于 docker run里的 -p
      servicename2:

    volumes: # 可选，相当于 docker volume create

    networks: # 可选，相当于 docker network create


以 :ref:`Python Flask + Redis练习`：为例子，改造成一个docker-compose文件

.. code-block:: bash

    docker image pull redis
    docker image build -t flask-demo .
    
    # create network
    docker network create -d bridge demo-network
    
    # create container
    docker container run -d --name redis-server --network demo-network redis
    docker container run -d --network demo-network --name flask-demo --env REDIS_HOST=redis-server -p 5000:5000 flask-demo


docker-compose.yml 文件如下

.. code-block:: yaml

    version: "3.8"

    services:
      flask-demo:
        image: flask-demo:latest
        environment:
          - REDIS_HOST=redis-server
        networks:
          - demo-network
        ports:
          - 8080:5000

      redis-server:
        image: redis:latest
        networks:
         - demo-network

    networks:
      demo-network:


docker-compose 语法版本
------------------------


向后兼容

https://docs.docker.com/compose/compose-file/