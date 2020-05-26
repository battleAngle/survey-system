package com.key.dwsurvey.action;

import com.key.common.plugs.page.Page;
import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.service.QuChenRowManager;
import com.key.common.QuType;
import com.key.dwsurvey.dao.AnChenFbkDao;
import com.key.dwsurvey.entity.AnChenFbk;
import com.key.dwsurvey.entity.AnDFillblank;
import com.key.dwsurvey.entity.QuChenColumn;
import com.key.dwsurvey.entity.QuChenRow;
import com.key.dwsurvey.entity.Question;
import com.key.dwsurvey.entity.QuestionLogic;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.service.AnChenFbkManager;
import com.key.dwsurvey.service.QuChenColumnManager;
import com.key.dwsurvey.service.QuestionManager;
import com.key.dwsurvey.service.SurveyDirectoryManager;
import com.opensymphony.xwork2.ActionSupport;

import org.apache.struts2.convention.annotation.*;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 矩阵单选，矩阵多选，矩阵填空
 * @author KeYuan(keyuan258@gmail.com)
 * @date 2014下午10:11:53
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
@AllowedMethods({"ajaxSave","ajaxDeleteColumn","ajaxDeleteRow","answers"})
public class QuChenAction extends ActionSupport{
	@Autowired
	private QuestionManager questionManager;
	@Autowired
	private QuChenRowManager quChenRowManager;
	@Autowired
	private QuChenColumnManager quChenColumnManager;
	
	@Autowired
	private SurveyDirectoryManager surveyDirectoryManager;
	
	@Autowired
	private AnChenFbkManager  anChenFbkManager;
	
	
	public String ajaxSave() throws Exception {
		HttpServletRequest request= Struts2Utils.getRequest();
		HttpServletResponse response= Struts2Utils.getResponse();
		try{
			Question entity=ajaxBuildSaveOption(request);
			questionManager.save(entity);
			String resultJson=buildResultJson(entity);
			System.err.println("保存次数");
			response.getWriter().write(resultJson);
		}catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("error");
		}
		return null;
	}
	
	private Question ajaxBuildSaveOption(HttpServletRequest request) throws UnsupportedEncodingException {
		String quId=request.getParameter("quId");
		String trWidthInfo=request.getParameter("trWidthInfo");
		String belongId=request.getParameter("belongId");
		String quTitle=request.getParameter("quTitle");
		String orderById=request.getParameter("orderById");
		String tag=request.getParameter("tag");
		String quType=request.getParameter("quType");
		String minSliderLength=request.getParameter("minSliderLength");
		String maxSliderLength=request.getParameter("maxSliderLength");
				
		
		//isRequired 是否必选
		String isRequired=request.getParameter("isRequired");
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
		if(quType.equals("CHENSCORE")){
			entity.setMaxSliderLength(Integer.parseInt(maxSliderLength));
			entity.setMinSliderLength(Integer.parseInt(minSliderLength));
		}
		entity.setTrWidthInfo(trWidthInfo);
		entity.setTag(Integer.parseInt(tag));
		//quType
		entity.setQuType(QuType.valueOf(quType));
		//参数
		isRequired=(isRequired==null || "".equals(isRequired))?"0":isRequired;
		hv=(hv==null || "".equals(hv))?"0":hv;
		randOrder=(randOrder==null || "".equals(randOrder))?"0":randOrder;
		cellCount=(cellCount==null || "".equals(cellCount))?"0":cellCount;
		
		entity.setIsRequired(Integer.parseInt(isRequired));
		entity.setHv(Integer.parseInt(hv));
		entity.setRandOrder(Integer.parseInt(randOrder));
		entity.setCellCount(Integer.parseInt(cellCount));
		//quChenColumn列选项
		Map<String, Object> columnOptionNameMaps=WebUtils.getParametersStartingWith(request, "columnValue_");
		List<QuChenColumn> quChenColumns=new ArrayList<QuChenColumn>();
		for (String key : columnOptionNameMaps.keySet()) {
			String optionId=request.getParameter("columnId_"+key);
			Object optionName=columnOptionNameMaps.get(key);
			String optionNameValue=(optionName!=null)?optionName.toString():"";
			QuChenColumn quChenColumn=new QuChenColumn();
			if("".equals(optionId)){
				optionId=null;
			}
			quChenColumn.setId(optionId);
			optionNameValue=URLDecoder.decode(optionNameValue,"utf-8");
			quChenColumn.setOptionName(optionNameValue);
			quChenColumn.setOrderById(Integer.parseInt(key));
			quChenColumns.add(quChenColumn);
		}
		entity.setColumns(quChenColumns);
		
		//quChenRow行选项
		Map<String, Object> rowOptionNameMaps=WebUtils.getParametersStartingWith(request, "rowValue_");
		List<QuChenRow> quChenRows=new ArrayList<QuChenRow>();
		for (String key : rowOptionNameMaps.keySet()) {
			String optionId=request.getParameter("rowId_"+key);
			Object optionName=rowOptionNameMaps.get(key);
			String optionNameValue=(optionName!=null)?optionName.toString():"";
			QuChenRow quChenRow=new QuChenRow();
			if("".equals(optionId)){
				optionId=null;
			}
			quChenRow.setId(optionId);
			optionNameValue=URLDecoder.decode(optionNameValue,"utf-8");
			quChenRow.setOptionName(optionNameValue);
			quChenRow.setOrderById(Integer.parseInt(key));
			quChenRows.add(quChenRow);
		}
		entity.setRows(quChenRows);
		
		//逻辑选项设置
		Map<String, Object> quLogicIdMap=WebUtils.getParametersStartingWith(request, "quLogicId_");
		List<QuestionLogic> quLogics=new ArrayList<QuestionLogic>();
		for (String key : quLogicIdMap.keySet()) {
			String cgQuItemId=request.getParameter("cgQuItemId_"+key);
			String ckQuItemId=request.getParameter("ckQuItemId_"+key);
			String skQuId=request.getParameter("skQuId_"+key);
			
			String geLe=request.getParameter("geLe_"+key);
			String eqAndNq=request.getParameter("eqAndNq_"+key);
			String scoreNum=request.getParameter("scoreNum_"+key);
			String visibility=request.getParameter("visibility_"+key);
			String logicType=request.getParameter("logicType_"+key);
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
			quLogic.setGeLe(geLe);
			quLogic.setScoreNum(scoreNum);
			quLogic.setVisibility(Integer.parseInt(visibility));
			quLogic.setTitle(key);
			quLogic.setLogicType(logicType);
			quLogic.setEqAndNq(eqAndNq);
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
		//列选项
		strBuf.append(",quColumnItems:[");
		List<QuChenColumn> quChenColumns=entity.getColumns();
		for (QuChenColumn column : quChenColumns) {
			strBuf.append("{id:'").append(column.getId());
			strBuf.append("',title:'").append(column.getOrderById()).append("'},");
		}
		int strLen=strBuf.length();
		if(strBuf.lastIndexOf(",")==(strLen-1)){
			strBuf.replace(strLen-1, strLen, "");
		}
		strBuf.append("]");
		
		//行选项
		strBuf.append(",quRowItems:[");
		List<QuChenRow> rows=entity.getRows();
		for (QuChenRow quChenRow : rows) {
			strBuf.append("{id:'").append(quChenRow.getId());
			strBuf.append("',title:'").append(quChenRow.getOrderById()).append("'},");
		}
		strLen=strBuf.length();
		if(strBuf.lastIndexOf(",")==(strLen-1)){
			strBuf.replace(strLen-1, strLen, "");
		}
		strBuf.append("]");
		
		//逻辑选项
		strBuf.append(",quLogics:[");
		List<QuestionLogic> questionLogics=entity.getQuestionLogics();
		if(questionLogics!=null){
			for (QuestionLogic questionLogic : questionLogics) {
				strBuf.append("{id:'").append(questionLogic.getId());
				strBuf.append("',title:'").append(questionLogic.getTitle()).append("'},");
			}
		}
		strLen=strBuf.length();
		if(strBuf.lastIndexOf(",")==(strLen-1)){
			strBuf.replace(strLen-1, strLen, "");
		}
		strBuf.append("]}");
		return strBuf.toString();
	}
	
	/**
	 * 删除列选项选项
	 * @return
	 * @throws Exception
	 */
	public String ajaxDeleteColumn() throws Exception {
		HttpServletRequest request= Struts2Utils.getRequest();
		HttpServletResponse response= Struts2Utils.getResponse();
		try{
			String quItemId=request.getParameter("quItemId");
			quChenColumnManager.ajaxDelete(quItemId);
			response.getWriter().write("true");
		}catch(Exception e){
			e.printStackTrace();
			response.getWriter().write("error");
		}
		return null;
	}
	/**
	 * 删除列选项选项
	 * @return
	 * @throws Exception
	 */
	public String ajaxDeleteRow() throws Exception {
		HttpServletRequest request= Struts2Utils.getRequest();
		HttpServletResponse response= Struts2Utils.getResponse();
		try{
			String quItemId=request.getParameter("quItemId");
			quChenRowManager.ajaxDelete(quItemId);
			response.getWriter().write("true");
		}catch(Exception e){
			e.printStackTrace();
			response.getWriter().write("error");
		}
		return null;
	}
	
	/**
	 * 矩阵答案回显
	 * 
	 * */
	
	private Page<AnChenFbk> anPage = new Page<AnChenFbk>();
	
	public  String answers() throws Exception{
		HttpServletRequest request = Struts2Utils.getRequest();
		String quId = request.getParameter("quId");
		String surveyId = request.getParameter("surveyId");
		String quColId = request.getParameter("quColId");
		String quRowId = request.getParameter("quRowId");
		SurveyDirectory directory=surveyDirectoryManager.get(surveyId);
		anPage.setPageSize(1000);
		Criterion cri1 = Restrictions.eq("quId",quId);
		Criterion cri2 = Restrictions.eq("quColId",quColId);
		Criterion cri3 = Restrictions.eq("quRowId",quRowId);
		anPage = anChenFbkManager.findPage(anPage, cri1,cri2,cri3);
		Question question=questionManager.get(quId);
		request.setAttribute("surveyId",surveyId);
		request.setAttribute("directory", directory);
		request.setAttribute("anPage", anPage);
		request.setAttribute("question", question);
		
		
		return "answers";	
	}
	
	
}
