Swarm 的 overlay 网络
=========================


创建 overlay 网络
----------------------

.. code-block:: bash

    vagrant@swarm-manager:~$ docker network create -d overlay mynet


这个网络会同步到所有的swarm节点上

创建服务
----------


创建一个服务连接到这个 overlay网络， name 是 test ， replicas 是 2

.. code-block:: bash

    vagrant@swarm-manager:~$ docker service create --network mynet --name test --replicas 2 busybox ping 8.8.8.8
    vagrant@swarm-manager:~$ docker service ps test
    ID             NAME      IMAGE            NODE            DESIRED STATE   CURRENT STATE            ERROR     PORTS
    yf5uqm1kzx6d   test.1    busybox:latest   swarm-worker1   Running         Running 18 seconds ago
    3tmp4cdqfs8a   test.2    busybox:latest   swarm-worker2   Running         Running 18 seconds ago


网络查看
------------

到worker1和worker2上分别查看容器的网络连接情况

