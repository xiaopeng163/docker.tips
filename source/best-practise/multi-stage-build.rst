Dockerfile 技巧——镜像的多阶段构建
========================================

这一节来聊聊多阶段构建，以及为什么要使用它。


C语言例子
--------------

假如有一个C的程序，我们想用Docker去做编译，然后执行可执行文件。

.. code-block:: c

    #include <stdio.h>

    void main(int argc, char *argv[])
    {
        printf("hello %s\n", argv[argc - 1]);
    }


本地测试（如果你本地有C环境）

.. code-block:: bash

    $ gcc --static -o hello hello.c
    $ ls
    hello  hello.c
    $ ./hello docker
    hello docker
    $ ./hello world
    hello world
    $ ./hello friends
    hello friends
    $


构建一个Docker镜像，因为要有C的环境，所以我们选择gcc这个image

.. code-block:: Dockerfile

    FROM gcc:9.4

    COPY hello.c /src/hello.c

    WORKDIR /src

    RUN gcc --static -o hello hello.c

    ENTRYPOINT [ "/src/hello" ]

    CMD []


build和测试

.. code-block:: bash

    $ docker build -t hello .
    Sending build context to Docker daemon   5.12kB
    Step 1/6 : FROM gcc:9.4
    ---> be1d0d9ce039
    Step 2/6 : COPY hello.c /src/hello.c
    ---> Using cache
    ---> 70a624e3749b
    Step 3/6 : WORKDIR /src
    ---> Using cache
    ---> 24e248c6b27c
    Step 4/6 : RUN gcc --static -o hello hello.c
    ---> Using cache
    ---> db8ae7b42aff
    Step 5/6 : ENTRYPOINT [ "/src/hello" ]
    ---> Using cache
    ---> 7f307354ee45
    Step 6/6 : CMD []
    ---> Using cache
    ---> 7cfa0cbe4e2a
    Successfully built 7cfa0cbe4e2a
    Successfully tagged hello:latest
    $ docker image ls
    REPOSITORY     TAG          IMAGE ID       CREATED       SIZE
    hello          latest       7cfa0cbe4e2a   2 hours ago   1.14GB
    gcc            9.4          be1d0d9ce039   9 days ago    1.14GB
    $ docker run --rm -it hello docker
    hello docker
    $ docker run --rm -it hello world
    hello world
    $ docker run --rm -it hello friends
    hello friends
    $


可以看到镜像非常的大，1.14GB

实际上当我们把hello.c编译完以后，并不需要这样一个大的GCC环境，一个小的alpine镜像就可以了。

这时候我们就可以使用多阶段构建了。


.. code-block:: Dockerfile

    FROM gcc:9.4 AS builder

    COPY hello.c /src/hello.c

    WORKDIR /src

    RUN gcc --static -o hello hello.c



    FROM alpine:3.13.5

    COPY --from=builder /src/hello /src/hello

    ENTRYPOINT [ "/src/hello" ]

    CMD []
    

测试

.. code-block:: bash

    $ docker build -t hello-apline -f Dockerfile-new .
    Sending build context to Docker daemon   5.12kB
    Step 1/8 : FROM gcc:9.4 AS builder
    ---> be1d0d9ce039
    Step 2/8 : COPY hello.c /src/hello.c
    ---> Using cache
    ---> 70a624e3749b
    Step 3/8 : WORKDIR /src
    ---> Using cache
    ---> 24e248c6b27c
    Step 4/8 : RUN gcc --static -o hello hello.c
    ---> Using cache
    ---> db8ae7b42aff
    Step 5/8 : FROM alpine:3.13.5
    ---> 6dbb9cc54074
    Step 6/8 : COPY --from=builder /src/hello /src/hello
    ---> Using cache
    ---> 18c2bce629fb
    Step 7/8 : ENTRYPOINT [ "/src/hello" ]
    ---> Using cache
    ---> 8dfb9d9d6010
    Step 8/8 : CMD []
    ---> Using cache
    ---> 446baf852214
    Successfully built 446baf852214
    Successfully tagged hello-apline:latest
    $ docker image ls
    REPOSITORY     TAG          IMAGE ID       CREATED       SIZE
    hello-alpine   latest       446baf852214   2 hours ago   6.55MB
    hello          latest       7cfa0cbe4e2a   2 hours ago   1.14GB
    demo           latest       079bae887a47   2 hours ago   125MB
    gcc            9.4          be1d0d9ce039   9 days ago    1.14GB
    $ docker run --rm -it hello-alpine docker
    hello docker
    $ docker run --rm -it hello-alpine world
    hello world
    $ docker run --rm -it hello-alpine friends
    hello friends
    $

可以看到这个镜像非常小，只有6.55MB


Go语言例子
-------------


Angular例子
---------------

