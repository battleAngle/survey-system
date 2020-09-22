package com.key.dwsurvey.dao;

import com.key.common.dao.BaseDao;
import com.key.dwsurvey.entity.Role;

/**
 * @author yangye
 * @date 2020/09/21
 */
public interface SysRoleDao extends BaseDao<Role, String> {

	Role findByRoleId(Integer roleId);
}
