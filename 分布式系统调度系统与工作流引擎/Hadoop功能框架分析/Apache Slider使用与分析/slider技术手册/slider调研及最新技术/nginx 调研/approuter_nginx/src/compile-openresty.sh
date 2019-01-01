#!/bin/bash
source router_env.sh


apt-get install libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl

export PATH=$PATH:/sbin
cd $BASE_SRC_DIR
tar xzf ../lib/$OPENRESTY_TARGZ
cd $BASE_SRC_DIR/$OPENRESTY_SRCDIR
./configure --prefix=/$BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR --with-luajit
make -j 4
make install
sed "s#NGX_BASE_SRC_DIR#$BASE_SRC_DIR#g"  $BASE_SRC_DIR/conf/nginx-openresty.conf > $BASE_SRC_DIR/$OPENRESTY_INSTALL_DIR/nginx/conf/nginx.conf


