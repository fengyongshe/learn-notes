/*
 * =====================================================================================
 *
 *       Filename:  mq_proxy.h
 *
 *
 * =====================================================================================
 */

#ifndef  MQ_PROXY_H
#define  MQ_PROXY_H


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include <json/json.h>

#include "router_mq.h"
#include "hiredis.h"

redisContext *redis_conn;
redisReply *redis_reply;


int redis_init();
int curl_execute(json_object *my_object);
int add_app_info(char *app_key, char *quota);
int add_app_domain(char *app_key, char *app_domain);
int add_app_instance(char *app_key, char *app_instance, char *app_md5);
int addAppRouterMap( Cm__Omae__Base__AppInfo *app_info, RouterMap * item_rm, char *commad_type, json_object *my_array);
int del_app_info(char *app_key);
int del_app_instance(char *app_key, char *app_instance);
int del_app_domain(char *app_key);
int deleteAppRouterMap( Cm__Omae__Base__AppInfo *app_info, RouterMap * item_rm, char *commad_type, json_object *my_array);
int updateAppQuota( Cm__Omae__Base__AppInfo *app_info, RouterMap * item_rm, char *commad_type, json_object *my_array);

#endif   /* *    */
