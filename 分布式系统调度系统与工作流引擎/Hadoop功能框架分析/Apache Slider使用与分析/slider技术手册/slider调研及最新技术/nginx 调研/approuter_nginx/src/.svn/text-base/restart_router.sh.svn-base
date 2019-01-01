#!/bin/bash

source router_env.sh

sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g" $BASE_SRC_DIR/conf/nginx-openresty.conf > $BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/nginx/conf/nginx.conf
$BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/nginx/sbin/nginx -s reload
sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g" $BASE_SRC_DIR/conf/nginx-server.conf > $BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR/conf/nginx.conf
$BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR/sbin/nginx -s reload
