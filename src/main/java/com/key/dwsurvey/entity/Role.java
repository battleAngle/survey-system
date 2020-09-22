package com.key.dwsurvey.entity;

import com.key.common.base.entity.IdEntity;

import javax.persistence.Entity;
import javax.persistence.Table;

/**
 * @author yangye
 * @date 2020/09/21
 */
@Entity
@Table(name = "T_ROLE")
public class Role extends IdEntity {

	private int roleId;

	private int createPerm;

	private int viewPerm;

	private int updatePerm;

	private int deployPerm;

	private int pausePerm;

	private int removePerm;

	private int importPerm;

	private int exportPerm;

	private int tplExportPerm;

	public int getRoleId() {
		return roleId;
	}

	public void setRoleId(int roleId) {
		this.roleId = roleId;
	}

	public int getCreatePerm() {
		return createPerm;
	}

	public void setCreatePerm(int createPerm) {
		this.createPerm = createPerm;
	}

	public int getViewPerm() {
		return viewPerm;
	}

	public void setViewPerm(int viewPerm) {
		this.viewPerm = viewPerm;
	}

	public int getUpdatePerm() {
		return updatePerm;
	}

	public void setUpdatePerm(int updatePerm) {
		this.updatePerm = updatePerm;
	}

	public int getDeployPerm() {
		return deployPerm;
	}

	public void setDeployPerm(int deployPerm) {
		this.deployPerm = deployPerm;
	}

	public int getPausePerm() {
		return pausePerm;
	}

	public void setPausePerm(int pausePerm) {
		this.pausePerm = pausePerm;
	}

	public int getRemovePerm() {
		return removePerm;
	}

	public void setRemovePerm(int removePerm) {
		this.removePerm = removePerm;
	}

	public int getImportPerm() {
		return importPerm;
	}

	public void setImportPerm(int importPerm) {
		this.importPerm = importPerm;
	}

	public int getExportPerm() {
		return exportPerm;
	}

	public void setExportPerm(int exportPerm) {
		this.exportPerm = exportPerm;
	}

	public int getTplExportPerm() {
		return tplExportPerm;
	}

	public void setTplExportPerm(int tplExportPerm) {
		this.tplExportPerm = tplExportPerm;
	}
}
