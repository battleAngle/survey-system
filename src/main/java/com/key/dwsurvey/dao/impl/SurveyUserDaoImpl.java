package com.key.dwsurvey.dao.impl;

import java.util.List;

import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.key.common.dao.BaseDaoImpl;
import com.key.dwsurvey.dao.SurveyUserDao;
import com.key.dwsurvey.entity.SurveyUser;

@Repository
public class SurveyUserDaoImpl extends BaseDaoImpl<SurveyUser, String> implements SurveyUserDao{

	@Override
	@Transactional
	public List<SurveyUser> findByNamePassByDirId(String username,
			String password, String directoryId) {
		Criterion criterion1=Restrictions.eq("userName",username);
		Criterion criterion2=Restrictions.eq("passWord",password);
		Criterion criterion3=Restrictions.eq("directory_id",directoryId);
		return find(criterion1,criterion2,criterion3);
		
	}

	@Override
	public void deleteByDirectoryId(String survey_id) {
		 
		getSession().createQuery("delete from SurveyUser where directory_id =?").setParameter(0,survey_id).executeUpdate() ;
	}

   
}
