镜像的基本操作
=================



.. code-block:: bash


    $ docker image

    Usage:  docker image COMMAND

    Manage images

    Commands:
    build       Build an image from a Dockerfile
    history     Show the history of an image
    import      Import the contents from a tarball to create a filesystem image
    inspect     Display detailed information on one or more images
    load        Load an image from a tar archive or STDIN
    ls          List images
    prune       Remove unused images
    pull        Pull an image or a repository from a registry
    push        Push an image or a repository to a registry
    rm          Remove one or more images
    save        Save one or more images to a tar archive (streamed to STDOUT by default)
    tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

    Run 'docker image COMMAND --help' for more information on a command.



镜像的拉取Pull Image
----------------------

默认从Docker Hub拉取，如果不指定版本，会拉取最新版

.. code-block:: bash

    $ docker pull nginx
    Using default tag: latest
    latest: Pulling from library/nginx
    69692152171a: Pull complete
    49f7d34d62c1: Pull complete
    5f97dc5d71ab: Pull complete
    cfcd0711b93a: Pull complete
    be6172d7651b: Pull complete
    de9813870342: Pull complete
    Digest: sha256:df13abe416e37eb3db4722840dd479b00ba193ac6606e7902331dcea50f4f1f2
    Status: Downloaded newer image for nginx:latest
    docker.io/library/nginx:latest

指定版本

.. code-block:: bash

    $ docker pull nginx:1.20.0
    1.20.0: Pulling from library/nginx
    69692152171a: Already exists
    965615a5cec8: Pull complete
    b141b026b9ce: Pull complete
    8d70dc384fb3: Pull complete
    525e372d6dee: Pull complete
    Digest: sha256:ea4560b87ff03479670d15df426f7d02e30cb6340dcd3004cdfc048d6a1d54b4
    Status: Downloaded newer image for nginx:1.20.0
    docker.io/library/nginx:1.20.0

从Quay上拉取镜像


.. code-block:: bash

    $ docker pull quay.io/bitnami/nginx
    Using default tag: latest
    latest: Pulling from bitnami/nginx
    2e6370f1e2d3: Pull complete
    2d464c695e97: Pull complete
    83eb3b1671f4: Pull complete
    364c139450f9: Pull complete
    dc453d5ae92e: Pull complete
    09bd59934b83: Pull complete
    8d2bd62eedfb: Pull complete
    8ac060ae1ede: Pull complete
    c7c9bc2f4f9d: Pull complete
    6dd7098b85fa: Pull complete
    894a70299d18: Pull complete
    Digest: sha256:d143befa04e503472603190da62db157383797d281fb04e6a72c85b48e0b3239
    Status: Downloaded newer image for quay.io/bitnami/nginx:latest
    quay.io/bitnami/nginx:latest


镜像的查看
---------------

.. code-block:: bash

    $ docker image ls
    REPOSITORY              TAG       IMAGE ID       CREATED       SIZE
    quay.io/bitnami/nginx   latest    0922eabe1625   6 hours ago   89.3MB
    nginx                   1.20.0    7ab27dbbfbdf   10 days ago   133MB
    nginx                   latest    f0b8a9a54136   10 days ago   133MB


镜像的删除
------------------

.. code-block:: bash

    $ docker image rm 0922eabe1625
    Untagged: quay.io/bitnami/nginx:latest
    Untagged: quay.io/bitnami/nginx@sha256:d143befa04e503472603190da62db157383797d281fb04e6a72c85b48e0b3239
    Deleted: sha256:0922eabe16250e2f4711146e31b7aac0e547f52daa6cf01c9d00cf64d49c68c8
    Deleted: sha256:5eee4ed0f6b242e2c6e4f4066c7aca26bf9b3b021b511b56a0dadd52610606bd
    Deleted: sha256:472a75325eda417558f9100ff8b4a97f4a5e8586a14eb9c8fc12f944b26a21f8
    Deleted: sha256:cdcb5872f8a64a0b5839711fcd2a87ba05795e5bf6a70ba9510b8066cdd25e76
    Deleted: sha256:e0f1b7345a521469bbeb7ec53ef98227bd38c87efa19855c5ba0db0ac25c8e83
    Deleted: sha256:11b9c2261cfc687fba8d300b83434854cc01e91a2f8b1c21dadd937e59290c99
    Deleted: sha256:4819311ec2867ad82d017253500be1148fc335ad13b6c1eb6875154da582fcf2
    Deleted: sha256:784480add553b8e8d5ee1bbd229ed8be92099e5fb61009ed7398b93d5705a560
    Deleted: sha256:e0c520d1a43832d5d2b1028e3f57047f9d9f71078c0187f4bb05e6a6a572993d
    Deleted: sha256:94d5b1d6c9e31de42ce58b8ce51eb6fb5292ec889a6d95763ad2905330b92762
    Deleted: sha256:95deba55c490bbb8de44551d3e6a89704758c93ba8503a593cb7c07dfbae0058
    Deleted: sha256:1ad1d903ef1def850cd44e2010b46542196e5f91e53317dbdb2c1eedfc2d770c