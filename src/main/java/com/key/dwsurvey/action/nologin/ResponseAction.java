package com.key.dwsurvey.action.nologin;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.baidubce.util.DateUtils;
import com.key.dwsurvey.dao.SurveyUserDao;
import com.key.dwsurvey.entity.AnCheckbox;
import com.key.dwsurvey.entity.AnRadio;
import com.key.dwsurvey.entity.SurveyDetail;
import com.key.dwsurvey.entity.SurveyUser;
import com.key.dwsurvey.service.SurveyDirectoryManager;

import org.apache.commons.httpclient.util.DateUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.convention.annotation.*;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.util.WebUtils;

import com.key.common.base.action.CrudActionSupport;
import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import com.key.common.plugs.aliyun.AliyunOSS;
import com.key.common.plugs.baiduyun.BaiduBOS;
import com.key.common.plugs.ipaddr.IPService;
import com.key.common.utils.CookieUtils;
import com.key.common.utils.DiaowenProperty;
import com.key.common.utils.HttpRequestDeviceUtils;
import com.key.common.utils.NumberUtils;
import com.key.common.utils.web.Struts2Utils;
import com.key.common.QuType;
import com.key.dwsurvey.entity.SurveyAnswer;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.service.SurveyAnswerManager;
import com.octo.captcha.service.image.ImageCaptchaService;
import com.opensymphony.xwork2.ActionSupport;


/**
 * 答卷 action
 * @author KeYuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 *
 */

@Namespaces({ @Namespace("/") })
@InterceptorRefs({ @InterceptorRef(value = "paramsPrepareParamsStack") })
@Results({
		@Result(name = ResponseAction.RESULT_FREQUENCY, location = "/WEB-INF/page/surveydir/survey/stats/response-frequency.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = CrudActionSupport.INPUT, location = "/WEB-INF/page/surveydir/survey/response/response-survey.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = ResponseAction.INPUT_IFRAME, location = "/WEB-INF/page/surveydir/survey/response/response-answer-iframe.jsp", type = Struts2Utils.DISPATCHER),

		@Result(name = ResponseAction.ANSWER_SUCCESS, location = "/WEB-INF/page/content/diaowen-answer/response-success.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = ResponseAction.ANSWER_FAILURE, location = "/WEB-INF/page/content/diaowen-answer/response-failure.jsp", type = Struts2Utils.DISPATCHER),

		@Result(name = ResponseAction.ANSWER_SUCCESS_M, location = "/WEB-INF/page/content/diaowen-answer/response-success-m.jsp", type = Struts2Utils.DISPATCHER),

		
		@Result(name = ResponseAction.ANSWER_INPUT_RULE, location = "/WEB-INF/page/content/diaowen-answer/response-input-rule.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = ResponseAction.ANSWER_INPUT_UP, location = "/WEB-INF/page/content/diaowen-answer/response-input-up.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = ResponseAction.ANSWER_INPUT_ERROR, location = "/WEB-INF/page/content/diaowen-answer/response-input-error.jsp", type = Struts2Utils.DISPATCHER),
		
		
		@Result(name = ResponseAction.ANSWER_ERROR, location = "/WEB-INF/page/content/diaowen-answer/response-input-error.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = ResponseAction.ANSWER_ERROR_M, location = "/WEB-INF/page/content/diaowen-answer/response-input-error-m.jsp", type = Struts2Utils.DISPATCHER),
		@Result(name = ResponseAction.ANSWER_CODE_ERROR, location = "/wenjuan/${sid}.html?errorcode=3", type = Struts2Utils.REDIRECT),
		@Result(name = ResponseAction.ANSWER_CODE_ERROR_M, location = "/survey!answerSurveryMobile.action?surveyId=${surveyId}&errorcode=3", type = Struts2Utils.REDIRECT),
		@Result(name = ResponseAction.RELOAD_ANSWER_SUCCESS, location = "response!answerSuccess.action?sid=${sid}", type = Struts2Utils.REDIRECT),
		@Result(name = ResponseAction.RELOAD_ANSWER_FAILURE, location = "response!answerFailure.action?surveyId=${surveyId}", type = Struts2Utils.REDIRECT),
		@Result(name = ResponseAction.RELOAD_ANSER_ERROR, location = "response!answerError.action?surveyId=${surveyId}", type = Struts2Utils.REDIRECT),
		@Result(name = ResponseAction.RELOAD_ANSER_ERROR_M, location = "response!answerErrorM.action?surveyId=${surveyId}", type = Struts2Utils.REDIRECT),

		@Result(name = ResponseAction.RESPONSE_MSG, location = "/WEB-INF/page/content/diaowen-answer/response-msg.jsp", type = Struts2Utils.DISPATCHER),

		@Result(name = ResponseAction.RELOAD_ANSWER_SUCCESS_M, location = "response!answerSuccessM.action?surveyId=${surveyId}", type = Struts2Utils.REDIRECT),
		@Result(name = ResponseAction.RESPONSE_MOBILE, location = "response!answerMobile.action?surveyId=${surveyId}", type = Struts2Utils.REDIRECT) })

@AllowedMethods({"saveMobile","answerSuccess","answerMobile","answerFailure","answerError","answerSuccessM","ajaxCheckSurvey","ajaxCheckJcaptchaInput",
	"ajaxCheckRuleCode","ajaxCheckSurveyUser","checkIsSubmit", "tempSave", "userLogout"})
public class ResponseAction extends ActionSupport {
	private static final long serialVersionUID = -2289729314160067840L;

	// 问卷用户登录过期时间，默认两小时
	private final Integer LOGIN_EXPIRED_MINUTES = 60 * 2;

	protected static final String RESULT_FREQUENCY = "resultFrequency";
	protected final static String INPUT_IFRAME = "input_iframe";
	protected final static String ANSWER_SUCCESS = "answerSuccess";
	protected final static String ANSWER_FAILURE = "answerFailure";
	protected final static String ANSWER_ERROR = "answerError";
	protected final static String ANSWER_ERROR_M = "answerErrorM";

	protected final static String ANSWER_SUCCESS_M = "answerSuccessM";

	protected final static String RELOAD_ANSWER_SUCCESS = "reloadAnswerSuccess";
	protected final static String RELOAD_ANSWER_FAILURE = "reloadAnswerFailure";
	protected final static String RELOAD_ANSER_ERROR = "reloadAnserError";// 已经答过，在间隔时间内
	protected final static String RELOAD_ANSER_ERROR_M = "reloadAnserErrorM";// 已经答过，在间隔时间内

	protected final static String ANSWER_CODE_ERROR = "answerCodeError";// 验证码不正确
	protected final static String ANSWER_CODE_ERROR_M = "answerCodeErrorM";// 验证码不正确
	protected final static String ANSWER_INPUT_RULE = "answer_input_rule";// 令牌
	protected final static String ANSWER_INPUT_UP = "answer_input_up";//用户名密码
	protected final static String ANSWER_INPUT_ERROR = "answer_input_error";//用户答题过多

	protected final static String RELOAD_ANSWER_SUCCESS_M = "reloadAnswerSuccessM";//

	protected final static String SURVEY_RESULT = "surveyResult";

	protected final static String RESPONSE_MSG = "responseMsg";

	protected final static String RESPONSE_MOBILE = "responseMobile";
	
	

	private String sid;
	private String surveyId;
	
	private String surveyuser_username;
	
	private String surveyuser_password;
	
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

	@Autowired
	private SurveyAnswerManager surveyAnswerManager;
	@Autowired
	private SurveyDirectoryManager directoryManager;
	@Autowired
	private IPService ipService;
	@Autowired
	private AccountManager accountManager;
	
	@Autowired
	private SurveyUserDao surveyuserdao;
	// @Autowired
	// private GenericManageableCaptchaService captchaService;
	@Autowired
	private ImageCaptchaService imageCaptchaService;
	

	/**
	 * 进入答卷页面 ：跳转策略。。同一url 进同一方法做重复判断
	 */
	public String execute() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response = Struts2Utils.getResponse();
		SurveyDirectory directory = directoryManager.getSurveyBySid(sid);
		
		surveyuser_username=request.getParameter("surveyuser_username")==null?"":request.getParameter("surveyuser_username");
		surveyuser_password=request.getParameter("surveyuser_password") == null?"":request.getParameter("surveyuser_password");
		if (directory != null) {
			surveyId = directory.getId();
			
			//判断答题状态--（问卷已经收集完毕--返回收集完毕页面）--问卷已经回答过返回已经回答的页面 --问卷包含令牌 -返回令牌页面
			String filterStatus = filterStatus(directory,request);
			if(filterStatus!=null){
				return filterStatus;
			}
//			if (HttpRequestDeviceUtils.isMobileDevice(request)) {
//				return RESPONSE_MOBILE;
//			} else {
				/*Struts2Utils.getSession().setAttribute("surveyuser_username", surveyuser_username);
				Struts2Utils.getSession().setAttribute("surveyuser_password", surveyuser_password);*/
				String htmlPath = directory.getHtmlPath();
				if(surveyuser_username.equals("")){
					// 插入开始答题时间
					String realpath=request.getServletContext().getRealPath("/")+htmlPath;
					File file=new File(realpath);
					insertStringInFile(file, 3524, "<input type='hidden' id='surveystart_time' name='surveystart_time' value='" + new Date().getTime() + "'>");
					request.getRequestDispatcher("/" + htmlPath).forward(request,
							response);
				}else{
				   //只能在文件的指定行插入
					String realpath=request.getServletContext().getRealPath("/")+htmlPath;
					File file=new File(realpath);
					insertStringInFile(file, 3524, "<input type='hidden' id='surveyuser_username' value='" + surveyuser_username + "'>" +
									"<input type='hidden' id='surveyuser_password' value='" + surveyuser_password + "'>" +
							"<input type='hidden' id='surveystart_time' name='surveystart_time' value='" + new Date().getTime() + "'>");
					Long time=new Date().getTime();
					request.getRequestDispatcher("/" + htmlPath+"?time="+time).forward(request,
							response);
				}
//			}
		}

		return NONE;
	}

	private void clearLoginUser(SurveyUser loginUser) {
		ServletContext application = Struts2Utils.getSession().getServletContext();
		List<SurveyUser> surveyUserList = (List<SurveyUser>) (application.getAttribute("surveyUsers") == null ? new ArrayList<SurveyUser>() : application.getAttribute("surveyUsers"));
		List<SurveyUser> removeUsers = new ArrayList<SurveyUser>();
		for (SurveyUser surveyUser : surveyUserList) {
			if (StringUtils.equals(surveyUser.getDirectory_id(), loginUser.getDirectory_id()) &&
					StringUtils.equals(surveyUser.getUserName(), loginUser.getUserName()) &&
					StringUtils.equals(surveyUser.getPassWord(), loginUser.getPassWord())) {
				removeUsers.add(surveyUser);
			}
		}
		surveyUserList.removeAll(removeUsers);
	}
	
	//将文件插入指定行的方法
	public void insertStringInFile(File inFile, int lineno, String lineToBeInserted)
			throws Exception {
			// 临时文件
			File outFile = File.createTempFile("name", ".tmp");
			// 输入
			FileInputStream fis = new FileInputStream(inFile);
			BufferedReader in = new BufferedReader(new InputStreamReader(fis,"utf-8"));
			// 输出
			FileOutputStream fos = new FileOutputStream(outFile);
			PrintWriter out = new PrintWriter(new OutputStreamWriter(fos,"utf-8"));
			// 保存一行数据
			String thisLine;
			// 行号从1开始
			int i = 1;
			while ((thisLine = in.readLine()) != null) {
			// 如果行号等于目标行,则输出要插入的数据
			if (i == lineno) {
			out.println(lineToBeInserted);
			}
			// 输出读取到的数据
			out.println(thisLine);
			// 行号增加
			i++;
			}
			in.close();
			out.flush();
			out.close();
			
			// 删除原始文件
			inFile.delete();
			// 把临时文件改名为原文件名
			outFile.renameTo(inFile);
			}

	private String filterStatus(SurveyDirectory directory,HttpServletRequest request) throws ParseException{
		SurveyDetail surveyDetail = directory.getSurveyDetail();
		int rule = surveyDetail.getRule();
		Integer ynEndNum = surveyDetail.getYnEndNum();
		Integer endNum = surveyDetail.getEndNum();
		Integer ynEndTime = surveyDetail.getYnEndTime();
		Date endTime = surveyDetail.getEndTime();
		Integer anserNum = directory.getAnswerNum();
        List<SurveyUser> surveyUsers=directory.getSurveyUsers();
        HttpSession session=Struts2Utils.getSession();
		if (directory.getSurveyState() == 3) {
			request.setAttribute("surveyName", "目前该问卷已暂停发布，请稍后再试");
			request.setAttribute("msg", "目前该问卷已暂停发布，请稍后再试");
			return RESPONSE_MSG;
		}
		if (directory.getSurveyQuNum() <= 0
				|| directory.getSurveyState() != 1 ||
				(anserNum!=null && ynEndNum==1 && anserNum >= endNum ) ||
				(endTime!=null && ynEndTime==1 && endTime.getTime() < (new Date().getTime())) ){
			request.setAttribute("surveyName", "目前该问卷已暂停收集，请稍后再试");
			request.setAttribute("msg", "目前该问卷已暂停收集，请稍后再试");
			return RESPONSE_MSG;
		}
		//重复答题的判断
		if (2 == rule) {
			request.setAttribute("msg", "rule2");
			return RELOAD_ANSER_ERROR;
		}
		//默认的用户名密码答题
		else if(surveyUsers!= null && surveyUsers.size()!=0){
			String surveyuser_username=request.getParameter("surveyuser_username");
			String surveyuser_password=request.getParameter("surveyuser_password");
			
			List<Criterion> criterions=new ArrayList<Criterion>();
			criterions.add(Restrictions.eq("userName", surveyuser_username));
			criterions.add(Restrictions.eq("passWord", surveyuser_password));
			criterions.add(Restrictions.eq("directory_id",directory.getId()));
			SurveyUser surveyUser=surveyuserdao.findFirst(criterions);
			SurveyAnswer surveyAnswer=null;
			if(surveyUser !=null){
				surveyAnswer=surveyAnswerManager.findbyUsername(surveyuser_username,directory.getId(), 0);
			}
			
			//这边可能要新增用户过期的逻辑
		 	if(surveyAnswer != null){
				// 用户已经回答过问卷，清除登录
				SurveyUser loginUser = new SurveyUser(surveyId, surveyuser_username, surveyuser_password);
				clearLoginUser(loginUser);
				return RELOAD_ANSER_ERROR;
			} else if(surveyUser == null || new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(surveyUser.getEndTime()).before(new Date())){
				request.setAttribute("directory", directory);
				return  ANSWER_INPUT_UP;
			}else{
				session.setAttribute("surveyuser_id", surveyUser.getId());
			}
		}
		else if (3 == rule) {
			String ruleCode = request.getParameter("ruleCode");
			String surveyRuleCode = surveyDetail.getRuleCode();
			if (ruleCode == null || !ruleCode.equals(surveyRuleCode)) {
				return ANSWER_INPUT_RULE;
			}
		}
		return null;
	}

	public String answerMobile() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response = Struts2Utils.getResponse();
		SurveyDirectory directory = directoryManager.getSurvey(surveyId);
		if (directory != null) {
			String filterStatus = filterStatus(directory,request);
			if(filterStatus!=null){
				return filterStatus;
			}
			String htmlPath = directory.getHtmlPath();
			htmlPath = htmlPath.substring(0,htmlPath.lastIndexOf("/"));
			String realpath=request.getServletContext().getRealPath("/")+htmlPath+"/m_"+surveyId+".html";
			File file=new File(realpath);
			insertStringInFile(file,3035,"<input type='hidden' id='surveyuser_username' value='"+surveyuser_username+"'><br/><input type='hidden' id='surveyuser_password' value='"+surveyuser_password+"'>");
			request.getRequestDispatcher("/" + htmlPath+"/m_"+surveyId+".html").forward(request,response);
			return NONE;
		}

		return NONE;
	}

	public String tempSave() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response = Struts2Utils.getResponse();
		String surveyuser_id=request.getParameter("surveyuser_id");

		String surveyuser_username=request.getParameter("surveyuser_username");
		String surveyuser_password=request.getParameter("surveyuser_password");
		String surveystart_time=request.getParameter("surveystart_time");

		//答案对象
		SurveyAnswer entity = new SurveyAnswer();
		User user = accountManager.getCurUser();
		if (user != null) {
			//entity.setUserId(user.getId());
			entity.setUserId(surveyuser_id);
		}
		if (StringUtils.isNotEmpty(surveystart_time)) {
			long time = Long.parseLong(surveystart_time);
			entity.setBgAnDate(new Date(time));
		} else {
			entity.setBgAnDate(new Date());
		}
		if (surveyuser_password != null) {
			entity.setAnswerPassword(surveyuser_password);
		} else {
			entity.setAnswerPassword("");
		}
		if(surveyuser_username != null){
			entity.setAnswerUserName(surveyuser_username);
		}else{
			entity.setAnswerUserName("");
		}
		String ipAddr = ipService.getIp(request);
		Map<String, Map<String, Object>> quMaps = buildSaveSurveyMap(request);
		String addr = ipService.getCountry(ipAddr);
		String city = ipService.getCurCityByCountry(addr);
		entity.setIpAddr(ipAddr);
		entity.setAddr(addr);
		entity.setCity(city);
		entity.setSurveyId(surveyId);
		entity.setDataSource(0);
		entity.setIsTemp(1);
		surveyAnswerManager.tempSaveAnswer(entity, quMaps);

//		SurveyUser loginUser = new SurveyUser(surveyId, surveyuser_username, surveyuser_password);
//		this.clearLoginUser(loginUser);
		response.getWriter().write("保存成功");
		return null;
	}

	public String userLogout() throws IOException {
		SurveyUser loginUser = new SurveyUser(surveyId, surveyuser_username, surveyuser_password);
		this.clearLoginUser(loginUser);
		Struts2Utils.getResponse().getWriter().write("退出成功");
		return null;
	}

	public String save() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response = Struts2Utils.getResponse();
		ServletContext application=Struts2Utils.getRequest().getServletContext();
		String formFrom = request.getParameter("form-from");
		String surveyuser_id=request.getParameter("surveyuser_id");
		
		String surveyuser_username=request.getParameter("surveyuser_username");
		String surveyuser_password=request.getParameter("surveyuser_password");
		String surveystart_time=request.getParameter("surveystart_time");
		try {
			
			List<SurveyUser> surveyusers=(List<SurveyUser>) application.getAttribute("surveyUsers");
			List<SurveyUser> temps=new ArrayList<SurveyUser>();
			if(surveyusers != null && surveyusers.size() != 0){
				for(SurveyUser surveyUser:surveyusers){
					if(surveyUser.getUserName().equals(surveyuser_username)&& surveyUser.getPassWord().equals(surveyuser_password)){
						temps.add(surveyUser);
					}
				}
				surveyusers.removeAll(temps);
				application.setAttribute("surveyUsers", surveyusers);
			}

			String ipAddr = ipService.getIp(request);
			long ipNum = surveyAnswerManager.getCountByIp(surveyId, ipAddr);
			SurveyDirectory directory = directoryManager.getSurvey(surveyId);

			// 校验是否暂停发布
			if (directory.getSurveyState().equals(3)) {
				request.setAttribute("msg", "目前该问卷已暂停发布，请稍后再试");
				return RESPONSE_MSG;
			}
			SurveyDetail surveyDetail = directory.getSurveyDetail();
			int refreshNum = surveyDetail.getRefreshNum();
			
			Integer refresh=surveyDetail.getRefresh();
			User user = accountManager.getCurUser();
			
			//答案对象
			SurveyAnswer entity = new SurveyAnswer();
			if (user != null) {
				//entity.setUserId(user.getId());
				entity.setUserId(surveyuser_id);
			}
			if(surveyuser_username != null){
				entity.setAnswerUserName(surveyuser_username);
			}else{
				entity.setAnswerUserName("");
			}
			if (surveyuser_password != null) {
				entity.setAnswerPassword(surveyuser_password);
			} else {
				entity.setAnswerPassword("");
			}
			if (StringUtils.isNotEmpty(surveystart_time)) {
				long time = Long.parseLong(surveystart_time);
				entity.setBgAnDate(new Date(time));
			} else {
				entity.setBgAnDate(new Date());
			}
			Cookie cookie = CookieUtils.getCookie(request, surveyId);
			Integer effectiveIp = surveyDetail.getEffectiveIp();
			Integer effective = surveyDetail.getEffective();
			if ((effective != null && effective > 1 && cookie != null) || (effectiveIp != null && effectiveIp == 1 && ipNum > 0)) {
				return RELOAD_ANSER_ERROR;
			}
			if (ipNum >= refreshNum && refresh == 1) {
				String code = request.getParameter("jcaptchaInput");
				if (!imageCaptchaService.validateResponseForID(request.getSession().getId(), code)) {
					return ANSWER_CODE_ERROR;
				}
			}
			Map<String, Map<String, Object>> quMaps = buildSaveSurveyMap(request);
			String addr = ipService.getCountry(ipAddr);
			String city = ipService.getCurCityByCountry(addr);
			entity.setIpAddr(ipAddr);
			entity.setAddr(addr);
			entity.setCity(city);
			entity.setSurveyId(surveyId);
			entity.setDataSource(0);
			surveyAnswerManager.saveAnswer(entity, quMaps);
		    String answerId=entity.getId();
		    request.getSession().setAttribute("answerId", answerId);
			int effe = surveyDetail.getEffectiveTime();
			CookieUtils.addCookie(response, surveyId, (ipNum + 1) + "",
					effe * 60, "/");
			// exambatchManager.savePaperAnswer(entity,quMaps);
		} catch (Exception e) {
			e.printStackTrace();
			return RELOAD_ANSWER_FAILURE;
		}
		return RELOAD_ANSWER_SUCCESS;
	}

	public String saveMobile() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response = Struts2Utils.getResponse();

		try {
			String ipAddr = ipService.getIp(request);
			long ipNum = surveyAnswerManager.getCountByIp(surveyId, ipAddr);
			SurveyDirectory directory = directoryManager.getSurvey(surveyId);
			SurveyDetail surveyDetail = directory.getSurveyDetail();
			int refreshNum = surveyDetail.getRefreshNum();
			User user = accountManager.getCurUser();

			SurveyAnswer entity = new SurveyAnswer();
			if (user != null) {
				entity.setUserId(user.getId());
			}
			Cookie cookie = CookieUtils.getCookie(request, surveyId);
			Integer effectiveIp = surveyDetail.getEffectiveIp();
			Integer effective = surveyDetail.getEffective();
			if ((effective != null && effective > 1 && cookie != null) || (effectiveIp != null && effectiveIp == 1 && ipNum > 0)) {
				return RELOAD_ANSER_ERROR_M;
			}
			if (ipNum >= refreshNum) {
				String code = request.getParameter("jcaptchaInput");
				if (!imageCaptchaService.validateResponseForID(request
						.getSession().getId(), code)) {
					return ANSWER_CODE_ERROR_M;
				}
			}

			Map<String, Map<String, Object>> quMaps = buildSaveSurveyMap(request);
			String addr = ipService.getCountry(ipAddr);
			String city = ipService.getCurCityByCountry(addr);
			entity.setIpAddr(ipAddr);
			entity.setAddr(addr);
			entity.setCity(city);
			entity.setSurveyId(surveyId);
			entity.setDataSource(0);
			surveyAnswerManager.saveAnswer(entity, quMaps);

			int effe = surveyDetail.getEffectiveTime();
			CookieUtils.addCookie(response, surveyId, (ipNum + 1) + "",
					effe * 60, "/");
			// exambatchManager.savePaperAnswer(entity,quMaps);
		} catch (Exception e) {
			e.printStackTrace();
			return RELOAD_ANSWER_FAILURE;
		}
		return RELOAD_ANSWER_SUCCESS_M;
		// return SURVEY_RESULT;
	}


	public Map<String, Map<String, Object>> buildSaveSurveyMap(HttpServletRequest request) {
		Map<String, Map<String, Object>> quMaps = new HashMap<String, Map<String, Object>>();
		Map<String, Object> yesnoMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.YESNO + "_");//是非
		quMaps.put("yesnoMaps", yesnoMaps);
		Map<String, Object> radioMaps = WebUtils.getParametersStartingWith(
				request, "qu_"+QuType.RADIO + "_");//单选
		Map<String, Object> checkboxMaps = WebUtils.getParametersStartingWith(
				request, "qu_"+QuType.CHECKBOX + "_");//多选
		Map<String, Object> fillblankMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.FILLBLANK + "_");//填空
		quMaps.put("fillblankMaps", fillblankMaps);
		Map<String, Object> dfillblankMaps = WebUtils
				.getParametersStartingWith(request, "qu_"
						+ QuType.MULTIFILLBLANK + "_");//多项填空
		for (String key : dfillblankMaps.keySet()) {
			String dfillValue = dfillblankMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, dfillValue);
			dfillblankMaps.put(key, map);
		}
		quMaps.put("multifillblankMaps", dfillblankMaps);
		Map<String, Object> answerMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.ANSWER + "_");//多行填空
		quMaps.put("answerMaps", answerMaps);
		Map<String, Object> compRadioMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.COMPRADIO + "_");//复合单选
		for (String key : compRadioMaps.keySet()) {
			String enId = key;
			String quItemId = compRadioMaps.get(key).toString();
			String otherText = Struts2Utils.getParameter("text_qu_"
					+ QuType.COMPRADIO + "_" + enId + "_" + quItemId);
			AnRadio anRadio = new AnRadio();
			anRadio.setQuId(enId);
			anRadio.setQuItemId(quItemId);
			anRadio.setOtherText(otherText);
			compRadioMaps.put(key, anRadio);
		}
		quMaps.put("compRadioMaps", compRadioMaps);
		Map<String, Object> compCheckboxMaps = WebUtils
				.getParametersStartingWith(request, "qu_" + QuType.COMPCHECKBOX
						+ "_");//复合多选
		for (String key : compCheckboxMaps.keySet()) {
			String dfillValue = compCheckboxMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, "tag_" + dfillValue);
			for (String key2 : map.keySet()) {
				String quItemId = map.get(key2).toString();
				String otherText = Struts2Utils.getParameter("text_"
						+ dfillValue + quItemId);
				AnCheckbox anCheckbox = new AnCheckbox();
				anCheckbox.setQuItemId(quItemId);
				anCheckbox.setOtherText(otherText);
				map.put(key2, anCheckbox);
			}
			compCheckboxMaps.put(key, map);
		}
		quMaps.put("compCheckboxMaps", compCheckboxMaps);
		Map<String, Object> enumMaps = WebUtils.getParametersStartingWith(request, "qu_" + QuType.ENUMQU + "_");//枚举
		quMaps.put("enumMaps", enumMaps);
		Map<String, Object> scoreMaps = WebUtils.getParametersStartingWith(request, "qu_" + QuType.SCORE + "_");//分数
		for (String key : scoreMaps.keySet()) {
			String tag = scoreMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			scoreMaps.put(key, map);
		}
		quMaps.put("scoreMaps", scoreMaps);
		Map<String, Object> quOrderMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.ORDERQU + "_");//排序
		for (String key : quOrderMaps.keySet()) {
			String tag = quOrderMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			quOrderMaps.put(key, map);
		}
		quMaps.put("quOrderMaps", quOrderMaps);
		Map<String, Object> chenRadioMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.CHENRADIO + "_");
		for (String key : chenRadioMaps.keySet()) {
			String tag = chenRadioMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			chenRadioMaps.put(key, map);
		}
		quMaps.put("chenRadioMaps", chenRadioMaps);
		Map<String, Object> chenCheckboxMaps = WebUtils
				.getParametersStartingWith(request, "qu_" + QuType.CHENCHECKBOX
						+ "_");
		for (String key : chenCheckboxMaps.keySet()) {
			String tag = chenCheckboxMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			for (String keyRow : map.keySet()) {
				String tagRow = map.get(keyRow).toString();
				Map<String, Object> mapRow = WebUtils
						.getParametersStartingWith(request, tagRow);
				map.put(keyRow, mapRow);
			}
			chenCheckboxMaps.put(key, map);
		}
		quMaps.put("chenCheckboxMaps", chenCheckboxMaps);
		Map<String, Object> chenScoreMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.CHENSCORE + "_");
		for (String key : chenScoreMaps.keySet()) {
			String tag = chenScoreMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			for (String keyRow : map.keySet()) {
				String tagRow = map.get(keyRow).toString();
				Map<String, Object> mapRow = WebUtils
						.getParametersStartingWith(request, tagRow);
				map.put(keyRow, mapRow);
			}
			chenScoreMaps.put(key, map);
		}
		quMaps.put("chenScoreMaps", chenScoreMaps);
		Map<String, Object> chenFbkMaps = WebUtils.getParametersStartingWith(
				request, "qu_" + QuType.CHENFBK + "_");
		for (String key : chenFbkMaps.keySet()) {
			String tag = chenFbkMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			for (String keyRow : map.keySet()) {
				String tagRow = map.get(keyRow).toString();
				Map<String, Object> mapRow = WebUtils
						.getParametersStartingWith(request, tagRow);
				map.put(keyRow, mapRow);
			}
			chenFbkMaps.put(key, map);
		}
		quMaps.put("chenFbkMaps", chenFbkMaps);
		for (String key:radioMaps.keySet()) {
			String enId = key;
			String quItemId = radioMaps.get(key).toString();
			String otherText = Struts2Utils.getParameter("text_qu_"
					+ QuType.RADIO + "_" + enId + "_" + quItemId);
			AnRadio anRadio = new AnRadio();
			anRadio.setQuId(enId);
			anRadio.setQuItemId(quItemId);
			anRadio.setOtherText(otherText);
			radioMaps.put(key, anRadio);
		}
		quMaps.put("compRadioMaps", radioMaps);
		for (String key : checkboxMaps.keySet()) {
			String dfillValue = checkboxMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, dfillValue);
			for (String key2 : map.keySet()) {
				String quItemId = map.get(key2).toString();
				String otherText = Struts2Utils.getParameter("text_"
						+ dfillValue + quItemId);
				AnCheckbox anCheckbox = new AnCheckbox();
				anCheckbox.setQuItemId(quItemId);
				anCheckbox.setOtherText(otherText);
				map.put(key2, anCheckbox);
			}
			checkboxMaps.put(key, map);
		}
		quMaps.put("compCheckboxMaps", checkboxMaps);
		Map<String, Object> chenCompChenRadioMaps = WebUtils
				.getParametersStartingWith(request, "qu_"
						+ QuType.COMPCHENRADIO + "_");
		for (String key : chenCompChenRadioMaps.keySet()) {
			String tag = chenCompChenRadioMaps.get(key).toString();
			Map<String, Object> map = WebUtils.getParametersStartingWith(
					request, tag);
			for (String keyRow : map.keySet()) {
				String tagRow = map.get(keyRow).toString();
				Map<String, Object> mapRow = WebUtils
						.getParametersStartingWith(request, tagRow);
				map.put(keyRow, mapRow);
			}
			chenCompChenRadioMaps.put(key, map);
		}
		quMaps.put("compChenRadioMaps", chenCompChenRadioMaps);
		return quMaps;
	}

	public String answerSuccess() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		SurveyDirectory directory = directoryManager.getSurveyBySid(sid);
		request.setAttribute("surveyName", directory.getSurveyName());
		request.setAttribute("viewAnswer", directory.getViewAnswer());
		request.setAttribute("sid", directory.getSid());
		return ANSWER_SUCCESS;
	}

	public String answerFailure() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		SurveyDirectory directory = directoryManager.get(surveyId);
		request.setAttribute("surveyName", directory.getSurveyName());
		request.setAttribute("sId", directory.getSid());
		return ANSWER_FAILURE;
	}

	public String answerError() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		SurveyDirectory directory = directoryManager.get(surveyId);
		request.setAttribute("surveyName", directory.getSurveyName());
		request.setAttribute("sId", directory.getSid());
		String ipAddr = ipService.getIp(request);
		request.setAttribute("ip", ipAddr);
		return ANSWER_ERROR;
	}

	public String answerErrorM() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		SurveyDirectory directory = directoryManager.get(surveyId);
		request.setAttribute("surveyName", directory.getSurveyName());
		request.setAttribute("sId", directory.getSid());
		String ipAddr = ipService.getIp(request);
		request.setAttribute("ip", ipAddr);
		return ANSWER_ERROR_M;
	}

	public String answerSuccessM() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		SurveyDirectory directory = directoryManager.get(surveyId);
		request.setAttribute("directory", directory);
		return ANSWER_SUCCESS_M;
	}

	/**
	 * 异步有效性验证
	 * 
	 * @return
	 */
	public String ajaxCheckSurvey() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		HttpServletResponse response = Struts2Utils.getResponse();
		HttpSession session=Struts2Utils.getSession();
	
		// 0 1 2
		String ajaxResult = "0";
		try {
			SurveyDirectory directory = directoryManager.getSurvey(surveyId);
			SurveyDetail surveyDetail = directory.getSurveyDetail();
			
			Integer refresh=surveyDetail.getRefresh();
			int effective = surveyDetail.getEffective();
			int rule = surveyDetail.getRule();
			request.setAttribute("directory", directory);
			String surveyuser_id=(String) session.getAttribute("surveyuser_id");
			// 调查规则
			String surveyStatus = "0";
			// cookie
			Cookie cookie = CookieUtils.getCookie(request, surveyId);
			// 根据 源IP
			String ip = ipService.getIp(request);
			Long ipNum = 0L;
			if (effective > 1) {
				// 根据 cookie过滤
				if (cookie != null) {
					String cookieValue = cookie.getValue();
					if (cookieValue != null
							&& NumberUtils.isNumeric(cookieValue)) {
						ipNum = Long.parseLong(cookieValue);
					}
					surveyStatus = "1";
				} else {
					/*
					 * SurveyAnswer surveyAnswer =
					 * surveyAnswerManager.getTimeInByIp(surveyDetail, ip); if
					 * (surveyAnswer != null) { request.setAttribute("msg",
					 * 2);//表示在有效性验证，间隔时间内 surveyStatus="1"; }
					 */
				}
			}

			ipNum = surveyAnswerManager.getCountByIp(surveyId, ip);
			if (ipNum == null) {
				ipNum = 0L;
			}
			Integer effectiveIp = surveyDetail.getEffectiveIp();
			if (effectiveIp != null && effectiveIp == 1 && ipNum > 0) {
				surveyStatus = "2";
			}

			String isCheckCode = "0";
			// 启用验证码
			int refreshNum = surveyDetail.getRefreshNum();
			if (ipNum >= refreshNum && refresh == 1 ) {
				isCheckCode = "3";
			}
			ajaxResult = "{surveyStatus:\"" + surveyStatus
					+ "\",isCheckCode:\"" + isCheckCode + "\",surveyuser_id:\""+surveyuser_id+"\"}";
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.getWriter().write(ajaxResult);
		return null;
	}
	
	
	public String ajaxCheckJcaptchaInput() throws IOException{
		HttpServletRequest  request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		String jcaptchaInput=request.getParameter("jcaptchaInput");
		String msg="true";
		if(!imageCaptchaService.validateResponseForID(request.getSession().getId(), jcaptchaInput)){
			msg="false";
		}
		response.getWriter().write(msg);
		return  null;
	}
	
	public String ajaxCheckRuleCode() throws Exception{
		HttpServletRequest  request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		String sId=request.getParameter("sId");
		String ruleCode = request.getParameter("ruleCode");
		SurveyDirectory surveyDirectory=directoryManager.getSurveyBySid(sId);
		if(ruleCode != null && !"".equals(ruleCode) && ruleCode.equals(surveyDirectory.getSurveyDetail().getRuleCode())){
			response.getWriter().write("1");
		}else{
			response.getWriter().write("0");
		}
		return null;
	}
	
	public String ajaxCheckSurveyUser() throws Exception{
		HttpServletRequest  request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		ServletContext application=Struts2Utils.getSession().getServletContext();
		String surveyuser_username = request.getParameter("surveyuser_username");
		String surveyuser_password = request.getParameter("surveyuser_password");
		String sid=request.getParameter("sid");
		SurveyDirectory surveyDirectory=directoryManager.getSurveyBySid(sid);
		String directoryId=surveyDirectory.getId();
		// 数据库用户名密码
		List<SurveyUser> surveyUsers=surveyuserdao.findByNamePassByDirId(surveyuser_username, surveyuser_password, directoryId);
		// 正在登录的用户
		List<SurveyUser> surveyUserList=(List<SurveyUser>) (application.getAttribute("surveyUsers")==null?new ArrayList<SurveyUser>():application.getAttribute("surveyUsers"));
		if(surveyUsers == null || surveyUsers.size() == 0){
			// 用户名密码错误
			response.getWriter().write("0");
		}else if(containsSurveyUser(surveyUserList,surveyUsers.get(0))){
			// 用户正在答题
			response.getWriter().write("-2");
		} else{
			SurveyUser surveyUser=surveyUsers.get(0);
			SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			if(simpleDateFormat.parse(surveyUser.getEndTime()).before(new Date())){
				// 答题时间已经结束
				response.getWriter().write("-1");
			}else{
				// 登录
				List<SurveyUser> temp=(List<SurveyUser>) (application.getAttribute("surveyUsers")==null?new ArrayList<SurveyUser>():application.getAttribute("surveyUsers"));
				surveyUser.setLoginTime(new Date());
				temp.add(surveyUser);
				application.setAttribute("surveyUsers", temp);
 				response.getWriter().write("1");
			}
		}
		
		return null;
	}
	
	public String checkIsSubmit() throws Exception{
		HttpServletRequest  request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		String surveyuser_username=request.getParameter("surveyuser_username");
		String surveyuser_password=request.getParameter("surveyuser_password");
		ServletContext application=Struts2Utils.getSession().getServletContext();
		List<SurveyUser> surveyUserList=(List<SurveyUser>) (application.getAttribute("surveyUsers")==null?new ArrayList<SurveyUser>():application.getAttribute("surveyUsers"));
		List<SurveyUser> surveyUsers=new ArrayList<SurveyUser>();
		if(surveyUserList != null && surveyUserList.size() != 0){
			for(SurveyUser temp :surveyUserList){
				
				if(temp.getUserName().equals(surveyuser_username) && temp.getPassWord().equals(surveyuser_password)){
					surveyUsers.add(temp);
				}
			}
			surveyUserList.removeAll(surveyUsers);
			application.setAttribute("surveyUsers", surveyUserList);
		}
		
		return null;
	}
	
	public boolean containsSurveyUser(List<SurveyUser> surveyList,SurveyUser surveyUser){
		boolean flag=false;
		for(SurveyUser temp:surveyList){
			if(StringUtils.equals(temp.getDirectory_id(), surveyUser.getDirectory_id()) &&
					StringUtils.equals(temp.getUserName(), surveyUser.getUserName()) &&
					StringUtils.equals(temp.getPassWord(), surveyUser.getPassWord())){
				if (calcTimeDiffMinutes(temp.getLoginTime(), new Date()) >= LOGIN_EXPIRED_MINUTES) {
					// 登录两小时
					flag = false;
					clearLoginUser(temp);
				} else {
					flag=true;
				}
				break;
			}
		}
		
		return flag;
		
	}

	/**
	 * 计算时间差，返回分钟
	 * @param start
	 * @param end
	 * @return
	 */
	private int calcTimeDiffMinutes(Date start, Date end) {
		return (int) (end.getTime() - start.getTime()) / (1000 * 60);
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getSurveyId() {
		return surveyId;
	}

	public void setSurveyId(String surveyId) {
		this.surveyId = surveyId;
	}

}
