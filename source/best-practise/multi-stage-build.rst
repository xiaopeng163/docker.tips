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

    $ docker build -t hello-alpine -f Dockerfile-new .
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
    Successfully tagged hello-alpine:latest
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


同样的，假如有一个Go的程序，我们想用Docker去做编译，然后执行可执行文件。

.. code-block:: golang

    package main

    import (
        "log"
        "net/http"
    )

    func test(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("Hello golang"))
    }

    func main() {
        log.SetFlags(log.LstdFlags | log.Lshortfile)
        log.Println("start server on [localhost:8080] ...")
        http.HandleFunc("/", test)
        err := http.ListenAndServe(":8080", nil)
        if err != nil {
            log.Fatal(err)
        }
    }



本地测试（如果你本地有Golang环境）

.. code-block:: bash

    $ go build 
    $ ls
    app  df  dockerfile  go.mod  main.go
    $ ./app 
    2023/02/15 02:28:18 main.go:14: start server on [localhost:8080] ...

另一个终端

.. code-block:: bash

    $ curl localhost:8080
    Hello golang                                              


构建一个Docker镜像，因为要有Go的环境，所以我们选择golang这个image

.. code-block:: Dockerfile

    FROM golang:alpine3.17 AS builder

    COPY main.go /src/app.go
    
    WORKDIR /src

    RUN go build app.go

    EXPOSE 8080

    ENTRYPOINT [ "/src/app" ]


build和测试

.. code-block:: bash

    $ docker build -t hello-go .
    Sending build context to Docker daemon  6.512MB
    Step 1/6 : FROM golang:alpine3.17 AS builder
    ---> 3257bc8ee9f7
    Step 2/6 : COPY main.go /src/app.go
    ---> b0156e003e2d
    Step 3/6 : WORKDIR /src
    ---> Running in 7976422fe214
    Removing intermediate container 7976422fe214
    ---> 122042396c76
    Step 4/6 : RUN go build app.go
    ---> Running in f321f6a73147
    Removing intermediate container f321f6a73147
    ---> 21236778ceee
    Step 5/6 : EXPOSE 8080
    ---> Running in d47b6e2fb836
    Removing intermediate container d47b6e2fb836
    ---> 133988261356
    Step 6/6 : ENTRYPOINT [ "/src/app" ]
    ---> Running in 7f19bd8952b4
    Removing intermediate container 7f19bd8952b4
    ---> 2ccb4f220a22
    Successfully built 2ccb4f220a22
    Successfully tagged hello-go:latest
    $ docker image ls
    REPOSITORY                                                           TAG                 IMAGE ID            CREATED             SIZE
    hello-go                                                             latest              2ccb4f220a22        19 minutes ago      321MB
    golang                                                               alpine3.17          3257bc8ee9f7        3 days ago          254MB
    $ docker run -p 8080:8080 -it hello-go
    2023/02/14 18:16:11 app.go:14: start server on [localhost:8080] ...

.. code-block:: bash

    $ curl localhost:8080
    Hello golang


可以看到镜像也很大，321MB，同样的，我们使用多阶段构建。


.. code-block:: Dockerfile

    FROM golang:alpine3.17 AS builder

    COPY main.go /src/app.go

    WORKDIR /src

    RUN go build app.go

    FROM alpine:3.17.0

    COPY --from=builder /src/app /src/app

    EXPOSE 8080

    ENTRYPOINT [ "/src/app" ]
    

测试

.. code-block:: bash
    $ docker build -t hello-go-alpine -f ./df .
    Sending build context to Docker daemon  6.512MB
    Step 1/8 : FROM golang:alpine3.17 AS builder
    ---> 3257bc8ee9f7
    Step 2/8 : COPY main.go /src/app.go
    ---> 167672dc57ce
    Step 3/8 : WORKDIR /src
    ---> Running in a53f0f84c92d
    Removing intermediate container a53f0f84c92d
    ---> cc8ee771cdbd
    Step 4/8 : RUN go build app.go
    ---> Running in 9e8e575af675
    Removing intermediate container 9e8e575af675
    ---> e8e7c7219cd5
    Step 5/8 : FROM alpine:3.17.0
    3.17.0: Pulling from library/alpine
    c158987b0551: Pull complete 
    Digest: sha256:8914eb54f968791faf6a8638949e480fef81e697984fba772b3976835194c6d4
    Status: Downloaded newer image for alpine:3.17.0
    ---> 49176f190c7e
    Step 6/8 : COPY --from=builder /src/app /src/app
    ---> 8121bedd9a21
    Step 7/8 : EXPOSE 8080
    ---> Running in 93a02551712d
    Removing intermediate container 93a02551712d
    ---> e91f0c467511
    Step 8/8 : ENTRYPOINT [ "/src/app" ]
    ---> Running in aef94175c85d
    Removing intermediate container aef94175c85d
    ---> f3ee197cba4f
    Successfully built f3ee197cba4f
    Successfully tagged hello-go-alpine:latest
    $ docker image ls
    REPOSITORY                                                           TAG                 IMAGE ID            CREATED             SIZE
    hello-go-alpine                                                      latest              f3ee197cba4f        31 seconds ago      13.6MB
    <none>                                                               <none>              e8e7c7219cd5        46 seconds ago      321MB
    hello-go                                                             latest              2ccb4f220a22        24 minutes ago      321MB
    golang                                                               alpine3.17          3257bc8ee9f7        3 days ago          254MB
    $ docker run --rm -p 8080:8080 -it hello-go-alpine
    2023/02/14 18:42:29 app.go:14: start server on [localhost:8080] ...
现在镜像只有13.6MB

.. code-block:: bash

    $ curl localhost:8080
    Hello golang


Angular例子
---------------

