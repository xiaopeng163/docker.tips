FROM python:3.9.5-slim

COPY ./ /app

WORKDIR /app

RUN pip install -r requirements.txt && \
    apt-get update && apt-get install -y build-essential && \
    make html
