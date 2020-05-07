package com.key.dwsurvey.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;





import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import com.key.common.plugs.page.Page;
import com.key.common.service.BaseServiceImpl;
import com.key.dwsurvey.dao.SurveyUserDao;
import com.key.dwsurvey.entity.SurveyUser;
import com.key.dwsurvey.service.SurveyUserService;

@Service("SurveyUserService")
public class SurveyUserServiceImpl extends BaseServiceImpl<SurveyUser, String> implements SurveyUserService{
    
	
	@Autowired
	private SurveyUserDao surveyuserdao; 
	
	@Autowired
	private AccountManager accountManager;
	
	@Override
	public void setBaseDao() {
		this.baseDao=surveyuserdao;
	}

	@Override
	public Page<SurveyUser> findByUser(Page<SurveyUser> page,
			SurveyUser surveyUser) {
		
		User user=accountManager.getCurUser();
		List<Criterion> criterions=new ArrayList<Criterion>();
		if(user!=null){
			if(surveyUser != null){
				if(surveyUser.getUserName()!=null && surveyUser.getUserName()!=""){
					criterions.add(Restrictions.like("userName", "%"+surveyUser.getUserName()+"%"));
				}
				if(surveyUser.getDirectory_id()!=null && surveyUser.getDirectory_id() != ""){
					criterions.add(Restrictions.eq("directory_id",surveyUser.getDirectory_id()));
				}
			}
			//可以添加条件
		
		}
		page.setOrderBy("startTime");
		page.setOrderDir("desc");
		page=surveyuserdao.findPageList(page,criterions);
		return page;
	}

	@Override
	public List<SurveyUser> findByStatusBySurveyUser(String status,
			SurveyUser surveyUsr) {
		Criterion criterion1=Restrictions.eq("directory_id",surveyUsr.getDirectory_id());
		Criterion criterion2=Restrictions.eq("status",status);
		return surveyuserdao.find(criterion1,criterion2);
	}

}
