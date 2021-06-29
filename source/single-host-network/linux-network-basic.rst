网络常用命令
==================


IP地址的查看
-------------------


Windows

.. code-block:: bash

    ipconfig

Linux

.. code-block:: bash

    ifconfig

或者

.. code-block:: bash

    ip addr



网络连通性测试
----------------------


ping命令
~~~~~~~~~~~~

.. code-block:: bash

    PS C:\Users\Peng Xiao> ping 192.168.178.1

    Pinging 192.168.178.1 with 32 bytes of data:
    Reply from 192.168.178.1: bytes=32 time=2ms TTL=64
    Reply from 192.168.178.1: bytes=32 time=3ms TTL=64
    Reply from 192.168.178.1: bytes=32 time=3ms TTL=64
    Reply from 192.168.178.1: bytes=32 time=3ms TTL=64

    Ping statistics for 192.168.178.1:
        Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
    Approximate round trip times in milli-seconds:
        Minimum = 2ms, Maximum = 3ms, Average = 2ms
    PS C:\Users\Peng Xiao>

telnet命令
~~~~~~~~~~~~~~~~

测试端口的连通性

.. code-block:: bash

    ➜  ~ telnet www.baidu.com 80
    Trying 104.193.88.123...
    Connected to www.wshifen.com.
    Escape character is '^]'.

    HTTP/1.1 400 Bad Request

    Connection closed by foreign host.
    ➜  ~


traceroute
~~~~~~~~~~~~~

路径探测跟踪


Linux下使用 ``tracepath``

.. code-block:: bash

    ➜  ~ tracepath www.baidu.com
    1?: [LOCALHOST]                      pmtu 1500
    1:  DESKTOP-FQ0EO8J                                       0.430ms
    1:  DESKTOP-FQ0EO8J                                       0.188ms
    2:  192.168.178.1                                         3.371ms
    3:  no reply
    4:  gv-rc0052-cr102-et91-251.core.as33915.net            13.970ms
    5:  asd-tr0021-cr101-be156-10.core.as9143.net            19.190ms
    6:  nl-ams04a-ri3-ae51-0.core.as9143.net                213.589ms
    7:  63.218.65.33                                         16.887ms
    8:  HundredGE0-6-0-0.br04.sjo01.pccwbtn.net             176.099ms asymm 10
    9:  HundredGE0-6-0-0.br04.sjo01.pccwbtn.net             173.399ms asymm 10
    10:  63-219-23-98.static.pccwglobal.net                  177.337ms asymm 11
    11:  104.193.88.13                                       178.197ms asymm 12
    12:  no reply
    13:  no reply
    14:  no reply
    15:  no reply
    16:  no reply
    17:  no reply
    18:  no reply
    19:  no reply
    20:  no reply
    21:  no reply
    22:  no reply
    23:  no reply
    24:  no reply
    25:  no reply
    26:  no reply
    27:  no reply
    28:  no reply
    29:  no reply
    30:  no reply
        Too many hops: pmtu 1500
        Resume: pmtu 1500
    ➜  ~

Windows下使用 ``TRACERT.EXE``

.. code-block:: bash

    PS C:\Users\Peng Xiao> TRACERT.EXE www.baidu.com

    Tracing route to www.wshifen.com [104.193.88.123]
    over a maximum of 30 hops:

    1     4 ms     3 ms     3 ms  192.168.178.1
    2     *        *        *     Request timed out.
    3    21 ms    18 ms    19 ms  gv-rc0052-cr102-et91-251.core.as33915.net [213.51.197.37]
    4    14 ms    13 ms    12 ms  asd-tr0021-cr101-be156-10.core.as9143.net [213.51.158.2]
    5    23 ms    19 ms    14 ms  nl-ams04a-ri3-ae51-0.core.as9143.net [213.51.64.194]
    6    15 ms    14 ms    13 ms  63.218.65.33
    7   172 ms   169 ms   167 ms  HundredGE0-6-0-0.br04.sjo01.pccwbtn.net [63.223.60.58]
    8   167 ms   168 ms   168 ms  HundredGE0-6-0-0.br04.sjo01.pccwbtn.net [63.223.60.58]
    9   168 ms   173 ms   167 ms  63-219-23-98.static.pccwglobal.net [63.219.23.98]
    10   172 ms   170 ms   171 ms


curl命令
~~~~~~~~~

请求web服务的

http://www.ruanyifeng.com/blog/2019/09/curl-reference.html
