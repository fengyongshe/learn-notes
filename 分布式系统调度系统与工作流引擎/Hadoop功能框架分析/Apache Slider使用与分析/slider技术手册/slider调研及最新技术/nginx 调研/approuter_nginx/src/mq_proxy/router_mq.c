/*
 * =====================================================================================
 *
 *       Filename:  router_mq.c
 *
 *
 * =====================================================================================
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>

#include "router_mq.h"


	/*
	 *  at least APR_UUID_FORMATTED_LENGTH + 1 bytes buffer. 
	 *
	 */
void get_uuid_string( char *buffer  )
{
	char temp[1024]={0};
	FILE *fp;
	fp = fopen("/proc/sys/kernel/random/uuid","r");
	if(fp==NULL)
	{
		strcpy(buffer,"1111-1111-1111-1111-1111");
		printf("fopen file is failed\n");
	}
	else
	{
		fgets(temp,1024,fp);
		printf("temp=%s\n",temp);
		strcpy(buffer,temp);
	}
	fclose(fp);

	//strcpy(buffer,"4eb63566-913c-421e-b877-bc995e0c634b");
	//apr_uuid_t uuid;

	//apr_uuid_get( &uuid );
	//apr_uuid_format( buffer, &uuid );
}


void create_router_mq_handle(char *brokerHost, int brokerPort, char *username, char *password, char *clientID)
{
	strcpy(router_mq_handle_t.brokerHost, brokerHost);
	router_mq_handle_t.brokerPort = brokerPort;

	strcpy(router_mq_handle_t.username, username );
	strcpy(router_mq_handle_t.password, password );
	strcpy(router_mq_handle_t.clientID, clientID );

	router_mq_handle_t.propertiesHandle.handle = (MQInt32)0xFEEEFEEE; //  MQ_INVALID_HANDLE;
	router_mq_handle_t.connectionHandle.handle = (MQInt32)0xFEEEFEEE; //     MQ_INVALID_HANDLE;
	router_mq_handle_t.sessionHandle.handle = (MQInt32)0xFEEEFEEE; //     MQ_INVALID_HANDLE;

	router_mq_handle_t.destinationHandle.handle = (MQInt32)0xFEEEFEEE; //   MQ_INVALID_HANDLE;
	router_mq_handle_t.producerHandle.handle = (MQInt32)0xFEEEFEEE; //  MQ_INVALID_HANDLE;
	router_mq_handle_t.consumerHandle.handle = (MQInt32)0xFEEEFEEE; //    = MQ_INVALID_HANDLE;

	router_mq_handle_t.messageHandle.handle = (MQInt32)0xFEEEFEEE; //    = MQ_INVALID_HANDLE;
	router_mq_handle_t.headersHandle.handle = (MQInt32)0xFEEEFEEE; //    = MQ_INVALID_HANDLE;
}


#define MQ_ERR_CHK(mqCall)                             \
  if (MQStatusIsError(status = (mqCall)) == MQ_TRUE) { \
    goto Cleanup;                                      \
  }



int setup_router_mq_handle()
{
	MQStatus status;

	/* Setup connection properties */
  
	MQ_ERR_CHK( MQCreateProperties(&(router_mq_handle_t.propertiesHandle) )  );
  
	MQ_ERR_CHK( MQSetStringProperty(router_mq_handle_t.propertiesHandle, 
                                  MQ_BROKER_HOST_PROPERTY, router_mq_handle_t.brokerHost) ); 
  
	MQ_ERR_CHK( MQSetInt32Property(router_mq_handle_t.propertiesHandle, 
                                 MQ_BROKER_PORT_PROPERTY, router_mq_handle_t.brokerPort) );
  
	MQ_ERR_CHK( MQSetStringProperty(router_mq_handle_t.propertiesHandle,
                                  MQ_CONNECTION_TYPE_PROPERTY, "TCP") );
  
	/* Create a connection to Message Queue broker */
	MQ_ERR_CHK( MQCreateConnection(router_mq_handle_t.propertiesHandle, router_mq_handle_t.username, 
					router_mq_handle_t.password, router_mq_handle_t.clientID, 
                                 NULL, NULL, &(router_mq_handle_t.connectionHandle) ) );
  
	/* Create a session */ 
	MQ_ERR_CHK( MQCreateSession(router_mq_handle_t.connectionHandle, MQ_FALSE, MQ_CLIENT_ACKNOWLEDGE,
                              MQ_SESSION_SYNC_RECEIVE, & (router_mq_handle_t.sessionHandle) ) );

	return 0;

Cleanup:
  
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("MQError = %s in setup_router_mq_handle\n",errorString);
		MQFreeString(errorString);
	}

	MQCloseSession(router_mq_handle_t.sessionHandle); 

	MQFreeProperties(router_mq_handle_t.propertiesHandle);
	MQCloseConnection(router_mq_handle_t.connectionHandle);
	MQFreeConnection(router_mq_handle_t.connectionHandle);

	return -1;
}


void  cleanup_router_mq_handle()
{

	MQCloseSession(router_mq_handle_t.sessionHandle); 

	MQFreeProperties(router_mq_handle_t.propertiesHandle);
	MQCloseConnection(router_mq_handle_t.connectionHandle);
	MQFreeConnection(router_mq_handle_t.connectionHandle);


}
/*
void  reset_router_mq_handle( router_mq_handle_t  *h )
{

	apr_pool_clear( router_mq_handle_t.tmp_pool );

}*/

int SendAppRouterJoinRequest( char *request_id, char *app_router_id, char *session_id )
{
	MQStatus status;

	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQProducerHandle producerHandle ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	AppRouterJoin  join = APP_ROUTER_JOIN__INIT;
	unsigned char *packed = NULL; 
	size_t   join_len=0;

	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	producerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	join.request_id = request_id;
	join.app_router_id = app_router_id;
	join.session_id = session_id;

	join_len = app_router_join__get_packed_size( &join );
	packed = malloc ( join_len );
	app_router_join__pack( &join, packed );


	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.approuter.join" , /* destinationName, */
                                  MQ_QUEUE_DESTINATION , /*  destinationType,  */
								  &destinationHandle) );

	/* Create a messagse producer for the destination */
	MQ_ERR_CHK( MQCreateMessageProducerForDestination(router_mq_handle_t.sessionHandle,
                                  destinationHandle, &producerHandle) );
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Create a message handle */
	MQ_ERR_CHK(MQCreateBytesMessage(&messageHandle) );
  
	/* Sending messages */

      
	/* Set message body */
	MQ_ERR_CHK( MQSetBytesMessageBytes(messageHandle,( const MQInt8 * ) packed, join_len ) );

	//MQ_ERR_CHK( MQSendMessage(producerHandle, messageHandle) );
	MQ_ERR_CHK( MQSendMessageExt(producerHandle, messageHandle, MQ_NON_PERSISTENT_DELIVERY,4,600000) );
  
	MQ_ERR_CHK( MQFreeMessage(messageHandle) );
  
	/* Close the message producer */
	MQ_ERR_CHK( MQCloseMessageProducer(producerHandle) );

	free( packed );

	return 0;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("MQError = %s in SendAppRouterJoinRequest\n",errorString);
		MQFreeString(errorString);
	}
  

	if ( packed )
		free( packed );
    MQCloseMessageProducer(producerHandle);
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );

	return -1;
}

AppRouterJoinResponse * GetAppRouterJoinResponse( char *request_id, char *app_router_id, char *session_id, int timeout, int *val )
{
	MQStatus status;

	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQConsumerHandle consumerHandle  ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	AppRouterJoinResponse *join_resp;
	//char  *selector;
	char selector[300]={0};
	//sprintf(selector,"AppRouterID='%s' and SessionID='%s'",app_router_id,session_id);

	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	consumerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	sprintf(selector,"AppRouterID='%s' and SessionID='%s'",app_router_id, session_id);
	//selector = apr_pstrcat(router_mq_handle_t.tmp_pool, "AppRouterID='" , app_router_id, "'  and  ", 
	//	"SessionID='",  session_id , "'", NULL );	

	printf("Join selector: [%s] \n", selector);

	//ap_log_perror(APLOG_MARK, APLOG_NOTICE, 0, router_mq_handle_t.tmp_pool, "Join selector: [%s]", selector  ); 

	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.approuter.join.response",
                                  MQ_QUEUE_DESTINATION, &destinationHandle) );

	/* Create a synchronous messagse consumer on the destination */
	MQ_ERR_CHK( MQCreateMessageConsumer(router_mq_handle_t.sessionHandle, destinationHandle,
                                      selector , MQ_TRUE, &consumerHandle) );
  
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Start the connection */
	MQ_ERR_CHK( MQStartConnection(router_mq_handle_t.connectionHandle) );
  
	/* Receiving messages */

  
	while (1) {

    
		//printf("Waiting for message ...\n");
		//MQ_ERR_CHK( MQReceiveMessageWait(consumerHandle, &messageHandle) );
		MQ_ERR_CHK( MQReceiveMessageWithTimeout (consumerHandle, timeout * 1000  ,  &messageHandle) ) ;
		//MQReceiveMessageWithTimeout (consumerHandle, timeout * 1000  ,  &messageHandle);
    
		{
			//printf("get response data just finished\n");
			const MQInt8  *msgdata;
			MQInt32  msgdata_len;

			MQMessageType messageType;

      
			// Check message type 
			MQ_ERR_CHK( MQGetMessageType(messageHandle, &messageType) );
      
			if (messageType != MQ_BYTES_MESSAGE) {
        
				//printf("Received mesage is not MQ_BYTES_MESSAGE type.\n");
				MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );
		
				MQ_ERR_CHK( MQFreeMessage(messageHandle) );
        
				continue;
      
			}

			// Get message body 
			MQ_ERR_CHK( MQGetBytesMessageBytes(messageHandle, &msgdata,  &msgdata_len) );

	
			// Acknowledge the message 

			MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );
			//printf("get response data\n");
			join_resp = app_router_join_response__unpack( NULL, msgdata_len, ( const uint8_t * )msgdata );
			if (strcmp(join_resp->request_id, request_id) == 0 ) {
				//printf("get ture data!!!\n");
				MQ_ERR_CHK( MQFreeMessage(messageHandle) );
         
				break;
			}

			app_router_join_response__free_unpacked( join_resp, NULL );
			
			//* Free the message handle 
			MQ_ERR_CHK( MQFreeMessage(messageHandle) );
    
		} 

      
	} /** while **/
  
	/* Close the message consumer */
	MQ_ERR_CHK( MQCloseMessageConsumer(consumerHandle) );

	*val = 0;
	return  join_resp;


Cleanup:
  
	{ 
		if (MQGetStatusCode(status) == MQ_TIMEOUT_EXPIRED ) {                                                         
			*val = 1;                                                                                                   
		}                                                                                                             
		else {
			*val = -1; 
		}
		//printf("*val = %d in GetAppRouterJoninRespons\n",*val);
		MQString errorString = MQGetStatusString(status);
		printf("MQError = %s in GetAppRouterJoinResponse\n",errorString);
		MQFreeString(errorString);
	}
  
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );
	MQCloseMessageConsumer(consumerHandle);

	return  NULL;
}

int SendAppRouterQuitRequest( char *request_id, char *app_router_id, char *session_id )
{
	MQStatus status;

	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQProducerHandle producerHandle ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	AppRouterQuit  quit = APP_ROUTER_QUIT__INIT;
	unsigned char *packed = NULL; 
	size_t   quit_len=0;

	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	producerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	quit.request_id = request_id;
	quit.app_router_id = app_router_id;
	quit.session_id = session_id;

	quit_len = app_router_quit__get_packed_size( &quit );
	packed = malloc ( quit_len );
	app_router_quit__pack( &quit, packed );


	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.approuter.quit" , /* destinationName, */
                                  MQ_QUEUE_DESTINATION , /*  destinationType,  */
								  &destinationHandle) );

	/* Create a messagse producer for the destination */
	MQ_ERR_CHK( MQCreateMessageProducerForDestination(router_mq_handle_t.sessionHandle,
                                  destinationHandle, &producerHandle) );
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Create a message handle */
	MQ_ERR_CHK(MQCreateBytesMessage(&messageHandle) );
  
	/* Sending messages */

      
	/* Set message body */
	MQ_ERR_CHK( MQSetBytesMessageBytes(messageHandle,( const MQInt8 * ) packed, quit_len ) );

	//MQ_ERR_CHK( MQSendMessage(producerHandle, messageHandle) );
	MQ_ERR_CHK( MQSendMessageExt(producerHandle, messageHandle, MQ_NON_PERSISTENT_DELIVERY,4,600000) );
  
	MQ_ERR_CHK( MQFreeMessage(messageHandle) );
  
	/* Close the message producer */
	MQ_ERR_CHK( MQCloseMessageProducer(producerHandle) );

	free( packed );

	//printf("SendAppRouterQuitRequest is successful\n");
	return 0;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("MQError = %s in SendAppRouterQuitRequest\n",errorString);
		MQFreeString(errorString);
	}
  

	if ( packed )
		free( packed );

	MQCloseMessageProducer(producerHandle);
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );

	return -1;
}

AppRouterQuitResponse * GetAppRouterQuitResponse( char *request_id, char *app_router_id, char *session_id )
{
	MQStatus status;

	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQConsumerHandle consumerHandle  ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	//char *selector;

	AppRouterQuitResponse *quit_resp;

	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	consumerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;


	char selector[300]={0};
	//sprintf(selector,"AppRouterID='%s' and SessionID='%s'",app_router_id,session_id);

	sprintf(selector,"AppRouterID='%s' and SessionID='%s'",app_router_id, session_id);
	//selector = apr_pstrcat(router_mq_handle_t.tmp_pool, "AppRouterID='" , app_router_id, "'  and  ", 
	//  "SessionID='",  session_id , "'", NULL );   

	printf("Join selector: %s \n", selector);

	//selector = apr_pstrcat(router_mq_handle_t.tmp_pool, "AppRouterID='" , app_router_id, "'  and  ", 
	//	"SessionID='",  session_id , "'", NULL );	
  
	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.approuter.quit.response",
                                  MQ_QUEUE_DESTINATION, &destinationHandle) );

	/* Create a synchronous messagse consumer on the destination */
	MQ_ERR_CHK( MQCreateMessageConsumer(router_mq_handle_t.sessionHandle, destinationHandle,
                                      selector, MQ_TRUE, &consumerHandle) );
  
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Start the connection */
	MQ_ERR_CHK( MQStartConnection(router_mq_handle_t.connectionHandle) );
  
	/* Receiving messages */

  
	while (1) {

    
		//fprintf(stdout, "Waiting for message ...\n");
		MQ_ERR_CHK( MQReceiveMessageWait(consumerHandle, &messageHandle) );
    
		{
			const MQInt8  *msgdata;
			MQInt32  msgdata_len;

			MQMessageType messageType;

      
			/* Check message type */
			MQ_ERR_CHK( MQGetMessageType(messageHandle, &messageType) );
      
			if (messageType != MQ_BYTES_MESSAGE) {
        
				//fprintf(stdout, "Received mesage is not MQ_BYTES_MESSAGE type.\n");
				MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );
		
				MQ_ERR_CHK( MQFreeMessage(messageHandle) );
        
				continue;
      
			}

			/* Get message body */
			MQ_ERR_CHK( MQGetBytesMessageBytes(messageHandle, &msgdata,  &msgdata_len) );

	
			/* Acknowledge the message */

			MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );

			quit_resp = app_router_quit_response__unpack( NULL, msgdata_len, ( const uint8_t * )msgdata );
			if (strcmp(quit_resp->request_id, request_id) == 0 ) {
		
				MQ_ERR_CHK( MQFreeMessage(messageHandle) );
         
				break;
			}

			app_router_quit_response__free_unpacked( quit_resp, NULL );

			/* Free the message handle */
			MQ_ERR_CHK( MQFreeMessage(messageHandle) );
    
		} 

      
	} /** while **/
  
	/* Close the message consumer */
	MQ_ERR_CHK( MQCloseMessageConsumer(consumerHandle) );

	//printf("GetAppRouterQuitRespons is successful\n");
	return  quit_resp;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("MQError = %s in SendAppRouterQuitRequest\n",errorString);
		MQFreeString(errorString);
	}
  
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );
	MQCloseMessageConsumer(consumerHandle);

	return  NULL;
}

int SendAppRouterHeartBeat( char *app_router_id, char *session_id )
{
	MQStatus status;

	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQProducerHandle producerHandle ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	AppRouterHeartBeat  beat = APP_ROUTER_HEART_BEAT__INIT;
	unsigned char *packed = NULL; 
	size_t   beat_len=0;

	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	producerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	//beat.timestamp = apr_time_now() ;
	struct timeval tv;
	gettimeofday(&tv, NULL);
	beat.timestamp = tv.tv_sec ;
	beat.app_router_id = app_router_id;
	beat.session_id = session_id;

	beat_len = app_router_heart_beat__get_packed_size( &beat );
	packed = malloc ( beat_len );
	app_router_heart_beat__pack( &beat, packed );


	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.approuter.heartbeat" , /* destinationName, */
                                  MQ_QUEUE_DESTINATION , /*  destinationType,  */
								  &destinationHandle) );

	/* Create a messagse producer for the destination */
	MQ_ERR_CHK( MQCreateMessageProducerForDestination(router_mq_handle_t.sessionHandle,
                                  destinationHandle, &producerHandle) );
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Create a message handle */
	MQ_ERR_CHK(MQCreateBytesMessage(&messageHandle) );
  
	/* Sending messages */

      
	/* Set message body */
	MQ_ERR_CHK( MQSetBytesMessageBytes(messageHandle,( const MQInt8 * ) packed, beat_len ) );

	//MQ_ERR_CHK( MQSendMessage(producerHandle, messageHandle) );
	MQ_ERR_CHK( MQSendMessageExt(producerHandle, messageHandle, MQ_NON_PERSISTENT_DELIVERY,4,600000) );
  
	MQ_ERR_CHK( MQFreeMessage(messageHandle) );
  
	/* Close the message producer */
	MQ_ERR_CHK( MQCloseMessageProducer(producerHandle) );

	free( packed );

	//printf("send heart beat successful\n");
	return 0;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("MQError = %s in SendAppRouterHeartBeat\n",errorString);
		MQFreeString(errorString);
	}
  

	if ( packed )
		free( packed );
  
	MQCloseMessageProducer(producerHandle);
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );

	return -1;
}

void dumpAppRouterJoinResponse( AppRouterJoinResponse *join_resp )
{
	Cm__Omae__Base__ActionResult *action_result;

	printf("start dump join resp: [request id %s, session_id %s]\n", join_resp->request_id, join_resp->session_id	);

	action_result = join_resp->action_result;

	printf("action_result  result=%d\n", action_result->result );
	printf("n_app_router_map = %d\n", join_resp->n_app_router_map );


	printf("n_configuration = %d\n", join_resp->n_configuration );

	printf("end dump join resp\n" );

}

app_router_command_msg * GetAppRouterCommandMsg( int timeout, char *app_router_id, char *session_id, int *val )
{
	MQStatus status;

	MQPropertiesHandle propertiesHandle; // = MQ_INVALID_HANDLE;
	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQConsumerHandle consumerHandle; //  = MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle; // = MQ_INVALID_HANDLE;

	char *cmd_str;
	char *cmd_data;
	size_t cmd_data_len;

	app_router_command_msg *cmd_msg;
	//AppRouterMapCommand * command_resp = NULL;

	propertiesHandle.handle = (MQInt32)0xFEEEFEEE;
	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	consumerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.appmaster.approuter.command",
	//MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "mytest",
                                  MQ_TOPIC_DESTINATION, &destinationHandle) );

	/* Create a synchronous messagse consumer on the destination */
	MQ_ERR_CHK( MQCreateMessageConsumer(router_mq_handle_t.sessionHandle, destinationHandle,
                                     NULL , MQ_TRUE, &consumerHandle) );
  
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Start the connection */
	MQ_ERR_CHK( MQStartConnection(router_mq_handle_t.connectionHandle) );
  
	/* Receiving messages */

  
	while (1) {

		//printf("Waiting for message ...\n");
	//	MQ_ERR_CHK( MQReceiveMessageWait (consumerHandle,   &messageHandle) ) ;
		MQ_ERR_CHK( MQReceiveMessageWithTimeout (consumerHandle, timeout * 1000  ,  &messageHandle) ) ;

		{
			const MQInt8  *msgdata;
			MQInt32  msgdata_len;

			MQMessageType messageType;

			ConstMQString cmd_type;
			//char cmd_type[50]={0};
      
			/* Check message type */
			MQ_ERR_CHK( MQGetMessageType(messageHandle, &messageType) );


	/*		ConstMQString msgtext;
      
			if (messageType != MQ_TEXT_MESSAGE) {
			   fprintf(stdout, "Received mesage is not MQ_TEXT_MESSAGE type.\n");
			   MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );
			   MQ_ERR_CHK( MQFreeMessage(messageHandle) );
			   continue;
			   }

			MQ_ERR_CHK( MQGetTextMessageText(messageHandle, &msgtext) );
			fprintf(stdout, "Received message: %s\n", msgtext);*/

			if (messageType != MQ_BYTES_MESSAGE) {
        
				//fprintf(stdout, "Received mesage is not MQ_BYTES_MESSAGE type.\n");
				MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );
		
				MQ_ERR_CHK( MQFreeMessage(messageHandle) );
        
				//printf("Received mesage is not MQ_BYTES_MESSAGE type.\n");
				continue;
      
			}

			/* Get message body */
			MQ_ERR_CHK( MQGetBytesMessageBytes(messageHandle, &msgdata,  &msgdata_len) );
      
			/* Get message properties if any */

			status = MQGetMessageProperties(messageHandle, &propertiesHandle);
      
			if (MQGetStatusCode(status) != MQ_NO_MESSAGE_PROPERTIES) {
        
				MQ_ERR_CHK( status );
        
				//status = MQGetStringProperty(propertiesHandle, "Command", cmd_type); 
				status = MQGetStringProperty(propertiesHandle, "Command", &cmd_type); 
        
				if (MQGetStatusCode(status) != MQ_NOT_FOUND) {
          
					MQ_ERR_CHK( status );
          
					//command_resp = app_router_map_command__unpack( NULL, msgdata_len , ( const uint8_t * )msgdata);
					//printf("Property index=%d\n", index);

					cmd_str = strdup( cmd_type );
					cmd_data = malloc(msgdata_len);
					memcpy(cmd_data,msgdata,msgdata_len);
					cmd_data_len = msgdata_len;

					break;

        
				}
				else
					goto Cleanup; 


			}
			else
				goto Cleanup; 

        
    
		} 

      
	} /** while **/
  
	/* Free the properties handle */
	MQ_ERR_CHK( MQFreeProperties(propertiesHandle) );
	
	/* Acknowledge the message */

	MQ_ERR_CHK( MQAcknowledgeMessages(router_mq_handle_t.sessionHandle, messageHandle) );

	/* Free the message handle */
	MQ_ERR_CHK( MQFreeMessage(messageHandle) );

	/* Close the message consumer */
	MQ_ERR_CHK( MQCloseMessageConsumer(consumerHandle) );

	cmd_msg = malloc( sizeof( app_router_command_msg ) );

	cmd_msg->command = cmd_str;
	cmd_msg->data = cmd_data;
	cmd_msg->data_len  = cmd_data_len;

	return  cmd_msg;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		if (MQGetStatusCode(status) == MQ_TIMEOUT_EXPIRED ) {
			*val = 0;
		}
		else {
			*val = 1;
			printf("GetAppRouterCommandMsg  consumer(): Error: %s\n",(errorString == NULL) ? "NULL":errorString);
		}
		//printf("*val = %d in GetAppRouterCommandMsg\n",*val); 
		MQFreeString(errorString);
	}
			
	MQFreeProperties(propertiesHandle);
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );
	MQCloseMessageConsumer(consumerHandle);

	return  NULL;
}

int SendAppRouterMapCommandResponse( int result_code, char *request_id, char *app_router_id, char *session_id )
{
	MQStatus status;

	MQPropertiesHandle propertiesHandle; // = MQ_INVALID_HANDLE;
	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQProducerHandle producerHandle ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	AppRouterMapCommandResponse resp = APP_ROUTER_MAP_COMMAND_RESPONSE__INIT;
	Cm__Omae__Base__ActionResult action_result =CM__OMAE__BASE__ACTION_RESULT__INIT ;

	unsigned char *packed = NULL; 
	size_t   resp_len=0;

	propertiesHandle.handle = (MQInt32)0xFEEEFEEE;
	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	producerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	action_result.result = result_code;
	resp.action_result = & action_result;

	resp.request_id = request_id;
	resp.app_router_id = app_router_id;
	resp.session_id = session_id;

	resp_len = app_router_map_command_response__get_packed_size( &resp );
	packed = malloc ( resp_len );
	app_router_map_command_response__pack( &resp, packed );


	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.appmaster.approuter.command.response", /* destinationName, */
                                  MQ_QUEUE_DESTINATION , /*  destinationType,  */
								  &destinationHandle) );

	/* Create a messagse producer for the destination */
	MQ_ERR_CHK( MQCreateMessageProducerForDestination(router_mq_handle_t.sessionHandle,
                                  destinationHandle, &producerHandle) );
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Create a message handle */
	MQ_ERR_CHK(MQCreateBytesMessage(&messageHandle) );
  
	/* Sending messages */

	      
	/*  Set message properties if any */
	MQ_ERR_CHK( MQCreateProperties(&propertiesHandle) );
	MQ_ERR_CHK( MQSetStringProperty(propertiesHandle, "Command", "updateRouterMap") );
	MQ_ERR_CHK( MQSetMessageProperties(messageHandle, propertiesHandle) );
      
	/* Set message body */
	MQ_ERR_CHK( MQSetBytesMessageBytes(messageHandle,( const MQInt8 * ) packed, resp_len ) );

	//MQ_ERR_CHK( MQSendMessage(producerHandle, messageHandle) );
	MQ_ERR_CHK( MQSendMessageExt(producerHandle, messageHandle, MQ_NON_PERSISTENT_DELIVERY,4,600000) );
  
	MQ_ERR_CHK( MQFreeMessage(messageHandle) );
  
	/* Close the message producer */
	MQ_ERR_CHK( MQCloseMessageProducer(producerHandle) );

	free( packed );

	return 0;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("SendAppRouterCommandResponse: Error: %s\n",(errorString == NULL) ? "NULL":errorString);
		MQFreeString(errorString);
	}
  

	if ( packed )
		free( packed );

	MQCloseMessageProducer(producerHandle);
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );

	return -1;
}

int SendAppRouterMapRefreshResponse( int result_code, char *request_id, char *app_router_id, char *session_id )
{
	MQStatus status;

	MQPropertiesHandle propertiesHandle; // = MQ_INVALID_HANDLE;
	MQDestinationHandle destinationHandle; // = MQ_INVALID_HANDLE;
	MQProducerHandle producerHandle ; //= MQ_INVALID_HANDLE;
	MQMessageHandle messageHandle ; //= MQ_INVALID_HANDLE;

	AppRouterMapRefreshResponse resp = APP_ROUTER_MAP_REFRESH_RESPONSE__INIT;
	Cm__Omae__Base__ActionResult action_result =CM__OMAE__BASE__ACTION_RESULT__INIT ;

	unsigned char *packed = NULL; 
	size_t   resp_len=0;

	propertiesHandle.handle = (MQInt32)0xFEEEFEEE;
	destinationHandle.handle = (MQInt32)0xFEEEFEEE;
	producerHandle.handle = (MQInt32)0xFEEEFEEE;
	messageHandle.handle = (MQInt32)0xFEEEFEEE;

	action_result.result = result_code;
	resp.action_result = & action_result;

	resp.request_id = request_id;
	resp.app_router_id = app_router_id;
	resp.session_id = session_id;

	resp_len = app_router_map_refresh_response__get_packed_size( &resp );
	packed = malloc ( resp_len );
	app_router_map_refresh_response__pack( &resp, packed );


	/* Create a destination */
	MQ_ERR_CHK( MQCreateDestination(router_mq_handle_t.sessionHandle, "cm.omae.appmaster.approuter.command.response", /* destinationName, */
                                  MQ_QUEUE_DESTINATION , /*  destinationType,  */
								  &destinationHandle) );

	/* Create a messagse producer for the destination */
	MQ_ERR_CHK( MQCreateMessageProducerForDestination(router_mq_handle_t.sessionHandle,
                                  destinationHandle, &producerHandle) );
	/* Free the destination handle */
	MQ_ERR_CHK( MQFreeDestination(destinationHandle) );

	/* Create a message handle */
	MQ_ERR_CHK(MQCreateBytesMessage(&messageHandle) );
  
	/* Sending messages */

	      
	/*  Set message properties if any */
	MQ_ERR_CHK( MQCreateProperties(&propertiesHandle) );
	MQ_ERR_CHK( MQSetStringProperty(propertiesHandle, "Command", "refreshRouterMap") );
	MQ_ERR_CHK( MQSetMessageProperties(messageHandle, propertiesHandle) );
      
	/* Set message body */
	MQ_ERR_CHK( MQSetBytesMessageBytes(messageHandle,( const MQInt8 * ) packed, resp_len ) );

	//MQ_ERR_CHK( MQSendMessage(producerHandle, messageHandle) );
	MQ_ERR_CHK( MQSendMessageExt(producerHandle, messageHandle, MQ_NON_PERSISTENT_DELIVERY,4,600000) );

  
	MQ_ERR_CHK( MQFreeMessage(messageHandle) );
	MQFreeProperties(propertiesHandle);
  
	/* Close the message producer */
	MQ_ERR_CHK( MQCloseMessageProducer(producerHandle) );

	free( packed );

	return 0;

Cleanup:
	{ 
		MQString errorString = MQGetStatusString(status);
		printf("SendAppRouterMapRefreshResponse: Error: %s\n",(errorString == NULL) ? "NULL":errorString);
		MQFreeString(errorString);
	}
  

	if ( packed )
		free( packed );

	MQCloseMessageProducer(producerHandle);
	MQFreeProperties(propertiesHandle);
	MQFreeMessage(messageHandle);
	MQFreeDestination( destinationHandle );

	return -1;
}

