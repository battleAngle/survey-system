package com.key.dwsurvey.action;

import com.alibaba.fastjson.JSONObject;
import com.key.common.base.action.CrudActionSupport;
import com.key.common.plugs.page.Page;
import com.key.common.utils.ExclesUtils;
import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.entity.SurveyUser;
import com.key.dwsurvey.service.SurveyUserService;
import com.opensymphony.xwork2.ActionSupport;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @author yangye
 * @date 2020/05/18
 */
@Namespace("/surveyuser")
public class ImportUserAction extends CrudActionSupport<SurveyUser, String> {

	private String survey_id;
	private File file;
	private String fileContentType;
	private String fileFileName;

	@Autowired
	private SurveyUserService surveyUserService;

	@Override
	@Action(value = "import-user")
	public String execute() throws Exception {
		HttpServletResponse response = Struts2Utils.getResponse();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String msg = checkFile();
		if (StringUtils.isNotEmpty(msg)) {
			response.getWriter().write(msg);
			return null;
		}
		List<String[]> list = ExclesUtils.readExcel(file);
		for (String[] row : list) {
			String username = row[0];
			String password = row[1];
			String startTime = row[2];
			String endTime = row[3];
			String surveyState;
			Date nowDate = new Date();
			if(nowDate.after(format.parse(endTime))){
				surveyState="0";
			}else{
				surveyState="1";
			}

			SurveyUser surveyUser = new SurveyUser(survey_id, username, password, surveyState, startTime, endTime);
			surveyUserService.save(surveyUser);
		}

		SurveyUser entity = new SurveyUser();
		if (StringUtils.isNotEmpty(survey_id)) {
			entity.setDirectory_id(survey_id);
		}
		page = surveyUserService.findByUser(page, entity);
		String pageString= JSONObject.toJSONString(page);
		response.getWriter().write(pageString);
		return null;
	}

	private String checkFile() throws IOException {
		//判断文件是否存在
		if(null == file){
			return "请选择文件";
		}
		//判断文件是否是excel文件
		if(!fileFileName.endsWith("xls") && !fileFileName.endsWith("XLS")){
			return "请上传xls文件";
		}
		return "";
	}


	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public String getSurvey_id() {
		return survey_id;
	}

	public void setSurvey_id(String survey_id) {
		this.survey_id = survey_id;
	}

	public String getFileContentType() {
		return fileContentType;
	}

	public void setFileContentType(String fileContentType) {
		this.fileContentType = fileContentType;
	}

	public String getFileFileName() {
		return fileFileName;
	}

	public void setFileFileName(String fileFileName) {
		this.fileFileName = fileFileName;
	}
}
