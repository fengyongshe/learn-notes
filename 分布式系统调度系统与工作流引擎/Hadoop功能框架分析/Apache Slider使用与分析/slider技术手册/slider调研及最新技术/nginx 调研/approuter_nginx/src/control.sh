#!/bin/bash

source router_env.sh

command=$1
enable_test_server=1

if [ $command = "start" ]; then
	touch /tmp/router_redis.sock
	chmod 777 /tmp/router_redis.sock
	sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g" $BASE_SRC_DIR/conf/redis.conf > $BASE_SRC_DIR/$REDIS_INSTALL_DIR/redis.conf
	$BASE_SRC_DIR/$REDIS_INSTALL_DIR/bin/redis-server $BASE_SRC_DIR/$REDIS_INSTALL_DIR/redis.conf
	if [ $enable_test_server = 1 ]; then
	    sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g"  $BASE_SRC_DIR/conf/nginx-server.conf > $BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR/conf/nginx.conf
		$BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR/sbin/nginx
	fi
	sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g"  $BASE_SRC_DIR/conf/nginx-openresty.conf > $BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/nginx/conf/nginx.conf
	$BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/nginx/sbin/nginx 
elif [ $command = "stop" ]; then
	$BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR/sbin/nginx -s quit
	$BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/nginx/sbin/nginx -s quit
	killall -9 redis-server
else
	echo "commnad $command not recognized."
fi

