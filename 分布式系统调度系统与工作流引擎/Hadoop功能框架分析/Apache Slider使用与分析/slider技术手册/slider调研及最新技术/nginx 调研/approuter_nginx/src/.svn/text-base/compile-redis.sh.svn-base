#!/bin/bash

source router_env.sh

cd $BASE_SRC_DIR
tar xzf ../lib/$REDIS_TARGZ
cd /$BASE_SRC_DIR/$REDIS_SRCDIR
make
#make test
make PREFIX=/$BASE_SRC_DIR/$REDIS_INSTALL_DIR install

