Docker 的非 root 模式
==========================

本节Vagrant搭建的文件下载 

- :download:`Vagrantfile <docker-rootless.zip>`


文档 https://docs.docker.com/engine/security/rootless/

rootless在使用之前需要

.. code-block:: bash

    $ export DOCKER_HOST=unix:///run/user/1000/docker.sock