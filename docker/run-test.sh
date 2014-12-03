#!/bin/sh

set -e

ls .

/share/start-all.sh

riak-admin wait-for-service riak_kv

## canary code with side effect
## curl -i http://localhost:8098/types/t/buckets/__presto_schema/keys/__schema
## curl -i -XPUT http://localhost:8098/types/t/buckets/b/keys/k -H 'Content-type: application/json' -d '[]'
## curl -i  http://localhost:8098/types/t/buckets/b/keys/k

echo "\ninstalling test data"
/share/testdata.py  || (tail /var/log/riak/console.log || exit 1)

CLI=/opt/presto-server/bin/presto-cli

ls /opt/presto-server/etc/
cat  /opt/presto-server/etc/config.properties

echo "runniung sql"
$CLI --catalog riak --schema t --execute 'show tables;'
$CLI --catalog riak --schema t --execute 'select * from logs;'
$CLI --catalog riak --schema t --execute 'select * from users;'
