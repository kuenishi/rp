#!/bin/sh

set -e

PRESTO_DIR=$1
NODE=$2
PORT=2008$NODE

echo $PRESTO_DIR
echo $NODE
echo $PORT

cp -r $PRESTO_DIR dev/dev$NODE
mkdir dev/dev$NODE/data
rm -rf dev/dev$NODE/lib dev/dev$NODE/plugin
ln -s ../../$PRESTO_DIR/lib dev/dev$NODE/lib
ln -s ../../$PRESTO_DIR/plugin dev/dev$NODE/plugin
cp -r etc dev/dev$NODE/

UUID=`uuidgen`
echo $UUID

sed -e "s/56c2e257-e534-4ee6-aa49-d2b5ac9e10bc/$UUID/" -i.back dev/dev$NODE/etc/node.properties
sed -e "s/rpc/rpc\/dev\/dev$NODE/" -i.back dev/dev$NODE/etc/node.properties

# if not node1:
if [ $NODE != 1 ]; then
  sed -e "s/coordinator=true/coordinator=false/" -i.back dev/dev$NODE/etc/config.properties
  sed -e "s/discovery-server.enabled=true//" -i.back dev/dev$NODE/etc/config.properties
fi

# all nodes:
sed -e "s/http-server.http.port=8080/http-server.http.port=$PORT/" -i.back dev/dev$NODE/etc/config.properties
sed -e "s/localhost:8080/localhost:20081/" -i.back dev/dev$NODE/etc/config.properties

RIAKPORT=100${NODE}7
sed -e "s/localhost:8087/localhost:$RIAKPORT/" -i.back dev/dev$NODE/etc/catalog/riak.properties
sed -e "s/riak@/dev$NODE@/" -i.back dev/dev$NODE/etc/catalog/riak.properties
sed -e "s/presto@/presto$NODE@/" -i.back dev/dev$NODE/etc/catalog/riak.properties
