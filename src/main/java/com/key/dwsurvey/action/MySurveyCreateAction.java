package com.key.dwsurvey.action;

import java.net.URLDecoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import com.key.dwsurvey.service.SurveyDirectoryManager;

import org.apache.struts2.convention.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.opensymphony.xwork2.ActionSupport;


/**
 * 创建问卷
 * @author keyuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 *
 */

@Namespace("/design")
@InterceptorRefs({ @InterceptorRef("paramsPrepareParamsStack")})
@Results({
	@Result(name="design",location="/design/my-survey-design.action?surveyId=${surveyId}",type=Struts2Utils.REDIRECT)
})
@AllowedMethods({"checkSurveyName"})
public class MySurveyCreateAction extends ActionSupport{
	@Autowired
	private SurveyDirectoryManager directoryManager;

	private String surveyId;

	@Override
	public String execute() throws Exception {
	    return SUCCESS;
	}
	
	public String save() throws Exception {
		String surveyName=Struts2Utils.getParameter("surveyName");
		SurveyDirectory survey = new SurveyDirectory();
	    try{
	    	survey.setDirType(2);
	    	if(surveyName==null || "".equals(surveyName.trim())){
	    		surveyName="请输入问卷标题";
	    	}else{
	    		surveyName=URLDecoder.decode(surveyName,"utf-8");
	    	}
	 	    survey.setSurveyName(surveyName);
	 	    directoryManager.save(survey);
	 	    surveyId = survey.getId();
	    }catch(Exception e){
	    	e.printStackTrace();
	    }
	    return "design";
	}
	
	
	public String checkSurveyName() throws Exception{
		
		HttpServletResponse response=Struts2Utils.getResponse();
		String surveyName=Struts2Utils.getParameter("surveyName");
		List<SurveyDirectory> surveyDirectories=directoryManager.findByName(surveyName);
		
		if(surveyDirectories == null || surveyDirectories.size() == 0 || surveyDirectories.get(0).getVisibility() == 0){
			response.getWriter().write("1");
		}else{
			response.getWriter().write("0");
		}
		
		return null;
	}
	
	public String getSurveyId() {
	    return surveyId;
	}
	
}
