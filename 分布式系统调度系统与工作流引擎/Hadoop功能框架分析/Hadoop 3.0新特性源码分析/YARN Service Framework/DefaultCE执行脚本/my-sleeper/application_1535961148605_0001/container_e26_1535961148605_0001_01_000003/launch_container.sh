#!/bin/bash

set -o pipefail -e
export PRELAUNCH_OUT="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/prelaunch.out"
exec >"${PRELAUNCH_OUT}"
export PRELAUNCH_ERR="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/prelaunch.err"
exec 2>"${PRELAUNCH_ERR}"
echo "Setting up env variables"
export JAVA_HOME=${JAVA_HOME:-"/usr/jdk64/jdk1.8.0_112"}
export HADOOP_COMMON_HOME=${HADOOP_COMMON_HOME:-"/usr/bch/3.0.0/hadoop"}
export HADOOP_HDFS_HOME=${HADOOP_HDFS_HOME:-"/usr/bch/3.0.0/hadoop"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/usr/bch/3.0.0/hadoop/etc/hadoop"}
export HADOOP_YARN_HOME=${HADOOP_YARN_HOME:-"/usr/bch/current/hadoop-yarn-nodemanager"}
export HADOOP_HOME=${HADOOP_HOME:-"/usr/bch/3.0.0/hadoop"}
export PATH=${PATH:-"/usr/sbin:/sbin:/usr/lib/ambari-server/*:/opt/hadoop-3.2.0-SNAPSHOT/bin:/opt/hadoop-3.2.0-SNAPSHOT/sbin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/apache-geode-1.6.0/bin:/usr/jdk64/jdk1.8.0_77/bin:/usr/jdk64/jdk1.8.0_77/bin:/root/bin:/var/lib/ambari-agent"}
export HADOOP_TOKEN_FILE_LOCATION="/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/container_tokens"
export CONTAINER_ID="container_e26_1535961148605_0001_01_000003"
export NM_PORT="45454"
export NM_HOST="fys1.cmss.com"
export NM_HTTP_PORT="8042"
export LOCAL_DIRS="/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001"
export LOCAL_USER_DIRS="/hadoop/yarn/local/usercache/hdfs/"
export LOG_DIRS="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003"
export USER="hdfs"
export LOGNAME="hdfs"
export HOME="/home/"
export PWD="/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003"
export JVM_PID="$$"
export MALLOC_ARENA_MAX="4"
export NM_AUX_SERVICE_timeline_collector=""
export NM_AUX_SERVICE_mapreduce_shuffle="AAA0+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LOG_DIR="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003"
export HADOOP_USER_NAME="hdfs"
export WORK_DIR="$PWD"
export LC_ALL="en_US.UTF-8"
echo "Setting up job resources"
echo "Copying debugging information"
# Creating copy of launch script
cp "launch_container.sh" "/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/launch_container.sh"
chmod 640 "/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/launch_container.sh"
# Determining directory contents
echo "ls -l:" 1>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/directory.info"
ls -l 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/directory.info"
echo "find -L . -maxdepth 5 -ls:" 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/directory.info"
find -L . -maxdepth 5 -ls 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/directory.info"
echo "broken symlinks(find -L . -maxdepth 5 -type l -ls):" 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/directory.info"
find -L . -maxdepth 5 -type l -ls 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/directory.info"
echo "Launching container"
exec /bin/bash -c "sleep 900000 1>/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/stdout.txt 2>/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000003/stderr.txt "
