FROM ubuntu:22.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y python3.10 python3-pip python3.10-dev
ADD hello.py /
CMD ["python3", "/hello.py"]
