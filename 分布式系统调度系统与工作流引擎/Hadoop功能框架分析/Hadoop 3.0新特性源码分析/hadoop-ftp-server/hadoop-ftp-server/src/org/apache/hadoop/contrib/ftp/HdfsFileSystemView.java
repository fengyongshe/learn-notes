package org.apache.hadoop.contrib.ftp;

import org.apache.ftpserver.ftplet.FileObject;
import org.apache.ftpserver.ftplet.FileSystemView;
import org.apache.ftpserver.ftplet.FtpException;
import org.apache.ftpserver.ftplet.User;

/**
 * Implemented FileSystemView to use HdfsFileObject
 */
public class HdfsFileSystemView implements FileSystemView {

	// the root directory will always end with '/'.
	private String rootDir = "/";

	// the first and the last character will always be '/'
	// It is always with respect to the root directory.
	private String currDir = "/";

	private User user;

	// private boolean writePermission;

	private boolean caseInsensitive = false;

	/**
	 * Constructor - set the user object.
	 */
	protected HdfsFileSystemView(User user) throws FtpException {
		this(user, true);
	}

	/**
	 * Constructor - set the user object.
	 */
	protected HdfsFileSystemView(User user, boolean caseInsensitive)
			throws FtpException {
		if (user == null) {
			throw new IllegalArgumentException("user can not be null");
		}
		if (user.getHomeDirectory() == null) {
			throw new IllegalArgumentException(
					"User home directory can not be null");
		}

		this.caseInsensitive = caseInsensitive;

		// add last '/' if necessary
		String currDir = user.getHomeDirectory();
		// rootDir = NativeFileObject.normalizeSeparateChar(rootDir);
		if (!currDir.endsWith("/")) {
			currDir += '/';
		}
		this.currDir = '/' + currDir;
		this.rootDir = this.currDir;
		this.user = user;

	}

	/**
	 * Get the user home directory. It would be the file system root for the
	 * user.没用的方法
	 */
	public FileObject getHomeDirectory() {
//		System.err.println("返回root的路径");
		return new HdfsFileObject(rootDir, user);
	}

	/**
	 * Get the current directory.路径跳转时会走的方法，同时currDir这个会不断改变
	 */
	public FileObject getCurrentDirectory() {
	//	System.err.println("返回current的路径：" + currDir);
		return new HdfsFileObject(currDir, user);
	}

	/**
	 * Get file object.
	 */
	public FileObject getFileObject(String file) {
		String path;
		if (file.startsWith("/")) {
			path = file;
		} else if (currDir.length() > 1) {
			path = currDir + "/" + file;
		} else {
			path = "/" + file;
		}
		return new HdfsFileObject(path, user);
	}

	/**
	 * Change directory.变换路径时，会走这个方法
	 */
	public boolean changeDirectory(String dir) {
	//	System.err.println("改变dir："+dir);
		String path;
		if (dir.startsWith("/")) {
			path = dir;
		} else if (currDir.length() > 1) {
			path = currDir + "/" + dir;
		} else {
			path = "/" + dir;
		}
		HdfsFileObject file = new HdfsFileObject(path, user);
		/*
		 * 限定不允许跳出home dir范围，超出范围则跳到用户根目录(不判断read权限了)
		 */
		if(!file.isDirectory()){
			return false;
		}else if(file.isLegal()){
			currDir = path;
		}else{
			currDir = rootDir;
		}
		return true;
		/*if (file.isDirectory() && file.hasReadPermission() && file.isLegal()) {
			currDir = path;
			return true;
		} else {
			return false;
		}*/
	}

	/**
	 * Is the file content random accessible?
	 */
	public boolean isRandomAccessible() {
		return true;
	}

	/**
	 * Dispose file system view - does nothing.
	 */
	public void dispose() {
	}
}
