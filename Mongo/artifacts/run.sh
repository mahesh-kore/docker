#!/bin/bash
set -m

mongodb_cmd=" /usr/bin/mongod"
cmd="$mongodb_cmd"

if [ "$AUTH" == "yes" ]; then
    cmd="$cmd --auth --dbpath /data/mongo/db "
fi

$cmd &

if [ ! -f /data/mongo/.mongodb_password_set ]; then
    /tmp/Mongo_PostInstall.sh
fi

