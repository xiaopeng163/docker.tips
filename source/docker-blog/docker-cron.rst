通过 Docker container 执行计划任务
====================================

``crontab`` 大家应该都比较熟悉了，Linux计划任务，再加上一门脚本shell或者python，可以灵活的实现多种计划任务。

如何通过docker container去执行计划任务呢，其实办法挺多的：

- 比如执行通过宿主机的crontab去docker run --rm xxxxxxxxxxxx, 定期执行然后清理
- 比如 直接在container里安装cron，然后安装传统的方式去编辑crontab

但是直接用cron的话，log是一个问题。使用容器的最佳实践之一就是，要把app的log转到stdout，stderr里，不要写到syslog文件里。cron默认是syslog的，所以你还需要做一些额外的重定向工作。

直到最近发现了一个工具supercronic：https://github.com/aptible/supercronic/ 这个专为容器而生的计划任务工具。

用起来很简单，这里给大家一个非常简单的小例子。

.. code-block:: dockerfile

    FROM alpine:latest
    RUN apk update
    RUN apk --no-cache add curl
    ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
        SUPERCRONIC=supercronic-linux-amd64 \
        SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e
    RUN curl -fsSLO "$SUPERCRONIC_URL" \
        && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
        && chmod +x "$SUPERCRONIC" \
        && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
        && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
    COPY my-cron /app/my-cron
    # RUN cron job
    CMD ["/usr/local/bin/supercronic", "/app/my-cron"]


使用的my-cron就是一个crontab格式的计划任务，比如, 每隔一分钟输出时间到一个文件里

.. code-block:: bash

    $ more my-cron
    */1 * * * * date >> /app/test.txt


这里给大家推荐一个写crontab规则的网站https://crontab.guru


就是这样简单，如果想执行python的话，可以换个base image，根据自己的需求灵活改变，创建自己的dockers image。

