package com.key.dwsurvey.action;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.key.common.plugs.page.Page;
import com.key.dwsurvey.entity.AnFillblank;
import com.key.dwsurvey.entity.Question;
import com.key.dwsurvey.entity.QuestionLogic;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.service.AnFillblankManager;
import com.key.dwsurvey.service.SurveyDirectoryManager;

import org.apache.struts2.convention.annotation.*;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.util.WebUtils;

import com.key.common.utils.web.Struts2Utils;
import com.key.common.CheckType;
import com.key.common.QuType;
import com.key.dwsurvey.service.QuestionManager;
import com.opensymphony.xwork2.ActionSupport;
/**
 * 填空题 action
 * @author KeYuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 *
 */
@Namespaces({@Namespace("/design")})
@InterceptorRefs({ @InterceptorRef("paramsPrepareParamsStack") })
@Results({
		@Result(name="answers",location="/WEB-INF/page/content/diaowen-da/fillblank.jsp",type=Struts2Utils.DISPATCHER)
})
@AllowedMethods({"ajaxSave","answers"})
public class QuFillblankAction extends ActionSupport{
	@Autowired
	private QuestionManager questionManager;
	@Autowired
	private AnFillblankManager anFillblankManager;
	
	@Autowired
	private SurveyDirectoryManager surveyDirectoryManager;
	
	public String ajaxSave() throws Exception {
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		try{
			Question entity=ajaxBuildSaveOption(request);
			questionManager.save(entity);
			String resultJson=buildResultJson(entity);
			response.getWriter().write(resultJson);
			//返回各部分ID
		}catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("error");
		}
		return null;
	}
	
	private Question ajaxBuildSaveOption(HttpServletRequest request) throws UnsupportedEncodingException {
		String quId=request.getParameter("quId");
		String belongId=request.getParameter("belongId");
		String quTitle=request.getParameter("quTitle");
		String orderById=request.getParameter("orderById");
		String tag=request.getParameter("tag");
		//isRequired 是否必选
		String isRequired=request.getParameter("isRequired");
		
		String answerInputWidth=request.getParameter("answerInputWidth");
		String answerInputRow=request.getParameter("answerInputRow");
		
		String contactsAttr=request.getParameter("contactsAttr");
		String contactsField=request.getParameter("contactsField");
		
		String checkType=request.getParameter("checkType");
		
		
		/** 某一类型题目特有的 **/
		//hv 1水平显示 2垂直显示
		String hv=request.getParameter("hv");
		//randOrder 选项随机排列
		String randOrder=request.getParameter("randOrder");
		String cellCount=request.getParameter("cellCount");
		
		if("".equals(quId)){
			quId=null;
		}
		Question entity=questionManager.getModel(quId);
		entity.setBelongId(belongId);
		String  projectName=request.getServletContext().getContextPath();
		if(quTitle!=null){
			quTitle=URLDecoder.decode(quTitle,"utf-8");
//			quTitle =quTitle.replace("href=\"", "href=\""+projectName);
			entity.setQuTitle(quTitle);
		}
		entity.setOrderById(Integer.parseInt(orderById));
		entity.setTag(Integer.parseInt(tag));
		entity.setQuType(QuType.FILLBLANK);
		//参数
		
		//设置必答题的数目
	
		isRequired=(isRequired==null || "".equals(isRequired))?"0":isRequired;
		hv=(hv==null || "".equals(hv))?"0":hv;
		randOrder=(randOrder==null || "".equals(randOrder))?"0":randOrder;
		cellCount=(cellCount==null || "".equals(cellCount))?"0":cellCount;
		
		contactsAttr=(contactsAttr==null || "".equals(contactsAttr))?"0":contactsAttr;
		entity.setContactsAttr(Integer.parseInt(contactsAttr));
		entity.setContactsField(contactsField);
		
		
		answerInputWidth=(answerInputWidth==null || "".equals(answerInputWidth))?"300":answerInputWidth;
		answerInputRow=(answerInputRow==null || "".equals(answerInputRow))?"1":answerInputRow;
		entity.setAnswerInputWidth(Integer.parseInt(answerInputWidth));
		entity.setAnswerInputRow(Integer.parseInt(answerInputRow));
		
		entity.setIsRequired(Integer.parseInt(isRequired));
		entity.setHv(Integer.parseInt(hv));
		entity.setRandOrder(Integer.parseInt(randOrder));
		entity.setCellCount(Integer.parseInt(cellCount));
		
		checkType=(checkType==null || "".equals(checkType))?"NO":checkType;
		entity.setCheckType(CheckType.valueOf(checkType));
		
		//逻辑选项设置 --找到所有的逻辑选项的id值
		Map<String, Object> quLogicIdMap=WebUtils.getParametersStartingWith(request, "quLogicId_");
		List<QuestionLogic> quLogics=new ArrayList<QuestionLogic>();
		for (String key : quLogicIdMap.keySet()) {
			String cgQuItemId=request.getParameter("cgQuItemId_"+key);
			String ckQuItemId=request.getParameter("ckQuItemId_"+key);
			String skQuId=request.getParameter("skQuId_"+key);
			String geLe=request.getParameter("geLe_"+key);
			String scoreNum=request.getParameter("scoreNum_"+key);
			String visibility=request.getParameter("visibility_"+key);
			String logicType=request.getParameter("logicType_"+key);
			String eqAndNq=request.getParameter("eqAndNq_"+key);
			Object quLogicId=quLogicIdMap.get(key);
			String quLogicIdValue=(quLogicId!=null)?quLogicId.toString():"";
			
			QuestionLogic quLogic=new QuestionLogic();
			if("".equals(quLogic)){
				quLogic=null;
			}
			quLogic.setId(quLogicIdValue);
			quLogic.setCgQuItemId(cgQuItemId);
		    if(ckQuItemId != null && ckQuItemId != ""){
		    	quLogic.setCkQuItemId(ckQuItemId);
		    }
			quLogic.setSkQuId(skQuId);
			quLogic.setEqAndNq(eqAndNq);
			quLogic.setGeLe(geLe);
			quLogic.setScoreNum(scoreNum);
			quLogic.setVisibility(Integer.parseInt(visibility));
			quLogic.setTitle(key);
			quLogic.setLogicType(logicType);
			quLogics.add(quLogic);
		}
		entity.setQuestionLogics(quLogics);
		
		return entity;
	}
	
	public static String buildResultJson(Question entity){
		//{id:'null',quItems:[{id:'null',title:'null'},{id:'null',title:'null'}]}
		StringBuffer strBuf=new StringBuffer();
		strBuf.append("{id:'").append(entity.getId());
		strBuf.append("',orderById:");
		strBuf.append(entity.getOrderById());
		
		strBuf.append(",quLogics:[");
		List<QuestionLogic> questionLogics=entity.getQuestionLogics();
		if(questionLogics!=null){
			for (QuestionLogic questionLogic : questionLogics) {
				strBuf.append("{id:'").append(questionLogic.getId());
				strBuf.append("',title:'").append(questionLogic.getTitle()).append("'},");
			}
		}
		int strLen=strBuf.length();
		if(strBuf.lastIndexOf(",")==(strLen-1)){
			strBuf.replace(strLen-1, strLen, "");
		}
		strBuf.append("]}");
		return strBuf.toString();
	}


	private Page<AnFillblank> anPage = new Page<AnFillblank>();
	//取上传题结果
	public String answers() throws Exception {
		HttpServletRequest request = Struts2Utils.getRequest();
		String quId = request.getParameter("quId");
		String surveyId = request.getParameter("surveyId");
		SurveyDirectory directory=surveyDirectoryManager.get(surveyId);
		anPage.setPageSize(1000);
		Criterion cri1 = Restrictions.eq("quId",quId);
		anPage = anFillblankManager.findPage(anPage, cri1);
		request.setAttribute("surveyId",surveyId);
		request.setAttribute("directory", directory);
		
		return "answers";
	}

	public Page<AnFillblank> getAnPage() {
		return anPage;
	}

	public void setAnPage(Page<AnFillblank> anPage) {
		this.anPage = anPage;
	}


}
