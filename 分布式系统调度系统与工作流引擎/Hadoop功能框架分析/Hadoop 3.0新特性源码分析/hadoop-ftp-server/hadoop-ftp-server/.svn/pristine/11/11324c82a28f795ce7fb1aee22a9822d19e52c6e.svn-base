package com.cmcc;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Properties;

import org.apache.hadoop.contrib.ftp.HdfsOverFtpServer;

import com.bipaasportal.update.remote.FtpElement;
import com.caucho.hessian.client.HessianProxyFactory;

/**
 * 单例模式，获取自定义用户manager对象
 * 
 * @author Administrator
 *
 */
public class MyUserManager {
	private static MyUserManager xx = null;
	private HessianProxyFactory factory = null;
	private Properties props = null;
	private String rmiUrl = "example";
	private ReuserService myService = null;

	private MyUserManager() {
		factory = new HessianProxyFactory();
	}

	public static synchronized MyUserManager getUserManager() {
		if (null == xx) {
			xx = new MyUserManager();
		}
		return xx;
	}

	/**
	 * 判断用户是否存在
	 * 
	 * @param name
	 * @return
	 */
	public boolean isExist(String name) {
		return getService().isExist(name);
	}

	/**
	 * 通过用户名和用户密码获取用户登录ftp所需要的信息
	 * 
	 * @param name
	 * @param pwd
	 * @return
	 */
	public FtpElement getUserElement(String name, String pwd) {
		return getService().getFtpOfInfo(name, pwd);
	}

	/**
	 * 获取ReuserService对象
	 * 
	 * @return
	 */
	private ReuserService getService() {
		if (null == myService) {
			if (null == factory) {
				factory = new HessianProxyFactory();
			}
			try {
				myService = (ReuserService) factory.create(ReuserService.class,
						getRmiUrl("url.rmi.usermanager"));
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return myService;
	}

	/**
	 * 获取rmi的远程调用接口
	 * 
	 * @param name
	 * @return
	 */
	private String getRmiUrl(String name) {
		if (!rmiUrl.equals("example")) {
			return rmiUrl;
		}
		if (null == props) {
			props = new Properties();
		}
		try {
			props.load(new FileInputStream(loadResource("/urlparam.properties")));
			rmiUrl = props.getProperty(name);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rmiUrl;
	}

	/**
	 * 获取文件的软链接
	 * 
	 * @param resourceName
	 * @return
	 */
	private File loadResource(String resourceName) {
		final URL resource = HdfsOverFtpServer.class.getResource(resourceName);
		if (resource == null) {
			throw new RuntimeException("Resource not found: " + resourceName);
		}
		return new File(resource.getFile());
	}
}
