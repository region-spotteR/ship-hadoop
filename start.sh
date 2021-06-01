#!/bin/bash
docker image rm hadoop_base # delete old images

HADOOP_DEFAULT_VERSION=3.2.2
read -p "Set Hadoop Version [${HADOOP_DEFAULT_VERSION}]):" HADOOP_VERSION
HADOOP_VERSION=${HADOOP_VERSION:-${HADOOP_DEFAULT_VERSION}}

SPARK_DEFAULT=n
read -p "Do you want to use Spark as well [y/n]):" SPARK
SPARK=${SPARK:-${SPARK_DEFAULT}}


if [[ "$HADOOP_VERSION" == "$HADOOP_DEFAULT_VERSION" ]]
then
    if [[ "$SPARK" == "$SPARK_DEFAULT" ]]; then
        docker build -f ./hadoop/base.dockerfile -t hadoop_base .
        exit 1
    else
        docker build -f ./hadoop/baseSpark.dockerfile -t hadoop_base .
        exit 1
    fi
else
    HADOOP_NUM=$(echo "${HADOOP_VERSION}" | head -c3)
    if awk 'BEGIN {exit !('$HADOOP_NUM' >= '3.2')}'; then export SPARK_VERSION="3.1.1"; else export SPARK_VERSION="2.4.8"; fi \

    if [[ "$SPARK" == "$SPARK_DEFAULT" ]]; then
        echo "build base - with hadoop version: ${HADOOP_VERSION}"
        docker build --build-arg HADOOP_VERSION=$HADOOP_VERSION -f ./hadoop/base.dockerfile -t hadoop_base .
        exit 1
    else
        echo "build SPARK - with hadoop version: ${HADOOP_VERSION} and spark version: ${SPARK_VERSION}"
        docker build --build-arg HADOOP_VERSION=$HADOOP_VERSION SPARK_VERSION=$SPARK_VERSION -f ./hadoop/baseSpark.dockerfile -t hadoop_base .
        exit 1
    fi

fi

# 

