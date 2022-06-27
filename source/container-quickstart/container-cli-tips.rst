docker container 命令小技巧
=================================


批量停止
-----------


.. code-block:: bash

    $ docker container ps
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
    cd3a825fedeb   nginx     "/docker-entrypoint.…"   7 seconds ago    Up 6 seconds    80/tcp    mystifying_leakey
    269494fe89fa   nginx     "/docker-entrypoint.…"   9 seconds ago    Up 8 seconds    80/tcp    funny_gauss
    34b68af9deef   nginx     "/docker-entrypoint.…"   12 seconds ago   Up 10 seconds   80/tcp    interesting_mahavira
    7513949674fc   nginx     "/docker-entrypoint.…"   13 seconds ago   Up 12 seconds   80/tcp    kind_nobel


方法1

.. code-block:: bash

    $ docker container stop cd3 269 34b 751


方法2

.. code-block:: bash

    $ docker container stop $(docker container ps -aq)
    cd3a825fedeb
    269494fe89fa
    34b68af9deef
    7513949674fc
    $ docker container ps -a
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                     PORTS     NAMES
    cd3a825fedeb   nginx     "/docker-entrypoint.…"   30 seconds ago   Exited (0) 2 seconds ago             mystifying_leakey
    269494fe89fa   nginx     "/docker-entrypoint.…"   32 seconds ago   Exited (0) 2 seconds ago             funny_gauss
    34b68af9deef   nginx     "/docker-entrypoint.…"   35 seconds ago   Exited (0) 2 seconds ago             interesting_mahavira
    7513949674fc   nginx     "/docker-entrypoint.…"   36 seconds ago   Exited (0) 2 seconds ago             kind_nobel
    $


批量删除
-------------

和批量停止类似，可以使用  ``docker container rm $(docker container ps -aq)``



.. note::

    ``docker system prune -a -f`` 可以快速对系统进行清理，删除停止的容器，不用的image，等等
