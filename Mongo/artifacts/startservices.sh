#!/bin/bash

sh /tmp/run.sh


/usr/sbin/rabbitmq-server &


rabbitmq-plugins enable rabbitmq_management

/sbin/rabbitmqctl add_vhost /
/sbin/rabbitmqctl add_vhost main
/sbin/rabbitmqctl add_vhost email
/sbin/rabbitmqctl add_vhost flows

rabbitmqctl set_permissions -p / ".*" ".*" ".*"
rabbitmqctl set_permissions -p main ".*" ".*" ".*"
rabbitmqctl set_permissions -p email ".*" ".*" ".*"
rabbitmqctl set_permissions - flows ".*" ".*" ".*"



/data/redis/bin/redis-server /etc/redis.conf &

mongod --auth --dbpath /data/mongo/db



