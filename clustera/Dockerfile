#korebot
FROM registry.access.redhat.com/rhel:7.3

LABEL name="korebot" \
      maintainer="pass-services@list.db.omc" \
      summary="KoreBot Platform" \
      description="korebot images for kore platform" \
      io.k8s.display-name="korebot" \
      io.k8s.description="korebot images for kore platform" \
      io.openshift.expose-services="80 3002 1024 6000 4000" \
      io.openshift.tags="korebot,clustera"

RUN useradd kore -u 1001

ENV KOREBOT_RELEASE release6.0.5

ENV KOREBOT_ENV dev

ENV ARTIFACTORY_URL http://54.145.44.93:8040/artifactory/libs-release-local

#Directories Creation
RUN bash -c 'mkdir -pv /data/{ChatScript,LOGS,USERS,kore,mongoc} \
                       /data/kore/{deployment,mongo_scripts,tmp,CS,postinstallation} \
                       /data/www/tmp \
                       /.forever/pids \
                       /data/java \
                       /data/kore/deployment/{logs,downloads} \
                       /data/kore/deployment/downloads/{builder,DesktopWeb,EntAdmin,KoreServer,KoreWebPortal,MarketPlace,WorkFlows,ChatScript,FAQ,MachineLearning}'


COPY artifactory.txt /tmp/
COPY configs.tar.gz /tmp/

RUN cd /data && curl -LH "X-JFrog-Art-API: `cat /tmp/artifactory.txt`" -O $ARTIFACTORY_URL/artifacts.tar.gz && \
    tar xzf artifacts.tar.gz && rm -rf artifacts.tar.gz  && \
    mv /data/artifacts/build_files/kore.repo /etc/yum.repos.d/ && \
    curl -LH "X-JFrog-Art-API: `cat /tmp/artifactory.txt`" -O $ARTIFACTORY_URL/kore-repo-redhat7.tar.gz && \
    tar xzf kore-repo-redhat7.tar.gz && rm -rf kore-repo-redhat7.tar.gz && \
    mv /data/artifacts/startup.sh /data/ &&  \
    mv /data/artifacts/mongoc.tar.gz /data/ && tar xzf mongoc.tar.gz && rm -rf mongoc.tar.gz && \
    mv /data/artifacts/chatscriptmongo.conf /etc/ld.so.conf.d/chatscriptmongo.conf && echo "/data/java/jdk1.8.0_131//lib/amd64/jli/" >> /etc/ld.so.conf.d/chatscriptmongo.conf && ldconfig && \
    mv /data/artifacts/nvm.tar.gz /usr/local/ && cd /usr/local/ && tar xzf nvm.tar.gz && rm -rf nvm.tar.gz && \
    ln -sf /usr/local/nvm/v0.10.35/bin/node /usr/bin/node && \
    mv /data/artifacts/build_files/checkforbuild.sh /data/kore/deployment/ && \
    mv /data/artifacts/build_files/initdscripts.tar.gz /etc/init.d/ && cd /etc/init.d/ && tar xzf initdscripts.tar.gz && rm -rf initdscripts.tar.gz && \
    ln -sf /data/www /var/ && \
    chmod -R 777 /data/kore/deployment && \
    ulimit -n 64000 && \
    yum install -y unzip logstash net-tools telnet wget libjpeg-turbo-official-1.3.0 lcms-libs-1.19-2.2 libwmf-lite-0.2.8.4-22 libGraphicsMagick3-1.3.18_Q16-6 libGraphicsMagickWand2-1.3.18_Q16-6 GraphicsMagick-1.3.18_Q16-6 nginx --disablerepo=* --enablerepo=kore && yum clean all -y && \
    chown -R 1001:root /var/cache/nginx/  /var/log/nginx/ /var/run/ && chmod -R g+rwx /var/cache/nginx/  /var/log/nginx/ /etc/logstash/ && chmod -R 777 /etc/logstash/ /.forever && \
    rm -rf /data/kore-repo-redhat7 /etc/yum.repos.d/kore.repo /data/artifacts && \
    chown -R 1001:root /data /var /run && \
    chmod -R g+rwxs /data/kore/deployment /data /var/ /run /.forever && chmod -R o+rwx /data/ && \
    cd /data && curl -LH "X-JFrog-Art-API: `cat /tmp/artifactory.txt`" -O $ARTIFACTORY_URL/releases.tar.gz && \
    tar xzf releases.tar.gz && rm -rf releases.tar.gz && \
    mv /data/releases/$KOREBOT_RELEASE.tar.gz /data/ && cd /data/ && tar xvzf $KOREBOT_RELEASE.tar.gz && \
    rm -rf $KOREBOT_RELEASE.tar.gz && \
    /data/kore/deployment/checkforbuild.sh KoreServer $KOREBOT_RELEASE && \
    /data/kore/deployment/checkforbuild.sh builder $KOREBOT_RELEASE && \
    /data/kore/deployment/checkforbuild.sh EntAdmin $KOREBOT_RELEASE && \
    /data/kore/deployment/checkforbuild.sh WorkFlows $KOREBOT_RELEASE && \
    /data/kore/deployment/checkforbuild.sh MarketPlace $KOREBOT_RELEASE &&  \
    /data/kore/deployment/checkforbuild.sh ChatScript $KOREBOT_RELEASE && \
    ln -s /data/LOGS /data/ChatScript/LOGS && mkdir -p /var/www/logs && \
    mv /data/artifacts/integrations.conf /var/www/KoreServer/config/nginx/integrations.conf && mv /data/artifacts/static.conf /var/www/KoreServer/config/nginx/static.conf && \
    /bin/echo "daemon off;" >> /var/www/KoreServer/config/nginx/integrations.conf && \
    /bin/sed -i 's/80/9090/' /var/www/KoreServer/config/nginx/common/resourceresolver_server.conf && \
    /bin/sed -i 's/localhost/localhost:9090/' /var/www/KoreServer/ResourceResolver/index.js && \
    /bin/sed -i 's/localhost/localhost:9090/' /var/www/KoreServer/ResourceResolver/server.js && \
    mv /tmp/configs.tar.gz /data/artifacts/ && \
    cd /data/artifacts/ && tar xzf configs.tar.gz && rm -rf configs.tar.gz && \
    cp /data/artifacts/configs/$KOREBOT_ENV/KoreConfig.json /var/www/KoreServer/config/ && \
    cp /data/artifacts/configs/$KOREBOT_ENV/keyserver.json /var/www/KoreServer/config && \
    cp /data/artifacts/configs/$KOREBOT_ENV/cs_init_OnPrem.txt /data/kore/CS/ && \
    cp /data/artifacts/configs/$KOREBOT_ENV/logstash-shipper.conf /etc/logstash/conf.d/ && \
    chmod -R g+rwxs /var /data && chmod -R o+rwx /var /data

USER 1001

EXPOSE 9090 9443 3002 6000 4000 1024 1099

CMD ["/data/startup.sh", "start", "clustera"]
