# Table of Contents
- [Table of Contents](#table-of-contents)
- [Overview](#overview)
- [Getting Started](#getting-started)
- [Details](#details)
  - [Hadoop](#hadoop)
  - [Environment Variables](#environment-variables)
  - [Docker-Compose](#docker-compose)
- [Some Hadoop Theory](#some-hadoop-theory)
  - [NameNode](#namenode)
  - [DataNode](#datanode)
  - [YARN](#yarn)
    - [Resource Manager](#resource-manager)
    - [Node Manager](#node-manager)
    - [History Server](#history-server)
  - [Sources](#sources)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

# Overview 

Purpose of this repository:
* Learn about the different parts of hadoop
* understanding if they are seperate or interconnected

This repository consists of four parts: 
- a hadoop folder with all the dockerfiles 
- a config folder inside the hadoop folder with all xml files for hadoop 
- an hadoop.env-file containing private environment variables for hadoop  
- a docker-compose.yml to start hadoop 

# Getting Started 

1. First the create the hadoop base container: `docker build -f ./hadoop/base.dockerfile -t hadoop_base . ` or type `sh start.sh` and the script guides you through the basic steps. Note that the second step is still advised since helps discovering errors if there are any. 
2. Second run `docker-compose up -d`. If you want to see the log in your command line omit `-d`

After initialisation (takes a few seconds) you should find the management view under `localhost:9870`.  

# Details

## Hadoop

Overview of the different dockerfiles
* `base.dockerfile`: The basic image. Downloads hadoop and imports the `xml`-configuration files (cf. config-folder). Sets up the user and environment variables
* `NameNode.dockerfile`: Performs a health check and starts the [NameNode](#namenode). Uses a volume.
* `DataNode.dockerfile`: Performs a health check and starts the [DataNode](#datanode). Uses a volume.
* `NodeManager.dockerfile`: Performs a health check and starts the [Resource Manager](#resource-manager).
* `RessourceManager.dockerfile`: Performs a health check and starts the [Node Manager](#node-manager).
* `HistoryServer.dockerfile`: Performs a health check and starts the [History Server](#history-server). Uses a volume

## Environment Variables

The `hadoop.env` contains the following environment variables

```
HDFS_NAMENODE_USER=
HDFS_DATANODE_USER=
HDFS_SECONDARYNAMENODE_USER=
YARN_RESOURCEMANAGER_USER=
YARN_NODEMANAGER_USER=
```

Further private environment variables can be added

## Docker-Compose

The `docker-compose.yml` defines the sequence in which containers must be started and otherwise does the same thing a `docker container run` command would do. 

# Some Hadoop Theory

Note that all of the folling components like, e.g., NameNode and DataNode are processes and no virtual environments. Docker, e.g., is also a process, not a VM or something similar in any way.

## NameNode

The NameNode performs the following duties:
* manages the file-system
* regulates access for clients
* manages which blocks are written to which DataNode
* Opens, closes and renames files/folders
* There is three ways to secure its availability:
  * write backups of its metadata to a network file system
  * alternatively you can have a second (inactive) Namenode on standby
  * HDFS Federation: Seperate NameNodes which are responsible for a Namespace among the Data-Nodes

## DataNode

The DataNodes perform the following duties 

* manages the storing of data
* one or several data blocks are stored here
* writes and reads files
* creates/deletes/replicates blocks (on the command of the NameNodes)
* HDFS-clients runs on the DataNode


## YARN

manages the process

### Resource Manager

* Manages CPU and RAM (YARN - Yet Another Ressource Negotiator)
* manages the NodeManage or more precisely allocates the jobs to NodeManagers


### Node Manager

* Runs YARN-clients
* executes jobs
* can run on the same location as the DataNode or seperately 

### History Server

Saves the executed jobs for monitoring.

## Sources

1. [Source for information about NameNodes and DataNodes](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html#NameNode+and+DataNodes)
2. [Source for information about YARN components of hadoop](https://community.cloudera.com/t5/Community-Articles/Understanding-basics-of-HDFS-and-YARN/ta-p/248860)

----------------------------------------------------------------------------------------------------------------

