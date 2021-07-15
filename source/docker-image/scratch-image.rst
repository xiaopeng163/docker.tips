关于 scratch 镜像
=====================

Scratch是一个空的Docker镜像。

通过scratch来构建一个基础镜像。


``hello.c``

.. code-block:: c

    #include <stdio.h>
    int main()
    {
        printf("hello docker\n");
    }    

编译成一个二进制文件

.. code-block:: bash

    $ gcc --static -o hello hello.c
    $ ./hello
    hello docker
    $

``Dockerfile`` 

.. code-block:: bash

    FROM scratch
    ADD hello /
    CMD ["/hello"]


构建

.. code-block:: bash

    $ docker build -t hello .
    $ docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
    hello        latest    2936e77a9daa   40 minutes ago   872kB

运行

.. code-block:: bash

    $ docker container run -it hello
    hello docker