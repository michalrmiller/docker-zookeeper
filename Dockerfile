FROM java:8

ENV MIRROR="http://apache.mirrors.lucidnetworks.net/"
ENV VERSION="3.4.6"
ENV SHA1="2a9e53f5990dfe0965834a525fbcad226bf93474"

LABEL zk_version="${VERSION}"
LABEL zk_sha1="${SHA1}"

# Download and sha1sum validate
WORKDIR /tmp
RUN echo "${SHA1}\tzookeeper-${VERSION}.tar.gz" > checksum
RUN wget ${MIRROR}/zookeeper/zookeeper-${VERSION}/zookeeper-${VERSION}.tar.gz
RUN sha1sum --check checksum

# Extract
RUN mkdir -p /opt/zookeeper
RUN tar --strip-components=1 -zxf zookeeper-${VERSION}.tar.gz -C /opt/zookeeper

# Clean up
RUN rm -rf /tmp/*

# Setup dataDir
RUN mkdir -p /opt/zookeeper/data

# Just the sample config with the dataDir changed to /opt/zookeeper/data
COPY zoo_basic.cfg /opt/zookeeper/conf/zoo.cfg

# Basic logging config with rolling log
RUN mkdir -p /opt/zookeeper/logs
COPY log4j.properties /opt/zookeeper/conf/log4j.properties

WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper/data","/opt/zookeeper/logs","/opt/zookeeper/conf"]

ENTRYPOINT ["bin/zkServer.sh"]
CMD ["start-foreground"]