package com.key.dwsurvey.dao.impl;

import com.key.common.dao.BaseDaoImpl;
import com.key.dwsurvey.dao.SysRoleDao;
import com.key.dwsurvey.entity.Role;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

/**
 * @author yangye
 * @date 2020/09/21
 */
@Repository
public class SysRoleDaoImpl extends BaseDaoImpl<Role, String> implements SysRoleDao {
	@Override
	public Role findByRoleId(Integer roleId) {
		Criterion c= Restrictions.eq("roleId",roleId);
		return findUnique(c);
	}
}
