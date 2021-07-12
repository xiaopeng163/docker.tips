docker compose 水平扩展
=========================

本节课的源码下载 :download:`本节源码 <compose-scale-example-1.zip>`


环境清理
-----------

删除所有容器和镜像

.. code-block:: bash
  
    $ docker container rm -f $(docker container ps -aq)
    $ docker system prune -a -f  

启动
--------

下载源码，进入源码目录

.. code-block:: bash

    $ docker-compose pull
    $ docker-compose build
    $ docker-compose up -d
    Creating network "compose-scale-example_default" with the default driver
    Creating compose-scale-example_flask_1        ... done
    Creating compose-scale-example_client_1       ... done
    Creating compose-scale-example_redis-server_1 ... done
    $ docker-compose ps
                    Name                              Command               State    Ports
    ----------------------------------------------------------------------------------------
    compose-scale-example_client_1         sh -c while true; do sleep ...   Up
    compose-scale-example_flask_1          flask run -h 0.0.0.0             Up      5000/tcp
    compose-scale-example_redis-server_1   docker-entrypoint.sh redis ...   Up      6379/tcp

水平扩展 scale
--------------

.. code-block:: bash

    $ docker-compose up -d --scale flask=3
    compose-scale-example_client_1 is up-to-date
    compose-scale-example_redis-server_1 is up-to-date
    Creating compose-scale-example_flask_2 ... done
    Creating compose-scale-example_flask_3 ... done
    $ docker-compose ps
                    Name                              Command               State    Ports
    ----------------------------------------------------------------------------------------
    compose-scale-example_client_1         sh -c while true; do sleep ...   Up
    compose-scale-example_flask_1          flask run -h 0.0.0.0             Up      5000/tcp
    compose-scale-example_flask_2          flask run -h 0.0.0.0             Up      5000/tcp
    compose-scale-example_flask_3          flask run -h 0.0.0.0             Up      5000/tcp
    compose-scale-example_redis-server_1   docker-entrypoint.sh redis ...   Up      6379/tcp


添加 nginx
--------------

源码下载 :download:`源码更新 <compose-scale-example-2.zip>`

.. image:: ../_static/flask-nginx.png
    :alt: docker-compose-flask-nginx
