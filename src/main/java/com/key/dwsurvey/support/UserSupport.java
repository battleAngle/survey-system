package com.key.dwsurvey.support;

import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author yangye
 * @date 2020/12/31
 */
@Component
public class UserSupport {

	@Autowired
	private AccountManager accountManager;

	public boolean isAdminRole() {
		User curUser = accountManager.getCurUser();
		return curUser.getRoleId() == 0;
	}
}
