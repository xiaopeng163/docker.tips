文件复制和目录操作 (ADD,COPY,WORKDIR)
=====================================

往镜像里复制文件有两种方式，``COPY`` 和 ``ADD`` , 我们来看一下两者的不同。


复制普通文件
-----------------


``COPY`` 和 ``ADD`` 都可以把local的一个文件复制到镜像里，如果目标目录不存在，则会自动创建

.. code-block:: dockerfile

    FROM python:3.9.5-alpine3.13
    COPY hello.py /app/hello.py

比如把本地的 hello.py 复制到 /app 目录下。 /app这个folder不存在，则会自动创建


复制压缩文件
----------------

``ADD`` 比 COPY高级一点的地方就是，如果复制的是一个gzip等压缩文件时，ADD会帮助我们自动去解压缩文件。


.. code-block:: dockerfile

    FROM python:3.9.5-alpine3.13
    ADD hello.tar.gz /app/


如何选择
--------------

因此在 COPY 和 ADD 指令中选择的时候，可以遵循这样的原则，所有的文件复制均使用 COPY 指令，仅在需要自动解压缩的场合使用 ADD。
