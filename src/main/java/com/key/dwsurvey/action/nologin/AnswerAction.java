package com.key.dwsurvey.action.nologin;

import com.alibaba.fastjson.JSONObject;
import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.entity.Question;
import com.key.dwsurvey.entity.SurveyAnswer;
import com.key.dwsurvey.service.SurveyAnswerManager;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.convention.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 问卷 action
 *
 * @author KeYuan(keyuan258 @ gmail.com)
 * <p>
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 */
@Namespace("/ans")
@InterceptorRefs({@InterceptorRef("paramsPrepareParamsStack")})
@Results({
})
public class AnswerAction extends ActionSupport {
	private String surveyId;

	private String surveyuser_username;
	private String surveyuser_password;

	@Autowired
	private SurveyAnswerManager surveyAnswerManager;

	@Override
	public String execute() throws Exception {
		HttpServletResponse response = Struts2Utils.getResponse();
		// 找到答案
		SurveyAnswer surveyAnswer = surveyAnswerManager.findbyUsername(surveyuser_username, surveyId, 1);
		if (surveyAnswer == null) {
			response.getWriter().write("");
			return null;
		}
		// 根据答案
		List<Question> answerDetail = surveyAnswerManager.findAnswerDetail(surveyAnswer);
		response.getWriter().write(JSONObject.toJSONString(answerDetail));
		return null;
	}

	public String getSurveyuser_username() {
		return surveyuser_username;
	}

	public void setSurveyuser_username(String surveyuser_username) {
		this.surveyuser_username = surveyuser_username;
	}

	public String getSurveyuser_password() {
		return surveyuser_password;
	}

	public void setSurveyuser_password(String surveyuser_password) {
		this.surveyuser_password = surveyuser_password;
	}

	public String getSurveyId() {
		return surveyId;
	}

	public void setSurveyId(String surveyId) {
		this.surveyId = surveyId;
	}
}
