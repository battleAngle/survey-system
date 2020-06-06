<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>问卷编辑</title>
<link rel="stylesheet" href="${ctx }/js/plugs/bootstrap-3.3.0-dist/dist/css/bootstrap.css">
<link rel="stylesheet" href="http://jqueryui.com/resources/demos/style.css">
<link href="${ctx }/js/plugs/jquery-ui-1.10.3.custom/css/mycss/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${ctx }/js/plugs/jquery-ui-1.10.3.custom/js/jquery-1.10.1.js"></script>
<script type="text/javascript" src="${ctx }/js/plugs/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"></script>
<link href="${ctx}/js/plugs/validate/jquery.validate.css" type="text/css" rel="stylesheet" />
<link href="${ctx}/js/plugs/layer/skin/default/layer.css" type="text/css" rel="stylesheet" />
<link href="${ctx}/js/plugs/zTree/css/zTreeStyle.css" type="text/css" rel="stylesheet" />
<script src="${ctx}/js/plugs/zTree/js/jquery.ztree.all-3.5.min.js" type="text/javascript"></script>
<script src="${ctx}/js/plugs/layer/layer.js" type="text/javascript"></script>
<script src="${ctx}/js/plugs/validate/jquery.validate.js" type="text/javascript"></script>
<script src="${ctx}/js/plugs/validate/messages_cn.js" type="text/javascript"></script>
<script src="${ctx }/js/plugs/validate/jquery.metadata.js" type="text/javascript"></script>
<script type="text/javascript" charset="utf-8" src="${ctx }/js/plugs/ueditor1_4_2-utf8-jsp/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${ctx }/js/plugs/ueditor1_4_2-utf8-jsp/ueditor.all.min.js"> </script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8" src="${ctx }/js/plugs/ueditor1_4_2-utf8-jsp/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript" src="${ctx }/js/dw/jquery.resizableColumns.js"></script>
<script type="text/javascript" src="${ctx }/js/dw/store.min.js"></script>
<script type="text/javascript" src="${ctx }/js/dw/dw-design-init.js"></script>
<script type="text/javascript" src="${ctx }/js/dw/address.js"></script>
<script language="javascript" type="text/javascript" src="${ctx }/js/plugs/My97DatePickerBeta/My97DatePicker/WdatePicker.js"></script>
<link href="${ctx }/css/jquery.resizableColumns.css" rel="stylesheet" type="text/css" />
<link href="${ctx }/css/design-survey.css" rel="stylesheet" type="text/css" />
<link href="${ctx }/css/dw-user.css" rel="stylesheet" type="text/css" />
<!--[if lt IE 7]><link rel="stylesheet" href="ie-stuff.css" type="text/css" media="screen"/><![endif]--> 
<script type="text/javascript">
</script>
</head>
<body>
<div id="wrap">
<input type="hidden" id="id" name="id" value="${survey.id }">
<input type="hidden" id="ctx" value="${ctx }">
<input type="hidden" id="surveyModel_hidden" value="${survey.surveyModel }">
<input type="hidden" id="survey_state" value="${survey.surveyState}">
<input type="hidden" id="page_now" value="${page.pageNo}">
<div id="header" >
<div id="header_left">
<%-- <img alt="调问网" src="${ctx }/images/logo/logo.jpg" > --%>
<!-- <div id="header_title">DIAOWEN-在线问卷编辑器</div> -->
<div class="header_Item header_logo">
		<a href="${ctx }/"><img alt="Auxing" src="${ctx }/images/logo/main_logo.png" style="height: 46px;" ><span style="font-family: '微软雅黑';font-size: 16px;line-height: 46px;color: white">&nbsp;&nbsp;奥科星</span></a>
		<!-- <div style="font-family: '微软雅黑';font-size:26px;padding-left:10px;">DIAOWEN&nbsp;&nbsp; </div>-->
		&nbsp;&nbsp;
		<span style="font-family: '微软雅黑';font-size: 16px;line-height: 46px;" id="pageHeaderSpan">在线问卷编辑器</span>
</div>
</div>
<div id="header_right">
<div style="line-height: 22px;"><a href="${ctx }/design/my-survey.action">问卷</a>&nbsp;&nbsp;<a href="${ctx }/ic/user!myaccount.action">账号</a></div>
</div>
</div>

<div id="tools_wrap">
<div id="tools">
<div class="tools_tabs">
	<div class="tools_tabs_left">
	<ul>
	<li class="current" id="tools_tab1_li">基本</li>
	<li id="tools_tab2_li">常用</li>
	<li id="tools_tab3_li">用户</li>
	</ul></div>
	<div class="tools_tabs_right"><ul><li style="padding: 0px;font: 12px;line-height: 22px;"><a href="http://support.diaowen.net/" target="_black" style="text-decoration: none;color: gray;display: none">帮助</a></li></ul></div>
</div>

<div class="tools_contents">
	<div id="tools_tab1" class="tools_tab_div" style="display: inline;">
	<div id="toolsBashQu" class="tools_item">
		<div class="toolbars">
			<ul class="dragQuUl" >
			<li id="radioQuModel">
				<%-- 单选题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="RADIO">
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="isSelectType" value="0">
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">选项1</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">选项2</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
									</ul></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="checkboxQuModel">
				<%-- 多选题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHECKBOX" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								<!-- minNum -->
								<input type="hidden" name="minNum" value="1">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<input type="checkbox"><label class="editAble quCoOptionEdit">选项1</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="checkbox"><label class="editAble quCoOptionEdit">选项2</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="checkbox"><label class="editAble quCoOptionEdit">选项3</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
									</ul></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>

			</li>
		
			<li id="fillblankQuModel">
				<%-- 填空题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="NO">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
								</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
												<textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="scoreQuModel">
				<%-- 评分题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="SCORE" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								
								<input type="hidden" name="paramInt01" value="1">
								<input type="hidden" name="paramInt02" value="5">
								
								<input type="hidden" name="isSlider" value="0">
								<input type="hidden" name="isScoreInput" value="0">
								<input type="hidden" name="maxSliderLength" value="0">
								<input type="hidden" name="minSliderLength" value="0">
								<input type="hidden" name="totalSliderLength" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem">
										<table class="quCoItemTable" cellpadding="0" cellspacing="0">
											<tr class="quScoreOptionTr">
												<td class="quCoItemTableTd quOptionEditTd">
													<label class="editAble quCoOptionEdit" for="amount">分项1</label>
													<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
												</td>
												<td class="quCoItemTableTd"><table class="scoreNumTable"><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr></table></td>
												<td class="quCoItemTableTd">分</td>
											</tr>
											<tr class="quScoreOptionTr">
												<td class="quCoItemTableTd quOptionEditTd">
													<label class="editAble quCoOptionEdit">分项2</label>
													<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
												</td>
												<td class="quCoItemTableTd"><table class="scoreNumTable"><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr></table></td>
												<td class="quCoItemTableTd">分</td>
											</tr>
										</table>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="orderQuModel">
				<%-- 排序题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="ORDERQU" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem">
										<div  class="quOrderByLeft">
										<ul>
											<li class="quCoItemUlLi"><label class="editAble quCoOptionEdit">选项1</label>
													<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></li>
											<li class="quCoItemUlLi"><label class="editAble quCoOptionEdit">选项2</label>
													<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></li>
											<li class="quCoItemUlLi"><label class="editAble quCoOptionEdit">选项3</label>
												<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></li>
										</ul></div>
										<div class="quOrderByRight">
											<table class="quOrderByTable">
												<tr><td class="quOrderyTableTd">1</td><td></td></tr>
												<tr><td class="quOrderyTableTd">2</td><td></td></tr>
												<tr><td class="quOrderyTableTd">3</td><td></td></tr>
											</table>
										</div>
										<div style="clear: both;"></div>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="mfillblankQuModel">
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="MULTIFILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="NO">
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								<input type="hidden" name="paramInt01" value="1">
								<input type="hidden" name="paramInt02" value="5">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem">
									<table class="mFillblankTable">
										<tr class="mFillblankTableTr">
											<td align="right" class="mFillblankTableEditTd"><label class="editAble quCoOptionEdit">选项11</label>
											<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
											</td>
											<td><input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
                                                <textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea><div class="dwFbMenuBtn"></div></td>
										</tr>
										<tr class="mFillblankTableTr">
											<td align="right" class="mFillblankTableEditTd"><label class="editAble quCoOptionEdit">选项12</label>
											<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
											</td>
											<td><input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
                                                <textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea><div class="dwFbMenuBtn"></div></td>
										</tr>
										<tr class="mFillblankTableTr">
											<td align="right" class="mFillblankTableEditTd"><label class="editAble quCoOptionEdit">选项13</label>
											<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
											</td>
											<td><input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
                                                <textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea><div class="dwFbMenuBtn"></div></td>
										</tr>
									</table>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
		    </ul>
		</div>
		<div class="tooltext">基本题型</div>
	</div>
	
	<div id="toolsChenQu" class="tools_item" style="">
		<div class="toolbars">
			<ul class="dragQuUl">
			<li id="chenRadioQuModel">
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENRADIO" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="trWidthInfo" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
												</tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td><input type="radio"> </td><td><input type="radio"> </td></tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td><input type="radio"> </td><td><input type="radio"> </td></tr>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>

								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="chenCheckboxQuModel">
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENCHECKBOX" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="trWidthInfo" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
												</tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td><input type="checkbox"> </td><td><input type="checkbox"> </td></tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td><input type="checkbox"> </td><td><input type="checkbox"> </td></tr>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>

								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="checkboxClassifyQuModel">
				<%-- 多选分类题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHECKBOX" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="isSubentry" value="1">
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem">
										<ul class="checkboxClassifyContentUl">
											<li class="quCoItemUlLi noCheckBoxLi_classify">
												<input type="checkbox" style="display:none"><label class="editAble quCoOptionEdit">选项1</label>
												<div class="surveyQuItemLeftTools">
													<ul class="surveyQuItemLeftToolsUl">
														<!-- <li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li> -->
													    <!--<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
														<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>  -->
			                                            <li title="复制分项" class="dwQuCopy_classify ui-draggable"><div class="dwQuIcon"></div></li>
														<li title="删除分项" class="dwQuDelete_classify ui-draggable"><div class="dwQuIcon"></div></li>
													</ul>
												</div>
												<div class="quItemInputCase">
													<input type="hidden" name="quItemId" value="">
													<input type="hidden" name="quItemSaveTag" value="0">
													<input type="hidden" name="isNote" value="0">
													<input type="hidden" name="checkType" value="NO">
													<input type="hidden" name="isRequiredFill" value="0">
											         <input type="hidden" name="noCheckBox" value="1">
												</div>
											</li>
											<li class="quCoItemUlLi">
												<input type="checkbox"><label class="editAble quCoOptionEdit">选项2</label>
												<div class="quItemInputCase">
													<input type="hidden" name="quItemId" value="">
													<input type="hidden" name="quItemSaveTag" value="0">
													<input type="hidden" name="isNote" value="0">
													<input type="hidden" name="checkType" value="NO">
													<input type="hidden" name="isRequiredFill" value="0">
													 <input type="hidden" name="noCheckBox" value="0">
												</div>
											</li>
											<li class="quCoItemUlLi">
												<input type="checkbox"><label class="editAble quCoOptionEdit">选项3</label>
												<div class="quItemInputCase">
													<input type="hidden" name="quItemId" value="">
													<input type="hidden" name="quItemSaveTag" value="0">
													<input type="hidden" name="isNote" value="0">
													<input type="hidden" name="checkType" value="NO">
													<input type="hidden" name="isRequiredFill" value="0">
													<input type="hidden" name="noCheckBox" value="0">
												</div>
											</li>
											<li class="quCoBottomTools">
												<ul class="quCoBottomToolsUl">
													<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
													<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
												</ul>
											</li>
										</ul>
									</div>
									
								</div>
							</div>
						</div>
				</div>
			</li>
			
			
			<li id="chenScoreQuModel">
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENSCORE" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="trWidthInfo" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="maxSliderLength" value="5">
								<input type="hidden" name="minSliderLength" value="1">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools"> 
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
												</tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td>评分 </td><td>评分 </td></tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td>评分 </td><td>评分 </td></tr>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>

								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="chenFillblankQuModel">
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENFBK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="trWidthInfo" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >题标题？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">列2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td>
												</tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行1</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td><input type="text"> </td><td><input type="text"> </td></tr>
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">行2</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div></td><td><input type="text"> </td><td><input type="text"> </td></tr>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>

								</div>
							</div>
						</div>
				</div>
			</li>
		    </ul>
		</div>
		<div class="tooltext">矩阵题型</div>
	</div>
	
	<div id="toolsAuxiliaryQu" class="tools_item">
		<div class="toolbars">
			<ul class="dragQuUl">
			<li id="pageQuModel">
				<%-- 分页题模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="PAGETAG" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools" style="margin-top:0px;">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="pageBorderTop" ></div>
								<div class="surveyQuItemContent" style="min-height: 10px;text-align: right;">
									<div class="pageQuContent">下一页（1/2）</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="paragraphQuModel">
				<%--段落说明 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody paragraphQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="PARAGRAPH" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<!--<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li> -->
                                            <li title="复制分段" class="dwQuCopy_paragraph ui-draggable"><div class="dwQuIcon"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent" style="min-height: 45px;">
									<div class="quCoTitle">
										<div class="quCoNum" style="display: none;">1、</div>
										<div class="editAble quCoTitleEdit" ><p><strong>分段标记</strong></p></div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
		    </ul>
		</div>
		<div class="tooltext">辅助组件</div>
	</div>
	
	<!--批量添加用户查看用户  -->
	<div id="toolsEvent" class="tools_item">
		<div class="toolbars">
			<ul>
			<!-- <li id="exportToolbar">
				<div class="dwToolbar_icon"></div>
			</li> -->
			<!-- <li id="logicToolbar" class="logicToolbar_li">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon"></span>
				</a>
			</li>
			<li id="qubankToolbar" >
				<div class="dwToolbar_icon" ></div>
			</li> -->
			<!-- 
			<li id="qubankToolbar" >
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="题库"></span>
				</a>
			</li>
			<li id="exportToolbar">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="导入"></span>
				</a>
			</li>
			 -->
			<li id="surveyAttrSetToolbar"  class="surveyAttrSetToolbar_li">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="问卷设置"></span>
				</a>
			</li>
			<li id="surveyStyleEditToolbar">
				<a  class="surveyStyleEditToolbar_a" >
				<span class="dwToolbar_icon" title="样式编辑"></span>
				</a>
			</li>
			
			<%-- <li id="surveyStyleLogicToolbar">
				<a href="${ctx }/logic/survey-logic!tologicpage.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" id="toolsEvent_dwToolbar_icon_3" title="逻辑设置" style="background-position: -8px -250px;"></span>
				</a>
			</li> --%>
			<%-- <li id="previewToolbar">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="预览"></span>
				</a>
			</li> --%>
		    </ul>
		</div>
		<div class="tooltext">操作</div>
	</div>
	
		<%-- <div id="toolsEvent" class="tools_item">
		<div class="toolbars">
			<ul>
			<!-- <li id="exportToolbar">
				<div class="dwToolbar_icon"></div>
			</li> -->
			<!-- <li id="logicToolbar" class="logicToolbar_li">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon"></span>
				</a>
			</li>
			<li id="qubankToolbar" >
				<div class="dwToolbar_icon" ></div>
			</li> -->
			<!-- 
			<li id="qubankToolbar" >
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="题库"></span>
				</a>
			</li>
			<li id="exportToolbar">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="导入"></span>
				</a>
			</li>
			 -->
			<li id="surveyAttrSetToolbar_person"  class="surveyAttrSetToolbar_li_person">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="问卷设置"></span>
				</a>
			</li>
			<li id="surveyStyleEditToolbar_person">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="样式编辑"></span>
				</a>
			</li>
			<li id="previewToolbar">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="预览"></span>
				</a>
			</li>
		    </ul>
		</div>
		<div class="tooltext">用户添加</div>
	</div> --%>
	<!--批量添加用户jieshu  -->
	</div>
	
	<div id="tools_tab2" class="tools_tab_div">
		
		<div id="contactPersonQuestion" class="tools_item">
			<div class="toolbars">
				<ul class="dragQuUl">
				<li id="userNameQuModel">
				<%-- 您的姓名--%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="NO">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="1">
								<input type="hidden" name="contactsField" value="1">
								
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的姓名？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
												<textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="phoneNoQuModel">
				<%-- 手机模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="PHONENUM">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="1">
								<input type="hidden" name="contactsField" value="2">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的手机号？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
												<textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="addressQuModel">
				<%-- 地址模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="NO">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="2">
								
								<input type="hidden" name="contactsAttr" value="1">
								<input type="hidden" name="contactsField" value="3">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的地址？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
												<textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="birthdayQuModel" style="display: none;">
				<%--生日模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的生日是？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
												<textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="emailQuModel">
				<%--Email模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="EMAIL">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="1">
								<input type="hidden" name="contactsField" value="5">
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的邮箱是？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;" class="quFillblankAnswerInput" />
												<textarea rows="5" style="width:300px;display: none;"class="quFillblankAnswerTextarea" ></textarea>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="genderQuModel">
				<%--性别模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="RADIO">
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="isSelectType" value="0">
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的性别是？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul class="transverse">
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">男</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">女</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
									</ul></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="educationQuModel">
				<%--学历模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="RADIO">
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="isSelectType" value="0">
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的最高学历是？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul class="transverse">
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">博士</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">硕士</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">本科</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">专科</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
									</ul></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="companyQuModel" style="display: none;">
				<%--公司模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="NO">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您现在所在的公司？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;">
												<div class="dwComEditMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="cityQuModel" style="display: none;">
				<%--城市模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="NO">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="1">
								<input type="hidden" name="contactsField" value="8">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您所在的城市？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<!-- <div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;">
												<div class="dwComEditMenuBtn" ></div>
											</div> -->
											<select style="padding: 5px;" class="hat_province"><option>--选择省--</option> </select>
											<select style="padding: 5px;" class="hat_city"><option>--选择市--</option> </select>
											<select style="padding: 5px;" class="hat_area"><option>--选择区--</option> </select>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="maritalQuModel">
				<%--婚姻状况模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="RADIO">
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="isSelectType" value="0">
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >请问您婚否？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul class="transverse">
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">是</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">否</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
									</ul></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="salaryQuModel">
				<%--收入模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="RADIO">
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="isSelectType" value="0">
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >您的月平均收入是？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul class="transverse">
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">3000元以下</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
						
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">3000-5000元</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">5000-10000元</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">10000-20000元</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
										<li class="quCoItemUlLi">
											<input type="radio"><label class="editAble quCoOptionEdit">20000元以上</label>
											<div class="quItemInputCase">
												<input type="hidden" name="quItemId" value="">
												<input type="hidden" name="quItemSaveTag" value="0">
												<input type="hidden" name="isNote" value="0">
												<input type="hidden" name="checkType" value="NO">
												<input type="hidden" name="isRequiredFill" value="0">
											</div>
										</li>
									</ul></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
			<li id="dateQuModel">
				<%--日期模板 --%>
				<div class="dwToolbar_icon"></div>
				<div class="dwQuTypeModel">
						<div class="surveyQuItemBody quDragBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK" >
								<input type="hidden" name="quId" value="">
								<input type="hidden" name="orderById" value="0"/>
								<input type="hidden" name="saveTag" value="0">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="1">
								<input type="hidden" name="hv" value="2">
								<input type="hidden" name="randOrder" value="0">
								<input type="hidden" name="cellCount" value="0">
								<input type="hidden" name="checkType" value="DATE">
								
								<input type="hidden" name="answerInputWidth" value="300">
								<input type="hidden" name="answerInputRow" value="1">
								
								<input type="hidden" name="contactsAttr" value="0">
								<input type="hidden" name="contactsField" value="0">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="0">
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li>
											<li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">1、</div>
										<div class="editAble quCoTitleEdit" >日期？</div>
										<input type="hidden" name="quTitleSaveTag" value="0">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<!-- <input type="text" style="width:200px;padding:5px;"> -->
											<div class="quFillblankItem">
												<input type="text" style="width:200px;padding:5px;"  class="Wdate" onClick="WdatePicker()">
												<div class="dwComEditMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
							</div>
						</div>
				</div>
			</li>
				<!-- <li id="exportToolbar">
					<div class="dwToolbar_icon"></div>
				</li>
				<li id="logicToolbar">
					<div class="dwToolbar_icon"></div>
				</li>
				<li id="qubankToolbar" >
					<div class="dwToolbar_icon"></div>
				</li> -->
			    </ul>
			</div>
			<div class="tooltext">常用题型</div>
	</div>
</div>
<!--添加第三个  -->

<div id="tools_tab3" class="tools_tab_div">
	<div id="contactPersonQuestion_3" class="tools_item">
		<div class="toolbars">
			<ul>
			<li id="surveyAttrSetToolbar_person"  class="surveyAttrSetToolbar_li_person">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="问卷设置"></span>
				</a>
			</li>
			<li id="surveyAttrViewPersonDialog" class="surveyAttrViewPerson_Dialog">
				<a href="${ctx }/design/my-survey-design!previewDev.action?surveyId=${param['surveyId']}" >
				<span class="dwToolbar_icon" title="样式编辑"></span>
				</a>
			</li>
				
      </ul>
	</div>
    <div class="tooltext">用户操作</div> 
	</div>
</div>
<!--添加第三个  -->
	
	<div id="toolsPubBtn" >
		<div class="toolbars" style="padding:10px  15px 10px 0px;">
			<ul>
			<li id="publishBtn" >
				<div class="dwToolbar_icon"></div>
			</li>
			<li id="saveＭodelBtn" style="display: none;" class="saveＭodelBtn_li">
				<div class="dwToolbar_icon"></div>
			</li>
			<li id="saveBtn" >
				<div class="dwToolbar_icon"></div>
			</li>
			<li id="previewBtn" >
				<div class="dwToolbar_icon"></div>
			</li>
		    </ul>
		</div>
	</div>
  </div>
 </div>
</div>
<div id="dw_body">
	<div id="dw_body_left">
		<div class="dw_body_title" style="text-align: center;">设计目录</div>
		<div id="dwBodyLeftContent">
			<h2 class=""><a href="" class="ellipsis">欢迎页</a></h2>
			<div>
			<div><h2 class=""><a href="" class="ellipsis">问卷页</a></h2></div>
			
			<div style="padding-left: 5px;">
			<h2 class=""><a href="" class="ellipsis">1、请问你的年级是？</a></h2>
			<h2 class=""><a href="" class="ellipsis">2、请问你的年级是？</a></h2>
			<h2 class=""><a href="" class="ellipsis">3、请问你的年级是？</a></h2>
			<h2 class=""><a href="" class="ellipsis">4、请问你的年级是？</a></h2>
			<h2 class=""><a href="" class="ellipsis">下一页</a></h2>
			<h2 class=""><a href="" class="ellipsis">5、请问你的年级是？</a></h2>
			<h2 class=""><a href="" class="ellipsis">6、请问你的年级是级是级是？</a></h2>
			</div>
			</div>
			<h2 class=""><a href="" class="ellipsis">结束页</a></h2>
		</div>
	</div>
	<div id="dw_body_right" style="display: none;"><div class="dw_body_title">题目推荐</div></div>
	<div id="dw_body_content">
		<%-- <div id="dwSurveyTitle" contenteditable="true">${survey.surveyName }</div> --%>
		<div id="dwSurveyTitle">
			<div id="dwSurveyName" class="editAble dwSvyName">${survey.surveyName }</div>
		</div>
		<input type="hidden" name="svyNmSaveTag" value="1">
		<div id="dwSurveyNote">
			<div id="dwSurveyNoteTools">参考样例</div>
			<%-- <div id="dwSurveyNoteEdit" contenteditable="true"  >${survey.surveyDetail.surveyNote }</div> --%>
			<div id="dwSurveyNoteEdit" class="editAble dwSvyNoteEdit"  >${survey.surveyDetail.surveyNote }</div>
			<input type="hidden" name="svyNoteSaveTag" value="1">
		</div>
		
		<div id="dwSurveyQuContent" style="min-height: 500px;">
			<ul id="dwSurveyQuContentAppUl">
				<!-- 题目内容 -->
					<c:forEach items="${survey.questions }" var="en" varStatus="i">
					<li class="li_surveyQuItemBody <c:if test="${en.quType eq 'PARAGRAPH'}">paragraphQuItemBody_li</c:if>">
				<c:choose>
					<c:when test="${en.quType eq 'RADIO' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="RADIO">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<!-- isSelectType -->
								<input type="hidden" name="isSelectType" value="${en.isSelectType }">
								<input type="hidden" name="contactsAttr" value="${en.contactsAttr }">
								<input type="hidden" name="contactsField" value="${en.contactsField }">
								
								<div class="quLogicInputCase">
								<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
								<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
								</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem">
									<c:choose>
										<c:when test="${en.hv eq 3 }">
											<table class='tableQuColItem'>
												<c:forEach begin="0" end="${fn:length(en.quRadios)-1 }" var="j" step="${en.cellCount }">
												<tr>
												<c:forEach begin="1" end="${en.cellCount }" var="k">
												<td width="${600/en.cellCount }">
													<!-- 判断不为空，访止数组越界 -->
													<c:set var="quOptionIndex" value="${(j+k-1) }" ></c:set>
													<c:choose>
														<c:when test="${quOptionIndex < fn:length(en.quRadios) }">
																<input type="radio"><label style="width:${600/en.cellCount-10 }px;" class="editAble quCoOptionEdit">${en.quRadios[quOptionIndex].optionName }</label>
																<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
																<div class="quItemInputCase">
																	<input type="hidden" name="quItemId" value="${en.quRadios[quOptionIndex].id }"><input type="hidden" name="quItemSaveTag" value="1">
																	<input type="hidden" name="isNote" value="${item.isNote }">
																	<input type="hidden" name="checkType" value="${item.checkType }">
																	<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
																</div>
														</c:when>
														<c:otherwise><div class="emptyTd"></div></c:otherwise>
													</c:choose>
												</td>
												</c:forEach>
												</tr>
												</c:forEach>
											</table>
										</c:when>
										<c:when test="${en.hv eq 1 }">
											<ul class="transverse">
												<c:forEach items="${en.quRadios }" var="item">
												<li class="quCoItemUlLi">
													<input type="radio"><label class="editAble quCoOptionEdit">${item.optionName }</label>
													<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
													<div class="quItemInputCase">
														<input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1">
														<input type="hidden" name="isNote" value="${item.isNote }">
														<input type="hidden" name="checkType" value="${item.checkType }">
														<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
													</div>
												</li>
												<!-- <li><select> <option>可想而知</option> </select> </li> -->
												</c:forEach>
											</ul>
										</c:when>
										<c:otherwise>
											<ul>
												<c:forEach items="${en.quRadios }" var="item">
												<li class="quCoItemUlLi">
													<input type="radio"><label class="editAble quCoOptionEdit">${item.optionName }</label>
													<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
													<div class="quItemInputCase">
														<input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1">
														<input type="hidden" name="isNote" value="${item.isNote }">
														<input type="hidden" name="checkType" value="${item.checkType }">
														<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
													</div>
												</li>
												<!-- <li><select> <option>可想而知</option> </select> </li> -->
												</c:forEach>
											</ul>
										</c:otherwise>
									</c:choose>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<c:when test="${en.quType eq 'CHECKBOX'}">
					   
					 <c:if test="${en.isSubentry eq '0'}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHECKBOX">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								
								<input type="hidden" name="contactsAttr" value="${en.contactsAttr }">
								<input type="hidden" name="contactsField" value="${en.contactsField }">
								<!-- minNum -->
								<input type="hidden" name="minNum" value="${en.minNum }">						
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem">
										<c:choose>
										<c:when test="${en.hv eq 3 }">
											<table class='tableQuColItem'>
												<c:forEach begin="0" end="${fn:length(en.quCheckboxs)-1 }" var="j" step="${en.cellCount }" >
												<tr>
												<c:forEach begin="1" end="${en.cellCount }" var="k">
												<td width="${600/en.cellCount }">
													<!-- 判断不为空，访止数组越界 -->
													<c:set var="quOptionIndex" value="${(j+k-1) }" ></c:set>
													<c:choose>
														<c:when test="${quOptionIndex < fn:length(en.quCheckboxs) }">
																<input type="checkbox" style="<c:if test="${item.noCheckBox == 1}">display:none;</c:if>"><label style="width:${600/en.cellCount-10 }px;" class="editAble quCoOptionEdit">${en.quCheckboxs[quOptionIndex].optionName }</label>
																<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
																<div class="quItemInputCase">
																	<input type="hidden" name="quItemId" value="${en.quCheckboxs[quOptionIndex].id }"><input type="hidden" name="quItemSaveTag" value="1">
																	<input type="hidden" name="isNote" value="${item.isNote }">
																	<input type="hidden" name="checkType" value="${item.checkType }">
																	<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
																	<input type="hidden" name="noCheckBox" value="${item.noCheckBox }">
																</div>
														</c:when>
														<c:otherwise><div class="emptyTd"></div></c:otherwise>
													</c:choose>
												</td>
												</c:forEach>
												</tr>
												</c:forEach>
											</table>
										</c:when>
										<c:when test="${en.hv eq 1 }">
											<ul class="transverse">
												<c:forEach items="${en.quCheckboxs }" var="item">
												<li class="quCoItemUlLi">
													<input type="checkbox" style="<c:if test="${item.noCheckBox == 1}">display:none;</c:if>"><label class="editAble quCoOptionEdit">${item.optionName }</label>
													<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
													<div class="quItemInputCase">
														<input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1">
														<input type="hidden" name="isNote" value="${item.isNote }">
														<input type="hidden" name="checkType" value="${item.checkType }">
														<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
														<input type="hidden" name="noCheckBox" value="${item.noCheckBox }">
													</div>
												</li>
												<!-- <li><select> <option>可想而知</option> </select> </li> -->
												</c:forEach>
											</ul>
										</c:when>
										<c:otherwise>
											<ul>
												<c:forEach items="${en.quCheckboxs }" var="item">
												<li class="quCoItemUlLi">
													<input type="checkbox" style="<c:if test="${item.noCheckBox == 1}">display:none;</c:if>" ><label class="editAble quCoOptionEdit">${item.optionName }</label>
													<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
													<div class="quItemInputCase">
														<input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1">
														<input type="hidden" name="isNote" value="${item.isNote }">
														<input type="hidden" name="checkType" value="${item.checkType }">
														<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
														<input type="hidden" name="noCheckBox" value="${item.noCheckBox }">
													</div>
												</li>
												<!-- <li><select> <option>可想而知</option> </select> </li> -->
												</c:forEach>
											</ul>
										</c:otherwise>
									</c:choose>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
								
							</div>
					</div>
					</c:if>
					
					 <!-- 分项题的模板 -->
					 <c:if test="${en.isSubentry eq '1'}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHECKBOX">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<input type="hidden" name="isSubentry" value="${en.isSubentry}">
								<input type="hidden" name="contactsAttr" value="${en.contactsAttr }">
								<input type="hidden" name="contactsField" value="${en.contactsField }">
								
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem">
										<c:choose>
										<c:when test="${en.hv eq 3 }">
											<table class='tableQuColItem'>
												<c:forEach begin="0" end="${fn:length(en.quCheckboxs)-1 }" var="j" step="${en.cellCount }" >
												<tr>
												<c:forEach begin="1" end="${en.cellCount }" var="k">
												<td width="${600/en.cellCount }">
													<!-- 判断不为空，访止数组越界 -->
													<c:set var="quOptionIndex" value="${(j+k-1) }" ></c:set>
													<c:choose>
														<c:when test="${quOptionIndex < fn:length(en.quCheckboxs) }">
																<input type="checkbox" style="<c:if test="${item.noCheckBox == 1}">display:none;</c:if>"><label style="width:${600/en.cellCount-10 }px;" class="editAble quCoOptionEdit">${en.quCheckboxs[quOptionIndex].optionName }</label>
																<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
																<div class="quItemInputCase">
																	<input type="hidden" name="quItemId" value="${en.quCheckboxs[quOptionIndex].id }"><input type="hidden" name="quItemSaveTag" value="1">
																	<input type="hidden" name="isNote" value="${item.isNote }">
																	<input type="hidden" name="checkType" value="${item.checkType }">
																	<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
																	<input type="hidden" name="noCheckBox" value="${item.noCheckBox }">
																</div>
														</c:when>
														<c:otherwise><div class="emptyTd"></div></c:otherwise>
													</c:choose>
												</td>
												</c:forEach>
												</tr>
												</c:forEach>
											</table>
										</c:when>
										<c:when test="${en.hv eq 1 }">
											<ul class="transverse">
												<c:forEach items="${en.quCheckboxs }" var="item">
												<li class="quCoItemUlLi">
													<input type="checkbox" style="<c:if test="${item.noCheckBox == 1}">display:none;</c:if>"><label class="editAble quCoOptionEdit">${item.optionName }</label>
													<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
													<div class="quItemInputCase">
														<input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1">
														<input type="hidden" name="isNote" value="${item.isNote }">
														<input type="hidden" name="checkType" value="${item.checkType }">
														<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
														<input type="hidden" name="noCheckBox" value="${item.noCheckBox }">
													</div>
												</li>
												<!-- <li><select> <option>可想而知</option> </select> </li> -->
												</c:forEach>
											</ul>
										</c:when>
										<c:otherwise>
											<ul class="checkboxClassifyContentUl">
												<c:forEach items="${en.quCheckboxs }" var="item" varStatus="vs">
												 <c:if test="${vs.count > 1 && item.noCheckBox == 1 }">
												  <li class="quCoBottomTools">
													<ul class="quCoBottomToolsUl">
														<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
														<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
													</ul>
											    </li>
												</c:if>
												<li class="quCoItemUlLi <c:if test="${item.noCheckBox == 1}">noCheckBoxLi_classify</c:if>" >
													<input type="checkbox" style="<c:if test="${item.noCheckBox == 1}">display:none;</c:if>" ><label class="editAble quCoOptionEdit">${item.optionName }</label>
													
													<c:if test="${item.noCheckBox == 1}">
													   <div class="surveyQuItemLeftTools">
													        <ul class="surveyQuItemLeftToolsUl">
																<!-- <li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li> -->
															<!-- 	<li title="设置" class="dwQuSet"><div class=dwQuIcon></div></li>
																<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo"></div></div></li>  -->
					                                            <li title="复制分项" class="dwQuCopy_classify ui-draggable"><div class="dwQuIcon"></div></li>
																<li title="删除分项" class="dwQuDelete_classify ui-draggable"><div class="dwQuIcon"></div></li>
															</ul>
												        </div>
													</c:if>
													<input type='text' class='optionInpText'  style="${item.isNote eq 1 ? '':'display: none;'}"/>
													<div class="quItemInputCase">
														<input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1">
														<input type="hidden" name="isNote" value="${item.isNote }">
														<input type="hidden" name="checkType" value="${item.checkType }">
														<input type="hidden" name="isRequiredFill" value="${item.isRequiredFill }">
														<input type="hidden" name="noCheckBox" value="${item.noCheckBox }">
													</div>
												</li>
												<!-- <li><select> <option>可想而知</option> </select> </li> -->
												</c:forEach>
												<li class="quCoBottomTools ">
													<ul class="quCoBottomToolsUl">
														<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
														<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
													</ul>
											    </li>
											</ul>
										</c:otherwise>
									</c:choose>
									</div>
								</div>
								
							</div>
					</div>
					</c:if>
					</c:when>
					
					<c:when test="${en.quType eq 'FILLBLANK' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="FILLBLANK">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<input type="hidden" name="checkType" value="${en.checkType }">
								
								<input type="hidden" name="answerInputWidth" value="${en.answerInputWidth }">
								<input type="hidden" name="answerInputRow" value="${en.answerInputRow }">
								
								<input type="hidden" name="contactsAttr" value="${en.contactsAttr }">
								<input type="hidden" name="contactsField" value="${en.contactsField }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem"><ul>
										<li class="quCoItemUlLi">
											<div class="quFillblankItem">
											<c:choose>
												<c:when test="${en.answerInputRow > 1 }">
													<input type="text" style="width:${empty(en.answerInputWidth)?'300':en.answerInputWidth}px;padding:5px;display: none;" class="quFillblankAnswerInput" >
													<textarea rows="${en.answerInputRow }" style="width:${empty(en.answerInputWidth)?'300':en.answerInputWidth}px;"class="quFillblankAnswerTextarea" ></textarea>	
												</c:when>
												<c:otherwise>
													<input type="text" style="width:${empty(en.answerInputWidth)?'300':en.answerInputWidth}px;padding:5px;" class="quFillblankAnswerInput" >
													<textarea rows="${empty(en.answerInputRow)?'1':en.answerInputRow }" style="width:${empty(en.answerInputWidth)?'300':en.answerInputWidth}px;display: none;"class="quFillblankAnswerTextarea" ></textarea>	
												</c:otherwise>
											</c:choose>
												<div class="dwFbMenuBtn" ></div>
											</div>
										</li>
									</ul>
									</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<c:when test="${en.quType eq 'SCORE' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="SCORE">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								
								<input type="hidden" name="paramInt01" value="${en.paramInt01 }">
								<input type="hidden" name="paramInt02" value="${en.paramInt02 }">
								
								<input type="hidden" name="isSlider" value="${en.isSlider }">
								<input type="hidden" name="isScoreInput" value="${en.isScoreInput }">
								<input type="hidden" name="maxSliderLength" value="${en.maxSliderLength }">
								<input type="hidden" name="minSliderLength" value="${en.minSliderLength }">
								<input type="hidden" name="totalSliderLength" value="${en.totalSliderLength }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class=dwQuIcon></div></li><li class="questionDown"><div class=dwQuIcon></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem">
										<table class="quCoItemTable" cellpadding="0" cellspacing="0">
											<c:forEach items="${en.quScores }" var="item">
											<tr class="quScoreOptionTr">
												<td class="quCoItemTableTd quOptionEditTd">
													<label class="editAble quCoOptionEdit">${item.optionName }</label>
													<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1"></div>
												</td>
												<td class="quCoItemTableTd">
													<table class="scoreNumTable">
														<tr><c:forEach begin="1" end="${en.paramInt02 }" var="scoreNum"><td>${scoreNum }</td></c:forEach></tr>
													</table>
												</td>
												<td class="quCoItemTableTd">分</td>
											</tr>
											</c:forEach>
										</table>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<c:when test="${en.quType eq 'ORDERQU' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="ORDERQU">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
				
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li> 
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem">
										<div  class="quOrderByLeft">
										<ul>
										<c:forEach items="${en.quOrderbys }" var="item">
											<li class="quCoItemUlLi"><label class="editAble quCoOptionEdit">${item.optionName }</label>
											<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></li>
										</c:forEach>
										</ul>
										</div>
										<div class="quOrderByRight">
											<table class="quOrderByTable">
											<c:forEach items="${en.quOrderbys }" var="item" varStatus="itemVarStatus">
													<tr><td class="quOrderyTableTd">${itemVarStatus.count }</td><td></td></tr>
											</c:forEach>
											</table>
										</div>
										<div style="clear: both;"></div>
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<%-- 分页题 --%>
					<c:when test="${en.quType eq 'PAGETAG' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="PAGETAG">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools" >
										<ul class="surveyQuItemLeftToolsUl">
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools" style="margin-top: 0px;">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="pageBorderTop nohover"  ></div>
								<div class="surveyQuItemContent" style="min-height: 10px;text-align: right;">
									<div class="pageQuContent">下一页（1/2）</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<%--段落说明 --%>
					<c:when test="${en.quType eq 'PARAGRAPH' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="PARAGRAPH">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<!-- <li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li> -->
											<li title="复制" class="dwQuCopy_paragraph"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools" style="margin-top: 5px;">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class="dwQuIcon"></div></li><li class="questionDown"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent" style="min-height: 45px;">
									<div class="quCoTitle">
										<div class="quCoNum" style="display: none;">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<%--多项填空题 --%>
					<c:when test="${en.quType eq 'MULTIFILLBLANK' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="MULTIFILLBLANK">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">

								<input type="hidden" name="paramInt01" value="${en.paramInt01 }">
								<input type="hidden" name="paramInt02" value="${en.paramInt02 }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class=dwQuIcon></div></li><li class="questionDown"><div class=dwQuIcon></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									<div class="quCoItem">
										<table class="mFillblankTable" cellpadding="0" cellspacing="0">
										<c:forEach items="${en.quMultiFillblanks }" var="item">
										<tr class="mFillblankTableTr">
											<td align="right" class="mFillblankTableEditTd"><label class="editAble quCoOptionEdit">${item.optionName }</label>
											<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${item.id }"><input type="hidden" name="quItemSaveTag" value="1"></div>
										</tr>
										</c:forEach>
									</table>
									
									</div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
								</div>
								
							</div>
					</div>
					</c:when>
					
					<%-- 矩阵单选题 --%>
					<c:when test="${en.quType eq 'CHENRADIO' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENRADIO">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class=dwQuIcon></div></li><li class="questionDown"><div class=dwQuIcon></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									
									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">${columnItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${columnItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">${rowItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${rowItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
														<c:forEach items="${en.columns }" var="columnItem">
														<td><input type="radio"> </td>
														</c:forEach>
													</tr>
												</c:forEach>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
									
									
								</div>
								
							</div>
					</div>
					</c:when>
					
					<%--矩阵多选题 --%>
					<c:when test="${en.quType eq 'CHENCHECKBOX' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENCHECKBOX">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class=dwQuIcon></div></li><li class="questionDown"><div class=dwQuIcon></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									
									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">${columnItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${columnItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
													<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">${rowItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${rowItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
														<c:forEach items="${en.columns }" var="columnItem">
														<td><input type="checkbox"> </td>
														</c:forEach>
													</tr>
												</c:forEach>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
									
									
								</div>
								
							</div>
					</div>
					</c:when>
					
					<%-- 矩阵填空题 --%>
					<c:when test="${en.quType eq 'CHENFBK' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENFBK">
								<input type="hidden" name="quId" value="${en.id}">
								<input type="hidden" name="trWidthInfo" value="${en.trWidthInfo}">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class=dwQuIcon></div></li><li class="questionDown"><div class=dwQuIcon></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									
									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr><td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">${columnItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${columnItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">${rowItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${rowItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
														<c:forEach items="${en.columns }" var="columnItem">
														<td><input type="text"> </td>
														</c:forEach>
													</tr>
												</c:forEach>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
									
									
								</div>
								
							</div>
					</div>
					</c:when>
					
					
					<%-- 矩阵评分题 --%>
					<c:when test="${en.quType eq 'CHENSCORE' }">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" name="quType" value="CHENSCORE">
								<input type="hidden" name="quId" value="${en.id }">
								<input type="hidden" name="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" name="orderById" value="${en.orderById }"/>
								<input type="hidden" name="saveTag" value="1">
								<input type="hidden" name="hoverTag" value="0">
								<input type="hidden" name="isRequired" value="${en.isRequired }">
								<input type="hidden" name="hv" value="${en.hv }">
								<input type="hidden" name="randOrder" value="${en.randOrder }">
								<input type="hidden" name="cellCount" value="${en.cellCount }">
								<input type="hidden" name="maxSliderLength" value="${en.maxSliderLength }">
								<input type="hidden" name="minSliderLength" value="${en.minSliderLength }">
					
								<div class="quLogicInputCase">
									<input type="hidden" name="quLogicItemNum" value="${fn:length(en.questionLogics) }">
									<c:forEach items="${en.questionLogics }" var="quLogicEn" varStatus="logicSts">
									<div class="quLogicItem quLogicItem_${logicSts.count }">
										<input type="hidden" name="quLogicId" value="${quLogicEn.id }"/>
										<input type="hidden" name="cgQuItemId" value="${quLogicEn.cgQuItemId }"/>
										<input type="hidden" name="skQuId" value="${quLogicEn.skQuId }"/>
										<input type="hidden" name="ckQuItemId" value="${quLogicEn.ckQuItemId }"/>
										<input type="hidden" name="visibility" value="1">
										<input type="hidden" name="eqAndNq" value="${quLogicEn.eqAndNq }">
										<input type="hidden" name="logicSaveTag" value="1">
										
										
										<input type="hidden" name="geLe" value="${quLogicEn.geLe }">
										<input type="hidden" name="scoreNum" value="${quLogicEn.scoreNum }">
										<input type="hidden" name="logicType" value="${quLogicEn.logicType }">
									</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemLeftTools">
										<ul class="surveyQuItemLeftToolsUl">
											<li title="移动排序" class="dwQuMove"><div class="dwQuIcon"></div></li>
											<li title="设置" class="dwQuSet"><div class="dwQuIcon"></div></li>
											<li title="逻辑" class="dwQuLogic"><div class="dwQuIcon"><div class="quLogicInfo">${fn:length(en.questionLogics) > 0?fn:length(en.questionLogics) :'' }</div></div></li>
											<li title="逻辑复制" class="dwQuLogicCopy"><div class="dwQuIcon"></div></li>
											<li title="复制" class="dwQuCopy"><div class="dwQuIcon fa fa-files-o"></div></li>
											<li title="删除" class="dwQuDelete"><div class="dwQuIcon"></div></li>
										</ul>
								</div>
								
								<div class="surveyQuItemRightTools">
										<ul class="surveyQuItemRightToolsUl">
											<li class="questionUp"><div class=dwQuIcon></div></li><li class="questionDown"><div class=dwQuIcon></div></li>
										</ul>
								</div>
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit" >${en.quTitle}</div>
										<input type="hidden" name="quTitleSaveTag" value="1">
									</div>
									
									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
										<table class="quCoChenTable" >
												<tr>
												   <td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label class="editAble quCoOptionEdit">${columnItem.optionName}</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${columnItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
												<tr class="quChenRowTr"><td class="quChenRowTd"><label class="editAble quCoOptionEdit">${rowItem.optionName }</label>
														<div class="quItemInputCase"><input type="hidden" name="quItemId" value="${rowItem.id }"><input type="hidden" name="quItemSaveTag" value="1"></div></td>
														<c:forEach items="${en.columns }" var="columnItem">
														<td>评分</td>
														</c:forEach>
													</tr>
												</c:forEach>
										</table>
										</div>
										<div class="quCoRightTools">
										<ul class="quCoBottomToolsUl" >
											<li class="addColumnOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreColumnOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
										</div>
									</div>
									<div style="clear: both;"></div>
									<div class="quCoBottomTools" >
										<ul class="quCoBottomToolsUl" >
											<li class="addRowOption" title="添加"><div class="dwQuIcon"></div></li>
											<li class="addMoreRowOption" title="批量添加"><div class="dwQuIcon" ></div></li>
										</ul>
									</div>
									
									
								</div>
								
							</div>
					</div>
					</c:when>
					
				</c:choose>
				</li>
	</c:forEach>				
				
				<%-- 
				<li>
				<div id="defaultAppQuObj" class="surveyQuItemBody"  style="height: 100px;">
					<div class="initLine"></div>
					<input type="hidden" name="quType" value="NOQUESTION">
					<input type="hidden" name="orderById" value="0"/>
				</div>
				</li>
				--%>
				
			</ul>
				
		</div>
	</div>
</div>

<!-- 各种模板 -->
<!-- 单选选项模板 -->
<div id="quRadioItem" class="modelHtml">
	<input type="radio"><label class="editAble quCoOptionEdit"></label>
	<div class="quItemInputCase">
		<input type="hidden" name="quItemId" value="">
		<input type="hidden" name="quItemSaveTag" value="0">
		<input type="hidden" name="isNote" value="0">
		<input type="hidden" name="checkType" value="NO">
		<input type="hidden" name="isRequiredFill" value="0">
	</div>
</div>
<!-- 多选选项模板 -->
<div id="quCheckboxItem" class="modelHtml">
	<input type="checkbox"><label class="editAble quCoOptionEdit"></label>
	<div class="quItemInputCase">
		<input type="hidden" name="quItemId" value="">
		<input type="hidden" name="quItemSaveTag" value="0">
		<input type="hidden" name="isNote" value="0">
		<input type="hidden" name="checkType" value="NO">
		<input type="hidden" name="isRequiredFill" value="0">
		<input type="hidden" name="noCheckBox" value="0">
	</div>
</div>
<!-- 评分题选项模板 -->
<table class="modelHtml">
<tr id="quScoreItemModel" class="quScoreOptionTr">
	<td class="quCoItemTableTd quOptionEditTd">
		<label class="editAble quCoOptionEdit">评分项</label>
		<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
	</td>
	<td class="quCoItemTableTd"><table class="scoreNumTable"><tr><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td></tr></table></td>
	<td class="quCoItemTableTd">分</td>
</tr>
</table>
<!-- 排序题模板 -->
<div id="quOrderItemLeftModel" class="modelHtml">
	<label class="editAble quCoOptionEdit">&nbsp;</label>
	<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
</div>
<table class="modelHtml">
<tr id="quOrderItemRightModel"><td class="quOrderyTableTd">1</td><td></td></tr>
</table>
<%--多项填空题 --%>
<table class="modelHtml" >
		<tr id="mFillblankTableModel" >
			<td align="right" class="mFillblankTableEditTd">
			<label class="editAble quCoOptionEdit" >大一</label>
			<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
			</td>
			<td><input type="text" style="width:200px;padding:5px;"></td>
		</tr>
</table>

<table class="modelHtml" >
<tr id="quChenColumnModel">
	<td class="quChenColumnTd">
	<label class="editAble quCoOptionEdit">新项</label>
	<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
	</td>
</tr>
<tr id="quChenRowModel">
	<td class="quChenRowTd">
	<label class="editAble quCoOptionEdit">新项</label>
	<div class="quItemInputCase"><input type="hidden" name="quItemId" value=""><input type="hidden" name="quItemSaveTag" value="0"></div>
	</td>
</tr>
</table>

<!-- 逻辑值保存模板 -->
<div id="quLogicItemModel" class="modelHtml">
<div class="quLogicItem">
	<input type="hidden" name="quLogicId" value=""/>
	<input type="hidden" name="cgQuItemId" value="0"/>
	<input type="hidden" name="ckQuId" value="0"/>
	<input type="hidden" name="skQuId" value="0"/>
	<input type="hidden" name="ckQuItemId" value="0"/>
	<input type="hidden" name="visibility" value="0"/>
	<input type="hidden" name="logicSaveTag" value="0"/>
	
	
	<input type="hidden" name="geLe" value="le">
	<input type="hidden" name="scoreNum" value="2">
	<input type="hidden" name="eqAndNq" value="1">
	<input type="hidden" name="logicType" value="1">
</div>
</div>
<table id="setQuLogicItem" style="display: none;">
	<tr id="setQuLogicItemTrModel">
	    <td class="buttonSet"><input type="checkbox" class="selectQuitemLogic"></td>
		<td class="ifSpanText1">如果本题回答</td>
		<td><select name="option_id" class="logicQuOptionSel"></select></td>
		<td>则&nbsp;<select name="option_event" class="logicType"  style="width: 60px;"><option value="2">显示</option><option value="3">移除</option><option value="4">隐藏</option></select> </td>
		<td><select name="jump_to_qid" class="logicQuSel" ></select></td>
	</tr>
	
	<tr id="setQuLogicItemTrModel_forQu">
		<td>则&nbsp;<select name="option_event" class="logicType"  style="width: 60px;"><option value="2">显示</option><option value="3">移除</option><option value="4">隐藏</option></select> </td>
		<td><select name="jump_to_qid" class="logicQuSel" ></select></td>
	</tr>
	
	<tr id="setQuLogicItemTrModel_new">
	    <td class="buttonSet"><input type="checkbox" class="selectQuitemLogic"></td>
		<td class="ifSpanText1">如果本题回答</td>
		<td><select name="option_id" class="logicQuOptionSel"></select></td>
	</tr>
	<tr id="setQuLogicItemTrModel_score">
	        <td class="buttonSet"><input type="checkbox" class="selectQuitemLogic"></td>
	        <td class="ifSpanText1">如果选项</td>
			<td><select name="option_id" class="logicQuOptionSel" style="width: 120px;" ></select>
				评分&nbsp;<select name="logicScoreGtLt" class="logicScoreGtLt"  style="width: 80px;"><option value="le">小等于</option><option value="ge">大等于</option></select>
			<input name="logicScoreNum" class="logicScoreNum"  style="width: 40px;border: 1px #77a5b4 solid;padding: 2px;height: 32px;"/>&nbsp;分,</td>
			<td>则&nbsp;<select name="option_event" class="logicType"  style="width: 60px;"><option value="2">显示</option><option value="3">移除</option><option value="4">隐藏</option></select> </td>
			<td><select name="jump_to_qid" class="logicQuSel"  ></select></td> 
		</tr>
	<tr id="setQuLogicItemTrModel_score_new">
	        <td class="buttonSet"><input type="checkbox" class="selectQuitemLogic"></td>
	        <td class="ifSpanText1">如果选项</td>
			<td><select name="option_id" class="logicQuOptionSel" style="width: 120px;"></select>
				评分&nbsp;<select name="logicScoreGtLt" class="logicScoreGtLt"  style="width: 80px;"><option value="le">小等于</option><option value="ge">大等于</option></select>
			<input name="logicScoreNum" class="logicScoreNum"  style="width: 40px;border: 1px #77a5b4 solid;padding: 2px;height: 32px;"></select>&nbsp;分</td>
		</tr>	
</table>

<div id="dwCommonEditRoot"  >
	<div class="dwCommonEdit">
	<ul class="dwComEditMenuUl" >
		<li><a href="javascript:;" class="SeniorEdit"><i class="menu_edit2_icon"></i>高级编辑</a></li>
		<li class="option_Set_Li"><a href="javascript:;" class="option_Set"><i class="menu_edit4_icon"></i>选项设置</a></li>
		<!-- <li><a href="javascript:;" class="reference_Set" style="display: none;"><i class="menu_edit4_icon"></i>引用设置</a></li> -->
	</ul>
	<ul class="dwComEditOptionUl">
		<li class="dwOptionUp"><div class=dwQuIcon></div></li>
		<li class="dwOptionDown"><div class=dwQuIcon></div></li>
		<li class="dwOptionDel"><div class=dwQuIcon></div></li>
	</ul>
	<div class="dwComEditMenuBtn"></div>
	<div id="dwComEditContent" contenteditable="true" >请问你的年级是？</div>
	</div>
</div>

<div id="dialog" title="Basic dialog">
 <div id="editDialogCenter" class="editDialogCenter">
	<div id="dialogUeditor" ></div>
</div>
<div id="dialogUeBottom">
	<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogUeOk"/></div>
	</div>
</div>

<div id="dialogBatchOption" title="Basic dialog">
 <div id="editDialogCenterBatchOption" class="editDialogCenterBatchOption">
	<div id="dialogUeditorBatchOption" ></div>
</div>
<div id="dialogUeBottomBatch">
	<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogUeOkBatch" style="margin-right: 20px"/></div>
	</div>
</div>



<div id="dwCommonDialog">
	<form action="#" id="dwCommonDialogForm">
	<div class="dwCommonRefIcon"><div class="dwCommonRefIcon1"></div><div class="dwCommonRefIcon2"></div></div>
	<div class="dwCommonDialogBody">
		<div  class="dwCommonDialogTitle"><span id="dwComDialogTitleText">标题文本</span><span id="dwCommonDialogClose" class="closeDialog"></span></div>
		<div class="dwCommonDialogContent">
			<!-- 默认显示的LOAD -->
			<div class="dwQuDialogLoad dwQuDialogCon"><img alt="" src="${ctx }/images/load.gif"></div>
			
			<!-- 题目设置 -->
			<div class="dwQuSetCon dwQuFormSetDialog dwQuDialogCon" >
				<ul>
					<!-- <li><input type="checkbox" name="quChage"><label>切换为多选</label> </li> -->
					<li><label><input type="checkbox" name="setIsRequired"  >此题必答</label> </li>
					<li class="optionAutoOrder"><label><input type="checkbox" name="setRandOrder" >选择随机排列</label> </li>
					<li class="contactsAttrLi"><label><input type="checkbox" name="setAutoContacts" >关联到联系人属性</label> </li>
					<li class="isSelectType"><label><input type="checkbox" name="isSelectType"  >启用下拉样式</label> </li>
					<li class="contactsFieldLi"><label>用户填写的内容，会成为联系人的</label>
					<select class="contacts_range" name="setContactsField"  style="width:120px;">
					<option value="1">姓名</option>
					<option value="2">手机</option>
					<option value="3">地址</option>
					<option value="4">生日</option>
					<option value="5">Email</option>
					<option value="6">性别</option>
					<option value="7">公司</option>
					<option value="8">城市</option>
					<option value="9">婚姻</option>
					<option value="10">收入</option>
					</select>
					</li>
					<li class="optionRangeHv"><label>选项排放：</label>
					<select class="option_range" name="setHv"  style="width:120px;">
					<option value="2">竖排</option>
					<option value="1">横排</option>
					<option value="3">按列</option>
					<!-- <option value="4">下拉显示</option> -->
					</select>
					<span class="option_range_3" style="display:none;"><input type="number" name="setCellCount"  size="2" value="1" class="" max="4" min="1">&nbsp;列</span>
					</li>
				     <li class="minNumLi">最少选&nbsp;<input type="text" size="3" name="minNum">&nbsp;项 </li>
						<!--<li class="maxNumLi">最多选&nbsp;<input type="text" size="3" name="maxNum">&nbsp;项 </li> -->
					<li class="minMaxLi">
					<span class="minSpan"><label class="lgleftLabel">&nbsp;最低分</label>&nbsp;<input class="minNum" value="1"  type="text" size="2" >&nbsp; <label class="lgRightLabel">分</label></span>&nbsp;&nbsp;
					<span class="maxSpan"><label class="lgLeftLabel">最高分</label>&nbsp;<input class="maxNum"  value="5"  type="text" size="2" >&nbsp;<label class="lgRightLabel">分</label> </span>
					</li>
					<li class="scoreMinMax">&nbsp;&nbsp;<label>最高分</label>&nbsp;<select class="maxScore"  >
					<option value="1">1分</option>
					<option value="2">2分</option>
					<option value="3">3分</option>
					<option value="4">4分</option>
					<option value="5">5分</option>
					<option value="6">6分</option>
					<option value="7">7分</option>
					<option value="8">8分</option>
					<option value="9">9分</option>
					<option value="10">10分</option>
					</select>&nbsp; </li>
					
					<li class="isSilder" display:none><label><input type="checkbox" name="isSlider"  >启用滑块样式</label> </li>
					<li class="isScoreInput" display:none><label><input type="checkbox" name="isScoreInput"  >启用多重数值输入</label> </li>
					<li class="maxSilderLength" display:none><label>最大值&emsp;<input type="text" name="maxSliderLength" ></label> </li>
					<li class="minSilderLength" display:none><label>最小值&emsp;<input type="text" name="minSliderLength" ></label> </li>
					<li class="totalSilderLength" display:none><label>总&emsp;值&emsp;<input type="text" name="totalSliderLength" ></label> </li>
				</ul>
				<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogQuSetSave"/></div>
			</div>
			
			<!-- 逻辑设置 模板-->
	<!-- 		<div class="dwQuDialogLogic dwQuDialogCon" style="max-height:400px;overflow: auto;">
				<div class="dwQuDialogLogicTitle">逻辑设置</div>
				<table id="dwQuLogicTable">
				  
					<tr><td>如果本题选项选中</td>
						<td><select name="option_id" class="option_select" ><option>任意选项</option></select></td>
						<td>则跳转到</td>
						<td><select name="jump_to_qid" class="jump_qid_select" ><option value="">-请选择题目-</option><option value="1">正常结束（计入结果）</option><option value="2">提前结束（不计入结果）</option></select></td>
						<td><div class="dialogRemoveLogic"></div></td>
					</tr>
					<tr><td>如果选项</td>
						<td><select name="option_id" class="option_select" style="width: 120px;"><option>任意选项</option></select>
							评分&nbsp;<select name="option_id" class="option_select"  style="width: 60px;"><option>小于</option><option>大于</option></select>
						<select name="option_id" class="option_select"  style="width: 40px;"><option>2</option><option>3</option></select>&nbsp;分,</td>
						<td>则&nbsp;<select name="option_id" class="option_select"  style="width: 60px;"><option>显示</option><option>跳到</option></select> </td>
						<td><select name="jump_to_qid" class="jump_qid_select" ><option value="" style="width: 140px;">-请选择题目-</option><option value="1">正常结束（计入结果）</option><option value="2">提前结束（不计入结果）</option></select></td>
						<td><div class="dialogRemoveLogic"></div></td>
					</tr>
				</table>
				<div class="dwQuDialogBotEvent"><div class="dwQuDialogAddLogic"><div class="dwQuIcon"></div></div></div>
				<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogSaveLogic"/></div>
			</div> -->
			
			<!-- Ztree逻辑设计模板-->
			<div class="dwQuDialogLogic dwQuDialogCon" style="max-height:400px;overflow: auto;height:300px">
				<div class="dwQuDialogLogicTitle">
				逻辑设置   逻辑：<select name="option_event" class="logicType"  style="width: 60px;"><option value="2">显示</option><option value="3">移除</option><option value="4">隐藏</option></select>
				<select name="jump_to_qid" class="logicQuSel" ></select>
				</div>
				
				 <!--Ztree 初始化模板  -->
				
				<div class="dwQuDialogLogicZtree">
				 <ul id="logicTree" class="ztree" style="margin-top: 10px; width: 200px; height: 150px;"></ul>
				</div>
			
				
				<div class="dwQuDialogBotEvent"><div class="dwQuDialogAddLogic"><div class="dwQuIcon"></div></div></div>
				<div class="dwQuDialogBtnCon" style="position: absolute;right: 24px;bottom: 12px;"><input type="button" value="保存" class="quDialogBtn" id="dwDialogSaveLogic"/></div>
			</div>
			
			<!-- 批量添加，单选 -->
			<div class="dwQuAddMore dwQuDialogCon"  >
				<div class="dwQuTextSpan">每行一个选项</div>
				<textarea id="dwQuMoreTextarea"></textarea>
				<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogSaveMoreItem"/></div>
			</div>
			
			
			<!--逻辑复制div  -->
			<div class="dwQuLogicCopyCon dwQuDialogCon" style="width:200px;height:170px">
			  <div style="margin-top: 10px;" class="logicType_2">
			    &emsp;&emsp;&emsp;<span>复制题目逻辑&emsp;&emsp;</span>
			    &emsp;&emsp;&emsp;<select id="nextUtilBody" style="margin-top: 5px;"></select>
			  </div>
			  <div class="logicType_three" style="margin-top: 10px;display:none;">
			    &emsp;&emsp;&emsp;<span>选择移除选项：</span>&emsp;&emsp;&emsp;<select id="thisItemforHidden" style="margin-top: 5px;margin-left: 40px"></select>
			  </div>	 
			  <div class="dwQuDialogBtnCon" style="float:left;margin-top: 10px">&emsp;&emsp;&emsp;<input type="button" value="保存" class="quDialogBtn" id="dwDialogLogicSetSave"/></div>
			</div>
			
			
		</div>
	</div>
	</form>
</div>

<div id="modelUIDialog">
	
	

	<div id="modelUIDialogContent" >
	<!-- 填空题  填空数据类型设置  -->
			<div class="dwQuFillDataTypeOption dwQuFormSetDialog dwQuDialogCon" >
				<ul>
					<li><label>输入框宽：</label>
					<input type="text" name="qu_inputWidth" value="300"><span>&nbsp;字符</span>
					</li>
					<li><label>输入框高：</label>
					<input type="text" name="qu_inputRow" value="1"><span>&nbsp;行</span>
					</li>
					<li><label>数据类型：</label>
					<select class="option_range" name="quFill_checkType"  style="width:120px;">
					<option value="NO">无验证</option>
					<option value="EMAIL">Email</option>
					<!-- <option value="STRLEN">字符长度</option> -->
					<option value="UNSTRCN">禁止中文</option>
					<option value="STRCN">仅许中文</option>
					<option value="NUM">数值</option>
					<option value="TELENUM">电话号码</option>
					<option value="PHONENUM">手机号码</option>
					<option value="DATE">日期</option>
					<option value="IDENTCODE">身份证号</option>
					<option value="ZIPCODE">邮政编码</option>
					<option value="URL">网址</option>
					<!-- <option value="4">下拉显示</option> -->
					</select>
					<span class="option_range_3" style="display:none;">&nbsp;列</span>
					</li>
					<!-- <li>最少选&nbsp;<input type="text" size="3">&nbsp;项 </li>
					<li>最多选&nbsp;<input type="text" size="3">&nbsp;项 </li> -->
				</ul>
				<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogQuFillOptionSave"/></div>
			</div>
			
	<!-- 用户添加class -->
		<div class="dwSurveyAttrSetDialog_person dwQuFormSetDialog dwQuDialogCon" >
				<form id="input_form" action="" method="post" >
								<table class="ac-form-table" style="width: 650px">
								<thead>
								 <tr>
								 <th width="98"></th>
								 <th></th>
								</tr>
								</thead>
									<tr>
										<td width="98" align="right">用户ID值</td>
										<td class="ac-input-td"><input type="text" name="survey_userId" value="自动" readonly="readonly"  style="background: rgb(240, 240, 240);" ></td>
										<td></td>
									</tr>
									<tr>
										<td width="98" align="right">用户数量</td>
										<td width="400" class="ac-input-td"><input type="text" id="survey_user_count" name="survey_user_count" value="" onchange="hideItem('survey_user_count')"> </td>
										<td style="color:red;" width="200">*<span style="color: red;display: none;" class="check_survey_user_count">请填写用户数量</span></td>
									</tr>
									<tr>
										<td width="98" align="right">密码设置</td>
										<td class="ac-input-td">
											<input name="password_type" type="radio" value="1" onclick="handlePwdType('1')" checked/>不使用密码
											<input name="password_type" type="radio" value="2"  onclick="handlePwdType('2')"/>唯一密码
											<input name="password_type" type="radio" value="3"  onclick="handlePwdType('3')"/>随机密码
											<input name="password_type" type="radio" value="4"  onclick="handlePwdType('4')"/>指定密码
										</td>
									</tr>
									<tr id="password_content_input" style="display:none">
										<td width="98" align="right">密码</td>
										<td class="ac-input-td"><input type="text" name="password" value="" onchange="hideItem('password')"> </td>
										<td style="color:red;" >*<span style="color: red;display: none;" class="check_password_length">请填写密码</span></td>
									</tr>
									<tr id="password_length_input" style="display:none">
										<td width="98" align="right">密码长度</td>
										<td class="ac-input-td"><input type="text" name="password_length" value="" onchange="hideItem('password_length')"> </td>
										<td style="color:red;" >*<span style="color: red;display: none;" class="check_password_length">请填写密码长度</span></td>
									</tr>
									<tr>
										<td width="98" align="right">初始姓名</td>
										<td class="ac-input-td"><input type="text" name="survey_user_name" value="" onchange="hideItem('survey_user_name')"> </td>
										<td style="color:red;" >*<span style="color: red;display: none;" class="check_survey_user_name">请填写初始姓名</span></td>
									</tr>
									<tr>
										<td width="98" align="right">有效起始</td>
										<td class="ac-input-td" >
										  <input type="text" name="alarmstarttime" value="" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'logmin\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" id="logmin" class="form-control inline-block Wdate" style="height:43px;" onchange="hideItem('alarmstarttime')">
				                          
										</td>
										<td style="color:red;">*<span style="color: red;display: none;" class="check_alarmstarttime">请填写有效起始时间</span></td>
		
									</tr>
									<tr>
										<td width="98" align="right">有效终止</td>
										<td class="ac-input-td" >
				                          <input type="text" onchange="hideItem('alarmendtime')" name="alarmendtime" value="" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'logmin\')}',dateFmt:'yyyy-MM-dd HH:mm:ss'})" id="logmax" class="form-control inline-block Wdate" style="height:43px;">
										</td>
										<td style="color:red;"><span>*</span><span style="color: red;display: none;" class="check_alarmendtime">请填写有效终止时间</span></td>
									</tr>
						
									<tr>
										<td width="98" align="right" style="height:43px;">
										 <div class="dwQuDialogBtnCon" ><input type="button" value="保存用户" class="quDialogBtn" id="survey_user_save" onclick="saveSurveyUser()"/></div>
										 </td>

									</tr>
								</table>
				</form>	
			</div>
			<!-- 用户查看 -->
	<div class="surveyAttrViewPerson_Dialog dwQuFormSetDialog dwQuDialogCon" style="width: 100%;height: 100%;" id="surveyUserSelect" >
			<!--内容  -->	
			<div class="contacts_search" style="padding: 5px;color:#666565;" >
								<div style="padding-left: 20px;padding-top: 8px;padding-bottom: 8px;">
									<span style="font-size: 14px;vertical-align: middle;">用户姓名&nbsp;&nbsp;</span>
									<input type="text" class="inputS1" name="survey_user_name_2" value="">
									<input type="button" value="查询" class="sbtn25 sbtn25_1" style="font-size: 16px;" onclick="selectByName()"/>
									<input type="button" value="导入" class="sbtn25 sbtn25_1" style="font-size: 16px;" onclick="importUser()"/>
									<input type="button" value="导出" class="sbtn25 sbtn25_1" style="font-size: 16px;" onclick="exportUser()"/>
									<input type="button" value="批量删除" class="sbtn25 sbtn25_1 " style="font-size: 16px;" onclick="bactchDelete()"/>
									<input type="button" value="全部删除" class="sbtn25 sbtn25_1 " style="font-size: 16px;" onclick="deleteAll()"/>
									<input type="file" id="uploadCsv" style="display:none" name="file" onchange ="uploadFile()"/>
								</div>
								
		 </div>
           <div id="pageconent">
					<table class="contacts-table" width="100%" cellpadding="0" cellspacing="0" align="middle" >
									<thead>
									<tr>
										<th style="text-align: center;" width="30"><input type="checkbox" class="checkTotal"></th>
										<th align="left" width="215" >用户姓名</th>
										<th align="left" width="215">用户密码</th>
										<th align="left" width="250">有效起始</th>
										<th align="left" width="250">有效终止</th>
										<th align="left" width="130">状态</th>
										<th align="center"  style="padding-left: 10px;">操作</th>
									</tr>
									</thead>
									<tbody id="surveyusertable">
									    
									</tbody>
								</table>
				</div>
			<!--内容  -->	
</div>

	<div class="dwQuRadioCheckboxOption dwQuFormSetDialog dwQuDialogCon" >
				<ul>
					<li><label>选项设置</label></li>
					<li class="quOptionAddFill"><label><input type="checkbox" name="quOption_isNote" >选项后添加填空</label> </li>
					<li class="quOptionFillContentLi"><label style="padding-left:16px;">填空内容：</label>
					<select class="option_range" name="quOption_checkType"  style="width:120px;">
					<option value="NO">无限制</option>
					<option value="EMAIL">Email</option>
					<!-- <option value="STRLEN">字符长度</option> -->
					<option value="UNSTRCN">禁止中文</option>
					<option value="STRCN">仅许中文</option>
					<option value="NUM">数值</option>
					<option value="TELENUM">电话号码</option>
					<option value="PHONENUM">手机号码</option>
					<option value="DATE">日期</option>
					<option value="IDENTCODE">身份证号</option>
					<option value="ZIPCODE">邮政编码</option>
					<option value="URL">网址</option>
					<!-- <option value="4">下拉显示</option> -->
					</select>
					<span class="option_range_3" style="display:none;">&nbsp;列</span>
					</li>
					<li class="quOptionFillRequiredLi"><label style="padding-left:15px;"><input type="checkbox" name="quOption_isRequiredFill" checked="checked" >&nbsp;该空可不填</label>&nbsp;</li>
					<!-- <li>最多选&nbsp;<input type="text" size="3">&nbsp;项 </li> -->
				</ul>
				<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogQuOptionSetSave"/></div>
		</div>
		
		<div class="dwSurveyAttrSetDialog dwQuFormSetDialog dwQuDialogCon" >
			<div class="tabbarDialog_1" >
					<div class="p_DialogContent" >
						<input type="hidden" name="svyAttrSaveTag" value="1">
						<div class="p_DialogContentTitle">回答限制</div>
						<div class="p_DialogContentRoot">
								<div class="p_DialogContentItem"><label><input type="checkbox" name="effective" value="4"> 每台电脑或手机只能答一次</label></div>
								<div class="p_DialogContentItem"><label><input type="checkbox" name="effectiveIp" value="1"> 每个IP只能答一次</label></div>
								<div class="p_DialogContentItem"><label><input type="checkbox" name="rule" value="3"> 启用访问密码</label>
								&nbsp;&nbsp;&nbsp;设置密码：<input type="text" size="10"  name="ruleCode" class="inputSytle_1">
								</div>
								<div class="p_DialogContentItem"><label><input type="checkbox" name="refresh" value="1"> 有重复回答启用验证码</label></div>
								<div class="p_DialogContentItem" style="display: none;"><label><input type="checkbox" name="mailOnly" value="1"> 只有邮件邀请唯一链接的受访者可回答</label></div>
						</div>
					</div>
					<div class="p_DialogContent" >
						<div class="p_DialogContentTitle">何时结束</div>
						<div class="p_DialogContentRoot">
								<div class="p_DialogContentItem"><label><input type="checkbox" name="ynEndNum" value="1"> 收集到&nbsp;<input type="text" size="12"  class="inputSytle_1" name="endNum">&nbsp;份答卷时结束</label></div>
								<div class="p_DialogContentItem"><label><input type="checkbox" name="ynEndTime" value="1"> 到&nbsp;<input type="text" size="20"  class="inputSytle_1 Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" name="endTime">&nbsp;时结束 </label></div>
						</div>
					</div>

				</div>
				<div class="dwQuDialogBtnCon" ><input type="button" value="保存" class="quDialogBtn" id="dwDialogSurveyAttrSave"/></div>
		</div>






		
		</div>
</div>

<!-- 
设置填空题选项
<div id="dwCommonInputMenuRoot"  >
	<div class="dwCommonInputMenu">
	<ul class="dwComEditMenuUl" >
		<li><a href="javascript:;" class="SeniorEdit"><i class="menu_edit2_icon"></i>高级编辑</a></li>
		<li><a href="javascript:;" class="reference_Set"><i class="menu_edit4_icon"></i>引用设置</a></li>
	</ul>
	<div class="dwComEditMenuBtn"></div>
	</div>
</div> -->

<%-- 
	逻辑题临时
		<c:choose>
			<c:when test="${empty en.questionLogics }">
			<div class="quLogicData">
				<div class="dwQuIcon"></div>
				<div class="quLogicInfo">1</div>
			</div>
			</c:when>
			<c:otherwise>
			<div class="quLogicData" style="display: inline;">
				<div class="dwQuIcon"></div>
				<div class="quLogicInfo">1</div>
			</div>
			</c:otherwise>
		</c:choose> 
		--%>
	
<script type="text/javascript">
	<!-- 初始化属性 -->
	//alert("${survey.surveyDetail.effectiveIp}");
	if("${survey.surveyDetail.effective}">1){
		$("input[name='effective']").attr("checked",true);	
	}else{
		$("input[name='effective']").attr("checked",false);
	}
	
	$("input[name='effectiveIp'][value='${survey.surveyDetail.effectiveIp}']").attr("checked",true);
	$("input[name='rule'][value='${survey.surveyDetail.rule}']").attr("checked",true);
	$("input[name='ruleCode']").val("${survey.surveyDetail.ruleCode}");
	$("input[name='refresh'][value='${survey.surveyDetail.refresh}']").attr("checked",true);
	$("input[name='mailOnly'][value='${survey.surveyDetail.mailOnly}']").attr("checked",true);
	$("input[name='ynEndNum'][value='${survey.surveyDetail.ynEndNum}']").attr("checked",true);
	$("input[name='endNum']").val("${survey.surveyDetail.endNum}");
	$("input[name='ynEndTime'][value='${survey.surveyDetail.ynEndTime}']").attr("checked",true);
	$("input[name='endTime']").val("${survey.surveyDetail.endTime}");
	//做日期格式化
	var endTimeval=$("input[name='endTime']").val();
	var endTimeRexp=/^\d{4}-(?:0\d|1[0-2])-(?:[0-2]\d|3[01])( (?:[01]\d|2[0-3])\:[0-5]\d\:[0-5]\d)?$/;
	if(!endTimeRexp.test(endTimeval)){
		endTimeval=endTimeval.substring(0,endTimeval.length-2);
		$("input[name='endTime']").val(endTimeval);
	}
	$("input[name='showShareSurvey'][value='${survey.surveyDetail.showShareSurvey}']").attr("checked",true);
	$("input[name='showAnswerDa'][value='${survey.surveyDetail.showAnswerDa}']").attr("checked",true);
	
	//复制逻辑
</script>
<%@ include file="/WEB-INF/page/layouts/other.jsp"%>

<div style="text-align: center;">
<div class="dw_foot" style="padding-bottom: 30px;">
	<div class="footer-copyright" style="color: gray;padding-top: 0px;font-size: 16px;">
		Powered by <a href="#" target="_blank" style="text-decoration: none;color: gray;">Auxing</a>&nbsp;&nbsp;&nbsp;
		Copyright © 2012-2017
		<a href="#" target="_blank" style="text-decoration: none;color: rgb(53, 117, 136);">苏州奥科星</a>
	</div>
</div>
</div>
</body>
</html>