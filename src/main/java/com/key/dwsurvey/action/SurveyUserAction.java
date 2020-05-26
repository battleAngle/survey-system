package com.key.dwsurvey.action;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.convention.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import com.alibaba.fastjson.JSONObject;
import com.key.common.base.action.CrudActionSupport;
import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import com.key.common.plugs.page.Page;
import com.key.common.utils.RandomUtils;
import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.dao.SurveyUserDao;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.entity.SurveyUser;
import com.key.dwsurvey.service.SurveyUserService;
import com.opensymphony.xwork2.ActionSupport;
import org.springframework.web.multipart.MultipartFile;


@Namespace("/surveyuser")
@AllowedMethods({"save","list","delete","exportuser","deleteBatch","deleteAll","importUser"})
@Results({	
})
public class SurveyUserAction extends CrudActionSupport<SurveyUser, String>{

	private String survey_id;
	
	private String surveyuser_id;
	
	private String survey_user_count;
	
	private String password_length;
	
	private String survey_user_name;
	
	private String alarmstarttime;
	
	private String alarmendtime;
   
	private String survey_state;

	private MultipartFile file;

	/**
	 * 1.不使用密码；2.唯一密码；3.随机密码；4.指定密码
	 */
	private String password_setting;

	private String password;


	
	@Autowired
	private SurveyUserService SurveyUserService;
	
	@Autowired
	private AccountManager accountManager;
	
	@Autowired
	private SurveyUserDao  surveyuserdao;
	
	
	public String  save() throws Exception {
		
		HttpServletResponse response=Struts2Utils.getResponse();
		//判断用户是否存在
		User user=accountManager.getCurUser();
		if(user!=null){
			// 已经生成的用户
		    java.util.List<SurveyUser> surveyusers=surveyuserdao.findBy("directory_id",survey_id);
			if(alarmstarttime.compareTo(alarmendtime) > 0){
				 response.getWriter().write("请设置有效起始时间");
				return null;
			} else {
				//做批量创建的操作
				int index = 0;
				TreeSet<String> existedUsernameSet = new TreeSet<String>();
				if (surveyusers != null && !surveyusers.isEmpty()) {
					for (SurveyUser surveyuser : surveyusers) {
						if (surveyuser.getUserName().contains(survey_user_name)) {
							existedUsernameSet.add(surveyuser.getUserName());
						}
					}
				}
				if (!existedUsernameSet.isEmpty()) {
					String last = existedUsernameSet.last();
					index = Integer.parseInt(last.replace(survey_user_name, ""));
				}
				int count=Integer.parseInt(survey_user_count);
				for(int i=0;i<count;i++){
					String username = survey_user_name + (i + index + 1);
					int len=Integer.parseInt(password_length);
					String password = genPassword(len);
					Date nowDate=new Date();
					Date alarmendtimeDate=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(alarmendtime);
					if(nowDate.after(alarmendtimeDate)){
						survey_state="0";
					}else{
						survey_state="1";
					}
					SurveyUser su=new SurveyUser(survey_id, username, password, survey_state, alarmstarttime, alarmendtime);
					SurveyUserService.save(su);
				}
				response.getWriter().write("批量生成成功");
				return null;
			}
		}else{
			response.getWriter().write("用户登录过期");
			return null;
		}
	}

	private String genPassword(int len) {
		String password = "";
		if ("1".equals(password_setting)) {
			// 不使用密码
		} else if ("2".equals(password_setting) || "4".equals(password_setting)) {
			password = this.getPassword();
		} else {
			password = RandomUtils.randomStr(len);
		}
		return password;
	}

	public  String list() throws Exception{
		
		//把page变量存入session作用域
		
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		HttpSession session=request.getSession();
		try{
			entity=new SurveyUser();
		    String userName=request.getParameter("userName");
			if(userName != null){
				if(userName != ""){
					entity.setUserName(userName);
				}
			}
			if(survey_id!=null){
				if(survey_id !=""){
					entity.setDirectory_id(survey_id);
				}
			}
			
			//先做update操作 -- 检查是否过期
			List<SurveyUser> surveyusers=SurveyUserService.findByStatusBySurveyUser("1", entity);
			for (SurveyUser surveyUser : surveyusers) {
				if(new Date().after(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(surveyUser.getEndTime()))){
					surveyUser.setStatus("0");
					SurveyUserService.save(surveyUser);
				}
			}
			
			page=SurveyUserService.findByUser(page,entity);
			
			//报空指针
			String pageString=JSONObject.toJSONString(page);
			
			response.getWriter().write(pageString);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	public String delete() throws Exception{
		
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		User user=accountManager.getCurUser();
		try{
			if(user!=null){
		    //判断用户是否存在，存在就删除
			SurveyUser surveyuser=surveyuserdao.get(surveyuser_id);
			if(surveyuser!=null){
				//删除成功后重新刷新page
				surveyuserdao.delete(surveyuser_id);
				entity=new SurveyUser();
				if(survey_id!=null){
					if(survey_id !=""){
						entity.setDirectory_id(survey_id);
					}
				}
				page=SurveyUserService.findByUser(page,entity);
				String pageString=JSONObject.toJSONString(page);
				response.getWriter().write(pageString);
			}
				
			}
		}catch(Exception e){
	
		  e.printStackTrace();
		}
		
		return null;
	}

	public String deleteBatch() throws Exception{
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		User user=accountManager.getCurUser();
		try{
			if(user!=null){
		    //判断用户是否存在，存在就删除
		 if	(surveyuser_id != null && !"".equals(surveyuser_id)) 	{
			 String [] 	surveyuser_idArr=surveyuser_id.split(",");
				//判断一个也不选
				for (String  tempSurveyuserId : surveyuser_idArr) {
					SurveyUser surveyuser=surveyuserdao.get(tempSurveyuserId);
					if(surveyuser!=null){
						//删除成功后重新刷新page
						surveyuserdao.delete(tempSurveyuserId);
					}
				} 
		 }
			entity=new SurveyUser();
			if(survey_id!=null){
				if(survey_id !=""){
					entity.setDirectory_id(survey_id);
				}
			}
			page=SurveyUserService.findByUser(page,entity);
			String pageString=JSONObject.toJSONString(page);
			response.getWriter().write(pageString);	
			}
		}catch(Exception e){
	
		  e.printStackTrace();
		}
		
		return null;
	}
	
	public String  deleteAll() throws Exception{
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		User user=accountManager.getCurUser();
		String survey_id=request.getParameter("survey_id");
		try{
			if(user!=null){
		    //判断用户是否存在，存在就删除
		 if	(survey_id != null && !"".equals(survey_id)) 	{
				//删除成功后重新刷新page
	       surveyuserdao.deleteByDirectoryId(survey_id);
			
		   }
			entity=new SurveyUser();
			if(survey_id!=null){
				if(survey_id !=""){
					entity.setDirectory_id(survey_id);
				}
			}
			page=SurveyUserService.findByUser(page,entity);
			String pageString=JSONObject.toJSONString(page);
			response.getWriter().write(pageString);	
			}
		}catch(Exception e){
	
		  e.printStackTrace();
		}
		return null;
	}
	public String  exportuser() throws Exception{
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		Object[] objs = null;
        List<ArrayList<Object[]>> list = new ArrayList<ArrayList<Object[]>>();
        Date startTime = null;
		Date endTime = null;
		try{
			List<SurveyUser>  surveyUsers= this.surveyuserdao.findBy("directory_id",request.getParameter("survey_id"));
		    int count=surveyUsers.size();
			int index = 1;
			if(count>10000){
				if(count%10000==0){
					index = count/10000;
				}else{
					index = (count/10000)+1;
				}
			}
			int startIndex,endIndex;
			 String[] rowsName = new String[]{"用户姓名","用户密码","有效起始","有效终止"};
			for(int j=0;j<index;j++){
				startIndex = 10000*j;
				endIndex = 	10000*(j+1);
				ArrayList<Object[]>  dataList = new ArrayList<Object[]>();
		        for(int i=0;i<surveyUsers.size();i++){
		            SurveyUser surveyUser=surveyUsers.get(i);
		            objs = new Object[rowsName.length];
		            objs[0]=surveyUser.getUserName();
		            objs[1]=surveyUser.getPassWord();
		            objs[2]=surveyUser.getStartTime();
		            objs[3]=surveyUser.getEndTime();
		            dataList.add(objs);
		        }
		        list.add(dataList); 
			}
			 com.key.common.utils.ExclesUtils.saveExcles(list, response,rowsName,startTime,endTime);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	public String importUser() throws IOException {
		HttpServletResponse response = Struts2Utils.getResponse();
		response.getWriter().write("test！");
		return null;
	}
	
	private static String getFixLenthString(int strLength) {  
	      
	    Random rm = new Random();   
	    // 获得随机数  
	    double pross = (1 + rm.nextDouble()) * Math.pow(10, strLength);  
	    // 将获得的获得随机数转化为字符串  
	    String fixLenthString = String.valueOf(pross);  
	    // 返回固定的长度的随机数  
	    return fixLenthString.substring(2, strLength + 2);  
	} 
	
	
	public String getSurvey_state() {
		return survey_state;
	}

	public void setSurvey_state(String survey_state) {
		this.survey_state = survey_state;
	}

	public String getSurvey_id() {
		return survey_id;
	}

	public void setSurvey_id(String survey_id) {
		this.survey_id = survey_id;
	}

	public String getSurvey_user_count() {
		return survey_user_count;
	}

	public void setSurvey_user_count(String survey_user_count) {
		this.survey_user_count = survey_user_count;
	}



	public String getPassword_length() {
		return password_length;
	}


	public void setPassword_length(String password_length) {
		this.password_length = password_length;
	}


	public String getSurvey_user_name() {
		return survey_user_name;
	}

	public void setSurvey_user_name(String survey_user_name) {
		this.survey_user_name = survey_user_name;
	}

	public String getAlarmstarttime() {
		return alarmstarttime;
	}

	public void setAlarmstarttime(String alarmstarttime) {
		this.alarmstarttime = alarmstarttime;
	}

	public String getAlarmendtime() {
		return alarmendtime;
	}

	public void setAlarmendtime(String alarmendtime) {
		this.alarmendtime = alarmendtime;
	}
	
	public String getSurveyuser_id() {
		return surveyuser_id;
	}

	public void setSurveyuser_id(String surveyuser_id) {
		this.surveyuser_id = surveyuser_id;
	}

	public String getPassword_setting() {
		return password_setting;
	}

	public void setPassword_setting(String password_setting) {
		this.password_setting = password_setting;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	@Override
	protected void prepareModel() throws Exception {
	     entity=new SurveyUser();
	}
}
