#!/bin/sh

set -e

/opt/presto-server/bin/launcher status
riak ping
/opt/presto-server/bin/presto-cli --schema t --catalog riak --execute 'select * from logs;'
