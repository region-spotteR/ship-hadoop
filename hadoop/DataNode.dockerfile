FROM hadoop_base

VOLUME data/dataNode

#ENV HDFS_CONF_dfs_namenode_name_dir=file:///home/hadoop/data/nameNode
HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

EXPOSE 9864

CMD  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode
