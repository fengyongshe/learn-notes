ARCH := $(shell uname -m)
X64 = x86_64
CC = gcc
PROGS =	mqproxy
ifeq ($(ARCH), $(X64))
#	M64 = -m64
	LIBS = -L/home/MessageQueue/mq//lib -lprotobuf-c -lmqcrt -lcurl -ljson libhiredis.a 
else
	LIBS = -L/home/MessageQueue/mq//lib -lprotobuf-c -lmqcrt -lcurl -ljson libhiredis.a 
endif

CFLAGS = -Wall -g -O2 -I/home/MessageQueue/mq//include $(M64)

all: $(PROGS)

STPROG = mq_proxy.o router_mq.o omae-base.pb-c.o appmaster-approuter.pb-c.o

appmaster-approuter.pb-c.o: appmaster-approuter.pb-c.c appmaster-approuter.pb-c.h
	$(CC) $(CFLAGS) -c -o $@ appmaster-approuter.pb-c.c

omae-base.pb-c.o: omae-base.pb-c.c omae-base.pb-c.h
	$(CC) $(CFLAGS) -c -o $@ omae-base.pb-c.c

router_mq.o: router_mq.c router_mq.h
	$(CC) $(CFLAGS) -c -o $@ router_mq.c

mq_proxy.o: mq_proxy.c mq_proxy.h md5.h
	$(CC) $(CFLAGS) -c -o $@ mq_proxy.c

mqproxy: $(STPROG)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ $(PROGS)
