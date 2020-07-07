package com.key.dwsurvey.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

import com.key.common.QuType;
import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.dao.SurveyAnswerDao;
import com.key.dwsurvey.entity.AnChenFbk;
import com.key.dwsurvey.entity.SurveyDetail;
import com.key.dwsurvey.service.AnScoreManager;
import com.key.dwsurvey.service.SurveyDirectoryManager;

import com.octo.captcha.module.taglib.QuestionTag;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.key.common.base.entity.User;
import com.key.common.plugs.page.Page;
import com.key.common.plugs.page.PropertyFilter;
import com.key.common.service.BaseServiceImpl;
import com.key.common.utils.excel.XLSExportUtil;
import com.key.common.utils.parsehtml.HtmlUtil;
import com.key.dwsurvey.entity.AnAnswer;
import com.key.dwsurvey.entity.AnCheckbox;
import com.key.dwsurvey.entity.AnChenCheckbox;
import com.key.dwsurvey.entity.AnChenRadio;
import com.key.dwsurvey.entity.AnChenScore;
import com.key.dwsurvey.entity.AnCompChenRadio;
import com.key.dwsurvey.entity.AnDFillblank;
import com.key.dwsurvey.entity.AnEnumqu;
import com.key.dwsurvey.entity.AnFillblank;
import com.key.dwsurvey.entity.AnOrder;
import com.key.dwsurvey.entity.AnRadio;
import com.key.dwsurvey.entity.AnScore;
import com.key.dwsurvey.entity.AnYesno;
import com.key.dwsurvey.entity.QuCheckbox;
import com.key.dwsurvey.entity.QuChenColumn;
import com.key.dwsurvey.entity.QuChenOption;
import com.key.dwsurvey.entity.QuChenRow;
import com.key.dwsurvey.entity.QuMultiFillblank;
import com.key.dwsurvey.entity.QuOrderby;
import com.key.dwsurvey.entity.QuRadio;
import com.key.dwsurvey.entity.QuScore;
import com.key.dwsurvey.entity.Question;
import com.key.dwsurvey.entity.SurveyAnswer;
import com.key.dwsurvey.entity.SurveyDirectory;
import com.key.dwsurvey.entity.SurveyStats;
import com.key.dwsurvey.service.AnAnswerManager;
import com.key.dwsurvey.service.AnCheckboxManager;
import com.key.dwsurvey.service.AnChenCheckboxManager;
import com.key.dwsurvey.service.AnChenFbkManager;
import com.key.dwsurvey.service.AnChenRadioManager;
import com.key.dwsurvey.service.AnChenScoreManager;
import com.key.dwsurvey.service.AnCompChenRadioManager;
import com.key.dwsurvey.service.AnDFillblankManager;
import com.key.dwsurvey.service.AnEnumquManager;
import com.key.dwsurvey.service.AnFillblankManager;
import com.key.dwsurvey.service.AnOrderManager;
import com.key.dwsurvey.service.AnRadioManager;
import com.key.dwsurvey.service.AnYesnoManager;
import com.key.dwsurvey.service.QuestionManager;
import com.key.dwsurvey.service.SurveyAnswerManager;

import org.springframework.web.util.WebUtils;

import javax.servlet.http.HttpServletRequest;


/**
 * 问卷回答记录
 * @author keyuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 */
@Service
public class SurveyAnswerManagerImpl extends
		BaseServiceImpl<SurveyAnswer, String> implements SurveyAnswerManager {

	@Autowired
	private SurveyAnswerDao surveyAnswerDao;
	@Autowired
	private QuestionManager questionManager;
	@Autowired
	private AnYesnoManager anYesnoManager;
	@Autowired
	private AnOrderManager anOrderManager;
	@Autowired
	private AnRadioManager anRadioManager;
	@Autowired
	private AnFillblankManager anFillblankManager;
	@Autowired
	private AnEnumquManager anEnumquManager;
	@Autowired
	private AnDFillblankManager anDFillblankManager;
	@Autowired
	private AnCheckboxManager anCheckboxManager;
	@Autowired
	private AnAnswerManager anAnswerManager;
	@Autowired
	private AnChenRadioManager anChenRadioManager;
	@Autowired
	private AnChenCheckboxManager anChenCheckboxManager;
	@Autowired
	private AnChenFbkManager anChenFbkManager;
	@Autowired
	private AnCompChenRadioManager anCompChenRadioManager;
	@Autowired
	private AnChenScoreManager anChenScoreManager;
	@Autowired
	private AnScoreManager anScoreManager;
	@Autowired
	private SurveyDirectoryManager directoryManager;

	@Override
	public void setBaseDao() {
		this.baseDao = surveyAnswerDao;
	}

	@Override
	public void saveAnswer(SurveyAnswer surveyAnswer,
						   Map<String, Map<String, Object>> quMaps) {
		surveyAnswerDao.saveAnswer(surveyAnswer, quMaps);
	}

	@Override
	public void tempSaveAnswer(SurveyAnswer surveyAnswer, Map<String, Map<String, Object>> quMaps) {
		// 先删除再保存新的
		surveyAnswerDao.deleteBySurveyIdAndUsername(surveyAnswer.getSurveyId(), surveyAnswer.getAnswerUserName());
		surveyAnswerDao.tempSaveAnswer(surveyAnswer, quMaps);
	}

	@Override
	public List<Question> findAnswerDetail(SurveyAnswer answer) {
		String surveyId = answer.getSurveyId();
		String surveyAnswerId = answer.getId();
		List<Question> questions = questionManager.findDetails(surveyId, "2");
		for (Question question : questions) {
			getquestionAnswer(surveyAnswerId, question);
		}
		return questions;
	}

	/**
	 * 取问卷值方式
	 *
	 * @param surveyAnswerId
	 * @param question
	 * @return
	 */
	@Override
	public int getquestionAnswer(String surveyAnswerId, Question question) {
		int score = 0;
		String quId = question.getId();
		// 查询每一题的答案,如果是主观题，则判断是否答对
		QuType quType = question.getQuType();

		//重置导出
		question.setAnAnswer(new AnAnswer());
		question.setAnCheckboxs(new ArrayList<AnCheckbox>());
		question.setAnDFillblanks(new ArrayList<AnDFillblank>());
		question.setAnEnumqus(new ArrayList<AnEnumqu>());
		question.setAnFillblank(new AnFillblank());
		question.setAnRadio(new AnRadio());
		question.setAnYesno(new AnYesno());
		question.setAnScores(new ArrayList<AnScore>());
		question.setAnChenRadios(new ArrayList<AnChenRadio>());
		question.setAnChenCheckboxs(new ArrayList<AnChenCheckbox>());
		question.setAnChenFbks(new ArrayList<AnChenFbk>());
		question.setAnCompChenRadios(new ArrayList<AnCompChenRadio>());
		question.setAnChenScores(new ArrayList<AnChenScore>());

		if (quType == QuType.YESNO) {// 是非题答案
			AnYesno anYesno = anYesnoManager.findAnswer(surveyAnswerId, quId);
			if (anYesno != null) {
				question.setAnYesno(anYesno);
			}
		} else if (quType == QuType.RADIO || quType == QuType.COMPRADIO) {// 单选题答案
			// 复合
			AnRadio anRadio = anRadioManager.findAnswer(surveyAnswerId, quId);
			if (anRadio != null) {
				question.setAnRadio(anRadio);
			}
		} else if (quType == QuType.CHECKBOX || quType == QuType.COMPCHECKBOX) {// 多选题答案
			// 复合
			List<AnCheckbox> anCheckboxs = anCheckboxManager.findAnswer(
					surveyAnswerId, quId);
			if (anCheckboxs != null) {
				question.setAnCheckboxs(anCheckboxs);
			}
		} else if (quType == QuType.FILLBLANK) {// 单项填空题答案
			AnFillblank anFillblank = anFillblankManager.findAnswer(
					surveyAnswerId, quId);
			if (anFillblank != null) {
				question.setAnFillblank(anFillblank);
			}

		} else if (quType == QuType.MULTIFILLBLANK) {// 多项填空题答案
			List<AnDFillblank> anDFillblanks = anDFillblankManager.findAnswer(
					surveyAnswerId, quId);
			// System.out.println("anDFillblank.getAnswer():"+anDFillblank.getAnswer());
			if (anDFillblanks != null) {
				question.setAnDFillblanks(anDFillblanks);
			}
		} else if (quType == QuType.ANSWER) {// 问答题答案
			AnAnswer anAnswer = anAnswerManager
					.findAnswer(surveyAnswerId, quId);
			if (anAnswer != null) {
				question.setAnAnswer(anAnswer);
			}
		} else if (quType == QuType.BIGQU) {// 大题答案
			// List<Question> childQuestions=question.getQuestions();
			// for (Question childQuestion : childQuestions) {
			// score=getquestionAnswer(surveyAnswerId, childQuestion);
			// }
		} else if (quType == QuType.ENUMQU) {
			List<AnEnumqu> anEnumqus = anEnumquManager.findAnswer(
					surveyAnswerId, quId);
			if (anEnumqus != null) {
				question.setAnEnumqus(anEnumqus);
			}
		} else if (quType == QuType.SCORE) {// 评分题
			List<AnScore> anScores = anScoreManager.findAnswer(surveyAnswerId,
					quId);
			if (anScores != null) {
				question.setAnScores(anScores);
			}
		}else if(quType == QuType.CHENSCORE){
			
			List<AnChenScore> anChenScores=anChenScoreManager.findAnswer(surveyAnswerId, quId);
			if(anChenScores != null){
				question.setAnChenScores(anChenScores);
			}
		}
		else if (quType == QuType.CHENRADIO) {// 矩阵单选题
			List<AnChenRadio> anChenRadios = anChenRadioManager.findAnswer(
					surveyAnswerId, quId);
			if (anChenRadios != null) {
				question.setAnChenRadios(anChenRadios);
			}
		} else if (quType == QuType.CHENCHECKBOX) {// 矩阵多选题
			List<AnChenCheckbox> anChenCheckboxs = anChenCheckboxManager
					.findAnswer(surveyAnswerId, quId);
			if (anChenCheckboxs != null) {
				question.setAnChenCheckboxs(anChenCheckboxs);
			}
		} else if (quType == QuType.CHENFBK) {// 矩阵填空题
			List<AnChenFbk> anChenFbks = anChenFbkManager.findAnswer(
					surveyAnswerId, quId);
			if (anChenFbks != null) {
				question.setAnChenFbks(anChenFbks);
			}
		} else if (quType == QuType.COMPCHENRADIO) {// 复合矩阵单选题
			List<AnCompChenRadio> anCompChenRadios = anCompChenRadioManager
					.findAnswer(surveyAnswerId, quId);
			if (anCompChenRadios != null) {
				question.setAnCompChenRadios(anCompChenRadios);
			}
		}else if(quType == QuType.ORDERQU){
			List<AnOrder> anOrders = anOrderManager
					.findAnswer(surveyAnswerId, quId);
			if (anOrders != null) {
				question.setAnOrders(anOrders);
			}
		}
		return score;
	}

	@Override
	public SurveyAnswer getTimeInByIp(SurveyDetail surveyDetail, String ip) {
		String surveyId = surveyDetail.getDirId();
		Criterion eqSurveyId = Restrictions.eq("surveyId", surveyId);
		Criterion eqIp = Restrictions.eq("ipAddr", ip);

		int minute = surveyDetail.getEffectiveTime();
		Date curdate = new Date();
		Calendar calendarDate = Calendar.getInstance();
		calendarDate.setTime(curdate);
		calendarDate.set(Calendar.MINUTE, calendarDate.get(Calendar.MINUTE)
				- minute);
		Date date = calendarDate.getTime();

		Criterion gtEndDate = Restrictions.gt("endAnDate", date);
		return surveyAnswerDao.findFirst("endAnDate", true, eqSurveyId, eqIp,
				gtEndDate);

	}

	@Override
	public Long getCountByIp(String surveyId, String ip) {
		String hql = "select count(*) from SurveyAnswer x where x.surveyId=? and x.ipAddr=? and x.isTemp = 0";
		Long count = (Long) surveyAnswerDao.findUniObjs(hql, surveyId, ip);
		return count;
	}

	@Override
	public List<SurveyAnswer> answersByIp(String surveyId, String ip) {
		Criterion criterionSurveyId = Restrictions.eq("surveyId", surveyId);
		Criterion criterionIp = Restrictions.eq("ipAddr", ip);
		List<SurveyAnswer> answers = surveyAnswerDao.find(criterionSurveyId,
				criterionIp);
		return answers;
	}


	@Override
	public String exportXLS(String surveyId, String savePath) {
		String basepath = surveyId + "";
		String urlPath = "/file/" + basepath + "/";// 下载所用的地址
		String path = urlPath.replace("/", File.separator);// 文件系统路径
		// File.separator +
		// "file" +
		// File.separator+basepath
		// + File.separator;
		savePath = savePath + path;
		File file = new File(savePath);
		if (!file.exists())
			file.mkdirs();

		SurveyDirectory surveyDirectory = directoryManager.getSurvey(surveyId);
		String fileName = surveyId + "_exportSurvey.xls";

		XLSExportUtil exportUtil = new XLSExportUtil(fileName, savePath);
		Criterion cri1 = Restrictions.eq("surveyId",surveyId);
//		Criterion cri2 = Restrictions.eq("isTemp",0);
		Page<SurveyAnswer> page = new Page<SurveyAnswer>();
		page.setPageSize(5000);
		try {
			page = findPage(page,cri1);
			int totalPage = page.getTotalPage();
			List<SurveyAnswer> answers = page.getResult();
			List<Question> questions = questionManager.findDetails(surveyId,"2");
			exportXLSTitle(exportUtil, questions);
			int answerListSize = answers.size();
			for (int j = 0; j < answerListSize; j++) {
				SurveyAnswer surveyAnswer = answers.get(j);
				String surveyAnswerId = surveyAnswer.getId();
				exportUtil.createRow(j+1);
				exportXLSRowLow(exportUtil, surveyAnswerId, questions, surveyAnswer);
				System.out.println(j+1+"/"+answerListSize);
			}
			exportUtil.exportXLS();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return urlPath + fileName;
	}

	private void exportXLSRowLow(XLSExportUtil exportUtil,String surveyAnswerId, List<Question> questions,SurveyAnswer surveyAnswer) {
		int cellIndex = 0;
		for (Question question : questions) {
			getquestionAnswer(surveyAnswerId, question);
			QuType quType = question.getQuType();
			String quName = question.getQuName();
			String titleName = quType.getCnName();
			//1
			if (quType == QuType.YESNO) {// 是非题
				String yesnoAnswer = question.getAnYesno().getYesnoAnswer();
				if("1".equals(yesnoAnswer)){
					yesnoAnswer=question.getYesnoOption().getTrueValue();
				}else if("0".equals(yesnoAnswer)){
					yesnoAnswer=question.getYesnoOption().getFalseValue();
				}else{
					yesnoAnswer="";
				}
				String yesnoAnswerCount=yesnoAnswer.equals("是")?"1":yesnoAnswer.equals("否")?"0":"";
				exportUtil.setCell(cellIndex++, yesnoAnswerCount);
			}
			
			else if (quType == QuType.RADIO) {// 单选题
				String quItemId = question.getAnRadio().getQuItemId();
				List<QuRadio> quRadios=question.getQuRadios();
				String answerOptionName="";
				String OptionNum="";
			/*	for (QuRadio quRadio : quRadios) {
					String quRadioId=quRadio.getId();
					if(quRadioId.equals(quItemId)){
						answerOptionName=quRadio.getOptionName();
						break;
					}
				}*/
				for(int i=0;i<quRadios.size();i++){
					String quRadioId=quRadios.get(i).getId();
					if(quRadioId.equals(quItemId)){
						OptionNum=(i+1)+"";
						break;
					} 
				}
				answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
				answerOptionName = answerOptionName.replace("&nbsp;"," ");
				exportUtil.setCell(cellIndex++, OptionNum);
			} else if (quType == QuType.CHECKBOX) {// 多选题
				List<AnCheckbox> anCheckboxs=question.getAnCheckboxs();
				List<QuCheckbox> checkboxs = question.getQuCheckboxs();
				/*for (QuCheckbox quCheckbox : checkboxs) {
					String quCkId=quCheckbox.getId();
					String answerOptionName="0";
					for (AnCheckbox anCheckbox : anCheckboxs) {
						String anQuItemId=anCheckbox.getQuItemId();
						if(quCkId.equals(anQuItemId)){
							answerOptionName=quCheckbox.getOptionName();
							answerOptionName="1";
							break;
						}
					}
					answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
					answerOptionName = answerOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerOptionName);
				}*/
				String optionNum="";
				for(int i=0;i<checkboxs.size();i++){
					String quCkId=checkboxs.get(i).getId();
					for (AnCheckbox anCheckbox : anCheckboxs) {
						String anQuItemId=anCheckbox.getQuItemId();
						if(quCkId.equals(anQuItemId)){
							optionNum+=(i+1)+"/";
						}
					}
					
				}
				optionNum=optionNum.equals("")?optionNum:optionNum.substring(0,(optionNum.length()-1));
				exportUtil.setCell(cellIndex++, optionNum);
			} else if (quType == QuType.FILLBLANK) {// 填空题
				AnFillblank anFillblank=question.getAnFillblank();
				exportUtil.setCell(cellIndex++, anFillblank.getAnswer());
			} else if (quType == QuType.ANSWER) {// 多行填空题
				AnAnswer anAnswer=question.getAnAnswer();
				exportUtil.setCell(cellIndex++, anAnswer.getAnswer());
			} else if (quType == QuType.COMPRADIO) {// 复合单选题
				AnRadio anRadio=question.getAnRadio();
				String quItemId = anRadio.getQuItemId();
				List<QuRadio> quRadios=question.getQuRadios();
				String answerOptionName="";
				String answerOtherText="";
				for (QuRadio quRadio : quRadios) {
					String quRadioId=quRadio.getId();
					if(quRadioId.equals(quItemId)){
						answerOptionName=quRadio.getOptionName();
						answerOtherText=anRadio.getOtherText();
						break;
					}
				}
				answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
				answerOtherText=HtmlUtil.removeTagFromText(answerOtherText);
				answerOptionName = answerOptionName.replace("&nbsp;"," ");
				exportUtil.setCell(cellIndex++, answerOptionName);
				exportUtil.setCell(cellIndex++, answerOtherText);
			} else if (quType == QuType.COMPCHECKBOX) {// 复合多选题
				List<AnCheckbox> anCheckboxs=question.getAnCheckboxs();
				List<QuCheckbox> checkboxs = question.getQuCheckboxs();
				for (QuCheckbox quCheckbox : checkboxs) {
					String quCkId=quCheckbox.getId();
					String answerOptionName="0";
					String answerOtherText="0";
					for (AnCheckbox anCheckbox : anCheckboxs) {
						String anQuItemId=anCheckbox.getQuItemId();
						if(quCkId.equals(anQuItemId)){
							answerOptionName=quCheckbox.getOptionName();
							answerOptionName="1";
							answerOtherText=anCheckbox.getOtherText();
							break;
						}
					}
					answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
					answerOptionName = answerOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerOptionName);
					if(1==quCheckbox.getIsNote()){
						answerOtherText=HtmlUtil.removeTagFromText(answerOtherText);
						exportUtil.setCell(cellIndex++, answerOtherText);
					}
				}
			} else if (quType == QuType.ENUMQU) {// 枚举题
				List<AnEnumqu> anEnumqus=question.getAnEnumqus();
				int enumNum = question.getParamInt01();
				for (int i = 0; i < enumNum; i++) {
					String answerEnum="";
					for (AnEnumqu anEnumqu : anEnumqus) {
						if(i==anEnumqu.getEnumItem()){
							answerEnum=anEnumqu.getAnswer();
							break;
						}
					}
					exportUtil.setCell(cellIndex++,  answerEnum);
				}
			} else if (quType == QuType.MULTIFILLBLANK) {// 组合填空题
				List<QuMultiFillblank> quMultiFillblanks = question.getQuMultiFillblanks();
				List<AnDFillblank> anDFillblanks=question.getAnDFillblanks();
				for (QuMultiFillblank quMultiFillblank : quMultiFillblanks) {
					String quMultiFillbankId=quMultiFillblank.getId();
					String answerOptionName="";
					for (AnDFillblank anDFillblank : anDFillblanks) {
						if(quMultiFillbankId.equals(anDFillblank.getQuItemId())){
							answerOptionName=anDFillblank.getAnswer();
							break;
						}
					}
					answerOptionName = answerOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerOptionName);
				}
			} else if (quType == QuType.SCORE) {// 评分题
				List<QuScore> quScores = question.getQuScores();
				List<AnScore> anScores=question.getAnScores();
				for (QuScore quScore : quScores) {
					String quScoreId=quScore.getId();
					String answerScore="";
					for (AnScore anScore : anScores) {
						if(quScoreId.equals(anScore.getQuRowId())){
							answerScore=anScore.getAnswserScore();
							break;
						}
					}
					exportUtil.setCell(cellIndex++, answerScore);
				}
			} else if (quType == QuType.CHENRADIO) {// 矩阵单选题
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<AnChenRadio> anChenRadios=question.getAnChenRadios();
			/*	for (QuChenRow quChenRow : quChenRows) {
					String quChenRowId=quChenRow.getId();
					String answerColOptionName="";
					boolean breakTag=false;
					for (QuChenColumn quChenColumn : quChenColumns) {
						String quChenColumnId=quChenColumn.getId();
						for (AnChenRadio anChenRadio : anChenRadios) {
							String anQuRowId=anChenRadio.getQuRowId();
							String anQuColId=anChenRadio.getQuColId();
							if(quChenRowId.equals(anQuRowId) && quChenColumnId.equals(anQuColId)){
								breakTag=true;
								break;
							}
						}
						if(breakTag){
							answerColOptionName=quChenColumn.getOptionName();
							break;
						}
					}
					answerColOptionName=HtmlUtil.removeTagFromText(answerColOptionName);
					answerColOptionName = answerColOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerColOptionName);
				}*/
				for(QuChenRow quChenRow :quChenRows){
					String quChenRowId=quChenRow.getId();
					String optionNum="";
					for(int i=0;i<quChenColumns.size();i++){
						String quChenColumnId=quChenColumns.get(i).getId();
						for (AnChenRadio anChenRadio : anChenRadios) {
							String anQuRowId=anChenRadio.getQuRowId();
							String anQuColId=anChenRadio.getQuColId();
							if(quChenRowId.equals(anQuRowId) && quChenColumnId.equals(anQuColId)){
								optionNum+=(i+1);
								break;
							}
						}
					}
					exportUtil.setCell(cellIndex++,optionNum );
				}
			} else if (quType == QuType.CHENCHECKBOX) {
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<AnChenCheckbox> anChenCheckboxs = question.getAnChenCheckboxs();
				/*for (QuChenRow quChenRow : quChenRows) {
					String quChenRowId=quChenRow.getId();
					for (QuChenColumn quChenColumn : quChenColumns) {
						String quChenColumnId=quChenColumn.getId();
						String answerOptionName = "";
						for (AnChenCheckbox anChenCheckbox : anChenCheckboxs) {
							String anChenRowId=anChenCheckbox.getQuRowId();
							String anChenColumnId=anChenCheckbox.getQuColId();
							if(quChenRowId.equals(anChenRowId) && quChenColumnId.equals(anChenColumnId)){
								answerOptionName=quChenColumn.getOptionName();
								break;
							}
						}
						answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
						answerOptionName = answerOptionName.replace("&nbsp;"," ");
						exportUtil.setCell(cellIndex++, answerOptionName);
					}
				}*/
				
				for(QuChenRow quChenRow : quChenRows){
					String quChenRowId=quChenRow.getId();
					String optionNum="";
					for(int i=0;i<quChenColumns.size();i++){
						String quChenColumnId=quChenColumns.get(i).getId();
						
						for (AnChenCheckbox anChenCheckbox : anChenCheckboxs) {
							String anChenRowId=anChenCheckbox.getQuRowId();
							String anChenColumnId=anChenCheckbox.getQuColId();
							if(quChenRowId.equals(anChenRowId) && quChenColumnId.equals(anChenColumnId)){
								optionNum+=(i+1)+"/";
							}
						}
						
					}
					optionNum=optionNum.equals("")?optionNum:optionNum.substring(0,(optionNum.length()-1));
					exportUtil.setCell(cellIndex++, optionNum);
				}
			} else if (quType == QuType.COMPCHENRADIO) {
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<QuChenOption> quChenOptions = question.getOptions();
				List<AnCompChenRadio> anCompChenRadios=question.getAnCompChenRadios();
				for (QuChenRow quChenRow : quChenRows) {
//					String optionName = quChenRow.getOptionName();
					String quChenRowId=quChenRow.getId();
					for (QuChenColumn quChenColumn : quChenColumns) {
						String answerOptionName="";
						String quChenColumnId=quChenColumn.getId();
						boolean breakTag=false;
						for (QuChenOption quChenOption : quChenOptions) {
							answerOptionName="";
							String quChenOptionId=quChenOption.getId();
							for (AnCompChenRadio anCompChenRadio : anCompChenRadios) {
								String anRowId=anCompChenRadio.getQuRowId();
								String anColumnId=anCompChenRadio.getQuColId();
								String anOptionId=anCompChenRadio.getQuOptionId();
								if(quChenRowId.equals(anRowId) && quChenColumnId.equals(anColumnId) && quChenOptionId.equals(anOptionId)){
									breakTag=true;
									break;
								}
							}
							if(breakTag){
								answerOptionName=quChenOption.getOptionName();
								break;
							}
						}
						answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
						answerOptionName = answerOptionName.replace("&nbsp;"," ");
						exportUtil.setCell(cellIndex++, answerOptionName);
					}
				}
			}
			//矩阵填空题
			else if(quType == QuType.CHENSCORE){
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<AnChenScore> anChenScores=question.getAnChenScores();
				for(QuChenRow quChenRow : quChenRows){
					String quChenRowId=quChenRow.getId();
					String optionNum="";
					for(int i=0;i<quChenColumns.size();i++){
						String quChenColumnId=quChenColumns.get(i).getId();
						
						for (AnChenScore anChenScore : anChenScores) {
							String anChenRowId=anChenScore.getQuRowId();
							String anChenColumnId=anChenScore.getQuColId();
							if(quChenRowId.equals(anChenRowId) && quChenColumnId.equals(anChenColumnId)){
								optionNum+=(anChenScore.getAnswserScore())+"/";
							}
						}
						
					}
					optionNum=optionNum.equals("")?optionNum:optionNum.substring(0,(optionNum.length()-1));
					exportUtil.setCell(cellIndex++, optionNum);
				}
			}else if(quType == QuType.CHENFBK){
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<AnChenFbk> anChenFbks=question.getAnChenFbks();
				for(QuChenRow quChenRow : quChenRows){
					String quChenRowId=quChenRow.getId();
					String optionNum="";
					for(int i=0;i<quChenColumns.size();i++){
						String quChenColumnId=quChenColumns.get(i).getId();
						
						for (AnChenFbk anChenFbk : anChenFbks) {
							String anChenRowId=anChenFbk.getQuRowId();
							String anChenColumnId=anChenFbk.getQuColId();
							if(quChenRowId.equals(anChenRowId) && quChenColumnId.equals(anChenColumnId)){
								optionNum+=(anChenFbk.getAnswerValue())+"/";
							}
						}
						
					}
					optionNum=optionNum.equals("")?optionNum:optionNum.substring(0,(optionNum.length()-1));
					exportUtil.setCell(cellIndex++, optionNum);
				}
			}else if(quType == QuType.ORDERQU){
				List<QuOrderby> quOrderbys=question.getQuOrderbys();
				List<AnOrder> anOrders=question.getAnOrders();
				/*for(QuOrderby quOrderby:quOrderbys){
					String optionNum="";
					for(AnOrder anOrder:anOrders){
						if(quOrderby.getId().equals(anOrder.getQuRowId())){
							
						}
					}
				}*/
				String optionNum="";
				for(int i=0;i<quOrderbys.size();i++){
					
					for(AnOrder anOrder:anOrders){
						if(quOrderbys.get(i).getId().equals(anOrder.getQuRowId())){
							String OrderNum=anOrder.getOrderyNum();
							optionNum+=(OrderNum+"/");
						}
					}
				}
				optionNum=optionNum.equals("")?optionNum:optionNum.substring(0,(optionNum.length()-1));
				exportUtil.setCell(cellIndex++, optionNum);
				
			}
		}
		int pageNum = 0;
		for (Question question : questions) {
			if (QuType.PAGETAG.equals(question.getQuType())) {
				pageNum++;
			}
		}
		exportUtil.setCell(cellIndex++,  ++pageNum);
		exportUtil.setCell(cellIndex++,  surveyAnswer.getTotalTime());
		exportUtil.setCell(cellIndex++,  surveyAnswer.getIpAddr());
		exportUtil.setCell(cellIndex++,  surveyAnswer.getCity());
		exportUtil.setCell(cellIndex++,  surveyAnswer.getAnswerUserName());
		exportUtil.setCell(cellIndex++,  surveyAnswer.getAnswerPassword());
		exportUtil.setCell(cellIndex++,  new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒").format(surveyAnswer.getBgAnDate()));
		exportUtil.setCell(cellIndex++,  new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒").format(surveyAnswer.getEndAnDate()));


	}
	
	private void exportXLSRow(XLSExportUtil exportUtil,String surveyAnswerId, List<Question> questions,SurveyAnswer surveyAnswer) {
		int cellIndex = 0;
		for (Question question : questions) {
			getquestionAnswer(surveyAnswerId, question);
			QuType quType = question.getQuType();
			String quName = question.getQuName();
			String titleName = quType.getCnName();
			if (quType == QuType.YESNO) {// 是非题
				String yesnoAnswer = question.getAnYesno().getYesnoAnswer();
				if("1".equals(yesnoAnswer)){
					yesnoAnswer=question.getYesnoOption().getTrueValue();
				}else if("0".equals(yesnoAnswer)){
					yesnoAnswer=question.getYesnoOption().getFalseValue();
				}else{
					yesnoAnswer="";
				}
				
				String result=yesnoAnswer.equals("是")?"1":"0";
				exportUtil.setCell(cellIndex++, result);
			} else if (quType == QuType.RADIO) {// 单选题
				String quItemId = question.getAnRadio().getQuItemId();
				List<QuRadio> quRadios=question.getQuRadios();
				String answerOptionName="";
				String answerNum="";
				for (int i=0;i<quRadios.size();i++) {
					String quRadioId=quRadios.get(i).getId();
					if(quRadioId.equals(quItemId)){
						answerOptionName=quRadios.get(i).getOptionName();
						answerNum = String.valueOf(i+1);
						break;
					}
				}
				answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
				answerOptionName = answerOptionName.replace("&nbsp;"," ");
				exportUtil.setCell(cellIndex++, answerNum);
			} else if (quType == QuType.CHECKBOX) {// 多选题
				List<AnCheckbox> anCheckboxs=question.getAnCheckboxs();
				List<QuCheckbox> checkboxs = question.getQuCheckboxs();
				for (int i=0;i<checkboxs.size();i++) {
					String quCkId=checkboxs.get(i).getId();
					String answerOptionName="0";
					String answerOptionNum="0";
					for (AnCheckbox anCheckbox : anCheckboxs) {
						String anQuItemId=anCheckbox.getQuItemId();
						if(quCkId.equals(anQuItemId)){
							answerOptionName=checkboxs.get(i).getOptionName();
							answerOptionName="1";
							answerOptionNum=String.valueOf(i+1);
							break;
						}
					}
					answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
					answerOptionName = answerOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerOptionNum);
				}
			} else if (quType == QuType.FILLBLANK) {// 填空题
				AnFillblank anFillblank=question.getAnFillblank();
				exportUtil.setCell(cellIndex++, anFillblank.getAnswer());
			} else if (quType == QuType.ANSWER) {// 多行填空题
				AnAnswer anAnswer=question.getAnAnswer();
				exportUtil.setCell(cellIndex++, anAnswer.getAnswer());
			} else if (quType == QuType.COMPRADIO) {// 复合单选题
				AnRadio anRadio=question.getAnRadio();
				String quItemId = anRadio.getQuItemId();
				List<QuRadio> quRadios=question.getQuRadios();
				String answerOptionName="";
				String answerOtherText="";
				for (QuRadio quRadio : quRadios) {
					String quRadioId=quRadio.getId();
					if(quRadioId.equals(quItemId)){
						answerOptionName=quRadio.getOptionName();
						answerOtherText=anRadio.getOtherText();
						break;
					}
				}
				answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
				answerOtherText=HtmlUtil.removeTagFromText(answerOtherText);
				answerOptionName = answerOptionName.replace("&nbsp;"," ");
				exportUtil.setCell(cellIndex++, answerOptionName);
				exportUtil.setCell(cellIndex++, answerOtherText);
			} else if (quType == QuType.COMPCHECKBOX) {// 复合多选题
				List<AnCheckbox> anCheckboxs=question.getAnCheckboxs();
				List<QuCheckbox> checkboxs = question.getQuCheckboxs();
				for (QuCheckbox quCheckbox : checkboxs) {
					String quCkId=quCheckbox.getId();
					String answerOptionName="0";
					String answerOtherText="0";
					for (AnCheckbox anCheckbox : anCheckboxs) {
						String anQuItemId=anCheckbox.getQuItemId();
						if(quCkId.equals(anQuItemId)){
							answerOptionName=quCheckbox.getOptionName();
							answerOptionName="1";
							answerOtherText=anCheckbox.getOtherText();
							break;
						}
					}
					answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
					answerOptionName = answerOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, cellIndex);
					if(1==quCheckbox.getIsNote()){
						answerOtherText=HtmlUtil.removeTagFromText(answerOtherText);
						exportUtil.setCell(cellIndex++, answerOtherText);
					}
				}
			} else if (quType == QuType.ENUMQU) {// 枚举题
				List<AnEnumqu> anEnumqus=question.getAnEnumqus();
				int enumNum = question.getParamInt01();
				for (int i = 0; i < enumNum; i++) {
					String answerEnum="";
					for (AnEnumqu anEnumqu : anEnumqus) {
						if(i==anEnumqu.getEnumItem()){
							answerEnum=anEnumqu.getAnswer();
							break;
						}
					}
					exportUtil.setCell(cellIndex++,  answerEnum);
				}
			} else if (quType == QuType.MULTIFILLBLANK) {// 组合填空题
				List<QuMultiFillblank> quMultiFillblanks = question.getQuMultiFillblanks();
				List<AnDFillblank> anDFillblanks=question.getAnDFillblanks();
				for (QuMultiFillblank quMultiFillblank : quMultiFillblanks) {
					String quMultiFillbankId=quMultiFillblank.getId();
					String answerOptionName="";
					for (AnDFillblank anDFillblank : anDFillblanks) {
						if(quMultiFillbankId.equals(anDFillblank.getQuItemId())){
							answerOptionName=anDFillblank.getAnswer();
							break;
						}
					}
					answerOptionName = answerOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerOptionName);
				}
			} else if (quType == QuType.SCORE) {// 评分题
				List<QuScore> quScores = question.getQuScores();
				List<AnScore> anScores=question.getAnScores();
				for (QuScore quScore : quScores) {
					String quScoreId=quScore.getId();
					String answerScore="";
					for (AnScore anScore : anScores) {
						if(quScoreId.equals(anScore.getQuRowId())){
							answerScore=anScore.getAnswserScore();
							break;
						}
					}
					exportUtil.setCell(cellIndex++, answerScore);
				}
			} else if (quType == QuType.CHENRADIO) {// 矩阵单选题
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<AnChenRadio> anChenRadios=question.getAnChenRadios();
				for (int i=0;i<quChenRows.size();i++) {
					String quChenRowId=quChenRows.get(i).getId();
					String answerColOptionName="";
					String answerColRowNum="";
					boolean breakTag=false;
					for (int j=0;j<quChenColumns.size();i++) {
						String quChenColumnId=quChenColumns.get(j).getId();
						for (AnChenRadio anChenRadio : anChenRadios) {
							String anQuRowId=anChenRadio.getQuRowId();
							String anQuColId=anChenRadio.getQuColId();
							if(quChenRowId.equals(anQuRowId) && quChenColumnId.equals(anQuColId)){
								breakTag=true;
								answerColRowNum=String.valueOf(i+1);
								break;
							}
						}
						if(breakTag){
							answerColOptionName=quChenColumns.get(i).getOptionName();
							break;
						}
					}
					answerColOptionName=HtmlUtil.removeTagFromText(answerColOptionName);
					answerColOptionName = answerColOptionName.replace("&nbsp;"," ");
					exportUtil.setCell(cellIndex++, answerColRowNum);
				}
			} else if (quType == QuType.CHENCHECKBOX) {
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<AnChenCheckbox> anChenCheckboxs = question.getAnChenCheckboxs();
				for (int i=0;i<quChenRows.size();i++) {
					String quChenRowId=quChenRows.get(i).getId();
					for (int j=0;j<quChenColumns.size();j++) {
						String quChenColumnId=quChenColumns.get(j).getId();
						String answerOptionName = "";
						String answerOptionNum="";
						for (AnChenCheckbox anChenCheckbox : anChenCheckboxs) {
							String anChenRowId=anChenCheckbox.getQuRowId();
							String anChenColumnId=anChenCheckbox.getQuColId();
							if(quChenRowId.equals(anChenRowId) && quChenColumnId.equals(anChenColumnId)){
								answerOptionName=quChenColumns.get(j).getOptionName();
								answerOptionNum=String.valueOf(j+1);
								break;
							}
						}
						answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
						answerOptionName = answerOptionName.replace("&nbsp;"," ");
						exportUtil.setCell(cellIndex++, cellIndex);
					}
				}
			} else if (quType == QuType.COMPCHENRADIO) {
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				List<QuChenOption> quChenOptions = question.getOptions();
				List<AnCompChenRadio> anCompChenRadios=question.getAnCompChenRadios();
				for (QuChenRow quChenRow : quChenRows) {
//					String optionName = quChenRow.getOptionName();
					String quChenRowId=quChenRow.getId();
					for (QuChenColumn quChenColumn : quChenColumns) {
						String answerOptionName="";
						String quChenColumnId=quChenColumn.getId();
						boolean breakTag=false;
						for (QuChenOption quChenOption : quChenOptions) {
							answerOptionName="";
							String quChenOptionId=quChenOption.getId();
							for (AnCompChenRadio anCompChenRadio : anCompChenRadios) {
								String anRowId=anCompChenRadio.getQuRowId();
								String anColumnId=anCompChenRadio.getQuColId();
								String anOptionId=anCompChenRadio.getQuOptionId();
								if(quChenRowId.equals(anRowId) && quChenColumnId.equals(anColumnId) && quChenOptionId.equals(anOptionId)){
									breakTag=true;
									break;
								}
							}
							if(breakTag){
								answerOptionName=quChenOption.getOptionName();
								break;
							}
						}
						answerOptionName=HtmlUtil.removeTagFromText(answerOptionName);
						answerOptionName = answerOptionName.replace("&nbsp;"," ");
						exportUtil.setCell(cellIndex++, answerOptionName);
					}
				}
			}
		}

		exportUtil.setCell(cellIndex++,  surveyAnswer.getIpAddr());
		exportUtil.setCell(cellIndex++,  surveyAnswer.getCity());
		exportUtil.setCell(cellIndex++,  new SimpleDateFormat("yyyy年MM月dd日 HH时mm分ss秒").format(surveyAnswer.getEndAnDate()));


	}

	private void exportXLSTitle(XLSExportUtil exportUtil,
								List<Question> questions) {
		exportUtil.createRow(0);
		int cellIndex = 0;


		int quNum=0;
		for (Question question : questions) {
			quNum++;
			QuType quType = question.getQuType();

//			String quName = question.getQuName();
			String quName = question.getQuTitle();
			quName=HtmlUtil.removeTagFromText(quName);
			String titleName =quNum +"、" + quName + "[" + quType.getCnName() + "]";
			if (quType == QuType.YESNO) {// 是非题
				exportUtil.setCell(cellIndex++, titleName);
			} else if (quType == QuType.RADIO) {// 单选题
				exportUtil.setCell(cellIndex++, titleName);
			} else if (quType == QuType.CHECKBOX) {// 多选题
				List<QuCheckbox> checkboxs = question.getQuCheckboxs();
				/*for (QuCheckbox quCheckbox : checkboxs) {
					String optionName = quCheckbox.getOptionName();

					optionName=HtmlUtil.removeTagFromText(optionName);
					exportUtil.setCell(cellIndex++,titleName+ "－"+optionName );
				}*/
				exportUtil.setCell(cellIndex++,titleName);	
			} else if (quType == QuType.FILLBLANK) {// 填空题
				exportUtil.setCell(cellIndex++, titleName);
			} else if (quType == QuType.ANSWER) {// 多行填空题
				exportUtil.setCell(cellIndex++, titleName);
			} else if (quType == QuType.COMPRADIO) {// 复合单选题
				exportUtil.setCell(cellIndex++, titleName);
				exportUtil.setCell(cellIndex++, titleName+"-说明" );

			} else if (quType == QuType.COMPCHECKBOX) {// 复合多选题
				List<QuCheckbox> checkboxs = question.getQuCheckboxs();
				for (QuCheckbox quCheckbox : checkboxs) {
					String optionName = quCheckbox.getOptionName();
					exportUtil.setCell(cellIndex++, titleName + "－"
							+ optionName);
					int isNote = quCheckbox.getIsNote();
					if (isNote == 1) {
						optionName=HtmlUtil.removeTagFromText(optionName);
						exportUtil.setCell(cellIndex++, titleName +"－"+ optionName
								+ "－" + "说明" );
					}
				}
			} else if (quType == QuType.ENUMQU) {// 枚举题
				int enumNum = question.getParamInt01();
				for (int i = 0; i < enumNum; i++) {
					exportUtil.setCell(cellIndex++,  titleName + i + "－枚举");
				}
			} else if (quType == QuType.MULTIFILLBLANK) {// 组合填空题
				List<QuMultiFillblank> quMultiFillblanks = question
						.getQuMultiFillblanks();
				for (QuMultiFillblank quMultiFillblank : quMultiFillblanks) {
					String optionName = quMultiFillblank.getOptionName();

					optionName=HtmlUtil.removeTagFromText(optionName);
					exportUtil.setCell(cellIndex++, titleName + "－"
							+ optionName);
				}
			} else if (quType == QuType.SCORE) {// 评分题
				List<QuScore> quScores = question.getQuScores();
				for (QuScore quScore : quScores) {
					String optionName = quScore.getOptionName();
					optionName=HtmlUtil.removeTagFromText(optionName);
					exportUtil.setCell(cellIndex++, titleName+"－"+optionName);
				}
			} else if (quType == QuType.CHENRADIO) {// 矩阵单选题
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				for (QuChenRow quChenRow : quChenRows) {
					String optionName = quChenRow.getOptionName();
					optionName=HtmlUtil.removeTagFromText(optionName);
					exportUtil.setCell(cellIndex++, titleName+ "-"
							+ optionName );
				}
			} else if (quType == QuType.CHENCHECKBOX) {// 矩阵多选题
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				for (QuChenRow quChenRow : quChenRows) {
					String optionName = quChenRow.getOptionName();
					/*for (QuChenColumn quChenColumn : quChenColumns) {
						optionName=HtmlUtil.removeTagFromText(optionName);
						exportUtil.setCell(cellIndex++, titleName + "-"
								+ optionName + "-"
								+ quChenColumn.getOptionName() );
					}*/
					exportUtil.setCell(cellIndex++, titleName + "-"
							+ optionName);	
				}
			} else if (quType == QuType.COMPCHENRADIO) {// 复合矩阵单选题
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				for (QuChenRow quChenRow : quChenRows) {
					String optionName = quChenRow.getOptionName();
					for (QuChenColumn quChenColumn : quChenColumns) {
						optionName=HtmlUtil.removeTagFromText(optionName);
						exportUtil.setCell(cellIndex++,  titleName + "-"
								+ optionName + "-"
								+ quChenColumn.getOptionName());
					}
				}
			}else if(quType == QuType.CHENSCORE){
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				for (QuChenRow quChenRow : quChenRows) {
					String optionName = quChenRow.getOptionName();
					/*for (QuChenColumn quChenColumn : quChenColumns) {
						optionName=HtmlUtil.removeTagFromText(optionName);
						exportUtil.setCell(cellIndex++, titleName + "-"
								+ optionName + "-"
								+ quChenColumn.getOptionName() );
					}*/
					exportUtil.setCell(cellIndex++, titleName + "-"
							+ optionName);	
				}
			}else if(quType == QuType.CHENFBK){
				List<QuChenRow> quChenRows = question.getRows();
				List<QuChenColumn> quChenColumns = question.getColumns();
				for (QuChenRow quChenRow : quChenRows) {
					String optionName = quChenRow.getOptionName();
					/*for (QuChenColumn quChenColumn : quChenColumns) {
						optionName=HtmlUtil.removeTagFromText(optionName);
						exportUtil.setCell(cellIndex++, titleName + "-"
								+ optionName + "-"
								+ quChenColumn.getOptionName() );
					}*/
					exportUtil.setCell(cellIndex++, titleName + "-"
							+ optionName);	
				}
			}else if(quType == QuType.ORDERQU){
				exportUtil.setCell(cellIndex++, titleName);
			}
		}

		exportUtil.setCell(cellIndex++,  "末页");
		exportUtil.setCell(cellIndex++,  "总计时长（秒）");
		exportUtil.setCell(cellIndex++,  "回答者IP");
		exportUtil.setCell(cellIndex++,  "IP所在地");
		exportUtil.setCell(cellIndex++,  "回答者姓名");
		exportUtil.setCell(cellIndex++,  "密码");
		exportUtil.setCell(cellIndex++,  "开始时间");
		exportUtil.setCell(cellIndex++,  "结束时间");

	}

	public void writeToXLS() {

	}

	@Override
	public SurveyStats surveyStatsData(SurveyStats surveyStats) {
		return surveyAnswerDao.surveyStatsData(surveyStats);
	}

	@Override
	public Page<SurveyAnswer> joinSurvey(Page<SurveyAnswer> page, User user) {
		if(user!=null){
			//查找所有参加过的问卷ID号
			Criterion criterion=Restrictions.eq("userId", user.getId());
			page.setOrderBy("endAnDate");
			page.setOrderDir("desc");
			page=findPage(page, criterion);
			List<SurveyAnswer> answers=page.getResult();
			for (SurveyAnswer surveyAnswer : answers) {
				surveyAnswer.setSurveyDirectory(directoryManager.get(surveyAnswer.getSurveyId()));
			}
		}
		return page;
	}

	/**
	 * 取一份卷子回答的数据
	 */
	public Page<SurveyAnswer> answerPage(Page<SurveyAnswer> page,String surveyId){
		Criterion cri1=Restrictions.eq("surveyId", surveyId);
		Criterion cri2=Restrictions.lt("handleState", 2);
		page.setOrderBy("endAnDate");
		page.setOrderDir("desc");
		page=findPage(page, cri1, cri2);
		return page;
	}


	@Override
	@Transactional
	public void delete(SurveyAnswer t) {
		if(t!=null){
			String belongAnswerId=t.getId();
			t.setHandleState(2);
			surveyAnswerDao.save(t);
			//更新当前答卷的回答记录值
			// 得到题列表
			List<Question> questions = questionManager.findDetails(t.getSurveyId(),"2");
			for (Question question : questions) {
				String quId=question.getId();
				QuType quType = question.getQuType();

				if (quType == QuType.YESNO) {// 是非题

				} else if (quType == QuType.RADIO) {// 单选题
					AnRadio anRadio=anRadioManager.findAnswer(belongAnswerId, quId);
					if(anRadio!=null){
						anRadio.setVisibility(0);
						//是否显示  1显示 0不显示
						anRadioManager.save(anRadio);
					}
				} else if (quType == QuType.CHECKBOX) {// 多选题
					List<AnCheckbox> anCheckboxs=anCheckboxManager.findAnswer(belongAnswerId, quId);
					if(anCheckboxs!=null){
						for (AnCheckbox anCheckbox : anCheckboxs) {
							anCheckbox.setVisibility(0);
							//是否显示  1显示 0不显示
							anCheckboxManager.save(anCheckbox);
						}
					}
				} else if (quType == QuType.FILLBLANK) {// 填空题
					AnFillblank anFillblank=anFillblankManager.findAnswer(belongAnswerId, quId);
					if(anFillblank!=null){
						anFillblank.setVisibility(0);
						//是否显示  1显示 0不显示
						anFillblankManager.save(anFillblank);
					}
				} else if (quType == QuType.ANSWER) {// 多行填空题

					AnAnswer anAnswer=anAnswerManager.findAnswer(belongAnswerId, quId);
					if(anAnswer!=null){
						anAnswer.setVisibility(0);
						//是否显示  1显示 0不显示
						anAnswerManager.save(anAnswer);
					}

				} else if (quType == QuType.COMPRADIO) {// 复合单选题


				} else if (quType == QuType.COMPCHECKBOX) {// 复合多选题

				} else if (quType == QuType.ENUMQU) {// 枚举题

				} else if (quType == QuType.MULTIFILLBLANK) {// 组合填空题
					List<AnDFillblank> anDFillblanks=anDFillblankManager.findAnswer(belongAnswerId, quId);
					if(anDFillblanks!=null){
						for (AnDFillblank anDFillblank : anDFillblanks) {
							anDFillblank.setVisibility(0);
							//是否显示  1显示 0不显示
							anDFillblankManager.save(anDFillblank);
						}
					}
				} else if (quType == QuType.SCORE) {// 评分题

					List<AnScore> anScores=anScoreManager.findAnswer(belongAnswerId, quId);
					if(anScores!=null){
						for (AnScore anScore : anScores) {
							anScore.setVisibility(0);
							//是否显示  1显示 0不显示
							anScoreManager.save(anScore);
						}

					}

				} else if (quType == QuType.CHENRADIO) {// 矩阵单选题

					List<AnChenRadio> anChenRadios=anChenRadioManager.findAnswer(belongAnswerId, quId);
					if(anChenRadios!=null){
						for (AnChenRadio anChenRadio : anChenRadios) {
							anChenRadio.setVisibility(0);
							//是否显示  1显示 0不显示
							anChenRadioManager.save(anChenRadio);
						}
					}

				} else if (quType == QuType.CHENCHECKBOX) {// 矩阵多选题

					List<AnChenCheckbox> anChenCheckboxs=anChenCheckboxManager.findAnswer(belongAnswerId, quId);
					if(anChenCheckboxs!=null){
						for (AnChenCheckbox anChenCheckbox : anChenCheckboxs) {
							anChenCheckbox.setVisibility(0);
							//是否显示  1显示 0不显示
							anChenCheckboxManager.save(anChenCheckbox);
						}

					}

				} else if (quType == QuType.COMPCHENRADIO) {// 复合矩阵单选题

				} else if (quType == QuType.CHENSCORE) {// 矩阵评分

					List<AnChenScore> anChenScores=anChenScoreManager.findAnswer(belongAnswerId, quId);
					if(anChenScores!=null){
						for (AnChenScore anChenScore : anChenScores) {
							anChenScore.setVisibility(0);
							//是否显示  1显示 0不显示
							anChenScoreManager.save(anChenScore);
						}
					}
				}

			}
		}
		super.delete(t);
	}

	@Override
	public SurveyAnswer findbyUserId(String userId) {
		
		List<Criterion> criterions=new ArrayList<Criterion>();
		criterions.add(Restrictions.eq("userId", userId));
		 SurveyAnswer surveyAnswer=surveyAnswerDao.findFirst(criterions);
		return surveyAnswer;
	}

	@Override
	public int getquestionAnswer_2(Question question) {
		int score = 0;
		String quId = question.getId();
		// 查询每一题的答案,如果是主观题，则判断是否答对
		QuType quType = question.getQuType();

		//重置导出
		question.setAnAnswer(new AnAnswer());
		question.setAnCheckboxs(new ArrayList<AnCheckbox>());
		question.setAnDFillblanks(new ArrayList<AnDFillblank>());
		question.setAnEnumqus(new ArrayList<AnEnumqu>());
		question.setAnFillblank(new AnFillblank());
		question.setAnRadio(new AnRadio());
		question.setAnYesno(new AnYesno());
		question.setAnScores(new ArrayList<AnScore>());
		question.setAnChenRadios(new ArrayList<AnChenRadio>());
		question.setAnChenCheckboxs(new ArrayList<AnChenCheckbox>());
		question.setAnChenFbks(new ArrayList<AnChenFbk>());
		question.setAnCompChenRadios(new ArrayList<AnCompChenRadio>());
		question.setAnChenScores(new ArrayList<AnChenScore>());

		if (quType == QuType.YESNO) {// 是非题答案
			AnYesno anYesno = anYesnoManager.findAnswer(quId);
			if (anYesno != null) {
				question.setAnYesno(anYesno);
			}
		} else if (quType == QuType.RADIO || quType == QuType.COMPRADIO) {// 单选题答案
			// 复合
			AnRadio anRadio = anRadioManager.findAnswer(quId);
			if (anRadio != null) {
				question.setAnRadio(anRadio);
			}
		} else if (quType == QuType.CHECKBOX || quType == QuType.COMPCHECKBOX) {// 多选题答案
			// 复合
			List<AnCheckbox> anCheckboxs = anCheckboxManager.findAnswer(quId);
			if (anCheckboxs != null) {
				question.setAnCheckboxs(anCheckboxs);
			}
		} else if (quType == QuType.FILLBLANK) {// 单项填空题答案
			AnFillblank anFillblank = anFillblankManager.findAnswer(quId);
			if (anFillblank != null) {
				question.setAnFillblank(anFillblank);
			}

		} else if (quType == QuType.MULTIFILLBLANK) {// 多项填空题答案
			List<AnDFillblank> anDFillblanks = anDFillblankManager.findAnswer(quId);
			// System.out.println("anDFillblank.getAnswer():"+anDFillblank.getAnswer());
			if (anDFillblanks != null) {
				question.setAnDFillblanks(anDFillblanks);
			}
		} else if (quType == QuType.ANSWER) {// 问答题答案
			AnAnswer anAnswer = anAnswerManager
					.findAnswer(quId);
			if (anAnswer != null) {
				question.setAnAnswer(anAnswer);
			}
		} else if (quType == QuType.BIGQU) {// 大题答案
			// List<Question> childQuestions=question.getQuestions();
			// for (Question childQuestion : childQuestions) {
			// score=getquestionAnswer(surveyAnswerId, childQuestion);
			// }
		} else if (quType == QuType.ENUMQU) {
			List<AnEnumqu> anEnumqus = anEnumquManager.findAnswer(
				quId);
			if (anEnumqus != null) {
				question.setAnEnumqus(anEnumqus);
			}
		} else if (quType == QuType.SCORE) {// 评分题
			List<AnScore> anScores = anScoreManager.findAnswer(
					quId);
			if (anScores != null) {
				question.setAnScores(anScores);
			}
		} else if (quType == QuType.CHENRADIO) {// 矩阵单选题
			List<AnChenRadio> anChenRadios = anChenRadioManager.findAnswer(
					 quId);
			if (anChenRadios != null) {
				question.setAnChenRadios(anChenRadios);
			}
		} else if (quType == QuType.CHENCHECKBOX) {// 矩阵多选题
			List<AnChenCheckbox> anChenCheckboxs = anChenCheckboxManager
					.findAnswer(quId);
			if (anChenCheckboxs != null) {
				question.setAnChenCheckboxs(anChenCheckboxs);
			}
		} else if (quType == QuType.CHENFBK) {// 矩阵填空题
			List<AnChenFbk> anChenFbks = anChenFbkManager.findAnswer(
					 quId);
			if (anChenFbks != null) {
				question.setAnChenFbks(anChenFbks);
			}
		} else if (quType == QuType.COMPCHENRADIO) {// 复合矩阵单选题
			List<AnCompChenRadio> anCompChenRadios = anCompChenRadioManager
					.findAnswer( quId);
			if (anCompChenRadios != null) {
				question.setAnCompChenRadios(anCompChenRadios);
			}
		}
		return score;
	}

	@Override
	public SurveyAnswer findbyUsername(String userName,String directoryId, Integer isTemp) {

		List<Criterion> criterions=new ArrayList<Criterion>();
		criterions.add(Restrictions.eq("answerUserName", userName));
		criterions.add(Restrictions.eq("surveyId", directoryId));
		criterions.add(Restrictions.eq("isTemp", isTemp));
		SurveyAnswer surveyAnswer=surveyAnswerDao.findFirst(criterions);
		return surveyAnswer;
	}


}
