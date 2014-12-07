#!/bin/sh

P=`pwd`
echo "pwd: ${P}"

ls dev

for i in `ls dev`; do
    cd dev/$i;
    echo "dev$i: "
    bin/launcher $1;
    cd ${P}
    echo "---"
done
