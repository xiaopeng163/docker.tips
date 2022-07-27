Shell 格式和 Exec 格式
=======================

CMD和ENTRYPOINT同时支持shell格式和Exec格式。

Shell格式
--------------

.. code-block:: dockerfile

    CMD echo "hello docker"

.. code-block:: dockerfile

    ENTRYPOINT echo "hello docker"


Exec格式
-------------

以可执行命令的方式

.. code-block:: dockerfile

    ENTRYPOINT ["echo", "hello docker"]

.. code-block:: dockerfile

    CMD ["echo", "hello docker"]


注意shell脚本的问题

.. code-block:: dockerfile

    FROM ubuntu:20.04
    ENV NAME=docker
    CMD echo "hello $NAME"

假如我们要把上面的CMD改成Exec格式，下面这样改是不行的, 大家可以试试。

.. code-block:: dockerfile

    FROM ubuntu:20.04
    ENV NAME=docker
    CMD ["echo", "hello $NAME"]

它会打印出 ``hello $NAME`` , 而不是 ``hello docker`` ,那么需要怎么写呢？ 我们需要以shell脚本的方式去执行


.. code-block:: dockerfile

    FROM ubuntu:20.04
    ENV NAME=docker
    CMD ["sh", "-c", "echo hello $NAME"]
