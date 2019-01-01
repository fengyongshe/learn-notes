package com.cmcc;

import com.bipaasportal.update.remote.FtpElement;


/**
 * @ClassName:ReuserService
 * @Description:用于用户管理远程调用
 * @author:陈熹伟
 * @date:2014年10月14日下午2:49:05
 * @version V1.0
 * 
 */
public interface ReuserService {
	public String test(String mess);
	/**
	 * @Title: isExist 
	 * @Description: 判断用户是否存在 
	 * @param:
	 * @return:boolean
	 * @throws
	 */
	public boolean isExist(String name);
	/**
	 * @Title: getUser 
	 * @Description: 获取用户对象
	 * @param:
	 * @return:User
	 * @throws
	 */
	public FtpElement getFtpOfInfo(String name, String pwd);
}
