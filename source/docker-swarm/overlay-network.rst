Swarm 的 overlay 网络详解
==============================

对于理解swarm的网络来讲，个人认为最重要的两个点：

- 第一是外部如何访问部署运行在swarm集群内的服务，可以称之为 ``入方向`` 流量，在swarm里我们通过 ``ingress`` 来解决
- 第二是部署在swarm集群里的服务，如何对外进行访问，这部分又分为两块:
  
  - 第一，``东西向流量`` ，也就是不同swarm节点上的容器之间如何通信，swarm通过 ``overlay`` 网络来解决；
  - 第二，``南北向流量`` ，也就是swarm集群里的容器如何对外访问，比如互联网，这个是 ``Linux bridge + iptables NAT`` 来解决的





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

.. image:: ../_static/docker-swarm/swarm-overlay.png
    :alt: docker-swarm-overlay
