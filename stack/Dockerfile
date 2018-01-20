#korebot
FROM registry.access.redhat.com/rhel7.3:latest

ENV MONGODB_ADMIN_USER admin
ENV MONGODB_ADMIN_PASS admin123
ENV MONGODB_APPLICATION_USER kore
ENV MONGODB_APPLICATION_PASS kore123
ENV REDIS_PASS kore123
ENV ARTIFACTORY_URL http://54.145.44.93:8040/artifactory/libs-release-local

LABEL name="korebot" \
      maintainer="pass-services@list.db.omc" \
      summary="KoreBot Platform" \
      description="korebot images for kore platform" \
      io.k8s.display-name="korebot" \
      io.k8s.description="korebot images for kore platform" \
      io.openshift.expose-services="80 3002 1024 6000 4000" \
      io.openshift.tags="korebot,clustere"

RUN useradd -l -u 1000300044 -g 0 rabbitmq

COPY artifactory.txt /tmp/

#Directories Creation
RUN mkdir -p /data/mongo/db /var/lib/redis/6379 /etc/redis /opt/redis /var/run/redis && \
    cd /data && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/artifacts_stack.tar.gz && \
    tar xzf artifacts_stack.tar.gz && rm -rf *.gz && \
    mv /data/artifacts/redis /data && ln -s /data/redis/bin/redis-cli /usr/local/bin/redis-cli && \
    cp /data/artifacts/kore.repo /etc/yum.repos.d/ && \
    yum install net-tools mongodb* erlang rabbitmq-server --disablerepo=* --enablerepo=kore -y && yum clean all -y && \
    cp /data/artifacts/mongo_unauth.conf /etc/mongo.conf && \
    echo "vm.overcommit_memory=1" >> /etc/sysctl.conf && \
    cp /data/artifacts/redis.conf /etc/redis.conf && \
    sed -i "s/kore123/'$REDIS_PASS'/g" /etc/redis.conf && \
    ln -s /usr/lib/rabbitmq/bin /usr/lib/rabbitmq/sbin && \
    cp /data/artifacts/rabbitmq.config /etc/rabbitmq/rabbitmq.config && \
    sed -i "s/kore123/'$RMQ_PASS'/" /etc/rabbitmq/rabbitmq.config && \
    chmod -R g+rwxs /usr/lib/rabbitmq /var/run /run /etc /var/lib/rabbitmq  && chmod -R o+rwx /etc /usr/lib/rabbitmq /var/run /run /var/lib/rabbitmq && \
    rm -rf /data/artifact* && usermod -d /var/lib/rabbitmq rabbitmq && cd /data/ && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/run.sh && chmod 777 /data/run.sh

USER 1000300044
EXPOSE 5672 15672 27017 6379

CMD ["sh", "-c", "tail -f /dev/null"]
