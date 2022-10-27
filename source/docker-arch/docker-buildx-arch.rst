使用 buildx 构建多架构镜像另外一个例子
==========================================

1. 创建一个新的 builder
---------------------------

.. code-block:: bash
    
    docker login
    docker buildx create --name mybuilder

2. 准备好Dockerfile
-----------------------

其中 ``TARGETARCH`` 这个参数会随着buildx的不同platform自动变化。然后会根据不同的platform下载不同二进制文件terraform。

类似  https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope 还有其他的一些自动变量可以参考链接。

.. note::

   关于 ``ARG`` 和 ``ENV`` 的区别和用法，请参考 https://dockertips.readthedocs.io/en/latest/dockerfile-guide/env_vs_arg.html
   
.. code-block:: dockerfile

    FROM alpine:3.16

    ARG TARGETARCH=amd64 TERRAFORM_VERSION="1.2.9"

    RUN apk update && apk add --no-cache curl

    RUN curl \
        --location \
        --output /tmp/terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip \
        && unzip /tmp/terraform.zip -d /usr/local/bin \
        && rm -rf /tmp/terraform.zip

    CMD []

3. 构建镜像
------------------

.. code-block:: bash

    $ docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t xiaopeng163/terraform:1.2.9 .
    [+] Building 27.9s (13/13) FINISHED
    => [internal] load build definition from Dockerfile                                                                                                                                                                          0.0s
    => => transferring dockerfile: 460B                                                                                                                                                                                          0.0s
    => [internal] load .dockerignore                                                                                                                                                                                             0.0s
    => => transferring context: 2B                                                                                                                                                                                               0.0s
    => [linux/arm64 internal] load metadata for docker.io/library/alpine:3.16                                                                                                                                                    1.2s
    => [linux/amd64 internal] load metadata for docker.io/library/alpine:3.16                                                                                                                                                    1.1s
    => [auth] library/alpine:pull token for registry-1.docker.io                                                                                                                                                                 0.0s
    => [linux/arm64 1/3] FROM docker.io/library/alpine:3.16@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad                                                                                              0.0s
    => => resolve docker.io/library/alpine:3.16@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad                                                                                                          0.0s
    => [linux/amd64 1/3] FROM docker.io/library/alpine:3.16@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad                                                                                              0.0s
    => => resolve docker.io/library/alpine:3.16@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad                                                                                                          0.0s
    => CACHED [linux/arm64 2/3] RUN apk update && apk add --no-cache curl                                                                                                                                                        0.0s
    => CACHED [linux/arm64 3/3] RUN curl     --location     --output /tmp/terraform.zip     https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_arm64.zip     && unzip /tmp/terraform.zip -d /usr/local/bin     0.0s
    => CACHED [linux/amd64 2/3] RUN apk update && apk add --no-cache curl                                                                                                                                                        0.0s
    => CACHED [linux/amd64 3/3] RUN curl     --location     --output /tmp/terraform.zip     https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_amd64.zip     && unzip /tmp/terraform.zip -d /usr/local/bin     0.0s
    => exporting to image                                                                                                                                                                                                       26.6s
    => => exporting layers                                                                                                                                                                                                       0.0s
    => => exporting manifest sha256:14704a82f6f432f13057d06401c8bf704b85458e8531d2dda616774bbec27cce                                                                                                                             0.0s
    => => exporting config sha256:0592e737952d4a1bba5572696eee64f8aaa372127363f413c06641dfa099dac8                                                                                                                               0.0s
    => => exporting manifest sha256:469a68b5e84746d1415c931378d6078a54f5aabdedad599da281f4743bc1d504                                                                                                                             0.0s
    => => exporting config sha256:0b1fcf8214c11d7f696bce23d9800fed508e0526da7db0c640c079eb171a2b3b                                                                                                                               0.0s
    => => exporting manifest list sha256:f137daace77c8b787d8a5cbf6b201605b62ac4b7455a56c38d5146a3fe7d55d0                                                                                                                        0.0s
    => => pushing layers                                                                                                                                                                                                        25.4s
    => => pushing manifest for docker.io/xiaopeng163/terraform:1.2.9@sha256:f137daace77c8b787d8a5cbf6b201605b62ac4b7455a56c38d5146a3fe7d55d0                                                                                     1.2s
    => [auth] xiaopeng163/terraform:pull,push token for registry-1.docker.io                                                                                                                                                     0.0s
