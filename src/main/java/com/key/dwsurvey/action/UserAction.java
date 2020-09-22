package com.key.dwsurvey.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.fastjson.JSON;
import com.key.dwsurvey.dao.SysRoleDao;
import com.key.dwsurvey.entity.Role;
import org.apache.struts2.convention.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import com.key.common.utils.security.DigestUtils;
import com.key.common.utils.web.Struts2Utils;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 用户中心 action
 * @author KeYuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 *
 */
@Namespace("/ic")
@InterceptorRefs({ @InterceptorRef("paramsPrepareParamsStack")})
@Results({
	@Result(name=UserAction.MYACCOUNT,location="/WEB-INF/page/content/diaowen-center/my-account.jsp",type=Struts2Utils.DISPATCHER),
		@Result(name="editPwd",location="/WEB-INF/page/content/diaowen-center/reset-pwd.jsp",type=Struts2Utils.DISPATCHER),
		@Result(name=UserAction.SUCCESS,location="user!myaccount.action",type=Struts2Utils.REDIRECT)
})
@AllowedMethods({"myaccount","pwd","updatePwd","checkOldPwd"})
public class UserAction extends ActionSupport{
	
	public final static String MYACCOUNT="myaccount";
	@Autowired
	private AccountManager accountManager;

	public String myaccount() throws Exception {
		HttpServletRequest request=Struts2Utils.getRequest();
		User user=accountManager.getCurUser();
		request.setAttribute("user", user);
		return MYACCOUNT;
	}


	public String pwd() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		User user=accountManager.getCurUser();
		
		request.setAttribute("curUser",user);
		return "editPwd";
	}

	public String updatePwd() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		String curpwd=request.getParameter("curpwd");
		String newPwd = request.getParameter("pwd");
		//先检查原密码是否正确
		accountManager.updatePwd(curpwd,newPwd);
		return SUCCESS;
	}
	
	public String checkOldPwd() throws Exception{
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		String id=request.getParameter("curuserid");
		String curpwd=DigestUtils.sha1Hex(request.getParameter("curpwd"));
		User user=accountManager.getCurUser();
		
		if(user != null){
			if(user.getShaPassword().equals(curpwd)){
				response.getWriter().write("1");
			}else{
				response.getWriter().write("-1");
			}
		}else{
			response.getWriter().write("-1");
		}
		
		return null;
	}

	public String save() throws Exception {
		HttpServletRequest request=Struts2Utils.getRequest();
		User user=accountManager.getCurUser();
		String email = request.getParameter("email");
		String cellphone = request.getParameter("cellphone");
		String name = request.getParameter("name");
		user.setEmail(email);
		user.setCellphone(cellphone);
		user.setName(name);
		accountManager.saveUp(user);
		return SUCCESS;
	}

}
