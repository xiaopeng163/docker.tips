Data Volume 练习 MySQL
========================

.. note::

    本次练习，演示使用的是Linux环境，Windows环境也可以做这里面的90%以上的内容


使用MySQL官方镜像，tag版本5.7

Dockerfile可以在这里查看 https://github.com/docker-library/mysql/tree/master/5.7


准备镜像
-------------

.. code-block:: bash

    $ docker pull mysql:5.7
    $ docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
    mysql        5.7       2c9028880e58   5 weeks ago    447MB


创建容器
------------------

关于MySQL的镜像使用，可以参考dockerhub https://hub.docker.com/_/mysql?tab=description&page=1&ordering=last_updated

关于Dockerfile Volume的定义，可以参考 https://github.com/docker-library/mysql/tree/master/5.7

.. code-block:: bash

    $ docker container run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d -v mysql-data:/var/lib/mysql mysql:5.7
    02206eb369be08f660bf86b9d5be480e24bb6684c8a938627ebfbcfc0fd9e48e
    $ docker volume ls
    DRIVER    VOLUME NAME
    local     mysql-data
    $ docker volume inspect mysql-data
    [
        {
            "CreatedAt": "2021-06-21T23:55:23+02:00",
            "Driver": "local",
            "Labels": null,
            "Mountpoint": "/var/lib/docker/volumes/mysql-data/_data",
            "Name": "mysql-data",
            "Options": null,
            "Scope": "local"
        }
    ]
    $


数据库写入数据
----------------

进入MySQL的shell，密码是 ``my-secret-pw``

.. code-block:: bash

    $ docker container exec -it 022 sh
    # mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 2
    Server version: 5.7.34 MySQL Community Server (GPL)

    Copyright (c) 2000, 2021, Oracle and/or its affiliates.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | sys                |
    +--------------------+
    4 rows in set (0.00 sec)
    
    mysql> create database demo;
    Query OK, 1 row affected (0.00 sec)
    
    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | demo               |
    | mysql              |
    | performance_schema |
    | sys                |
    +--------------------+
    5 rows in set (0.00 sec)
    
    mysql> exit
    Bye
    # exit

创建了一个叫 demo的数据库


查看data volume

.. code-block:: bash

    $ docker volume inspect mysql-data
    [
        {
            "CreatedAt": "2021-06-22T00:01:34+02:00",
            "Driver": "local",
            "Labels": null,
            "Mountpoint": "/var/lib/docker/volumes/mysql-data/_data",
            "Name": "mysql-data",
            "Options": null,
            "Scope": "local"
        }
    ]
    $ ls  /var/lib/docker/volumes/mysql-data/_data
    auto.cnf    client-cert.pem  ib_buffer_pool  ibdata1  performance_schema  server-cert.pem
    ca-key.pem  client-key.pem   ib_logfile0     ibtmp1   private_key.pem     server-key.pem
    ca.pem      demo             ib_logfile1     mysql    public_key.pem      sys
    $


其它数据库
------------------

如果熟悉的话，也可以试试MongoDB https://hub.docker.com/_/mongo