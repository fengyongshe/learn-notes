BCHadoop动态扩容
==========

本文介绍如何动态的新增BCHadoop子节点

## 扩容

* 修改$HADOOP_HOME/etc/hadoop/slaves文件，添加需要增加的节点hostname（每行一个），并同步到所有节点
* 将Hadoop目录复制到所有新增节点
* 逐个检查新增节点的linux环境，包括/etc/hosts配置，iptables配置，目录配置等
* 逐个ssh到新增的子节点，按照如下命令来启动DataNode和NodeManager

命令
	
	cd $HADOOP_HOME
	sbin/hadoop-daemon.sh start datanode
	sbin/yarn-daemon.sh start nodemanager
	
## HDFS负载均衡

因为新增的DataNode存储是空，因此需要进行HDFS负载均衡。
ssh到主节点，执行命令

	cd $HADOOP_HOME	
	bin/hadoop dfsadmin -setBalanacerBandwidth 1048576
	bin/hdfs balancer -threshold 5
	
上面第二条命令中，负载带宽参数默认1MB/s，可以酌情增大，执行日志如下


DEPRECATED: Use of this script to execute hdfs command is deprecated.
Instead use the hdfs command for it.
Balancer bandwidth is set to 1048576

上面的第三条命令，执行日志如下：

The cluster is balanced. Exiting...
Feb 11, 2015 7:18:19 AM           0                  0 B                 0 B               -1 B
Feb 11, 2015 7:18:19 AM  Balancing took 2.807 seconds

则表示执行成功