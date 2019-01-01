/*
 * =====================================================================================
 *
 *       Filename:  router_mq.h
 *
 *
 * =====================================================================================
 */

#ifndef  ROUTER_MQ_H
#define  ROUTER_MQ_H

#include "mqcrt.h"

#include "appmaster-approuter.pb-c.h"

struct  router_mq_handle
{
	char  brokerHost[30];
	int   brokerPort;	

	char  username[50];
	char  password[50];
	char  clientID[50];  /* identify the  connection.  */
 

	MQPropertiesHandle propertiesHandle ;
	MQConnectionHandle connectionHandle ;
	MQSessionHandle sessionHandle ;



	MQDestinationHandle destinationHandle ;
  
	MQProducerHandle producerHandle ;
	MQConsumerHandle consumerHandle ;
  
	MQMessageHandle messageHandle ;
	MQPropertiesHandle headersHandle;
};

struct  router_mq_handle  router_mq_handle_t;

typedef  struct  app_router_command_msg  app_router_command_msg;
struct app_router_command_msg
{
	char *command;
	char *data;
	size_t data_len;
};

void get_uuid_string( char *buffer  );

void create_router_mq_handle(char  *brokerHost, int   brokerPort, char  *username, char  *password, char  *clientID);

int setup_router_mq_handle();

//void reset_router_mq_handle();

// clear tmp pool of handle.  
void  cleanup_router_mq_handle();

int SendAppRouterJoinRequest( char *request_id, char *app_router_id, char *session_id );
AppRouterJoinResponse * GetAppRouterJoinResponse( char *request_id, char *app_router_id, char *session_id, int timeout, int *val );
int SendAppRouterQuitRequest( char *request_id, char *app_router_id, char *session_id );
AppRouterQuitResponse * GetAppRouterQuitResponse( char *request_id, char *app_router_id, char *session_id );
int SendAppRouterHeartBeat( char *app_router_id, char *session_id );
void dumpAppRouterJoinResponse( AppRouterJoinResponse *join_resp );
app_router_command_msg * GetAppRouterCommandMsg( int timeout,char *app_router_id, char *session_id, int *val );
int SendAppRouterMapCommandResponse( int result_code, char *request_id, char *app_router_id, char *session_id );
int SendAppRouterMapRefreshResponse( int result_code, char *request_id, char *app_router_id, char *session_id );


char mq_host[20];
char mq_port[10];
char mq_user[20];
char mq_passwd[20];
char heart_beat_time[10];
char proxy_router_id[50];
char redis_path[50];
int getparam_string(const char *param,char *buf,char *value,int value_size);
void getparam(char *buf);
void fixendofline(char *str);
void getconf(char *ConfigFile);

#endif   /* *    */



