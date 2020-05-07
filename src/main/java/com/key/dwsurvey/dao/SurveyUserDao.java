package com.key.dwsurvey.dao;

import java.util.List;

import com.key.common.dao.BaseDao;
import com.key.dwsurvey.entity.SurveyUser;

public interface SurveyUserDao extends BaseDao<SurveyUser, String>{
     
	List<SurveyUser> findByNamePassByDirId(String username,String password,String directoryId);
	
	void deleteByDirectoryId(String survey_id);
}
