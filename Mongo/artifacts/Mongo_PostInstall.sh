#!/bin/bash

# Admin User
MONGODB_ADMIN_USER=${MONGODB_ADMIN_USER:-"admin"}
MONGODB_ADMIN_PASS=${MONGODB_ADMIN_PASS:-"4dmInP4ssw0rd"}

# Application Database User
MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE:-"admin"}
MONGODB_APPLICATION_USER=${MONGODB_APPLICATION_USER:-"restapiuser"}
MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_PASS:-"r3sT4pIp4ssw0rd"}


mongodb_cmd=" /usr/bin/mongod -f /etc/mongod.conf"


  ulimit -f unlimited
  ulimit -t unlimited
  ulimit -v unlimited
  ulimit -n 64000
  ulimit -m unlimited
  ulimit -u 64000

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done


echo "=> Creating admin user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$MONGODB_ADMIN_USER', pwd: '$MONGODB_ADMIN_PASS', roles:[{role:'root',db:'admin'}]});"

sleep 3


echo "=> Creating a ${MONGODB_APPLICATION_DATABASE} database user with a password in MongoDB"
	mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS << EOF
	use $MONGODB_APPLICATION_DATABASE
	db.createUser({user: '$MONGODB_APPLICATION_USER', pwd: '$MONGODB_APPLICATION_PASS', roles:[{role:'read', db:'$MONGODB_APPLICATION_DATABASE'},{ role: "readWriteAnyDatabase", db: "admin" }]})
EOF


sleep 2 

touch /data/mongo/.mongodb_password_set

/usr/bin/mongorestore --username $MONGODB_ADMIN_USER --password $MONGODB_ADMIN_PASS /data/dump/ --authenticationDatabase admin

kill_mongodb=`ps -ef |grep "mongod --auth "|grep -v grep|awk '{print $2}'|xargs kill -9`

$kill_mongodb

sleep 4

echo "MongoDB configured successfully. You may now connect to the DB."

