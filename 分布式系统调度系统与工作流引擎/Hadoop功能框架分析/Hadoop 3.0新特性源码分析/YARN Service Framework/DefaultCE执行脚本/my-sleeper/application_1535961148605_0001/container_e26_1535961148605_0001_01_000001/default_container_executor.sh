#!/bin/bash
/bin/bash "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/default_container_executor_session.sh"
rc=$?
echo $rc > "/hadoop/yarn/local/nmPrivate/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/container_e26_1535961148605_0001_01_000001.pid.exitcode.tmp"
/bin/mv -f "/hadoop/yarn/local/nmPrivate/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/container_e26_1535961148605_0001_01_000001.pid.exitcode.tmp" "/hadoop/yarn/local/nmPrivate/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/container_e26_1535961148605_0001_01_000001.pid.exitcode"
exit $rc
