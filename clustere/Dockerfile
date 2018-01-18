#korebot
FROM java-base-j8:latest

LABEL name="korebot" \
      maintainer="pass-services@list.db.omc" \
      summary="KoreBot Platform" \
      description="korebot images for kore platform" \
      io.k8s.display-name="korebot" \
      io.k8s.description="korebot images for kore platform" \
      io.openshift.expose-services="80 3002 1024 6000 4000" \
      io.openshift.tags="korebot,clustere"

RUN useradd kore -u 1001

ENV KOREBOT_RELEASE

ENV KOREBOT_ENV

ENV ARTIFACTORY_URL

#Directories Creation
RUN bash -c 'mkdir -pv /data/kore/{deployment,mongo_scripts,tmp,CS,postinstallation} \
                       /data/kore/deployment/{logs,downloads} \
                       /data/kore/deployment/downloads/{FAQ,MachineLearning} \
                       /data/{py2.7,py3.5,MachineLearning,ml-share,faq-graph} \
                       /data/faq-graph/BotGraph \
                       /data/java \
                       /var/www \
                       /data/www/tmp'

COPY artifactory.txt /tmp/

COPY configs.tar.gz /tmp/

RUN cd /data && curl -LH "X-JFrog-Art-API: `cat /tmp/artifactory.txt`" -O $ARTIFACTORY_URL/artifacts.tar.gz && \
    tar xzf artifacts.tar.gz && rm -rf artifacts.tar.gz  && \
    mv /data/artifacts/kore.repo /etc/yum.repos.d/ && \
    mv /data/artifacts/chatscriptmongo.conf /etc/ld.so.conf.d/chatscriptmongo.conf && echo "/data/java/jdk1.8.0_131/lib/amd64/jli/" >> /etc/ld.so.conf.d/chatscriptmongo.conf && ldconfig && \
    mv /data/artifacts/build_files/startup.sh /data/ &&  \
    useradd kore -u 1001 && \
    ulimit -n 64000 && \
    cd /data/ && curl -LH "X-JFrog-Art-API: `cat /tmp/artifactory.txt`" -O $ARTIFACTORY_URL/kore-repo-redhat7.tar.gz && \
    tar xzf kore-repo-redhat7.tar.gz && rm -rf kore-repo-redhat7.tar.gz && \
    mv /data/artifacts/titan-1.0.0-hadoop1.tar.gz /data/ && cd /data/ && tar xzf titan-1.0.0-hadoop1.tar.gz && rm -rf titan-1.0.0-hadoop1.tar.gz && \
    mv /data/artifacts/virtualenv-15.1.0-py2.py3-none-any.whl /data/kore/tmp/ && \
    ln -sf /data/titan-1.0.0-hadoop1/bin/titan.sh /etc/init.d/titan && \
    yum install -y unzip telnet net-tools python2-pip libgomp --disablerepo=* --enablerepo=kore && yum clean all -y && \
    echo "######## Installing Python2.7......... ######## " && \
    mv /data/artifacts/py2.7.tar.gz /data/ && cd /data/ && tar xzf py2.7.tar.gz && rm -rf py2.7.tar.gz && \
    pip install /data/kore/tmp/virtualenv-15.1.0-py2.py3-none-any.whl &>/dev/null && \
    echo "######## Installing Python3.5......... ######## " && \
    mv /data/artifacts/build_files/py3.5.tar.gz /data/ && cd /data/ && tar xzf py3.5.tar.gz && rm -rf py3.5.tar.gz && \
    echo "######## Installing NLTK......... ######## " && \
    mv /data/artifacts/build_files/nltk_data.tar.gz /data/ && cd /data/ && tar xzf nltk_data.tar.gz && rm -rf nltk_data.tar.gz && \
    ln -sf /data/nltk_data /usr/share/nltk_data && \
    mv /data/artifacts/build_files/legacy_support.json /data/MachineLearning/legacy_support.json && \
    mv /data/artifacts/build_files/checkforbuild.sh /data/kore/deployment/ && \
    rm -rf /data/artifacts /data/kore-repo-redhat7 && \
    chown -R 1001:root /data /var/run/  && chmod -R 777 /data /var /run && \
    chmod -R g+rwxs /data /var /run  && chmod -R o+rwx /data/ && ln -sf /data/java/jdk1.8.0_131/bin/java /usr/bin/java
    cd /data && curl -LH "X-JFrog-Art-API: `cat /tmp/artifactory.txt`" -O $ARTIFACTORY_URL/releases.tar.gz && \
    tar xzf releases.tar.gz && rm -rf releases.tar.gz && \
    mv /data/releases/$KOREBOT_RELEASE.tar.gz /data/ && cd /data/ && tar xvzf $KOREBOT_RELEASE.tar.gz && \
    rm -rf $KOREBOT_RELEASE.tar.gz && \
    /data/kore/deployment/checkforbuild.sh FAQ $KOREBOT_RELEASE && \
    /data/kore/deployment/checkforbuild.sh MachineLearning $KOREBOT_RELEASE && \
    cd /data/www/tmp && \
    mkdir /var/www/logs && \
    mv /tmp/configs.tar.gz /data/artifacts/ && \
    cd /data/artifacts/ && tar xzf configs.tar.gz && rm -rf configs.tar.gz && \ 
    cp /data/artifacts/configs/$KOREBOT_ENV/ML_Config.json /data/py3.5/venv/ML_Config.json && \
    cp /data/artifacts/configs/$KOREBOT_ENV/config.py /var/www/FAQ/config.py && \
    chmod -R g+rwxs /var/www/*  && chmod -R o+rwx /var/www/*

USER 1001

EXPOSE 5005 6006

CMD ["/data/startup.sh", "start", "clustere"]
