package test;
import org.apache.ftpserver.usermanager.Md5PasswordEncryptor;
import org.apache.ftpserver.usermanager.PasswordEncryptor;


public class createpwd {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		PasswordEncryptor passwordEncryptor = new Md5PasswordEncryptor();
		System.out.println(passwordEncryptor.encrypt("hadoop").equals("0238775C7BD96E2EAB98038AFE0C4279"));
		System.out.println(System.getProperty("user.name"));
	}

}
