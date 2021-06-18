容器和虚拟机 Container vs VM
================================


.. image:: ../_static/containers-vs-virtual-machines.jpg
    :alt: docker-vs-vm

容器不是Mini虚拟机
---------------------

* 容器其实是进程Containers are just processes
* 容器中的进程被限制了对CPU内存等资源的访问
* 当进程停止后，容器就退出了


容器的进程process
---------------------

.. note::

    以下是在Ubuntu20.04中演示，因Windows环境下的Docker和Linux具有一些差异。``pstree``  命令需要额外安装，可以使用  ``yum install psmisc`` 或者 ``sudo apt-get install psmisc`` 安装

.. code-block:: bash

    ➜  ~ docker container run -d nginx
    57fe4033dd7e1e620a0b6a7b83b85d4f8f98772f0ce585624c384de254826fd0
    ➜  ~ docker container ls
    CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
    57fe4033dd7e   nginx     "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds   80/tcp    festive_proskuriakova
    ➜  ~ docker container top 57f
    UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
    root                7646                7625                0                   12:14               ?                   00:00:00            nginx: master process nginx -g daemon off;
    systemd+            7718                7646                0                   12:14               ?                   00:00:00            nginx: worker process
    ➜  ~
    ➜  ~
    ➜  ~  ps -aef --forest
    UID        PID  PPID  C STIME TTY          TIME CMD
    root         1     0  0 May14 ?        00:00:00 /init
    root       157     1  0 May14 ?        00:00:00 /init
    root       523   157  0 May14 ?        00:02:32  \_ /usr/bin/dockerd -p /var/run/docker.pid
    root       545   523  0 May14 ?        00:25:55  |   \_ containerd --config /var/run/docker/containerd/containerd.toml --log-level info
    root      7625   157  0 12:14 ?        00:00:00  \_ /usr/bin/containerd-shim-runc-v2 -namespace moby -id 57fe4033dd7e1e620a0b6a7b83b85d4f8f98772f0ce585624c384de254826fd0 -address /var/run/d
    root      7646  7625  0 12:14 ?        00:00:00      \_ nginx: master process nginx -g daemon off;
    systemd+  7718  7646  0 12:14 ?        00:00:00          \_ nginx: worker process
    root      6442     1  0 May18 ?        00:00:00 /init
    root      6443  6442  0 May18 ?        00:00:00  \_ /init
    penxiao   6444  6443  0 May18 pts/2    00:00:01      \_ -zsh
    penxiao   7770  6444  0 12:15 pts/2    00:00:00          \_ ps -aef --forest
    ➜  ~
    ➜  ~ pstree -halps 7718
    init,1
    └─init,157
        └─containerd-shim,7625 -namespace moby -id 57fe4033dd7e1e620a0b6a7b83b85d4f8f98772f0ce585624c384de254826fd0 -address /var/run/docker/containerd/containerd.sock
            └─nginx,7646
                └─nginx,7718



Gain Access to the MobyLinux VM on Windows or MacOS
---------------------------------------------------------

https://nickjanetakis.com/blog/docker-tip-70-gain-access-to-the-mobylinux-vm-on-windows-or-macos