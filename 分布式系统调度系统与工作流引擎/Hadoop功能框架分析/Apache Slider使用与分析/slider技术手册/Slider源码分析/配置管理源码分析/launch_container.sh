#!/bin/bash

export JAVA_HOME="/usr/jdk64/jdk1.7.0_67"
export NM_AUX_SERVICE_mapreduce_shuffle="AAA0+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=^M
"
export HADOOP_USER_NAME="fys"
export NM_HOST="bditest3.cmss.com"
export HADOOP_YARN_HOME="/usr/lib/hadoop-yarn"
export AGENT_LOG_ROOT="/data11/hadoop/yarn/log/application_1461811649094_0010/container_1461811649094_0010_01_000002"
export PYTHONPATH="./infra/agent/slider-agent/"
export JVM_PID="$$"
export PWD="/data10/hadoop/yarn/local/usercache/fys/appcache/application_1461811649094_0010/container_1461811649094_0010_01_000002"
export NM_PORT="45454"
export LOGNAME="fys"
export MALLOC_ARENA_MAX="4"
export NM_HTTP_PORT="8042"
export USER="fys"
export CONTAINER_ID="container_1461811649094_0010_01_000002"
export HOME="/home/"
export AGENT_WORK_ROOT="$PWD"
export HADOOP_CONF_DIR="/etc/hadoop/conf"
export SLIDER_PASSPHRASE="EAFsDSUExeLJSMg44L0aMHLHgVPe3pfozXEyATx6YXbmZx9QiR"
export LANG="en_US.UTF-8"
mkdir -p app
hadoop_shell_errorcode=$?
if [ $hadoop_shell_errorcode -ne 0 ]
then
  exit $hadoop_shell_errorcode
fi
ln -sf "/data15/hadoop/yarn/local/usercache/fys/appcache/application_1461811649094_0010/filecache/11/slider-kafka-app-package-0.80.0-bc1.3.0.zip" "app/definition"
hadoop_shell_errorcode=$?
if [ $hadoop_shell_errorcode -ne 0 ]
then
  exit $hadoop_shell_errorcode
fi
mkdir -p infra
hadoop_shell_errorcode=$?
if [ $hadoop_shell_errorcode -ne 0 ]
then
  exit $hadoop_shell_errorcode
fi
ln -sf "/data14/hadoop/yarn/local/usercache/fys/appcache/application_1461811649094_0010/filecache/10/slider-agent.tar.gz" "infra/agent"
hadoop_shell_errorcode=$?
if [ $hadoop_shell_errorcode -ne 0 ]
then
  exit $hadoop_shell_errorcode
fi
exec /bin/bash -c "python ./infra/agent/slider-agent/agent/main.py --label container_1461811649094_0010_01_000002___KAFKA_BROKER --zk-quorum bditest3.cmss.com:2181,bditest2.cmss.com:2181,bditest1.cmss.com:2181 --zk-reg-path /registry/users/fys/services/org-apache-slider/kafka210 > /data11/hadoop/yarn/log/application_1461811649094_0010/container_1461811649094_0010_01_000002/slider-agent.out 2>&1 "
hadoop_shell_errorcode=$?
if [ $hadoop_shell_errorcode -ne 0 ]
then
  exit $hadoop_shell_errorcode
fi