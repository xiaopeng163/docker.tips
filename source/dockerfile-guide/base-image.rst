基础镜像的选择 (FROM)
=======================

基本原则
-------------------

- 官方镜像优于非官方的镜像，如果没有官方镜像，则尽量选择Dockerfile开源的
- 固定版本tag而不是每次都使用latest
- 尽量选择体积小的镜像


.. code-block:: bash

    $ docker image ls
    REPOSITORY      TAG             IMAGE ID       CREATED          SIZE
    bitnami/nginx   1.18.0          dfe237636dde   28 minutes ago   89.3MB
    nginx           1.21.0-alpine   a6eb2a334a9f   2 days ago       22.6MB
    nginx           1.21.0          d1a364dc548d   2 days ago       133MB


Build一个Nginx镜像
------------------------

假如我们有一个 ``index.html`` 文件

.. code-block:: html

    <h1>Hello Docker</h1>

准备一个Dockerfile

.. code-block:: dockerfile

    FROM nginx:1.21.0-alpine

    ADD index.html /usr/share/nginx/html/index.html



延申阅读
---------------

- https://pythonspeed.com/articles/base-image-python-docker-images/
- https://pythonspeed.com/articles/alpine-docker-python/
