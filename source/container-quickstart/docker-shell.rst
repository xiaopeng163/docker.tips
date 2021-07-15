连接容器的 shell
=====================


``docker container run -it`` 创建一个容器并进入交互式模式
--------------------------------------------------------------

.. code-block:: bash

    ➜  ~ docker container run -it busybox sh
    / #
    / #
    / # ls
    bin   dev   etc   home  proc  root  sys   tmp   usr   var
    / # ps
    PID   USER     TIME  COMMAND
        1 root      0:00 sh
        8 root      0:00 ps
    / # exit

``docker container exec -it``  在一个已经运行的容器里执行一个额外的command
-------------------------------------------------------------------------------


.. code-block:: bash

    ➜  ~ docker container run -d nginx
    33d2ee50cfc46b5ee0b290f6ad75d724551be50217f691e68d15722328f11ef6
    ➜  ~
    ➜  ~ docker container exec -it 33d sh
    #
    #
    # ls
    bin  boot  dev  docker-entrypoint.d  docker-entrypoint.sh  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
    #
    # exit
    ➜  ~


