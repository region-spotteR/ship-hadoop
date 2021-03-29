FROM hadoop_base

#ENV HDFS_CONF_dfs_namenode_name_dir=file:///home/hadoop/data/nameNode
HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

EXPOSE 8042

CMD $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager
