package com.key.dwsurvey.service;

import com.key.common.service.BaseService;
import com.key.dwsurvey.entity.Question;
import com.key.dwsurvey.entity.AnAnswer;

/**
 * 答卷业务
 * @author keyuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 */

public interface AnAnswerManager extends BaseService<AnAnswer, String> {
	public AnAnswer findAnswer(String belongAnswerId,String quId);
	
	public AnAnswer findAnswer(String quId);

	public void findGroupStats(Question question);
}
