#BC-Slider故障处理手册
本手册主要描述了BC-Slider可能遇到故障的问题和解决方法。

**问题1**  
Slider update命令或者接口，报错Failed to acquire lock异常，一般是由于update服务操作异常导致读写锁未被释放  
 
**解决方法**  
1、查看/var/log/cmss/slider-router.log的日志文件，查找到对应的异常，异常信息一般如下所示：
	Failed to acquire lock /slider/.slider/cluster/{app-Name}/readlock

2、在hdfs目录中查找到/slider/.slider/cluster/{app-Name}/readlock文件，删除该文件即可


**问题2**    
Slider-Router的create调用，报NPE异常java.lang.NullPointerException at java.io.File.<init>，该问题的产生原因是Slider Router的CREATE Rest调用时通过appType获取app的定义文件，但是由于配置或者文件丢失，导致定义文件找不到

**解决方法**  
1、找到slider-router的安装节点，查看/slider/template/{app}目录下是否缺少appConfig.json和resources.json文件，如果没有，补充该文件
   
2、查看slider配置文件/cmss/bch/bc1.3.2/slider/conf/app-template.xml中的配置，是否能找到对应的app的配置，格式如下：
```
<type name="hbase">      
	<packagePath>   
		/slider/appzip/slider-hbase-app-package-1.1.3-bc1.3.2.zip
	</packagePath>
	<appConfigPath>/slider/template/hbase/appConfig.json</appConfigPath>
	<resourcePath>/slider/template/hbase/resources.json</resourcePath>
</type>
```
如果缺少，则补充

3、查看调用REST的content body传appType的参数是否正确，要和app-template.xml中的type保持一致

**问题3**  
Slider的REST调用无响应，查看日志发现Too many open files

**解决方法**  
在slider router所有节点的slider用户下，执行命令：
	lsof -n|awk '{print $2}'|sort|uniq -c |sort -nr|more
查看打开的文件数，如果超过系统的limit open files数目，则重启slider router或者调大系统的open files数目

**问题4**  
slider list命令，抛出Malformed cluster found异常，问题产生原因是app在运行过程中删除了其元数据  
**解决方法**  
1、查看/var/log/cmss/slider/slider-router.log日志，找到异常：
	Malformed cluster found at hdfs://bch/slider/.slider/cluster/{app}. It does not appear to be a valid persisted instance  
2、查看hdfs目录/slider/.slider/cluster/{app}，其目录中是否缺少appConfig.json，resources.json等文件，如果缺少，该app已经不能恢复   
3、删除/slider/.slider/cluster/{app}
