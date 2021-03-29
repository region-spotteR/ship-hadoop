ARG JAVA_VERSION=8
FROM openjdk:${JAVA_VERSION}-jdk-slim

# ARG HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
RUN apt update -y && apt upgrade -y && apt install -y wget ssh
# ENV echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/hadoop/hadoop-env.sh
# ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ARG HADOOP_VERSION=3.2.2
ARG HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

RUN wget ${HADOOP_URL} -O /tmp/hadoop.tar.gz \
    && tar -zxf /tmp/hadoop.tar.gz -C /opt/ \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop  \
    && rm /tmp/hadoop.tar.gz \
    && useradd -m -s /bin/bash hadoop 

WORKDIR /home/hadoop

USER hadoop

# Create directories for hadoop data
RUN mkdir -p ~/logs ~/data ~/data/nameNode ~/data/dataNode \
    ~/data/tmp ~/data/namesecondary ~/yarn/timeline\
    && touch ~/logs/fairscheduler-statedump.log \
    && export JAVA_HOME="/usr/local/openjdk-$(echo $JAVA_VERSION | head -c 1)"

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION} \
    HADOOP_OS_TYPE=Linux \
    HADOOP_CONF_DIR=/etc/hadoop \
    PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

COPY --chown=hadoop:hadoop config/*.xml  /etc/hadoop/
