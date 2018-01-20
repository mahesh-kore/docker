#korebot
FROM registry.access.redhat.com/rhel7.3:latest

LABEL name="korebot" \
      maintainer="pass-services@list.db.omc" \
      summary="KoreBot Platform" \
      description="korebot images for kore platform" \
      io.k8s.display-name="korebot" \
      io.k8s.description="korebot images for kore platform" \
      io.openshift.expose-services="80 3002 1024 6000 4000" \
      io.openshift.tags="korebot,clustere"

RUN useradd rabbitmq -u 1000170001

COPY artifactory.txt /tmp/

ENV ARTIFACTORY_URL http://54.145.44.93:8040/artifactory/libs-release-local

#Directories Creation
RUN mkdir /data/ && cd /data && curl --user `cat /tmp/artifactory.txt` -O $ARTIFACTORY_URL/artifacts_stack.tar.gz && \
    tar xzf artifacts_stack.tar.gz && rm -rf *.gz && \
    cp /data/artifacts/kore.repo /etc/yum.repos.d/ && \
    yum install erlang rabbitmq-server --disablerepo=* --enablerepo=kore -y && \
    chmod -R g+rwxs /usr/lib/rabbitmq /var && chmod -R o+rwx /usr/lib/rabbitmq /var && \
    rm -rf /data/artifacts

USER 1000170001
EXPOSE 5672 15672

CMD ["sh", "-c", "tail -f /dev/null"]
