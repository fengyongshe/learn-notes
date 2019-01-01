#!/bin/bash

set -o pipefail -e
export PRELAUNCH_OUT="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/prelaunch.out"
exec >"${PRELAUNCH_OUT}"
export PRELAUNCH_ERR="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/prelaunch.err"
exec 2>"${PRELAUNCH_ERR}"
echo "Setting up env variables"
export JAVA_HOME=${JAVA_HOME:-"/usr/jdk64/jdk1.8.0_112"}
export HADOOP_COMMON_HOME=${HADOOP_COMMON_HOME:-"/usr/bch/3.0.0/hadoop"}
export HADOOP_HDFS_HOME=${HADOOP_HDFS_HOME:-"/usr/bch/3.0.0/hadoop"}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/usr/bch/3.0.0/hadoop/etc/hadoop"}
export HADOOP_YARN_HOME=${HADOOP_YARN_HOME:-"/usr/bch/current/hadoop-yarn-nodemanager"}
export HADOOP_HOME=${HADOOP_HOME:-"/usr/bch/3.0.0/hadoop"}
export PATH=${PATH:-"/usr/sbin:/sbin:/usr/lib/ambari-server/*:/opt/hadoop-3.2.0-SNAPSHOT/bin:/opt/hadoop-3.2.0-SNAPSHOT/sbin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/apache-geode-1.6.0/bin:/usr/jdk64/jdk1.8.0_77/bin:/usr/jdk64/jdk1.8.0_77/bin:/root/bin:/var/lib/ambari-agent"}
export HADOOP_TOKEN_FILE_LOCATION="/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/container_tokens"
export CONTAINER_ID="container_e26_1535961148605_0001_01_000001"
export NM_PORT="45454"
export NM_HOST="fys1.cmss.com"
export NM_HTTP_PORT="8042"
export LOCAL_DIRS="/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001"
export LOCAL_USER_DIRS="/hadoop/yarn/local/usercache/hdfs/"
export LOG_DIRS="/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001"
export USER="hdfs"
export LOGNAME="hdfs"
export HOME="/home/"
export PWD="/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001"
export JVM_PID="$$"
export MALLOC_ARENA_MAX="4"
export NM_AUX_SERVICE_timeline_collector=""
export NM_AUX_SERVICE_mapreduce_shuffle="AAA0+gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
export LANG="en_US.UTF-8"
export APP_SUBMIT_TIME_ENV="1535961508900"
export HADOOP_USER_NAME="hdfs"
export TIMELINE_FLOW_NAME_TAG="my-sleeper2"
export TIMELINE_FLOW_VERSION_TAG="1"
export LANGUAGE="en_US.UTF-8"
export APPLICATION_WEB_PROXY_BASE="/proxy/application_1535961148605_0001"
export CLASSPATH="yarnservice-log4j.properties:conf/:lib/*:$CLASSPATH:$HADOOP_CONF_DIR"
export LC_ALL="en_US.UTF-8"
export TIMELINE_FLOW_RUN_ID_TAG="1535961508901"
echo "Setting up job resources"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/15/commons-io-2.5.jar" "lib/commons-io-2.5.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/150/metrics-core-3.2.4.jar" "lib/metrics-core-3.2.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/39/jsch-0.1.54.jar" "lib/jsch-0.1.54.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/145/leveldbjni-all-1.8.jar" "lib/leveldbjni-all-1.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/147/token-provider-1.0.1.jar" "lib/token-provider-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/18/hadoop-nfs-3.1.0-bc3.0.0.jar" "lib/hadoop-nfs-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/16/kerby-pkix-1.0.1.jar" "lib/kerby-pkix-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/74/jackson-annotations-2.7.8.jar" "lib/jackson-annotations-2.7.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/109/asm-5.0.4.jar" "lib/asm-5.0.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/108/hadoop-yarn-server-timeline-pluginstorage-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-timeline-pluginstorage-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/125/guice-4.0.jar" "lib/guice-4.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/148/jetty-io-9.3.19.v20170502.jar" "lib/jetty-io-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/131/gson-2.2.4.jar" "lib/gson-2.2.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/141/jsr305-3.0.0.jar" "lib/jsr305-3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/26/jcip-annotations-1.0-1.jar" "lib/jcip-annotations-1.0-1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/137/commons-collections-3.2.2.jar" "lib/commons-collections-3.2.2.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/50/snakeyaml-1.16.jar" "lib/snakeyaml-1.16.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/149/kerb-crypto-1.0.1.jar" "lib/kerb-crypto-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/79/curator-client-2.12.0.jar" "lib/curator-client-2.12.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/139/hadoop-yarn-api-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-api-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/89/hadoop-yarn-client-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-client-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/115/hadoop-yarn-server-web-proxy-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-web-proxy-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/97/javax.servlet-api-3.1.0.jar" "lib/javax.servlet-api-3.1.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/30/curator-recipes-2.12.0.jar" "lib/curator-recipes-2.12.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/73/commons-cli-1.2.jar" "lib/commons-cli-1.2.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/14/mockito-all-1.8.5.jar" "lib/mockito-all-1.8.5.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/48/kerb-server-1.0.1.jar" "lib/kerb-server-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/75/commons-compress-1.4.1.jar" "lib/commons-compress-1.4.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/110/jetty-xml-9.3.19.v20170502.jar" "lib/jetty-xml-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/112/slf4j-api-1.7.25.jar" "lib/slf4j-api-1.7.25.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/122/commons-lang3-3.4.jar" "lib/commons-lang3-3.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/13/hadoop-common-3.1.0-bc3.0.0-tests.jar" "lib/hadoop-common-3.1.0-bc3.0.0-tests.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/17/hadoop-yarn-server-tests-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-tests-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/35/commons-daemon-1.0.13.jar" "lib/commons-daemon-1.0.13.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/146/slf4j-log4j12-1.7.25.jar" "lib/slf4j-log4j12-1.7.25.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/21/avro-1.7.7.jar" "lib/avro-1.7.7.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/29/okhttp-2.7.5.jar" "lib/okhttp-2.7.5.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/53/kerby-xdr-1.0.1.jar" "lib/kerby-xdr-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/38/kerby-config-1.0.1.jar" "lib/kerby-config-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/58/fst-2.50.jar" "lib/fst-2.50.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/80/jsp-api-2.1.jar" "lib/jsp-api-2.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/28/jackson-jaxrs-base-2.7.8.jar" "lib/jackson-jaxrs-base-2.7.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/118/json-smart-2.3.jar" "lib/json-smart-2.3.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/12/hadoop-hdfs-3.1.0-bc3.0.0-tests.jar" "lib/hadoop-hdfs-3.1.0-bc3.0.0-tests.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/63/jackson-xc-1.9.13.jar" "lib/jackson-xc-1.9.13.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/136/htrace-core4-4.1.0-incubating.jar" "lib/htrace-core4-4.1.0-incubating.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/121/hadoop-hdfs-rbf-3.1.0-bc3.0.0-tests.jar" "lib/hadoop-hdfs-rbf-3.1.0-bc3.0.0-tests.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/142/kerby-asn1-1.0.1.jar" "lib/kerby-asn1-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/102/hadoop-yarn-common-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-common-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/117/jettison-1.1.jar" "lib/jettison-1.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/128/commons-logging-1.1.3.jar" "lib/commons-logging-1.1.3.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/10/protobuf-java-2.5.0.jar" "lib/protobuf-java-2.5.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/78/xml-apis-1.4.01.jar" "lib/xml-apis-1.4.01.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/36/jsr311-api-1.1.1.jar" "lib/jsr311-api-1.1.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/46/jersey-core-1.19.jar" "lib/jersey-core-1.19.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/132/hadoop-hdfs-rbf-3.1.0-bc3.0.0.jar" "lib/hadoop-hdfs-rbf-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/67/log4j-1.2.17.jar" "lib/log4j-1.2.17.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/95/snappy-java-1.0.5.jar" "lib/snappy-java-1.0.5.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/23/httpcore-4.4.4.jar" "lib/httpcore-4.4.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/107/hadoop-yarn-services-api-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-services-api-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/156/yarn-service-core.jar" "lib/yarn-service-core.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/47/commons-math3-3.1.1.jar" "lib/commons-math3-3.1.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/81/commons-beanutils-1.9.3.jar" "lib/commons-beanutils-1.9.3.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/114/commons-net-3.6.jar" "lib/commons-net-3.6.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/103/stax2-api-3.1.4.jar" "lib/stax2-api-3.1.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/143/HikariCP-java7-2.4.12.jar" "lib/HikariCP-java7-2.4.12.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/123/jersey-client-1.19.jar" "lib/jersey-client-1.19.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/100/jetty-security-9.3.19.v20170502.jar" "lib/jetty-security-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/43/okio-1.6.0.jar" "lib/okio-1.6.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/133/kerb-client-1.0.1.jar" "lib/kerb-client-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/54/jackson-jaxrs-1.9.13.jar" "lib/jackson-jaxrs-1.9.13.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/85/hadoop-hdfs-3.1.0-bc3.0.0.jar" "lib/hadoop-hdfs-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/101/hadoop-yarn-server-resourcemanager-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-resourcemanager-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/88/jetty-util-9.3.19.v20170502.jar" "lib/jetty-util-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/111/kerby-util-1.0.1.jar" "lib/kerby-util-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/55/jackson-module-jaxb-annotations-2.7.8.jar" "lib/jackson-module-jaxb-annotations-2.7.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/68/hadoop-yarn-server-applicationhistoryservice-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-applicationhistoryservice-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/45/paranamer-2.3.jar" "lib/paranamer-2.3.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/155/commons-lang-2.6.jar" "lib/commons-lang-2.6.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/105/guava-11.0.2.jar" "lib/guava-11.0.2.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/31/junit-4.11.jar" "lib/junit-4.11.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/134/nimbus-jose-jwt-4.41.1.jar" "lib/nimbus-jose-jwt-4.41.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/34/jul-to-slf4j-1.7.25.jar" "lib/jul-to-slf4j-1.7.25.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/11/hadoop-yarn-registry-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-registry-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/51/hadoop-yarn-server-sharedcachemanager-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-sharedcachemanager-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/84/xz-1.0.jar" "lib/xz-1.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/153/guice-servlet-4.0.jar" "lib/guice-servlet-4.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/157/jersey-guice-1.19.jar" "lib/jersey-guice-1.19.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/24/zookeeper-3.5.2-bc3.0.0.jar" "lib/zookeeper-3.5.2-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/140/hadoop-annotations-3.1.0-bc3.0.0.jar" "lib/hadoop-annotations-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/65/jetty-webapp-9.3.19.v20170502.jar" "lib/jetty-webapp-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/90/hadoop-hdfs-native-client-3.1.0-bc3.0.0-tests.jar" "lib/hadoop-hdfs-native-client-3.1.0-bc3.0.0-tests.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/57/curator-framework-2.12.0.jar" "lib/curator-framework-2.12.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/92/hadoop-yarn-server-common-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-common-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/19/json-io-2.5.1.jar" "lib/json-io-2.5.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/99/jersey-json-1.19.jar" "lib/jersey-json-1.19.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/59/json-simple-1.1.1.jar" "lib/json-simple-1.1.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/152/jackson-mapper-asl-1.9.13.jar" "lib/jackson-mapper-asl-1.9.13.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/20/hadoop-hdfs-client-3.1.0-bc3.0.0.jar" "lib/hadoop-hdfs-client-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/86/jetty-http-9.3.19.v20170502.jar" "lib/jetty-http-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/60/hadoop-yarn-services-core-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-services-core-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/56/kerb-common-1.0.1.jar" "lib/kerb-common-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/77/ehcache-3.3.1.jar" "lib/ehcache-3.3.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/52/jetty-server-9.3.19.v20170502.jar" "lib/jetty-server-9.3.19.v20170502.jar"
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/22/conf" "yarnservice-log4j.properties"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/82/accessors-smart-1.2.jar" "lib/accessors-smart-1.2.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/96/jetty-util-ajax-9.3.19.v20170502.jar" "lib/jetty-util-ajax-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/25/jaxb-api-2.2.11.jar" "lib/jaxb-api-2.2.11.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/40/jackson-core-asl-1.9.13.jar" "lib/jackson-core-asl-1.9.13.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/66/hadoop-auth-3.1.0-bc3.0.0.jar" "lib/hadoop-auth-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/135/hadoop-hdfs-client-3.1.0-bc3.0.0-tests.jar" "lib/hadoop-hdfs-client-3.1.0-bc3.0.0-tests.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/70/hadoop-hdfs-httpfs-3.1.0-bc3.0.0.jar" "lib/hadoop-hdfs-httpfs-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/91/httpclient-4.5.2.jar" "lib/httpclient-4.5.2.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/151/woodstox-core-5.0.3.jar" "lib/woodstox-core-5.0.3.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/27/kerb-admin-1.0.1.jar" "lib/kerb-admin-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/76/hadoop-yarn-applications-unmanaged-am-launcher-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-applications-unmanaged-am-launcher-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/87/dnsjava-2.1.7.jar" "lib/dnsjava-2.1.7.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/33/geronimo-jcache_1.0_spec-1.0-alpha-1.jar" "lib/geronimo-jcache_1.0_spec-1.0-alpha-1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/138/netty-all-4.0.52.Final.jar" "lib/netty-all-4.0.52.Final.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/41/re2j-1.1.jar" "lib/re2j-1.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/127/netty-3.10.5.Final.jar" "lib/netty-3.10.5.Final.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/120/jaxb-impl-2.2.3-1.jar" "lib/jaxb-impl-2.2.3-1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/130/jackson-jaxrs-json-provider-2.7.8.jar" "lib/jackson-jaxrs-json-provider-2.7.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/32/xercesImpl-2.11.0.jar" "lib/xercesImpl-2.11.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/94/kerb-core-1.0.1.jar" "lib/kerb-core-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/98/jackson-core-2.7.8.jar" "lib/jackson-core-2.7.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/71/jetty-servlet-9.3.19.v20170502.jar" "lib/jetty-servlet-9.3.19.v20170502.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/83/aopalliance-1.0.jar" "lib/aopalliance-1.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/144/hadoop-common-3.1.0-bc3.0.0.jar" "lib/hadoop-common-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/44/java-util-1.9.0.jar" "lib/java-util-1.9.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/49/mssql-jdbc-6.2.1.jre7.jar" "lib/mssql-jdbc-6.2.1.jre7.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/116/kerb-util-1.0.1.jar" "lib/kerb-util-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/126/kerb-simplekdc-1.0.1.jar" "lib/kerb-simplekdc-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/104/hadoop-kms-3.1.0-bc3.0.0.jar" "lib/hadoop-kms-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/106/jackson-databind-2.7.8.jar" "lib/jackson-databind-2.7.8.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/93/commons-configuration2-2.1.1.jar" "lib/commons-configuration2-2.1.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/154/jersey-server-1.19.jar" "lib/jersey-server-1.19.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/61/hadoop-yarn-applications-distributedshell-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-applications-distributedshell-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/119/swagger-annotations-1.5.4.jar" "lib/swagger-annotations-1.5.4.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/124/hadoop-hdfs-nfs-3.1.0-bc3.0.0.jar" "lib/hadoop-hdfs-nfs-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/72/commons-codec-1.11.jar" "lib/commons-codec-1.11.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/129/kerb-identity-1.0.1.jar" "lib/kerb-identity-1.0.1.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/42/hadoop-yarn-server-nodemanager-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-nodemanager-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/69/hadoop-hdfs-native-client-3.1.0-bc3.0.0.jar" "lib/hadoop-hdfs-native-client-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/64/hamcrest-core-1.3.jar" "lib/hamcrest-core-1.3.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/37/jersey-servlet-1.19.jar" "lib/jersey-servlet-1.19.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/113/hadoop-yarn-server-router-3.1.0-bc3.0.0.jar" "lib/hadoop-yarn-server-router-3.1.0-bc3.0.0.jar"
mkdir -p lib
ln -sf "/hadoop/yarn/local/usercache/hdfs/appcache/application_1535961148605_0001/filecache/62/javax.inject-1.jar" "lib/javax.inject-1.jar"
echo "Copying debugging information"
# Creating copy of launch script
cp "launch_container.sh" "/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/launch_container.sh"
chmod 640 "/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/launch_container.sh"
# Determining directory contents
echo "ls -l:" 1>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/directory.info"
ls -l 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/directory.info"
echo "find -L . -maxdepth 5 -ls:" 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/directory.info"
find -L . -maxdepth 5 -ls 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/directory.info"
echo "broken symlinks(find -L . -maxdepth 5 -type l -ls):" 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/directory.info"
find -L . -maxdepth 5 -type l -ls 1>>"/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/directory.info"
echo "Launching container"
exec /bin/bash -c "$JAVA_HOME/bin/java -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dlog4j.configuration=yarnservice-log4j.properties -DLOG_DIR=/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001 org.apache.hadoop.yarn.service.ServiceMaster -yarnfile hdfs://fys1.cmss.com:8020/user/hdfs/.yarn/services/my-sleeper2/my-sleeper2.json -D hadoop.registry.zk.root=/registry -D hadoop.registry.zk.quorum=fys1.cmss.com:2181,fys3.cmss.com:2181,fys2.cmss.com:2181 1>/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/serviceam-out.txt 2>/hadoop/yarn/log/application_1535961148605_0001/container_e26_1535961148605_0001_01_000001/serviceam-err.txt "
