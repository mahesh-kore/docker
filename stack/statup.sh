#!/bin/bash
/usr/sbin/rabbitmq-server &
rabbitmq-plugins enable rabbitmq_management
/sbin/rabbitmqctl add_vhost /
/sbin/rabbitmqctl add_vhost main
/sbin/rabbitmqctl add_vhost email
/sbin/rabbitmqctl add_vhost flows
rabbitmqctl add_user rabbitmq kore123
rabbitmqctl set_permissions -p / rabbitmq ".*" ".*" ".*"
rabbitmqctl set_permissions -p main rabbitmq ".*" ".*" ".*"
rabbitmqctl set_permissions -p email rabbitmq ".*" ".*" ".*"
rabbitmqctl set_permissions - flows rabbitmq ".*" ".*" ".*"
sh -c tail -f /dev/null
