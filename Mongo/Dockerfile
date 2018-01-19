FROM registry.access.redhat.com/rhel7.3


ENV AUTH yes

ENV MONGODB_ADMIN_USER admin
ENV MONGODB_ADMIN_PASS admin123123

ENV MONGODB_APPLICATION_USER koreapp
ENV MONGODB_APPLICATION_PASS koreapp123123

ENV REDIS_PASS rEdIs123
ENV RMQ_PASS RABbiTmQ

RUN bash -c 'mkdir -p /data/mongo/db /var/lib/redis/6379 /etc/redis /opt/redis /var/run/redis'

EXPOSE 27017 27017
EXPOSE 6379 6379

RUN  cd /data && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/artifacts_stack.tar.gz && \
     tar xzf artifacts_stack.tar.gz && rm -rf artifacts_stack.tar.gz && \
     mv /data/artifacts/RPMS /tmp/ && mv /data/artifacts/redis /data/ && mv /data/artifacts/dump /data/ && \
     chmod +x /data/artifacts/*.sh  && \
     cp /data/artifacts/mongo_unauth.conf /etc/mongo.conf && \
     ln -s /data/redis/bin/redis-cli /usr/local/bin/redis-cli && \
     echo "vm.overcommit_memory=1" >> /etc/sysctl.conf && \
     cp /data/artifacts/redis.conf /etc/redis.conf && \
     sed -i "s/kore123/'$REDIS_PASS'/g" /etc/redis.conf && \
     yum install *.rpm -y && yum clean all -y && \
     ln -s /usr/lib/rabbitmq/bin /usr/lib/rabbitmq/sbin && \
     cp /tmp/rabbitmq.config /etc/rabbitmq/rabbitmq.config && \
     sed -i "s/kore123/'$RMQ_PASS'/" /etc/rabbitmq/rabbitmq.config && \	
	

CMD ["/tmp/startservices.sh"]
