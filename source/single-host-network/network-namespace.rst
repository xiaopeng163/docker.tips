网络命名空间
==================

Linux的Namespace（命名空间）技术是一种隔离技术，常用的Namespace有 user namespace, process namespace, network namespace等

在Docker容器中，不同的容器通过Network namespace进行了隔离，也就是不同的容器有各自的IP地址，路由表等，互不影响。


.. note::

    准备一台Linux机器，这一节会用到一个叫 ``brtcl`` 的命令，这个命令需要安装，如果是Ubuntu的系统，可以通过 ``apt-get install bridge-utils`` 安装；如果是Centos系统，可以通过
    ``sudo yum install bridge-utils`` 来安装


.. image:: ../_static/network-namespace.png
    :alt: docker-volume


1. 创建两个网络命名空间 ns1 和 ns2
------------------------------------

.. code-block:: bash

    $ sudo ip netns add ns1
    $ sudo ip netns add ns2

2. 查看网络命名空间
-----------------------------

.. code-block:: bash

    $ sudo ip netns list
    ns2
    ns1

3. 在特定的网络命名空间里执行命令
------------------------------------

比如执行 ``ip a`` 命令查看各个空间的ip接口信息

.. code-block:: bash

    $ sudo ip netns exec ns1 ip a
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
        link/sit 0.0.0.0 brd 0.0.0.0
    $
    $ sudo ip netns exec ns2 ip a
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
        link/sit 0.0.0.0 brd 0.0.0.0
    $

4. 创建一个Linux网桥bridge
-------------------------------

创建一个名为 ``mydocker0`` 的bridge

.. code-block:: bash

    $ sudo brctl addbr mydocker0
    $ sudo brctl show
    bridge name     bridge id               STP enabled     interfaces
    docker0         8000.024236a15351       no
    mydocker0               8000.000000000000       no
    $

给mydocker0这个bridge配置IP地址

.. code-block:: bash

    $ sudo ip a add 172.16.1.254/16 dev mydocker0
    $ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
    4: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
        link/ether 00:15:5d:f1:59:64 brd ff:ff:ff:ff:ff:ff
        inet 172.26.233.26/20 brd 172.26.239.255 scope global eth0
        valid_lft forever preferred_lft forever
        inet6 fe80::215:5dff:fef1:5964/64 scope link
        valid_lft forever preferred_lft forever
    6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
        link/ether 02:42:36:a1:53:51 brd ff:ff:ff:ff:ff:ff
        inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
        valid_lft forever preferred_lft forever
    7: mydocker0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether e6:4c:52:f9:7e:d3 brd ff:ff:ff:ff:ff:ff
        inet 172.16.1.254/16 scope global mydocker0
        valid_lft forever preferred_lft forever
    $

并让这个bridge up起来

.. code-block:: bash

    $ sudo ip link set dev mydocker0 up
    $ route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         172.26.224.1    0.0.0.0         UG    0      0        0 eth0
    172.16.0.0      0.0.0.0         255.255.0.0     U     0      0        0 mydocker0
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    172.26.224.0    0.0.0.0         255.255.240.0   U     0      0        0 eth0
    $

5. 创建一对VETH把网络命名空间ns1和网桥mydocker0连起来
-------------------------------------------------------

一对veth， veth1和veth1p

.. code-block:: bash

    $ sudo ip link add veth1 type veth peer name veth1p
    $ ip -d link show |grep veth1
    8: veth1p@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    9: veth1@veth1p: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    $

把veth1连到 mydocker0上，并up

.. code-block:: bash

    $ sudo  brctl addif mydocker0 veth1
    $ brctl show
    bridge name     bridge id               STP enabled     interfaces
    docker0         8000.024236a15351       no
    mydocker0               8000.be59a873ffb9       no              veth1
    $ sudo ip link set veth1 up
    $ ip -d link show |grep veth1
    8: veth1p@veth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    9: veth1@veth1p: <NO-CARRIER,BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue master mydocker0 state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    $

把veth1p连接到网络命名空间ns1上， 然后up起来

.. code-block:: bash

    $ sudo ip link set veth1p netns ns1
    $ sudo ip netns exec ns1 ip a
    $ sudo ip netns exec ns1 ip link set veth1p up
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
        link/sit 0.0.0.0 brd 0.0.0.0
    8: veth1p@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 5a:21:42:35:7f:be brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet6 fe80::5821:42ff:fe35:7fbe/64 scope link
        valid_lft forever preferred_lft forever

给veth1p 这个接口配置一个IP地址

.. code-block:: bash

    $ sudo ip netns exec ns1 ip a add 172.16.1.1/16 dev veth1p
    $ sudo ip netns exec ns1 ip a
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
        link/sit 0.0.0.0 brd 0.0.0.0
    8: veth1p@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 5a:21:42:35:7f:be brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 172.16.1.1/16 scope global veth1p
        valid_lft forever preferred_lft forever
        inet6 fe80::5821:42ff:fe35:7fbe/64 scope link
        valid_lft forever preferred_lft forever
    $ sudo ip netns exec ns1 ping 172.16.1.254
    PING 172.16.1.254 (172.16.1.254) 56(84) bytes of data.
    64 bytes from 172.16.1.254: icmp_seq=1 ttl=64 time=0.035 ms
    ^C
    --- 172.16.1.254 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.035/0.035/0.035/0.000 ms
    $


6. 重复第五步，把网络命名空间ns2和mydocker0连接起来
-------------------------------------------------------

.. code-block:: bash

    $ sudo ip link add veth2 type veth peer name veth2p
    $ sudo brctl addif mydocker0 veth2
    $ sudo ip link set veth2 up
    $ sudo ip link set veth2p netns ns2
    $ sudo ip netns exec ns2 ip link set veth2p up
    $ sudo ip netns exec ns2 ip addr add 172.16.1.2/16 dev veth2p


检查连接

.. code-block:: bash

    $ brctl show
    bridge name     bridge id               STP enabled     interfaces
    docker0         8000.024236a15351       no
    mydocker0               8000.1a466eba3b01       no              veth1
                                                            veth2
    $ sudo ip netns exec ns1 ip a
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
        link/sit 0.0.0.0 brd 0.0.0.0
    8: veth1p@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 5a:21:42:35:7f:be brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 172.16.1.1/16 scope global veth1p
        valid_lft forever preferred_lft forever
        inet6 fe80::5821:42ff:fe35:7fbe/64 scope link
        valid_lft forever preferred_lft forever
    $ sudo ip netns exec ns2 ip a
    1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
        link/sit 0.0.0.0 brd 0.0.0.0
    10: veth2p@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether a2:6c:c4:ad:88:a1 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 172.16.1.2/16 scope global veth2p
        valid_lft forever preferred_lft forever
        inet6 fe80::a06c:c4ff:fead:88a1/64 scope link
        valid_lft forever preferred_lft forever
    $

7. 给ns1和ns2添加路由
-------------------------


.. code-block:: bash

    $ sudo  ip netns exec ns2 ip route add default via 172.16.1.254
    $ sudo  ip netns exec ns1 ip route add default via 172.16.1.254
    $


用ns1的IP去ping ns2的IP


