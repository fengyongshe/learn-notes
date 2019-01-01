#include<unistd.h>
#include "mq_proxy.h"
#include "md5.h"

//#define POSTURL "http://www.xiami.com/member/login"
#define POSTURL "http://127.0.0.1:8080/router_control"

const unsigned  cnCRC_16 = 0x8005;
const unsigned  cnCRC_CCITT = 0x1021;
const unsigned long cnCRC_32 = 0x04C10DB7;
unsigned long Table_CRC[256];
void BuildTable16( unsigned short aPoly )
{
	unsigned short i, j;
	unsigned short nData;
	unsigned short nAccum;

	for ( i = 0; i < 256; i++ )
	{
		nData = ( unsigned short )( i << 8 );
		nAccum = 0;
		for ( j = 0; j < 8; j++ )
		{
			if ( ( nData ^ nAccum ) & 0x8000 )
			  nAccum = ( nAccum << 1 ) ^ aPoly;
			else
			  nAccum <<= 1;
			nData <<= 1;
		}
		Table_CRC[i] = ( unsigned long )nAccum;
	}
}

unsigned short CRC_16( unsigned char * aData, unsigned long aSize )
{
	unsigned long i;
	unsigned short nAccum = 0;

	BuildTable16( cnCRC_16 ); // or cnCRC_CCITT 
	for ( i = 0; i < aSize; i++ )
	  nAccum = ( nAccum << 8 ) ^ ( unsigned short )Table_CRC[( nAccum >> 8 ) ^ *aData++];
	return nAccum % 1000;
}

int getTime(char *seq_num )
{
	char *wday[]={"星期日","星期一","星期二","星期三","星期四","星期五","星期六"};
	time_t curTime;
	struct tm *pTime;
	struct timeval tv;
	time(&curTime);
	printf("Second=%ld\n",curTime);
	pTime=localtime(&curTime);
	gettimeofday(&tv, NULL);
	printf("tv_sec; %ld\n", tv.tv_sec) ;
	printf("tv_usec; %ld\n",tv.tv_usec);
	printf("%d年%02d月%02d日",(1900+pTime->tm_year),(1+pTime->tm_mon),pTime->tm_mday);
	printf("%s %02d:%02d:%02d:%ld\n",wday[pTime->tm_wday],pTime->tm_hour,pTime->tm_min,pTime->tm_sec,tv.tv_usec);
	sprintf(seq_num,"%d%02d%02d%02d%02d%02d%ld",1900+pTime->tm_year,1+pTime->tm_mon,pTime->tm_mday,pTime->tm_hour,pTime->tm_min,pTime->tm_sec,tv.tv_usec);

	return 0;
}

int writelog(char* sLog,int nFlag)
{
	if(nFlag==0)
	{
		return -1;
	}
	time_t now;
	now = time(NULL);
	struct tm *tnow = localtime(&now);
	char sFileName[50] = {0};
	if(nFlag==1)
	{
		sprintf(sFileName,"./logs/%04d-%02d-%02d.log",tnow->tm_year+1900,tnow->tm_mon+1,tnow->tm_mday);
	}
	else if(nFlag==2)
	{
		sprintf(sFileName,"./logs/Error%04d-%02d-%02d.log",tnow->tm_year+1900,tnow->tm_mon+1,tnow->tm_mday);
	}
	else
	{
		return -2;
	}
	FILE *LogFile;
	LogFile = fopen(sFileName,"a");
	if(LogFile == NULL)
	{
		return -3;
	}
	else
	{
		fprintf(LogFile,"%02d:%02d:%02d: %s\n",tnow->tm_hour,tnow->tm_min,tnow->tm_sec,sLog);
		fclose(LogFile);
	}
	return 0;
}

int getparam_string(const char *param,char *buf,char *value,int value_size)
{
	int plen;

	plen=strlen(param);
	if (strncmp(buf,param,plen) != 0) return(0);
	buf+=plen;
	if ((unsigned char)*buf>' ') return(0);
	while (*buf && (unsigned char)*buf<=' ') buf++;

	strcpy(value,buf);

	return(1);
}
void getparam(char *buf)
{
	while(*buf && (unsigned char)*buf <= ' ')  buf++;
	if(*buf == '#' || *buf == '\0')
	  return;

	if(getparam_string("mq_host",buf,mq_host,sizeof(mq_host))>0) return;
	if(getparam_string("mq_port",buf,mq_port,sizeof(mq_port))>0) return;
	if(getparam_string("mq_user",buf,mq_user,sizeof(mq_user))>0) return;
	if(getparam_string("mq_passwd",buf,mq_passwd,sizeof(mq_passwd))>0) return;
	if(getparam_string("heart_beat_time",buf,heart_beat_time,sizeof(heart_beat_time))>0) return;
	if(getparam_string("proxy_router_id",buf,proxy_router_id,sizeof(proxy_router_id))>0) return;
	if(getparam_string("redis_path",buf,redis_path,sizeof(redis_path))>0) return;

	return;
}
void fixendofline(char *str)
{
	int i = strlen(str) - 1;
	for(i = strlen(str) -1; i  >= 0 && (unsigned char)str[i] <= ' '; i++)
	  str[i] = 0;
}
void getconf(char *ConfigFile)
{
	FILE *fp_in;
	char buf[512];

	if((fp_in = fopen(ConfigFile,"r")) == NULL)
	{
		fprintf(stderr,"SAR:can't open file %s\n",ConfigFile);
		exit(1);
	}

	while(fgets(buf,sizeof(buf),fp_in) != NULL)
	{
		fixendofline(buf);
		getparam(buf);
	}

	fclose(fp_in);
	return;
}
/*
void test_0()
{
	while(redis_init())
	{
		sleep(5);
	}
	char app_key[100]={0};
	strcpy(app_key,"myapp.1.123456");
	add_app_info(app_key, "0");
	add_app_domain(app_key, "myapp.omp.com");
	add_app_instance(app_key, "127.0.0.1:8001");
	add_app_instance(app_key, "127.0.0.1:8002");
	redisFree(redis_conn);
}*/

int add_app_info(char *app_key, char *quota)
{
	int reply_int = 0;
	redis_reply = redisCommand(redis_conn,"EXISTS %s", app_key);
	printf("EXISTS %s: %lld\n",app_key, redis_reply->integer);
	reply_int = 0;
	reply_int = redis_reply->integer;
	freeReplyObject(redis_reply);
	if(!reply_int)
	{
		redis_reply = redisCommand(redis_conn,"HMSET %s %s %d %s %d %s %s", app_key, "max_connections", 0, "auth", 0, "quota", quota);
		printf("HMSET INFO %s %s %d %s %d %s %s: %s\n",app_key, "max_connections", 0, "auth", 0, "quota", quota, redis_reply->str);
		freeReplyObject(redis_reply);

		return 0;
	}
	return 1;
}

int add_app_domain(char *app_key, char *app_domain)
{
	int reply_int = 0;
	redis_reply = redisCommand(redis_conn,"EXISTS %s", app_domain);
	printf("EXISTS %s: %lld\n", app_domain, redis_reply->integer);
	reply_int = 0;
	reply_int = redis_reply->integer;
	freeReplyObject(redis_reply);
	if(!reply_int)
	{
		redis_reply = redisCommand(redis_conn,"SET %s %s", app_domain, app_key);
		printf("SET %s %s: %s\n",app_domain, app_key, redis_reply->str);
		freeReplyObject(redis_reply);
		//add domain list
		redis_reply = redisCommand(redis_conn,"LPUSH %s %s", "app_domain_list" , app_domain);
		printf("LPUSH %s %s: %lld\n","app_domain_list" , app_domain, redis_reply->integer);
		freeReplyObject(redis_reply);
		//printf("add_app_domain_rec\n");
		//add app_key domain list
		redis_reply = redisCommand(redis_conn,"LPUSH %s_domain_list %s", app_key , app_domain);
		printf("LPUSH %s_domain_list %s: %lld\n",app_key , app_domain, redis_reply->integer);
		freeReplyObject(redis_reply);

		printf("addAppRouterMap  domain  %s\n", app_domain);
		return 0;
	}
	return 1;
}

int add_app_instance(char *app_key, char *app_instance, char *app_md5)
{
	char reply_str[200]={0}, md5_str[33]={0};
	int j = 0, instance_list_len = 0, instance_exist = 0;
	redis_reply = redisCommand(redis_conn,"LLEN %s_instance_list", app_key);
	printf("LLEN %s_instance_list: %lld\n",app_key, redis_reply->integer);
	instance_list_len = redis_reply->integer;
	freeReplyObject(redis_reply);

	for(j=0;j<instance_list_len;j++)
	{
		redis_reply = redisCommand(redis_conn,"LINDEX %s_instance_list %d", app_key, j);
		printf("LINDEX %s_instance_list %d: %s\n",app_key, j, redis_reply->str);
		memset(reply_str,0x00,200);
		strncpy(reply_str, redis_reply->str,redis_reply->len);
		freeReplyObject(redis_reply);
		if(!strcmp(reply_str,app_instance))
		{
			instance_exist = 1;
			break;
		}
	}

	if(instance_exist)
	{
		printf("addAppRouterMap  destination  %s exist!\n",app_instance);
		//return instance_exist;
		return 1;
	}
	redis_reply = redisCommand(redis_conn,"LPUSH %s_instance_list %s", app_key, app_instance);
	printf("LPUSH %s_instance_list %s: %lld\n",app_key, app_instance, redis_reply->integer);
	freeReplyObject(redis_reply);

	memset(md5_str,0x00,sizeof(md5_str));	
	strcat(md5_str,MDString(app_instance));
	printf("%s md5 val:%s\n", app_instance,md5_str);
	strcpy(app_md5, md5_str);
	//sprintf(app_md5,"%s_%s",app_key,md5_str);
	redis_reply = redisCommand(redis_conn,"MSET %s %s_%s %s_%s %s", app_instance, md5_str, app_key, md5_str, app_key, app_instance);
	printf("HMSET INFO %s %s_%s %s_%s %s: %s\n",app_instance, md5_str, app_key, md5_str, app_key, app_instance, redis_reply->str);
	freeReplyObject(redis_reply);

	printf("addAppRouterMap  destination  %s\n", app_instance);

	//return instance_exist;
	return 0;
}

int addAppRouterMap( Cm__Omae__Base__AppInfo *app_info, RouterMap * item_rm, char *commad_type, json_object *my_array)
{
	char app_key[200]={0}, app_md5[33]={0}, appname_md5[200]={0};
	int i=0 , res = -1;
	char seq_num[50] = {0};
	json_object *new_info_object = NULL, *new_domain_object = NULL, *new_instance_object = NULL;
	json_object *new_domain_array = NULL, *new_instance_array = NULL;
	json_object *new_instance_to_digest_object = NULL, *new_digest_to_instance_object = NULL;

	sprintf(app_key , "%s.%s.%s",app_info->id, app_info->version, app_info->sub_version );

	printf("addAppRouterMap app: %s, app_quota: %s\n", app_key, app_info->quota);

	res = add_app_info(app_key, app_info->quota);
	if(!res)
	{
		new_info_object = json_object_new_object();
		json_object_object_add(new_info_object, "command", json_object_new_string("set_app_info"));
		json_object_object_add(new_info_object, "type", json_object_new_string(commad_type));
		memset(seq_num,0x00,50);
		getTime(seq_num);
		json_object_object_add(new_info_object, "seq_num", json_object_new_string(seq_num));
		json_object_object_add(new_info_object, "app_name", json_object_new_string(app_key));
		json_object_object_add(new_info_object, "max_connections", json_object_new_string("0"));
		json_object_object_add(new_info_object, "quota", json_object_new_string(app_info->quota));
		json_object_object_add(new_info_object, "auth", json_object_new_string("0"));
		json_object_object_add(new_info_object, "auth_user", json_object_new_string("username"));
		json_object_object_add(new_info_object, "auth_pass", json_object_new_string("password"));
		json_object_object_add(new_info_object, "auth_method", json_object_new_string("basic"));

		int crc_16 = 0;
		crc_16 = CRC_16((unsigned char*)app_info->id,strlen(app_info->id));
		printf("crc_16=%d\n",crc_16);
		char crc_str[10]={0};
		sprintf(crc_str,"%d",crc_16);
		json_object_object_add(new_info_object, "app_hash", json_object_new_string(crc_str));

		json_object_array_add(my_array, new_info_object);
	}
	/* Try a GET */
	/*redis_reply = redisCommand(redis_conn,"EXISTS %s", app_key);
	printf("EXISTS %s: %lld\n",app_key, redis_reply->integer);
	reply_int = 0;
	reply_int = redis_reply->integer;
	freeReplyObject(redis_reply);
	if(!reply_int)
	{
		redis_reply = redisCommand(redis_conn,"HMSET %s %s %d %s %d %s %s", app_key, "max_connections", 0, "auth", 0, "quota", app_info->quota);
		printf("HMSET INFO %s %s %d %s %d %s %s: %s\n",app_key, "max_connections", 0, "auth", 0, "quota", app_info->quota, redis_reply->str);
		freeReplyObject(redis_reply);
	}*/

	//printf("item_rm->n_domain_name=%d\n",item_rm->n_domain_name);
	for( i=0; i < item_rm->n_domain_name; i++ )
	{
		res = add_app_domain(app_key, item_rm->domain_name[i]);
		if(!res)
		{
			if(new_domain_array == NULL)
			{
				new_domain_array = json_object_new_array();
			}
			json_object_array_add(new_domain_array, json_object_new_string(item_rm->domain_name[i]));
		}
		//printf("item_rm->domain_name[i]=%s\n",item_rm->domain_name[i]);
	/*	redis_reply = redisCommand(redis_conn,"EXISTS %s", item_rm->domain_name[i]);
		printf("EXISTS %s: %lld\n", item_rm->domain_name[i], redis_reply->integer);
		reply_int = 0;
		reply_int = redis_reply->integer;
		freeReplyObject(redis_reply);
		if(!reply_int)
		{
			redis_reply = redisCommand(redis_conn,"SET %s %s", item_rm->domain_name[i], app_key);
			printf("SET %s %s: %s\n",item_rm->domain_name[i], app_key, redis_reply->str);
			freeReplyObject(redis_reply);
			//add domain list
			redis_reply = redisCommand(redis_conn,"LPUSH %s %s", "app_domain_list" , item_rm->domain_name[i]);
			printf("LPUSH %s %s: %lld\n","app_domain_list" , item_rm->domain_name[i], redis_reply->integer);
			freeReplyObject(redis_reply);
			//printf("add_app_domain_rec\n");
			//add app_key domain list
			redis_reply = redisCommand(redis_conn,"LPUSH %s_domain_list %s", app_key , item_rm->domain_name[i]);
			printf("LPUSH %s_domain_list %s: %lld\n",app_key , item_rm->domain_name[i], redis_reply->integer);
			freeReplyObject(redis_reply);

			printf("addAppRouterMap  domain  %s\n", item_rm->domain_name[i]);
		}*/
	}
	if(new_domain_array)
	{
		new_domain_object = json_object_new_object();
		json_object_object_add(new_domain_object, "command", json_object_new_string("add_domain"));
		json_object_object_add(new_domain_object, "type", json_object_new_string(commad_type));
		memset(seq_num,0x00,50);
		getTime(seq_num);
		json_object_object_add(new_domain_object, "seq_num", json_object_new_string(seq_num));
		json_object_object_add(new_domain_object, "app_name", json_object_new_string(app_key));
		json_object_object_add(new_domain_object, "domain_set", new_domain_array);

		json_object_array_add(my_array, new_domain_object);
	}

	//printf("item_rm->n_destination=%d\n",item_rm->n_destination);
	for( i=0; i < item_rm->n_destination; i++ )
	{
		memset(app_md5,0x00,33);
		res = add_app_instance(app_key, item_rm->destination[i], app_md5);
		if(!res)
		{
			memset(appname_md5,0x00,200);
			sprintf(appname_md5,"%s_%s",app_key,app_md5);

			if(new_instance_array == NULL)
			{
				new_instance_array = json_object_new_array();
				new_instance_to_digest_object = json_object_new_object();
				new_digest_to_instance_object = json_object_new_object();
			}
			json_object_array_add(new_instance_array, json_object_new_string(item_rm->destination[i]));

			json_object_object_add(new_instance_to_digest_object, "command", json_object_new_string("set_instance_to_digest"));
			json_object_object_add(new_instance_to_digest_object, "type", json_object_new_string(commad_type));
			memset(seq_num,0x00,50);
			getTime(seq_num);
			json_object_object_add(new_instance_to_digest_object, "seq_num", json_object_new_string(seq_num));
			json_object_object_add(new_instance_to_digest_object, "instance", json_object_new_string(item_rm->destination[i]));
			json_object_object_add(new_instance_to_digest_object, "digest", json_object_new_string(app_md5));

			json_object_array_add(my_array, new_instance_to_digest_object);

			json_object_object_add(new_digest_to_instance_object, "command", json_object_new_string("set_digest_to_instance"));
			json_object_object_add(new_digest_to_instance_object, "type", json_object_new_string(commad_type));
			memset(seq_num,0x00,50);
			getTime(seq_num);
			json_object_object_add(new_digest_to_instance_object, "seq_num", json_object_new_string(seq_num));
			json_object_object_add(new_digest_to_instance_object, "digest", json_object_new_string(appname_md5));
			json_object_object_add(new_digest_to_instance_object, "instance", json_object_new_string(item_rm->destination[i]));

			json_object_array_add(my_array, new_digest_to_instance_object);
		}
		//printf("item_rm->destination[i]=%s\n",item_rm->destination[i]);
		//rec = find_app_instance_rec( info, item_rm->destination[i] );
	/*	int j = 0, instance_list_len = 0, instance_exist = 0;
		redis_reply = redisCommand(redis_conn,"LLEN %s_instance_list", app_key);
		printf("LLEN %s_instance_list: %lld\n",app_key, redis_reply->integer);
		instance_list_len = redis_reply->integer;
		freeReplyObject(redis_reply);

		for(j=0;j<instance_list_len;j++)
		{
			redis_reply = redisCommand(redis_conn,"LINDEX %s_instance_list %d", app_key, j);
			printf("LINDEX %s_instance_list %d: %s\n",app_key, j, redis_reply->str);
			memset(reply_str,0x00,50);
			strncpy(reply_str, redis_reply->str,redis_reply->len);
			freeReplyObject(redis_reply);
			if(!strcmp(reply_str,item_rm->destination[i]))
			{
				instance_exist = 1;
				break;
			}
		}
		
		if(instance_exist)
		{
			printf("addAppRouterMap  destination  %s exist!\n",item_rm->destination[i]);
			continue;
		}
		redis_reply = redisCommand(redis_conn,"LPUSH %s_instance_list %s", app_key, item_rm->destination[i]);
		printf("LPUSH %s_instance_list %s: %lld\n",app_key, item_rm->destination[i], redis_reply->integer);
		freeReplyObject(redis_reply);

		memset(md5_str,0x00,sizeof(md5_str));	
		strcat(md5_str,MDString(item_rm->destination[i]));
		printf("%s md5 val:%s\n", item_rm->destination[i],md5_str);
		redis_reply = redisCommand(redis_conn,"MSET %s %s %s %s", item_rm->destination[i], md5_str, md5_str, item_rm->destination[i]);
		printf("HMSET INFO %s %s %s %s: %s\n",item_rm->destination[i], md5_str, md5_str, item_rm->destination[i], redis_reply->str);
		freeReplyObject(redis_reply);

		printf("addAppRouterMap  destination  %s\n", item_rm->destination[i]);*/
	}
	if(new_instance_array)
	{
		new_instance_object = json_object_new_object();
		json_object_object_add(new_instance_object, "command", json_object_new_string("add_instance"));
		json_object_object_add(new_instance_object, "type", json_object_new_string(commad_type));
		memset(seq_num,0x00,50);
		getTime(seq_num);
		json_object_object_add(new_instance_object, "seq_num", json_object_new_string(seq_num));
		json_object_object_add(new_instance_object, "app_name", json_object_new_string(app_key));
		json_object_object_add(new_instance_object, "instance_set", new_instance_array);

		json_object_array_add(my_array, new_instance_object);
	}

	return 0;
}

int del_app_info(char *app_key)
{
	int appkey_domain_list_len = 0, i=0;
	int appkey_instance_list_len = 0;
	char reply_str[200]={0}, app_instance[200]={0};

	redis_reply = redisCommand(redis_conn,"LLEN %s_domain_list", app_key);
	printf("LLEN %s_domain_list: %lld\n",app_key, redis_reply->integer);
	appkey_domain_list_len = redis_reply->integer;
	freeReplyObject(redis_reply);

	for(i=0;i<appkey_domain_list_len;i++)
	{
		redis_reply = redisCommand(redis_conn,"LINDEX %s_domain_list %d", app_key, i);
		printf("LINDEX %s_domain_list %d: %s\n",app_key, i, redis_reply->str);
		memset(reply_str,0x00,200);
		strncpy(reply_str, redis_reply->str,redis_reply->len);
		freeReplyObject(redis_reply);

		redis_reply = redisCommand(redis_conn,"LREM %s %d %s", "app_domain_list", 1, reply_str);
		printf("LREM %s %d %s: %lld\n", "app_domain_list", 1, reply_str, redis_reply->integer);
		freeReplyObject(redis_reply);

		redis_reply = redisCommand(redis_conn,"DEL %s", reply_str);
		printf("DEL %s: %lld\n", reply_str, redis_reply->integer);
		freeReplyObject(redis_reply);
		break;
	}

	redis_reply = redisCommand(redis_conn,"LLEN %s_instance_list", app_key);
	printf("LLEN %s_instance_list: %lld\n",app_key, redis_reply->integer);
	appkey_instance_list_len = redis_reply->integer;
	freeReplyObject(redis_reply);

	for(i=0;i<appkey_instance_list_len;i++)
	{
		redis_reply = redisCommand(redis_conn,"LINDEX %s_instance_list %d", app_key, i);
		printf("LINDEX %s_instance_list %d: %s\n",app_key , i, redis_reply->str);
		memset(app_instance,0x00,200);
		strncpy(app_instance, redis_reply->str,redis_reply->len);
		freeReplyObject(redis_reply);

		redis_reply = redisCommand(redis_conn,"GET %s", app_instance);
		printf("GET %s: %s\n",app_instance, redis_reply->str);
		memset(reply_str,0x00,200);
		strncpy(reply_str, redis_reply->str,redis_reply->len);
		freeReplyObject(redis_reply);
		if(strlen(reply_str))
		{
			redis_reply = redisCommand(redis_conn,"DEL %s %s", reply_str, app_instance);
			printf("DEL %s %s: %lld\n", reply_str, app_instance, redis_reply->integer);
			freeReplyObject(redis_reply);
		}
	}

	redis_reply = redisCommand(redis_conn,"DEL %s %s_domain_list %s_instance_list", app_key, app_key, app_key);
	printf("DEL %s %s_domain_list %s_instance_list: %lld\n",app_key, app_key, app_key, redis_reply->integer);
	freeReplyObject(redis_reply);
	printf("remove_app_info_rec\n");

	return 0;
}

int del_app_instance(char *app_key, char *app_instance)
{
	char reply_str[200]={0};
	redis_reply = redisCommand(redis_conn,"LREM %s_instance_list %d %s", app_key, 1, app_instance);
	printf("LLEN %s_instance_list %d %s: %lld\n",app_key , 1, app_instance, redis_reply->integer);
	freeReplyObject(redis_reply);

	redis_reply = redisCommand(redis_conn,"GET %s", app_instance);
	printf("GET %s: %s\n",app_instance, redis_reply->str);
	memset(reply_str,0x00,200);
	strncpy(reply_str, redis_reply->str,redis_reply->len);
	freeReplyObject(redis_reply);
	if(strlen(reply_str))
	{
		redis_reply = redisCommand(redis_conn,"DEL %s %s", reply_str, app_instance);
		printf("DEL %s %s: %lld\n", reply_str, app_instance, redis_reply->integer);
		freeReplyObject(redis_reply);
	}

	printf("deleteAppRouterMap  destination  %s\n", app_instance);
	return 0;
}

int del_app_domain(char *app_key)
{
	char reply_str[200]={0};
	int appkey_instance_list_len = 0, i=0;

	redis_reply = redisCommand(redis_conn,"LLEN %s_instance_list", app_key);
	printf("LLEN %s_instance_list: %lld\n",app_key, redis_reply->integer);
	appkey_instance_list_len = redis_reply->integer;
	freeReplyObject(redis_reply);

	if(!appkey_instance_list_len)
	{
		//printf("item_rm->n_domain_name=%d\n",item_rm->n_domain_name);
		int appkey_domain_list_len = 0;

		redis_reply = redisCommand(redis_conn,"LLEN %s_domain_list", app_key);
		printf("LLEN %s_domain_list: %lld\n",app_key, redis_reply->integer);
		appkey_domain_list_len = redis_reply->integer;
		freeReplyObject(redis_reply);

		for(i=0;i<appkey_domain_list_len;i++)
		{
			redis_reply = redisCommand(redis_conn,"LINDEX %s_domain_list %d", app_key, i);
			printf("LINDEX %s_domain_list %d: %s\n",app_key, i, redis_reply->str);
			memset(reply_str,0x00,200);
			strncpy(reply_str, redis_reply->str,redis_reply->len);
			freeReplyObject(redis_reply);

			redis_reply = redisCommand(redis_conn,"LREM %s %d %s", "app_domain_list", 1, reply_str);
			printf("LREM %s %d %s: %lld\n", "app_domain_list", 1, reply_str, redis_reply->integer);
			freeReplyObject(redis_reply);

			redis_reply = redisCommand(redis_conn,"DEL %s", reply_str);
			printf("DEL %s: %lld\n", reply_str, redis_reply->integer);
			freeReplyObject(redis_reply);
			break;
		}

		redis_reply = redisCommand(redis_conn,"DEL %s %s_domain_list %s_instance_list", app_key, app_key, app_key);
		printf("DEL %s %s_domain_list %s_instance_list: %lld\n",app_key, app_key, app_key, redis_reply->integer);
		freeReplyObject(redis_reply);

		printf("deleteAppRouterMap  domain\n");
		return appkey_instance_list_len;
	}
	return appkey_instance_list_len;
}

int deleteAppRouterMap( Cm__Omae__Base__AppInfo *app_info, RouterMap * item_rm, char *commad_type, json_object *my_array)
{
	char app_key[200]={0};
	int i=0, res=-1;
	char seq_num[50]={0};
	json_object *new_info_object = NULL, *new_instance_object = NULL;
	json_object *new_info_array = NULL, *new_instance_array = NULL;

	sprintf(app_key , "%s.%s.%s",app_info->id, app_info->version, app_info->sub_version );

	printf("deleteAppRouterMap app: %s\n", app_key);

	/* remove  the app info . */
	//printf("remove_app_info_rec begining!\n");
	if ( item_rm->n_domain_name == 0 &&  item_rm->n_destination == 0 )
	{
		del_app_info(app_key);
		new_info_array = json_object_new_array();
		json_object_array_add(new_info_array, json_object_new_string(app_key));

		new_info_object = json_object_new_object();
		json_object_object_add(new_info_object, "command", json_object_new_string("del_app_info"));
		json_object_object_add(new_info_object, "type", json_object_new_string(commad_type));
		memset(seq_num,0x00,50);
		getTime(seq_num);
		json_object_object_add(new_info_object, "seq_num", json_object_new_string(seq_num));
		json_object_object_add(new_info_object, "app_name_set", new_info_array);

		json_object_array_add(my_array, new_info_object);
		/*int appkey_domain_list_len = 0;

		redis_reply = redisCommand(redis_conn,"LLEN %s_domain_list", app_key);
		printf("LLEN %s_domain_list: %lld\n",app_key, redis_reply->integer);
		appkey_domain_list_len = redis_reply->integer;
		freeReplyObject(redis_reply);

		for(i=0;i<appkey_domain_list_len;i++)
		{
			redis_reply = redisCommand(redis_conn,"LINDEX %s_domain_list %d", app_key, i);
			printf("LINDEX %s_domain_list %d: %s\n",app_key, i, redis_reply->str);
			memset(reply_str,0x00,50);
			strncpy(reply_str, redis_reply->str,redis_reply->len);
			freeReplyObject(redis_reply);

			redis_reply = redisCommand(redis_conn,"LREM %s %d %s", "app_domain_list", 1, reply_str);
			printf("LREM %s %d %s: %lld\n", "app_domain_list", 1, reply_str, redis_reply->integer);
			freeReplyObject(redis_reply);
			break;
		}

		redis_reply = redisCommand(redis_conn,"DEL %s %s_domain_list %s_instance_list", app_key, app_key, app_key);
		printf("DEL %s %s_domain_list %s_instance_list: %lld\n",app_key, app_key, app_key, redis_reply->integer);
		freeReplyObject(redis_reply);
		printf("remove_app_info_rec\n");*/
		return 0;
	}
	printf("item_rm->n_destination=%d\n",item_rm->n_destination);
	for( i=0; i < item_rm->n_destination; i++ )
	{
		//printf("info->instance_count=%d in delete_app\n",info->instance_count);
		del_app_instance(app_key,item_rm->destination[i]);
		if(new_instance_array == NULL)
		{
			new_instance_array = json_object_new_array();
		}
		json_object_array_add(new_instance_array, json_object_new_string(item_rm->destination[i]));

		/*redis_reply = redisCommand(redis_conn,"LREM %s_instance_list %d %s", app_key, 1, item_rm->destination[i]);
		printf("LLEN %s_instance_list %d %s: %lld\n",app_key, 1, item_rm->destination[i], redis_reply->integer);
		freeReplyObject(redis_reply);

		redis_reply = redisCommand(redis_conn,"GET %s", item_rm->destination[i]);
		printf("GET %s: %s\n",item_rm->destination[i], redis_reply->str);
		memset(reply_str,0x00,50);
		strncpy(reply_str, redis_reply->str,redis_reply->len);
		freeReplyObject(redis_reply);
		if(strlen(reply_str))
		{
			redis_reply = redisCommand(redis_conn,"DEL %s %s", reply_str, item_rm->destination[i]);
			printf("DEL %s %s: %lld\n", reply_str, item_rm->destination[i], redis_reply->integer);
			freeReplyObject(redis_reply);
		}

		printf("deleteAppRouterMap  destination  %s\n", item_rm->destination[i]);
		*/
	}
	if(new_instance_array)
	{
		new_instance_object = json_object_new_object();
		json_object_object_add(new_instance_object, "command", json_object_new_string("del_instance"));
		json_object_object_add(new_instance_object, "type", json_object_new_string(commad_type));
		memset(seq_num,0x00,50);
		getTime(seq_num);
		json_object_object_add(new_instance_object, "seq_num", json_object_new_string(seq_num));
		json_object_object_add(new_instance_object, "app_name", json_object_new_string(app_key));
		json_object_object_add(new_instance_object, "instance_set", new_instance_array);

		json_object_array_add(my_array, new_instance_object);
	}
	//printf("remove_app_instance_rec end!\n");
	//printf("info->instance_count=%d in delete_app\n",info->instance_count);
	res = del_app_domain(app_key);
	if(!res)
	{
		new_info_array = json_object_new_array();
		json_object_array_add(new_info_array, json_object_new_string(app_key));

		new_info_object = json_object_new_object();
		json_object_object_add(new_info_object, "command", json_object_new_string("del_app_info"));
		json_object_object_add(new_info_object, "type", json_object_new_string(commad_type));
		memset(seq_num,0x00,50);
		getTime(seq_num);
		json_object_object_add(new_info_object, "seq_num", json_object_new_string(seq_num));
		json_object_object_add(new_info_object, "app_name_set", new_info_array);

		json_object_array_add(my_array, new_info_object);

	}
	/*int appkey_instance_list_len = 0;

	redis_reply = redisCommand(redis_conn,"LLEN %s_instance_list", app_key);
	printf("LLEN %s_instance_list: %lld\n",app_key, redis_reply->integer);
	appkey_instance_list_len = redis_reply->integer;
	freeReplyObject(redis_reply);

	if(!appkey_instance_list_len)
	{
		//printf("item_rm->n_domain_name=%d\n",item_rm->n_domain_name);
		int appkey_domain_list_len = 0;

		redis_reply = redisCommand(redis_conn,"LLEN %s_domain_list", app_key);
		printf("LLEN %s_domain_list: %lld\n",app_key, redis_reply->integer);
		appkey_domain_list_len = redis_reply->integer;
		freeReplyObject(redis_reply);

		for(i=0;i<appkey_domain_list_len;i++)
		{
			redis_reply = redisCommand(redis_conn,"LINDEX %s_domain_list %d", app_key, i);
			printf("LINDEX %s_domain_list %d: %s\n",app_key, i, redis_reply->str);
			memset(reply_str,0x00,50);
			strncpy(reply_str, redis_reply->str,redis_reply->len);
			freeReplyObject(redis_reply);

			redis_reply = redisCommand(redis_conn,"LREM %s %d %s", "app_domain_list", 1, reply_str);
			printf("LREM %s %d %s: %lld\n", "app_domain_list", 1, reply_str, redis_reply->integer);
			freeReplyObject(redis_reply);
			break;
		}

		redis_reply = redisCommand(redis_conn,"DEL %s %s_domain_list %s_instance_list", app_key, app_key, app_key);
		printf("DEL %s %s_domain_list %s_instance_list: %lld\n",app_key, app_key, app_key, redis_reply->integer);
		freeReplyObject(redis_reply);
		printf("remove_app_info_rec\n");

		printf("deleteAppRouterMap  domain  %s\n", item_rm->domain_name[i]);
	}

		*/
	return 0;
}



int updateAppQuota( Cm__Omae__Base__AppInfo *app_info, RouterMap * item_rm, char *commad_type, json_object *my_array )
{
	char app_key[200]={0}, reply_str[200]={0};
	char seq_num[50]={0};

	sprintf(app_key , "%s.%s.%s",app_info->id, app_info->version, app_info->sub_version );

	printf("updateAppQuota app %s, AppQuota %s\n", app_key, app_info->quota);

	/* Try a GET */
	redis_reply = redisCommand(redis_conn,"GET %s", app_key);
	printf("GET %s: %s\n",app_key, redis_reply->str);
	memset(reply_str,0x00,200);
	strncpy(reply_str, redis_reply->str,redis_reply->len);
	freeReplyObject(redis_reply);
	if((!strlen(reply_str))||(strcmp(reply_str,"OK")))
	{
		printf("updateAppQuota app %s not exist\n", app_key );
		return 1;
	}

	json_object *new_info_object = NULL;
	new_info_object = json_object_new_object();
	json_object_object_add(new_info_object, "command", json_object_new_string("set_app_info"));
	json_object_object_add(new_info_object, "type", json_object_new_string(commad_type));
	memset(seq_num,0x00,50);
	getTime(seq_num);
	json_object_object_add(new_info_object, "seq_num", json_object_new_string(seq_num));
	json_object_object_add(new_info_object, "app_name", json_object_new_string(app_key));

	if(app_info->quota == NULL)
	{
		//strcpy(info->app_quota,"0");
		redis_reply = redisCommand(redis_conn,"HSET %s %s %s", app_key, "quota", "0");
		printf("HSET app_quota %s %s %s: %s\n",app_key, "quota", app_info->quota, redis_reply->str);
		freeReplyObject(redis_reply);

		json_object_object_add(new_info_object, "quota", json_object_new_string("0"));
	}
	else
	{
		//strcpy(info->app_quota,app_info->quota);
		redis_reply = redisCommand(redis_conn,"HSET %s %s %s", app_key, "quota", app_info->quota);
		printf("HSET app_quota %s %s %s: %s\n",app_key, "quota", app_info->quota, redis_reply->str);
		freeReplyObject(redis_reply);

		json_object_object_add(new_info_object, "quota", json_object_new_string(app_info->quota));
	}

	json_object_array_add(my_array, new_info_object);

	return 0;
}

int redis_init()
{
	struct timeval timeout = { 1, 500000 }; // 1.5 seconds
	//c = redisConnectWithTimeout((char*)"127.0.0.1", 6379, timeout);
	//redis_conn = redisConnectUnixWithTimeout((char*)"/tmp/redis.sock", timeout);
	redis_conn = redisConnectUnixWithTimeout(redis_path, timeout);
	if (redis_conn->err) {
		printf("Connection error: %s\n", redis_conn->errstr);
		return 1;
	}
	return 0;
}

int curl_execute(json_object *my_object)
{
	CURL *curl;      
	CURLcode res;
	int i = 0;

	curl = curl_easy_init();
	curl_easy_setopt(curl, CURLOPT_URL, POSTURL);
	curl_easy_setopt(curl, CURLOPT_POST, 1);      
	curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);   
	curl_easy_setopt(curl, CURLOPT_HEADER, 1);
	curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
	struct curl_slist *chunk = NULL;
	chunk = curl_slist_append(chunk, "Expect:");
	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chunk);

	curl_easy_setopt(curl, CURLOPT_POSTFIELDS, json_object_get_string(my_object));
	//curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "1234567890");
	//curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, sizeof(data));
	i = 0;
	while(i < 3)
	{
		res = curl_easy_perform(curl);
		printf("*********************************curl_easy_perform curlcode = %d\n",res);
		if(!res)
		{
			break;
		}
		i++;
		sleep(3);
	}
	long http_res_code = 0;
	i = 0;
	while(i < 3)
	{
		res = curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE , &http_res_code);
		printf("**********************http response code=%ld\n",http_res_code);
		if(http_res_code == 200)
		{
			break;
		}
		i++;
		sleep(3);
	}
	curl_slist_free_all(chunk);
	curl_easy_cleanup(curl);
	return 0;
}

int main()
{
	getconf("mqproxy.conf");

	//test_0();
	//printf("heart_beat_time=%s\n",heart_beat_time);
    time_t   timeout_tv =  atoi(heart_beat_time);
	time_t  last_heartbeat = 0;
	time_t  now_time;
	int JoinResTimeOut = 60;

	int  i=0;
    int return_val = 0, join_rep_val = 1;

	char   mq_session_id[50]={0};
	char   mq_request_id[50]={0};

	AppRouterJoinResponse * join_resp = NULL;
	AppRouterQuitResponse * quit_resp = NULL;
	app_router_command_msg *cmd_msg = NULL;
	json_object *my_array = NULL, *my_object = NULL;

	/* get session id for this mq conection.  */
	get_uuid_string( mq_session_id );
	//create_router_mq_handle("mq.omp.com", 7676, "admin", "admin" , mq_session_id );
	printf("mq_host=%s\n",mq_host);
	printf("mq_port=%s\n",mq_port);
	printf("mq_user=%s\n",mq_user);
	printf("mq_passwd=%s\n",mq_passwd);
	create_router_mq_handle(mq_host, atoi(mq_port), mq_user, mq_passwd, mq_session_id );

    while(1){
		cleanup_router_mq_handle();
		while(setup_router_mq_handle() < 0)
		{
			sleep(30);
		}
		int join_val = -1;
		while(1)
		{
			get_uuid_string( mq_request_id );
			join_val = SendAppRouterJoinRequest( mq_request_id, proxy_router_id , mq_session_id );
			//join_val = 0;
			if(!join_val)
			{
				join_resp = GetAppRouterJoinResponse( mq_request_id, proxy_router_id ,mq_session_id ,JoinResTimeOut,&join_rep_val );
				if(join_rep_val == 1)//timeout
				{
					if(JoinResTimeOut < 300)
					{
						JoinResTimeOut = JoinResTimeOut + 20;
					}
					else
					{
						JoinResTimeOut = 300;
					}
					continue;
				}
				else if(join_rep_val == 0)//return ture
				{
					break;
				}
				else if(join_rep_val == -1)//connect is close
				{
					join_val = -1;
					break;
				}
			}
			else
			{
				break;
			}

		}//while(1)
		if(join_resp && (!join_val)) 
		{
			printf("GetAppRouterJoinResponse!\n");
			
			//do clean redis data flashall redis
			while(redis_init())
			{
				sleep(5);
			}
			redis_reply = redisCommand(redis_conn,"FLUSHALL");
			printf("FLUSHALL: %s\n", redis_reply->str);
			freeReplyObject(redis_reply);

			my_array = json_object_new_array();
			
			for( i=0; i< join_resp->n_app_router_map; i++ )
			{
				AppRouterMap * item = join_resp->app_router_map[i];
				int  j;

				printf("appRouterMap n_router_map %d\n", item->n_router_map);

				for( j=0; j < item->n_router_map ; j++ )
				{
					RouterMap * item_rm = item->router_map[j];

					addAppRouterMap( item->app_info, item_rm, "refresh", my_array );

				}

			}
			redisFree(redis_conn);

			if(json_object_array_length(my_array))
			{
				my_object = json_object_new_object();
				json_object_object_add(my_object, "batched_commands", my_array);
				printf("my_object.to_string()=%s\n", json_object_to_json_string(my_object));
				curl_execute(my_object);
				json_object_put(my_object);
			}
			else
			{
				json_object_put(my_array);
			}
			dumpAppRouterJoinResponse( join_resp );
			app_router_join_response__free_unpacked( join_resp, NULL );
		
		while (1)
		{
			return_val = 0;
			printf("GetAppRouterCommandMsg is start...\n");
			cmd_msg = GetAppRouterCommandMsg( 30 , proxy_router_id , mq_session_id, &return_val ); 
			printf("GetAppRouterCommandMsg is end...\n");

			if ( cmd_msg )
			{
				printf("appRouter thread get cmd msg %s!\n", cmd_msg->command );
				my_array = json_object_new_array();
			
				if ( strcmp( cmd_msg->command , "updateRouterMap") == 0 )
				{
					AppRouterMapCommand  *command;
					RouterMapCommand * cmd_rm;
				
					command = app_router_map_command__unpack( NULL, cmd_msg->data_len , ( const uint8_t * )cmd_msg->data);

					while(redis_init())
					{
						sleep(5);
					}
					for( i=0; i < command->n_router_map_command; i++ )
					{
						printf("command->n_router_map_command=%d\n",command->n_router_map_command);
						cmd_rm = command->router_map_command[i];
						//printf("cmd_rm->operation=%d\n",cmd_rm->operation);
						if ( cmd_rm->operation == ROUTER_MAP_OPERATION__ADD )
						{
							printf("wrlock in ADD updateroutermap start...\n");
							addAppRouterMap( command->appinfo, cmd_rm->router_map, "update", my_array);

							printf("rdlock in ADD updateroutermap end...\n");
						}
						else if ( cmd_rm->operation == ROUTER_MAP_OPERATION__DELETE )
						{

							printf("wrlock in DELETE updateroutermap start...\n");
							
							//printf("rdlock in DELETE updateroutermap working...\n");
							deleteAppRouterMap( command->appinfo, cmd_rm->router_map, "update", my_array);

							//router->del_op_count ++;
							printf("rdlock in DELETE updateroutermap end...\n");
					
						}
					}
					redisFree(redis_conn);
					SendAppRouterMapCommandResponse( 1, command->request_id, proxy_router_id, mq_session_id );
					//  free  message.  
					app_router_map_command__free_unpacked( command , NULL);

				}
				else if ( strcmp( cmd_msg->command,  "refreshRouterMap" ) == 0 )
				{
					AppRouterMapRefresh  *refresh;

					refresh =  app_router_map_refresh__unpack( NULL, cmd_msg->data_len , ( const uint8_t * )cmd_msg->data);

					printf("refreshRouterMap n_app_router_map %d\n",refresh->n_app_router_map);

					// clear old data. 
					while(redis_init())
					{
						sleep(5);
					}
					redis_reply = redisCommand(redis_conn,"FLUSHALL");
					printf("FLUSHALL: %s\n", redis_reply->str);
					freeReplyObject(redis_reply);

					for( i=0; i< refresh->n_app_router_map; i++ )
					{
						AppRouterMap * item = refresh->app_router_map[i];
						size_t  j;

						printf("appRouterMap n_router_map %d\n", item->n_router_map);

						for( j=0; j < item->n_router_map ; j++ )
						{
							RouterMap * item_rm = item->router_map[j];

							addAppRouterMap( item->app_info, item_rm, "refresh", my_array);

						}

					}
					redisFree(redis_conn);
					// send command  response. 
					SendAppRouterMapRefreshResponse( 1, refresh->request_id, proxy_router_id, mq_session_id );

					//  free  message.  
					app_router_map_refresh__free_unpacked( refresh, NULL );
					

				}
				else if ( strcmp( cmd_msg->command,  "appOutOfQuota" ) == 0 )
				{
					AppRouterMapRefresh  *refresh;

					refresh =  app_router_map_refresh__unpack( NULL, cmd_msg->data_len , ( const uint8_t * )cmd_msg->data);

					printf("appOutOfQuota n_app_router_map %d\n",refresh->n_app_router_map);

					while(redis_init())
					{
						sleep(5);
					}
					for( i=0; i< refresh->n_app_router_map; i++ )
					{
						AppRouterMap * item = refresh->app_router_map[i];
						size_t  j;

						printf("appRouterMap n_router_map %d\n", item->n_router_map);

						for( j=0; j < item->n_router_map ; j++ )
						{
							RouterMap * item_rm = item->router_map[j];

							updateAppQuota( item->app_info, item_rm, "update", my_array);

						}

					}

					redisFree(redis_conn);
					// send command  response. 
					SendAppRouterMapRefreshResponse( 1, refresh->request_id, proxy_router_id, mq_session_id );
					//  free  message.  
					app_router_map_refresh__free_unpacked( refresh, NULL );
				}
				free(cmd_msg->command);
				free(cmd_msg->data);
				free(cmd_msg);

				if(json_object_array_length(my_array))
				{
					my_object = json_object_new_object();
					json_object_object_add(my_object, "batched_commands", my_array);
					printf("my_object.to_string()=%s\n", json_object_to_json_string(my_object));
					curl_execute(my_object);
					json_object_put(my_object);
				}
				else
				{
					json_object_put(my_array);
				}
			}

			time(&now_time);

			//printf("last_heartbeat=%d\n",last_heartbeat);
			//printf("now_time=%d\n",now_time);
			if ( now_time > last_heartbeat + timeout_tv )
			{
				printf("appRouter send heart beat!\n");
				SendAppRouterHeartBeat( proxy_router_id , mq_session_id  );
				last_heartbeat = now_time ;
			}

			if(return_val)
			{
				break;
			}

			}//while ( ! router->stop_thd  )
		 
		 }//if(join_resp && (!join_val))

    }//while ( ! router->stop_thd  )

	get_uuid_string( mq_request_id );
	SendAppRouterQuitRequest( mq_request_id, proxy_router_id , mq_session_id );
	quit_resp = GetAppRouterQuitResponse( mq_request_id, proxy_router_id , mq_session_id  );

	cleanup_router_mq_handle();

	printf("appRouter process exit!\n");

	return 0;
}
