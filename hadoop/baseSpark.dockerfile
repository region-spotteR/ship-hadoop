ARG JAVA_VERSION=8
FROM openjdk:${JAVA_VERSION}-jdk-slim

# ARG HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz
RUN apt update -y && apt upgrade -y && apt install -y wget ssh python3
# ENV echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/hadoop/hadoop-env.sh
# ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ARG HADOOP_VERSION=3.2.2 \
    SPARK_VERSION=3.1.1 

ARG HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    SPARK_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz 

RUN wget ${HADOOP_URL} -O /tmp/hadoop.tar.gz \
    && tar -zxf /tmp/hadoop.tar.gz -C /opt/ \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop  \
    && useradd -m -s /bin/bash hadoop 

##########################################
# SPARK
##########################################
RUN wget ${SPARK_URL} -O /tmp/spark.tgz \
    && tar -zxf /tmp/spark.tgz -C /tmp/ \
    && mv /tmp/spark-${SPARK_VERSION}-bin-without-hadoop /opt/spark \
    && rm /tmp/hadoop.tar.gz /tmp/spark.tgz 

WORKDIR /home/hadoop

USER hadoop

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION} \
    HADOOP_VERSION=${HADOOP_VERSION} \
    HADOOP_OS_TYPE=Linux \
    HADOOP_CONF_DIR=/etc/hadoop 

#This needs to be seperate 
ENV PATH="${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:/opt/scala-${SCALA_VERSION}/bin:/opt/spark/bin:${PATH}"

RUN mkdir -p ~/logs ~/data ~/data/nameNode ~/data/dataNode \
    ~/data/tmp ~/data/namesecondary ~/yarn/timeline\
    && touch ~/logs/fairscheduler-statedump.log \
    # Tell Spark where Hadoop
    && touch /opt/spark/conf/spark-env.sh \
    && printf "export SPARK_DIST_CLASSPATH=$(hadoop classpath) \n export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}" >> /opt/spark/conf/spark-env.sh \
    # Ensure that JAVA_HOME exists 
    && export JAVA_HOME="/usr/local/openjdk-$(echo $JAVA_VERSION | head -c 1)"  
    
COPY --chown=hadoop:hadoop hadoop/config/*.xml  /etc/hadoop/




