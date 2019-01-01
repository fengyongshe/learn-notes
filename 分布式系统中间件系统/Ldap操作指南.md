[TOC]

# LDAP操作指南

# 一、LDAP使用
## 1、ldap的安装

（1）请参考《HC操作指南之添加服务》章节，通过HC界面添加ldap服务；

（2）修改hdfs服务下高级core-site中如下两个属性：

```
hadoop.group.enable.ldap=true
hadoop.security.group.mapping.ldap.url=ldap://{ldap_ip}:389/dc=hadoop,dc=apache,dc=org
其中{ldap_ip}为ldap_server所在主机的ip地址
```

（3）根据界面提示重启相关服务即可；

## 2、ldap数据初始化 

（1）初始化元数据。

ldap只支持ldif类型的元数据。op的初始化元数据如下：

	dn: dc=hadoop,dc=apache,dc=org
	objectClass: top
	objectClass: domain
	
	dn: ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: organizationalUnit
	objectClass: top
	ou: users
	
	dn: ou=groups,dc=hadoop,dc=apache,dc=org
	objectClass: organizationalUnit
	objectClass: top
	ou: groups
	
	dn: ou=orgs,dc=hadoop,dc=apache,dc=org
	objectClass: organizationalUnit
	objectClass: top
	ou: orgs
	
	dn: cn=bdoc,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: bdoc
	sn: bdoc
	
	dn: cn=hive,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: hive
	sn: hive
	
	dn: cn=hbase,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: hbase
	sn: hbase
	
	dn: cn=hdfs,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: hdfs
	sn: hdfs
	
	dn: cn= yarn,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: yarn
	sn: yarn
	
	dn: cn=mapred,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: mapred
	sn: mapred
	
	dn: cn=kylin,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: kylin
	sn: kylin
	
	dn: cn=yafe,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: yafe
	sn: yafe
	
	dn: cn=slider,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: slider
	sn: slider
	
	dn: cn=ambari-qa,ou=users,dc=hadoop,dc=apache,dc=org
	objectClass: person
	objectClass: top
	cn: ambari-qa
	sn: ambari-qa
	
	dn: cn=bdoc,ou=groups,dc=hadoop,dc=apache,dc=org
	objectClass: groupofnames
	objectClass: top
	cn: bdoc
	member:cn=bdoc,ou=users,dc=hadoop,dc=apache,dc=org
	
	dn: cn=bdocadm,ou=groups,dc=hadoop,dc=apache,dc=org
	objectClass: groupofnames
	objectClass: top
	cn: bdocadm
	member:cn=bdoc,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=hdfs,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=hive,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=hbase,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=yarn,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=slider,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=mapred,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=yafe,ou=users,dc=hadoop,dc=apache,dc=org
	member:cn=ambari-qa,ou=users,dc=hadoop,dc=apache,dc=org
	
	dn: cn= hdfs,ou=groups,dc=hadoop,dc=apache,dc=org
	objectClass: groupofnames
	objectClass: top
	cn: hdfs
	member:cn=bdoc,ou=users,dc=hadoop,dc=apache,dc=org
假定如上文件名称是init.ldif,通过如下命令初始化：  

    ldapadd -x -D "cn=Manager,dc=hadoop,dc=apache,dc=org" -W -f init.ldif
（2）验证  
使用如下查询命令，检查是否初始化数据成功：
切换到hdfs用户：

    su - hdfs
执行命令：

    hdfs groups
如果显示结果为多个，则说明初始化OK；否则请根据提示修改。  
# 二、LDAP基本使用命令

	添加命令：ldapadd
	-x   进行简单认证
	-D   用来绑定服务器的DN
	-h   目录服务的地址
	-w   绑定DN的密码
	-f   使用ldif文件进行条目添加的文件
	例子
	ldapadd -x "cn=Manager,dc=hadoop,dc=apache,dc=org" -w secret -f /root/bdoc.ldif
	ldapadd -x "cn=Manager,dc=hadoop,dc=apache,dc=org" -w secret (这样写就是在命令行添加条目)
	
	搜索命令：ldapsearch
	-x   进行简单认证
	-D   用来绑定服务器的DN
	-w   绑定DN的密码
	-b   指定要查询的根节点
	-H   制定要查询的服务器
	ldapsearch -x -D "cn=Manager,dc=hadoop,dc=apache,dc=org" -w secret -b "dc=starxing,dc=com"
	使用简单认证，用 "dc=hadoop,dc=apache,dc=org" 进行绑定，
	要查询的根是 "dc=hadoop,dc=apache,dc=org"。这样会把绑定的用户能访问"dc=hadoop,dc=apache,dc=org"下的所有数据显示出来。
	
	删除命令：ldapdelete
	ldapdelete -x -D "cn=Manager,dc=hadoop,dc=apache,dc=org" -w secret "uid=test1,ou=People,dc=dc=hadoop,dc=apache,dc=org"
	ldapdelete -x -D 'cn=root,dc=hadoop,dc=apache,dc=org' -w secert 'uid=zyx,dc=hadoop,dc=apache,dc=org'
	这样就可以删除'uid=zyx,dc=it,dc=com'记录了，应该注意一点，如果o或ou中有成员是不能删除的。
	
	修改密码：ldappasswd
	-x   进行简单认证
	-D   用来绑定服务器的DN
	-w   绑定DN的密码
	-S   提示的输入密码
	-s pass 把密码设置为pass
	-a pass 设置old passwd为pass
	-A   提示的设置old passwd
	-H   是指要绑定的服务器
	-I   使用sasl会话方式
	#ldappasswd -x -D 'cm=root,dc=hadoop,dc=apache,dc=org' -w secret 'uid=zyx,dc=hadoop,dc=apache,dc=org' -S
	New password:
	Re-enter new password:
	就可以更改密码了，如果原来记录中没有密码，将会自动生成一个userPassword。

# 三、同步系统用户到LDAP  
由于LDAP只能识别特定格式的文件 即后缀为ldif的文件（也是文本文件），故采用migrationtools这个工具把系统上的用户转变成LDAP能识别的文件；  
1.安装配置migrationtools

    yum install migrationtools -y
2.修改配置：  
（1）进入migrationtool配置目录

    cd /usr/share/migrationtools/
（2）编辑migrate_common.ph

    vi migrate_common.ph
修改如下两个地方：

    $DEFAULT_MAIL_DOMAIN = "hadoop.apache.com";
    $DEFAULT_BASE = "dc=hadoop,dc=apache,dc=com";
保存退出。
3.使用pl脚本将/etc/passwd、/etc/shadow、/etc/group生成LDAP能读懂的文件格式，保存在/tmp/下

    ./migrate_base.pl > /tmp/base.ldif
    ./migrate_passwd.pl  /etc/passwd > /tmp/passwd.ldif
    ./migrate_group.pl  /etc/group > /tmp/group.ldif
4.导入系统用户到LDAP：

    ldapadd -x -D "cn=Manager,dc=hadoop,dc=apache,dc=com" -W -f /tmp/base.ldif
    ldapadd -x -D "cn=Manager,dc=hadoop,dc=apache,dc=com" -W -f /tmp/passwd.ldif
    ldapadd -x -D "cn=Manager,dc=hadoop,dc=apache,dc=com" -W -f /tmp/group.ldif
5.重启ldap，完成同步

    service slapd restart