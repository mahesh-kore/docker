FROM registry.access.redhat.com/rhel7.3:latest


ENV AUTH yes

ENV MONGODB_ADMIN_USER admin
ENV MONGODB_ADMIN_PASS admin123123
ENV ARTIFACTORY_URL http://54.145.44.93:8040/artifactory/libs-release-local
ENV MONGODB_APPLICATION_USER koreapp
ENV MONGODB_APPLICATION_PASS koreapp123123

ENV REDIS_PASS rEdIs123
ENV RMQ_PASS RABbiTmQ

RUN useradd kore -u 1001 -g 0


RUN bash -c 'mkdir -p /data/mongo/db /var/lib/redis/6379 /etc/redis /opt/redis /var/run/redis'
COPY artifactory.txt /tmp/

EXPOSE 27017 27017
EXPOSE 6379 6379

RUN  cd /data && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/artifacts_stack.tar.gz && \
     tar xzf artifacts_stack.tar.gz && rm -rf artifacts_stack.tar.gz && \
     mv /data/artifacts/redis /data/ && mv /data/artifacts/dump /data/ && \
     chmod +x /data/artifacts/*.sh  && \
     mv /data/artifacts/kore.repo /etc/yum.repos.d/ && \
     mv /data/artifacts/startservices.sh /data/ && \
     mv /data/artifacts/run.sh /tmp/ && \
     cp /data/artifacts/mongo_unauth.conf /etc/mongo.conf && \
     ln -s /data/redis/bin/redis-cli /usr/local/bin/redis-cli && \
     echo "vm.overcommit_memory=1" >> /etc/sysctl.conf && \
     cp /data/artifacts/redis.conf /etc/redis.conf && \
     sed -i "s/kore123/'$REDIS_PASS'/g" /etc/redis.conf && \
     yum install -y net-tools make openssl* mongodb* glibc* rabbitmq-server erlang --disablerepo=* --enablerepo=kore && yum clean all -y && \
     ln -s /usr/lib/rabbitmq/bin /usr/lib/rabbitmq/sbin && \
     cp /data/artifacts/rabbitmq.config /etc/rabbitmq/rabbitmq.config && \
     sed -i "s/kore123/'$RMQ_PASS'/" /etc/rabbitmq/rabbitmq.config && \	
     rm -rf /data/artifacts &&  chmod -R g+rwxs /var /data && chmod -R o+rwx /var /data && touch /.mongorc.js && chmod 777 /.mongorc.js && \
    rm -rf /data/startservices.sh && cd /data/ && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/startservices.sh && chmod 777 /data/startservices.sh && cd /tmp/ && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/run.sh && chmod 777 run.sh
	
CMD ["/data/startservices.sh"]
