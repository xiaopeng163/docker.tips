docker compose 的安装
===========================


Windows和Mac在默认安装了docker desktop以后，docker-compose随之自动安装


.. code-block:: powershell

    PS C:\Users\Peng Xiao\docker.tips> docker-compose --version
    docker-compose version 1.29.2, build 5becea4c

Linux用户需要自行安装

最新版本号可以在这里查询 https://github.com/docker/compose/releases

.. code-block:: bash

    $ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    $ sudo chmod +x /usr/local/bin/docker-compose
    $ docker-compose --version
    docker-compose version 1.29.2, build 5becea4c

熟悉python的朋友，可以使用pip去安装docker-Compose

.. code-block:: bash

    $ pip install docker-compose