package com.key.dwsurvey.service;

import java.util.List;

import com.key.common.plugs.page.Page;
import com.key.common.service.BaseService;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.entity.SurveyUser;

public interface SurveyUserService extends BaseService<SurveyUser, String>{
   
	
	public Page<SurveyUser> findByUser(Page<SurveyUser> page,SurveyUser surveyUser);
	
	
	public List<SurveyUser> findByStatusBySurveyUser(String status,SurveyUser surveyUsr);
}
