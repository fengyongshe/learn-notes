#!/bin/bash
source router_env.sh


#apt-get install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl
export LUAJIT_LIB=/$BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/luajit/lib
export LUAJIT_INC=/$BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/luajit/include/luajit-2.0

cd /$BASE_SRC_DIR
tar xzf ../lib/$NGINX_SERVER_TARGZ
cd /$BASE_SRC_DIR/$NGINX_SERVER_SRCDIR
./configure --prefix=/$BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR --add-module=/$BASE_SRC_DIR/$OPENRESTY_SRCDIR/bundle/$ECHO_NGINX_MOD_DIR --add-module=/$BASE_SRC_DIR/$OPENRESTY_SRCDIR/bundle/$NGX_DEVEL_KIT_SRCDIR  --add-module=/$BASE_SRC_DIR/$OPENRESTY_SRCDIR/bundle/$NGX_LUA_MOD_DIR
make -j 4
make install
sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g"  $BASE_SRC_DIR/conf/nginx-server.conf > $BASE_SRC_DIR/$NGINX_SERVER_INSTALL_DIR/conf/nginx.conf

