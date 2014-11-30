FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -qq logrotate sudo curl wget

RUN echo "riak soft nofile    100000" >> /etc/security/limits.conf
RUN echo "riak hard nofile    100000" >> /etc/security/limits.conf
RUN tail /etc/security/limits.conf

RUN curl https://packagecloud.io/gpg.key | apt-key add -
RUN apt-get install -y apt-transport-https
RUN hostname -f

RUN echo "deb https://packagecloud.io/basho/riak/ubuntu/ precise main" >> /etc/apt/sources.list.d/basho.list
RUN echo "deb-src https://packagecloud.io/basho/riak/ubuntu/ precise main" >> /etc/apt/sources.list.d/basho.list

RUN apt-get update
RUN apt-get install -qq openjdk-7-jre
RUN apt-get install -qq  riak

RUN sed -e 's/search = off/search = on/' -i.back /etc/riak/riak.conf
RUN sed -e 's/storage_backend = bitcask/storage_backend = leveldb/' -i.back /etc/riak/riak.conf
COPY ./ldna.beam /usr/lib/riak/lib/basho-patches/ldna.beam

RUN ls /sys/block/
RUN cat /sys/block/*/queue/scheduler

RUN mkdir -p /opt

ADD presto-server-0.85.tar.gz /opt
RUN ls /opt
RUN mv /opt/presto-server-0.85 /opt/presto-server

RUN ls /opt
RUN mkdir -p /opt/presto-server/plugin/presto-riak
COPY ./presto-riak-0.0.5-SNAPSHOT.jar /opt/presto-server/plugin/presto-riak/presto-riak-0.0.5-SNAPSHOT.jar
RUN ls /opt/presto-server/plugin/presto-riak

COPY ./presto-cli-0.85-executable.jar /opt/presto-server/bin/presto-cli

RUN mkdir -p /opt/presto-server/etc/
COPY ./etc/config.properties /opt/presto-server/etc/config.properties
