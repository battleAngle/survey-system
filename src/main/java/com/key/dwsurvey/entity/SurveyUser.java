package com.key.dwsurvey.entity;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.key.common.base.entity.IdEntity;


@Entity
@Table(name="t_survey_user")
public class SurveyUser extends IdEntity{
   
	private String directory_id;
	
	private String userName;
	
	private String passWord;
	
	private String status;
	
	private String startTime;
	
	private String endTime;

	public SurveyUser() {
		super();
	}

	public SurveyUser(String directory_id, String userName, String passWord,
			String status, String startTime, String endTime) {
		super();
		this.directory_id = directory_id;
		this.userName = userName;
		this.passWord = passWord;
		this.status = status;
		this.startTime = startTime;
		this.endTime = endTime;
	}

	public String getDirectory_id() {
		return directory_id;
	}

	public void setDirectory_id(String directory_id) {
		this.directory_id = directory_id;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassWord() {
		return passWord;
	}

	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	
	
	
	
	
}
