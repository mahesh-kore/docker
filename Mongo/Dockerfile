FROM registry.access.redhat.com/rhel7.3


ENV AUTH yes

ENV MONGODB_ADMIN_USER admin
ENV MONGODB_ADMIN_PASS admin123123
ENV ARTIFACTORY_URL http://54.145.44.93:8040/artifactory/libs-release-local
ENV MONGODB_APPLICATION_USER koreapp
ENV MONGODB_APPLICATION_PASS koreapp123123

ENV REDIS_PASS rEdIs123
ENV RMQ_PASS RABbiTmQ

RUN bash -c 'mkdir -p /data/mongo/db /var/lib/redis/6379 /etc/redis /opt/redis /var/run/redis'
COPY artifactory.txt /tmp/

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
     cd /tmp/RPMS && rpm -ivh make-3.82-23.el7.x86_64.rpm openssl-1.0.2k-8.el7.x86_64.rpm mongodb-org-3.0.15-1.el7.x86_64.rpm mongodb-org-mongos-3.0.15-1.el7.x86_64.rpm mongodb-org-server-3.0.15-1.el7.x86_64.rpm mongodb-org-shell-3.0.15-1.el7.x86_64.rpm mongodb-org-mongos-3.0.15-1.el7.x86_64.rpm mongodb-org-tools-3.0.15-1.el7.x86_64.rpm glibc-common-2.17-196.el7_4.2.x86_64.rpm glibc-2.17-196.el7_4.2.x86_64.rpm libmnl-1.0.3-7.el7.x86_64.rpm libnfnetlink-1.0.1-4.el7.x86_64.rpm libnetfilter_conntrack-1.0.6-1.el7_3.x86_64.rpm libnfnetlink-1.0.1-4.el7.x86_64 logrotate-3.8.6-14.el7.x86_64.rpm nss-softokn-freebl-3.28.3-8.el7_4.i686.rpm openssl-1.0.2k-8.el7.x86_64.rpm rabbitmq-server-3.5.3-1.noarch.rpm sysvinit-tools-2.88-14.dsf.el7.x86_64.rpm glibc-2.17-196.el7_4.2.x86_64.rpm glibc-common-2.17-196.el7_4.2.x86_64.rpm && \ 
     ln -s /usr/lib/rabbitmq/bin /usr/lib/rabbitmq/sbin && \
     cp /tmp/rabbitmq.config /etc/rabbitmq/rabbitmq.config && \
     sed -i "s/kore123/'$RMQ_PASS'/" /etc/rabbitmq/rabbitmq.config && \	
     rm -rf /data/artifacts/RPMS 
	

CMD ["/tmp/startservices.sh"]
