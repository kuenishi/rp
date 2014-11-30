#!/bin/sh

set -e

mkdir -p /opt/presto-server/etc
cp -r /share/etc/* /opt/presto-server/etc/

/opt/presto-server/bin/launcher start
/opt/presto-server/bin/launcher status
riak start
riak ping

riak-admin bucket-type create test-schema
riak-admin bucket-type activate test-schema

riak-admin bucket-type create t
riak-admin bucket-type activate t

riak-admin bucket-type list

echo "/opt/presto-server/bin/presto-cli --catalog riak --schema t"

/opt/presto-server/bin/presto-cli --schema t --catalog riak --execute 'select * from logs;'
