FROM hadoop_base

VOLUME data/nameNode

#ENV HDFS_CONF_dfs_namenode_name_dir=file:///home/hadoop/data/nameNode
HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

EXPOSE 9870

#$HADOOP_HOME/bin/hdfs namenode -format -y &&
CMD $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
