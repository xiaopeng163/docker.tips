容器的基本操作
=====================

.. list-table:: docker container command
   :widths: 25 25 25
   :header-rows: 1

   * - 操作
     - 命令(全)
     - 命令(简)
   * - 容器的创建
     - docker container run <image name>
     - docker run <image name>
   * - 容器的列出(up)
     - docker container ls
     - docker ps
   * - 容器的列出(up和exit)
     - docker container ls -a
     - docker ps -a
   * - 容器的停止
     - docker container stop <name or ID>
     - docker stop <container name or ID>
   * - 容器的删除
     - docker container rm <name or ID>
     - docker rm <container name or ID>


Demo
-------

.. code-block:: bash

    $ docker container run nginx
    $ docker ps
    CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
    343fd4031609   nginx     "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   80/tcp    xenodochial_clarke
    $ docker container ls
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
    343fd4031609   nginx     "/docker-entrypoint.…"   14 seconds ago   Up 13 seconds   80/tcp    xenodochial_clarke
    $ docker container stop 34
    34
    $ docker container ls -a
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                      PORTS     NAMES
    343fd4031609   nginx     "/docker-entrypoint.…"   29 seconds ago   Exited (0) 5 seconds ago              xenodochial_clarke
    d9095daa8bcf   nginx     "/docker-entrypoint.…"   28 minutes ago   Exited (0) 28 minutes ago             suspicious_shamir
    $ docker container rm 34
    34
    $ docker container ls -a
    CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                      PORTS     NAMES
    d9095daa8bcf   nginx     "/docker-entrypoint.…"   28 minutes ago   Exited (0) 28 minutes ago             suspicious_shamir
    $