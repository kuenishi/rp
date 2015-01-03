FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -qq logrotate sudo curl wget
RUN apt-get install -qq postgresql postgresql-contrib

RUN apt-get install -qq software-properties-common
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -qq oracle-java8-installer oracle-java8-set-default

RUN java -version

RUN ls /sys/block/
RUN cat /sys/block/*/queue/scheduler

RUN mkdir -p /opt

## https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.89/presto-server-0.89.tar.gz
ADD presto-server-0.89.tar.gz /opt
RUN ls /opt
RUN mv /opt/presto-server-0.89 /opt/presto-server
RUN apt-get install -qq python

RUN ls /opt

## https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.89/presto-cli-0.89-executable.jar
COPY ./presto-cli-0.89-executable.jar /opt/presto-server/bin/presto-cli

RUN mkdir -p /opt/presto-server/etc/catalog
COPY ./config.properties /opt/presto-server/etc/config.properties
COPY ./jvm.config /opt/presto-server/etc/jvm.config
COPY ./log.properties /opt/presto-server/etc/log.properties
COPY ./node.properties /opt/presto-server/etc/node.properties
COPY ./postgresql.properties /opt/presto-server/etc/catalog/postgresql.properties

RUN chmod 755 /opt/presto-server/bin/presto-cli
RUN ls -l /opt/presto-server/bin
RUN /opt/presto-server/bin/presto-cli --help

## setup postgresql
RUN mkdir -p /opt/data
RUN chown postgres:postgres /opt/data
RUN sudo -u postgres /usr/lib/postgresql/9.3/bin/initdb /opt/data

# run these commands inside some other scripts
## RUN sudo -u postgres /usr/lib/postgresql/9.3/bin/postgres -i -h localhost -p 5432 -D /opt/data &
## RUN sudo -u postgres /usr/lib/postgresql/9.3/bin/pg_ctl start -o "-i -h localhost -p 5432" -D /opt/data
## RUN sleep 3
## RUN echo "create table a (x int);" | sudo -u postgres psql
## RUN echo "\d" | sudo -u postgres psql

## RUN /opt/presto-server/bin/launcher status
