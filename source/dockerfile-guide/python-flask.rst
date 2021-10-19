一起构建一个 Python Flask 镜像
================================


Python 程序

.. code-block:: python

    from flask import Flask

    app = Flask(__name__)


    @app.route('/')
    def hello_world():
        return 'Hello, World!'

Dockerfile

.. code-block:: dockerfile

    FROM python:3.9.5-slim

    COPY app.py /src/app.py

    RUN pip install flask

    WORKDIR /src
    ENV FLASK_APP=app.py

    EXPOSE 5000

    CMD ["flask", "run", "-h", "0.0.0.0"]