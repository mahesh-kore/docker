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

ADD artifacts/RPMS.tar.gz /tmp/
ADD artifacts/redis.tar.gz /data/
ADD artifacts/dump.tar.gz /data/

COPY ["artifacts/mongo.repo", "artifacts/mongo_unauth.conf", "artifacts/mongo_Auth.conf", "artifacts/Mongo_PostInstall.sh", "artifacts/run.sh", "artifacts/startservices.sh", "artifacts/redis.conf","artifacts/rabbitmq.config", "/tmp/"]
RUN mv /tmp/mongo.repo /etc/yum.repos.d/ && \ 
	yum install -y /tmp/RPMS/mongodb-org* /tmp/RPMS/openssl* /tmp/RPMS/make* && yum clean all -y && \
	chmod +x /tmp/*.sh  && \
	cp /tmp/mongo_unauth.conf /etc/mongo.conf && \
	ln -s /data/redis/bin/redis-cli /usr/local/bin/redis-cli && \
	echo "vm.overcommit_memory=1" >> /etc/sysctl.conf && \
	cp /tmp/redis.conf /etc/redis.conf && \
	sed -i "s/kore123/'$REDIS_PASS'/g" /etc/redis.conf && \
	yum install /tmp/RPMS/rabbitmq-server-3.5.3-1.noarch.rpm /tmp/RPMS/erlang-18.3.4-5.el7.centos.x86_64.rpm -y && yum clean all -y && \
	ln -s /usr/lib/rabbitmq/bin /usr/lib/rabbitmq/sbin && \
	cp /tmp/rabbitmq.config /etc/rabbitmq/rabbitmq.config && \
	sed -i "s/kore123/'$RMQ_PASS'/" /etc/rabbitmq/rabbitmq.config && \	
	

CMD ["/tmp/startservices.sh"]
