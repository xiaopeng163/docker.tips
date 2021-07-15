镜像的导出和导入 (offline)
==========================

.. code-block:: bash

    PS C:\Users\Peng Xiao\docker.tips\image> docker image ls
    nginx        1.20.0    7ab27dbbfbdf   12 days ago   133MB
    nginx        latest    f0b8a9a54136   12 days ago   133MB
    PS C:\Users\Peng Xiao\docker.tips\image> docker image save nginx:1.20.0 -o nginx.image
    PS C:\Users\Peng Xiao\docker.tips\image> ls


        Directory: C:\Users\Peng Xiao\docker.tips\image


    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a----         5/24/2021   1:40 PM      137379328 nginx.image


    PS C:\Users\Peng Xiao\docker.tips\image> docker image rm 7ab
    Untagged: nginx:1.20.0
    Deleted: sha256:7ab27dbbfbdf4031f0603a4b597cc43031ff883b54f9329f0309c80952dda6f5
    Deleted: sha256:5b2a9404d052ae4205f6139190fd4b0921ddeff17bf2aaf4ee97f79e1a8242fe
    Deleted: sha256:03ebf76f0cbf5fd32ca010bb589c2139ce7e44c050fe3de2d77addf4cfd25866
    Deleted: sha256:0191669d087dce47072254a93fe55cbedd687f27d3798e2260f846e8f8f5729a
    Deleted: sha256:17651c6a0ba04d31da14ac6a86d8fb3f600883f9e155558e8aad0b94aa6540a2
    Deleted: sha256:5a673ff4c07a1b606f2ad1fc53697c99c45b0675734ca945e3bb2bd80f43feb8
    PS C:\Users\Peng Xiao\docker.tips\image> docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
    nginx        latest    f0b8a9a54136   12 days ago   133MB
    PS C:\Users\Peng Xiao\docker.tips\image> docker image load -i .\nginx.image
    1839f9962bd8: Loading layer [==================================================>]   64.8MB/64.8MB
    a2f4f809e04e: Loading layer [==================================================>]  3.072kB/3.072kB
    9b63e6289fbe: Loading layer [==================================================>]  4.096kB/4.096kB
    f7141923aaa3: Loading layer [==================================================>]  3.584kB/3.584kB
    272bc57d3405: Loading layer [==================================================>]  7.168kB/7.168kB
    Loaded image: nginx:1.20.0
    PS C:\Users\Peng Xiao\docker.tips\image> docker image ls
    REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
    nginx        1.20.0    7ab27dbbfbdf   12 days ago   133MB
    nginx        latest    f0b8a9a54136   12 days ago   133MB
    PS C:\Users\Peng Xiao\docker.tips\image>