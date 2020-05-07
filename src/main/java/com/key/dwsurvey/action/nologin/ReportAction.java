package com.key.dwsurvey.action.nologin;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.key.dwsurvey.entity.AnOrder;
import com.key.dwsurvey.entity.QuOrderby;
import com.key.dwsurvey.entity.Question;
import com.key.dwsurvey.entity.SurveyAnswer;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.entity.SurveyStats;
import com.key.dwsurvey.service.AnOrderManager;
import com.key.dwsurvey.service.SurveyAnswerManager;
import com.key.dwsurvey.service.SurveyDirectoryManager;
import com.key.dwsurvey.service.SurveyStatsManager;

import org.apache.struts2.convention.annotation.AllowedMethods;
import org.apache.struts2.convention.annotation.InterceptorRef;
import org.apache.struts2.convention.annotation.InterceptorRefs;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;

import com.key.common.QuType;
import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import com.key.common.utils.web.Struts2Utils;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 公开分析 action
 * @author KeYuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 *
 */

@Namespace("/report")
@InterceptorRefs({ @InterceptorRef("paramsPrepareParamsStack")})
@Results({
	@Result(name=ReportAction.DEFAULT_REPORT,location="/WEB-INF/page/content/diaowen-da/default-report-pub.jsp",type=Struts2Utils.DISPATCHER)
})
public class ReportAction extends ActionSupport{
	
	protected final static String DEFAULT_REPORT="default_report";
	
	@Autowired
	private SurveyStatsManager surveyStatsManager;
	@Autowired
	private SurveyDirectoryManager directoryManager;
	@Autowired
	private SurveyAnswerManager surveyAnswerManager;
	
	@Autowired
	private AnOrderManager anOrderManager;
	
	@Autowired
	private AccountManager  accountManager;
	
	private SurveyStats surveyStats = new SurveyStats();
	private SurveyDirectory directory = new SurveyDirectory();
	
	private String sid;

	
	
	public String execute() throws Exception {
		// 得到频数分析数据
		directory=directoryManager.getSurveyBySid(sid);
		Integer viewAnswer=directory.getViewAnswer();
        HttpServletRequest  request=Struts2Utils.getRequest();
        String answerId=(String) request.getSession().getAttribute("answerId");
		if(viewAnswer!=null && viewAnswer.intValue()==1){
			//得到的questions并没有answer信息
			List<Question> questions = surveyStatsManager.findFrequency(directory);
			for (Question question : questions) {
				String quid=question.getId();
				surveyAnswerManager.getquestionAnswer(answerId,question);
			}
			
			for (Question question : questions) {
				  if(question.getQuType() == QuType.ORDERQU){
					  List<AnOrder>  quOrderbys=question.getAnOrders();
					  Collections.sort(quOrderbys, new Comparator<AnOrder>() {
						        public int compare(AnOrder q1, AnOrder q2) {
						            /**
						             * 升序排的话就是第一个参数.compareTo(第二个参数);
						             * 降序排的话就是第二个参数.compareTo(第一个参数);
						             */
						        	 String  Ordernum1=anOrderManager.get(q1.getId()).getOrderyNum();
						        	 System.out.println(Ordernum1);
						        	 String  Ordernum2=anOrderManager.get(q2.getId()).getOrderyNum();
						        	 System.out.println(Ordernum2);
						             return Ordernum1.compareTo(Ordernum2);//升序
						        }
						    });
					  question.setAnOrders(quOrderbys);;
                  }
			   }
			surveyStats.setQuestions(questions);
		}else{
			Struts2Utils.getRequest().setAttribute("noview", 1);
		}
		
		return DEFAULT_REPORT;		
	}
	
	public SurveyStats getSurveyStats() {
		return surveyStats;
	}
	
	public SurveyDirectory getDirectory() {
		return directory;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	
}
