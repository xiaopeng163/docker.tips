swarm 使用 local volume
============================

本节源码，两个文件

``docker-compose.yml``

.. code-block:: yaml

    version: "3.8"

    services:
      db:
        image: mysql:5.7
        environment:
          - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql_pass
        restart: always
        secrets:
          - mysql_pass
        restart: always
        volumes:
          - data:/var/lib/mysql

    volumes:
      data:
        external: true

    secrets:
      mysql_pass:
        file: mysql_pass.txt

``mysql_pass.txt``

.. code-block:: yaml

    vagrant@swarm-manager:~$ more mysql_pass.txt
    abc123
    vagrant@swarm-manager:~$
