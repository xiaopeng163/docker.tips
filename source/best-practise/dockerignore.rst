Dockerfile 技巧——合理使用 .dockerignore
==============================================


什么是Docker build context
------------------------------

Docker是client-server架构，理论上Client和Server可以不在一台机器上。

在构建docker镜像的时候，需要把所需要的文件由CLI（client）发给Server，这些文件实际上就是build context

举例：

.. code-block:: bash

    $ dockerfile-demo more Dockerfile
    FROM python:3.9.5-slim

    RUN pip install flask

    WORKDIR /src
    ENV FLASK_APP=app.py

    COPY app.py /src/app.py

    EXPOSE 5000

    CMD ["flask", "run", "-h", "0.0.0.0"]
    $ dockerfile-demo more app.py
    from flask import Flask

    app = Flask(__name__)


    @app.route('/')
    def hello_world():
        return 'Hello, world!'

构建的时候，第一行输出就是发送build context。11.13MB （这里是Linux环境下的log）

.. code-block:: bash

    $ docker image build -t demo .
    Sending build context to Docker daemon  11.13MB
    Step 1/7 : FROM python:3.9.5-slim
     ---> 609da079b03a
    Step 2/7 : RUN pip install flask
     ---> Using cache
     ---> 955ce495635e
    Step 3/7 : WORKDIR /src
     ---> Using cache
     ---> 1c2f968e9f9b
    Step 4/7 : ENV FLASK_APP=app.py
     ---> Using cache
     ---> dceb15b338cf
    Step 5/7 : COPY app.py /src/app.py
     ---> Using cache
     ---> 0d4dfef28b5f
    Step 6/7 : EXPOSE 5000
     ---> Using cache
     ---> 203e9865f0d9
    Step 7/7 : CMD ["flask", "run", "-h", "0.0.0.0"]
     ---> Using cache
     ---> 35b5efae1293
    Successfully built 35b5efae1293
    Successfully tagged demo:latest

``.`` 这个参数就是代表了build context所指向的目录


.dockerignore 文件
----------------------


.. code-block:: bash


    .vscode/
    env/


有了.dockerignore文件后，我们再build, build context就小了很多，4.096kB


.. code-block:: bash

    $ docker image build -t demo .
    Sending build context to Docker daemon  4.096kB
    Step 1/7 : FROM python:3.9.5-slim
    ---> 609da079b03a
    Step 2/7 : RUN pip install flask
    ---> Using cache
    ---> 955ce495635e
    Step 3/7 : WORKDIR /src
    ---> Using cache
    ---> 1c2f968e9f9b
    Step 4/7 : ENV FLASK_APP=app.py
    ---> Using cache
    ---> dceb15b338cf
    Step 5/7 : COPY . /src/
    ---> a9a8f888fef3
    Step 6/7 : EXPOSE 5000
    ---> Running in c71f34d32009
    Removing intermediate container c71f34d32009
    ---> fed6995d5a83
    Step 7/7 : CMD ["flask", "run", "-h", "0.0.0.0"]
    ---> Running in 7ea669f59d5e
    Removing intermediate container 7ea669f59d5e
    ---> 079bae887a47
    Successfully built 079bae887a47
    Successfully tagged demo:latest