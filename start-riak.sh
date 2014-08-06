#!/bin/sh

set -e

for i in `seq 1 5`; do
    riak/dev/dev$i/bin/riak start;
done

for i in `seq 2 5`; do
    riak/dev/dev$i/bin/riak-admin cluster join dev1@127.0.0.1;
done

riak/dev/dev1/bin/riak-admin cluster plan
riak/dev/dev1/bin/riak-admin cluster commit
