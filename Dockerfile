FROM dockerimages/docker-systemd:ubuntu15.04
# You can change the FROM Instruction to your existing images if you like and build it with same tag
MAINTAINER Frank Lemanschik http://github.com/frank-dspeed
ENV LC_ALL C
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV SOLR_VERSION 4.10.2
ENV SOLR solr-$SOLR_VERSION

RUN export DEBIAN_FRONTEND=noninteractive \
&& echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu vivid main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
&& echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu vivid main" | tee -a /etc/apt/sources.list.d/webupd8team-jav.list \
&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
&& apt-get update \
&& apt-get upgrade -y \
&& echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
&& apt-get -y install \
oracle-java7-installer \
oracle-java7-set-default \
&& update-alternatives --display java \
&& rm -rf /var/cache/oracle-jdk7-installer \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& apt-get update \
&& apt-get -y install lsof curl procps \
&& mkdir -p /opt \
&& wget -nv --output-document=/opt/$SOLR.tgz http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz \
&& tar -C /opt --extract --file /opt/$SOLR.tgz \
&& rm /opt/$SOLR.tgz \
&& ln -s /opt/$SOLR /opt/solr
# Need to add unit files that do
# CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
RUN systemctl enable solr.service
EXPOSE 8983
ENTRYPOINT ["/lib/systemd/systemd"]
