<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx }/js/plugs/jquery-ui-1.10.3.custom/css/mycss/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css" />
<!-- 新 Bootstrap 核心 CSS 文件 -->
<!-- <link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css"> -->
<link rel="stylesheet" href="${ctx }/js/plugs/bootstrap-3.3.0-dist/dist/css/bootstrap.css">
<!-- 可选的Bootstrap主题文件（一般不用引入） -->
<!-- <link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap-theme.min.css"> -->
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<!-- <script src="http://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script> -->
<script src="${ctx }/js/plugs/bootstrap-3.3.0-dist/dist/js/bootstrap.js"></script>
<!-- <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet"> -->
<link href="${ctx }/js/plugs/font-awesome-4.2.0/css/font-awesome.css" rel="stylesheet">

<title>我的问卷</title>
<style type="text/css">
.surveyLeftBtnGroup a{
	color: #5A9ECD;
}
.btn-group{
	/* border: 1px solid #D1D1D1; */
}
.btn-group a{
	/* border-radius: 0px; */
	/* border-color: white; */
}
.btn-group a:hover{
	background: #317BCF;
	color: white;
	border-color: #317BCF;
}
.btn-group>.btn:not(:first-child) {
	margin-left: -1px;
}
.contacts-table tr td{
	font-size: 16px! important;
}
.dialogBtn1{
	border:none;
	font-size: 1em;
	font-weight:bold;
  	cursor: pointer;
  	padding: 8px 10px;
}
.dialogBtn1 .ui-button-text {
    padding: .4em 1em;
    display: block;
    line-height: normal;
}
.dialogBtn1Cencel{
	background: none;
}
.dialogBtn1Cencel:hover{
	background: #f6f6f6;
}
button {
	outline: none;
}

.dialogMessage select, .dialogMessage input {
    padding: 5px;
    color: #333333;
    border: 1px solid #98C5C3;
}
.exportFile{
    text-decoration: none;
    position: relative;
    cursor: pointer;
}
.exportFile input {
    outline:none;
    opacity: 0;
    display: inline-block;
    width:50px;
    position: absolute;
    left:0px;
    cursor: pointer;
    font-size:0;
    height: 20px;
}
</style>
</head>
<body>
	<input type="hidden" id="id" name="id" value="${survey.id }">
	<input type="hidden" id="ctxpath" name="ctxpath" value="${ctx}">
	<div style="clear: both;"></div>
	<div id="dwBody" style="margin-top: 15px;">
		<div id="dwBodyContent" class="bodyCenter" style="">
		<div id="dwBodyUser">
			<div class="surveyCollectMiddle">
				<div class="surveyCollectMiddleContent">
					<div style="padding: 25px 45px;overflow: auto;padding-top: 20px;">
							<div style="padding: 5px;color: #666565;letter-spacing: 2px;">
							所有问卷&nbsp;&nbsp;|&nbsp;&nbsp;
								<a href="${ctx }/design/my-survey-create!save.action" id="surveyAdd-a" style="outline: none;text-decoration: none;" ><i class="fa fa-plus " aria-hidden="true"></i>&nbsp;新建问卷</a>
								&nbsp;&nbsp;
								<a href="javascript:;" class="exportFile" style="outline: none;text-decoration: none;cursor:pointer"><i class="fa fa-upload" id="exportI"></i><span>&nbsp;上传问卷</span><input type="file" name="surveyfile" id="surveyfile" ></a>
								<input type="button" id="submitButton" value="确定上传" class="sbtn25 sbtn25_1"/>
								<input type="button" id="importButton" style="width: 156px;background-image: none;background-color: #599fd1;" value="导入问卷（无逻辑）" class="sbtn25 sbtn25_1"/>
							</div>

							<form action="${ctx}/design/my-survey.action" method="post" >
							<div class="contacts_search" style="padding: 5px;color:#666565;" >
								<div style="padding-left: 20px;padding-top: 8px;padding-bottom: 8px;">
									<span style="font-size: 14px;vertical-align: middle;">状态&nbsp;</span>
									<select name="surveyState" style="vertical-align: middle;">  <option value="">不限</option><option value="0">设计</option><option value="1">收集</option><option value="2">结束</option> </select>
									&nbsp;&nbsp;
									<span style="font-size: 14px;vertical-align: middle;">名称&nbsp;</span>
									<input type="text" class="inputS1" name="surveyName" value="${surveyName}">
									<input type="submit" value="查询" class="sbtn25 sbtn25_1" style="font-size: 16px;"/>
								</div>
								
							</div>
							</form>
							
							<div style="margin-top: 15px;">
							<!-- <div style="padding: 5px;color: #666565;text-align: right;">
								<a href="" class="export-contacts active"><span>&nbsp;</span>导出联系人</a>
							</div> -->
							<div style="padding: 5px;color:#666565; ">
								<table class="contacts-table" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<th style="text-align: center;" width="30"><!-- <input type="checkbox">  --></th>
										<th align="center" >问卷</th>
										<th align="center" >创建者</th>
										<th align="center" >创建时间</th>
										<th align="center" >答卷</th>
										<th align="center" width="80">状态</th>
										<th align="center" width="350" style="padding-left: 10px;">操作</th>
									</tr>
									<c:choose>
									<c:when test="${page.totalItems > 0}">
									<c:forEach items="${page.result }" var="en">
									<tr>
										<td align="center">
											<input type="hidden" name='surveyId' value="${en.id }">
										</td>
										<td align="center"><a target="_blank" href="${ctx }/wenjuan/${en.sid }.html" class="titleTag">${en.surveyName }</a></td>
										<td align="center" width="100" >${en.userName }</td>
										<td align="center">
											<fmt:formatDate value="${en.createDate }" pattern="yyyy年MM月dd日 HH:mm"/>
										</td>
										<td align="center">${empty(en.answerNum) ? '0':en.answerNum  }&nbsp;</td>
										<td align="center" >
											${en.surveyState eq 0 ? '设计':en.surveyState eq 1?'收集':en.surveyState eq 2?'收集完成':'暂停发布' }
										</td>
										<td align="center">
											<div class="btn-group surveyLeftBtnGroup">
											  <a class="btn btn-default designSurvey" href="${ctx }/design/my-survey-design.action?surveyId=${en.id}" title="设计"data-toggle="tooltip" data-placement="top" ><i class="fa fa-pencil-square-o"></i></a>
											  <a class="btn btn-default" href="${ctx }/design/my-collect.action?surveyId=${en.id}" title="收集答卷" data-toggle="tooltip" data-placement="top" ><i class="fa fa-comments-o"></i></a>
											  <a class="btn btn-default" href="${ctx }/da/survey-report!defaultReport.action?surveyId=${en.id}" title="分析报告" data-toggle="tooltip" data-placement="top" ><i class="fa fa-line-chart"></i></a>
											  <a class="btn btn-default copySurvey" href="#${en.id}" title="复制一份" data-toggle="tooltip" data-placement="top" ><i class="fa fa-files-o"></i></a>
											  <a class="btn btn-default deleteSurvey" href="${ctx}/design/my-survey!delete.action?id=${en.id}" title="删除问卷" data-toggle="tooltip" data-placement="top" ><i class="fa fa-trash-o fa-fw"></i></a>
											  <a class="btn btn-default copytofileSurvey" href="${ctx}/design/my-survey!exportsurvey.action?id=${en.id}" title="导出问卷" data-toggle="tooltip" data-placement="top" ><i class="fa fa-download"></i></a>
												<a class="btn btn-default unlockSurvey"  onclick="unlockSurvey()" sid = "${en.id}" title="开放问卷" data-toggle="tooltip" data-placement="top" ><i class="fa fa-unlock"></i></a>

												<c:choose>
												  <c:when test="${en.surveyState == 1}">
													  <a class="btn btn-default pauseSurvey"  href="${ctx}/design/my-survey!surveyState.action" title="暂停发布" data-toggle="tooltip" data-placement="top" ><i class="fa fa-pause"></i></a>
												  </c:when>
												  <c:when test="${en.surveyState == 3}">
													  <a class="btn btn-default reopenSurvey" href="${ctx}/design/my-survey!surveyState.action" title="重新发布" data-toggle="tooltip" data-placement="top" ><i class="fa fa-play"></i></a>
												  </c:when>
												  <c:otherwise>
													  <a class="btn btn-default pauseSurvey" style="pointer-events: none;opacity: 0.5"href="${ctx}/design/my-survey!surveyState.action" title="暂停发布" data-toggle="tooltip" data-placement="top" ><i class="fa fa-pause"></i></a>
												  </c:otherwise>
											  </c:choose>
											</div>&nbsp;
											<div class="btn-group" style="display: none;">
												<!-- <a class="btn btn-default" href="#"><i class="fa fa-eye"></i></a> -->
											    <a class="btn btn-default" href="#"><i class="fa fa-trash-o fa-fw"></i></a>
											</div>
										</td>
									</tr>
									</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="7">

												<div style="padding: 60px;font-size: 22px;text-align: center;color: #b1aeae;">还没有数据！</div>

											</td>
										</tr>
									</c:otherwise>
									</c:choose>
								</table>
								<div style="padding-top: 15px;text-align: center;">
									<div class="btn-group">
										<c:if test="${page.pageNo > 1}">
											<a href="javascript:jumpPage(${page.pageNo-1})" class="btn btn-default">&lt;</a>
										</c:if>
										<c:if test="${page.startpage > 1}">
											<a href="javascript:jumpPage(1)" class="btn btn-default">1</a>
											<c:if test="${page.startpage > 2 }">
												<a class="btn btn-default"><span>...</span></a>
											</c:if>
										</c:if>
										<c:forEach begin="${page.startpage }" end="${page.endpage }" var="en">
											<c:choose>
											  
												<c:when test="${page.pageNo eq en }"><a href="javascript:jumpPage(${en})" class="btn btn-default" style="background: #D3DEED;">${en }</a></c:when>
												<c:otherwise><a href="javascript:jumpPage(${en})" class="btn btn-default">${en }</a></c:otherwise>
											</c:choose>
										</c:forEach>
										<c:if test="${page.totalPage > (page.endpage)}">
											<c:if test="${page.totalPage > (page.endpage+1)}">
												<a class="btn btn-default"><span>...</span></a>
											</c:if>
											
											<a href="javascript:jumpPage(${page.totalPage})" class="btn btn-default">${page.totalPage }</a>
										</c:if>
										<c:if test="${page.totalPage > page.pageNo}">
						
											<a href="javascript:jumpPage(${page.pageNo+1})" class="btn btn-default">&gt;</a>
										</c:if>
										
									</div>
								</div>
							</div>
							</div>
					</div>
					
				</div>
			</div>
			
		</div>
		</div>
	</div>
	
	<%--批量添加 --%>


<script type="text/javascript">

	currentMenu("mysurvey");

	$("select[name='surveyState']").val("${surveyState}");

var options={
		animation:true,
		delay:100,
		container:"body",
		trigger:'hover' //触发tooltip的事件
	};
$('a[data-toggle=tooltip]').tooltip(options);


//权限控制
	$.ajax({
		url:'${ctx }/sy/user/user-admin!getCurrentUserPermission.action',
		type:"get",
		success:function(msg){
			let permissionInfo = JSON.parse(msg);
			switch(permissionInfo.roleId){
				case 2:
					$(".deleteSurvey").hide();
					break;
				case 3:
					$(".deleteSurvey").hide();
					$(".pauseSurvey").hide();
					break;
				case 4:
					$(".deleteSurvey").hide();
					$(".pauseSurvey").hide();
					$(".copytofileSurvey").hide();
					break;
				case 5:
					$(".designSurvey").hide();
					$(".deleteSurvey").hide();
					$(".pauseSurvey").hide();
					$(".copytofileSurvey").hide();
					$("#surveyAdd-a").hide();
					break;

			}
		}
	});

// 切换问卷开放状态
	$(".unlockSurvey").each(function(){
		var sid = $(this).attr('sid');
		var node = $(this);
		$.ajax({
			url:'${ctx }/design/my-survey-design!isOpen.action?surveyId=' + sid,
			type:"get",
			success:function(msg){
				if(msg === 'true') {
					node.css('pointer-events', 'none');
					node.css('opacity', 0.5);
				}
			}
		});
	});


    $(".unlockSurvey").click(function(){
        var sid = $(this).attr('sid');
        $.ajax({
            url:'${ctx}/design/my-survey-design!open.action?surveyId=' + sid,
            type:"get",
            success:function(msg){
                if(msg === 'success') {
                    window.location.reload();
                }else{
                    window.alert(msg);
                }
            }
        });
    });

//delete
$(".deleteSurvey").click(function(){
	if(confirm("确认删除吗？")){
		var th=$(this);
		var url=$(this).attr("href");
		var data="";
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg==="true"){
					th.parents("tr").hide("slow");
					th.parents("tr").remove();
				}else{
					alert("删除失败，未登录或没有权限！");
				}
			}
		});
	}
	return false;
});

$(".pauseSurvey").click(function(){
	if(confirm("暂停发布后，用户将不能提交问卷，确认暂停发布该问卷吗？")){
		var th=$(this);
		var url=$(this).attr("href");
		var surveyId=$(this).parents("tr").find("input[name='surveyId']").val();
		var data="id="+surveyId+"&surveyState=3";
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg==="true"){
					window.location.reload();
				}else{
					alert("暂停发布失败，未登录或没有权限！");
				}
			}
		});
	}
	return false;
});
$(".reopenSurvey").click(function(){
	if(confirm("确认重新发布该问卷吗？")){
		var th=$(this);
		var url=$(this).attr("href");
		var surveyId=$(this).parents("tr").find("input[name='surveyId']").val();
		var data="id="+surveyId+"&surveyState=1";
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg==="true"){
					window.location.reload();
				}else{
					alert("重新发布失败，未登录或没有权限！");
				}
			}
		});
	}
	return false;
});

$("#importButton").click(function(){
	var ctxpath=$("#ctxpath").val();
	var url="${ctx}/design/my-survey!tonewSurvey.action";
	var filename=$("#surveyfile").val().replace('C:\\fakepath\\',"");
	if(filename==""){
		alert("请选择导入文件");
		return false;
	}
	$.ajax({
		url:url,
		type:"get",
		datatype:"json",
		data:{"filename":filename},
		success:function(result){

			if(result != "error"){
				tonewSurveyWithoutLogic(result);
				$("#exportI").attr({"class":"fa fa-upload"});
				$("#surveyfile").val("");
			}else{
				alert("上传文件有误");
			}


		}

	})
})
	function  tonewSurveyWithoutLogic(surveyId){

		var titleValue="导入问卷";

		$("body").append("<div id=\"myDialogRoot\"><div class='dialogMessage' style='padding-top:40px;margin-left:20px;padding-bottom:0px;'>"+
				"<div>导入标题：<input id='surTitleTemp' type='text' style='padding:3px;width:320px;color:rgb(14, 136, 158);' value=''></div></div></div>");

		var myDialog=$( "#myDialogRoot" ).dialog({
			width:500,
			height:220,
			autoOpen: true,
			modal:true,
			position:["center","center"],
			title:"导入问卷、表单",
			resizable:false,
			draggable:false,
			closeOnEscape:false,
			show: {effect:"blind",direction:"up",duration: 500},
			hide: {effect:"blind",direction:"left",duration: 200},
			buttons: {
				"OK":{
					text: "确认导入",
					addClass:'dialogMessageButton dialogBtn1',
					click: function() {
						//执行发布
						var surveyName=$("#surTitleTemp").val();
						var surveyNameReal = $("#surTitleTemp").val();
						surveyName=optionValue=escape(encodeURIComponent(surveyName));

						var params="surveyName="+surveyName;
						params+="&fromBankId="+surveyId;

						var url="${ctx}/design/my-survey-create!checkSurveyName.action";
						if(surveyName == "" || surveyName == undefined){
							alert("问卷标题不能为空");
							return false;
						}

						if(surveyNameReal.replace(/[\u4e00-\u9fa5]/g,"a").length > 80){
							alert("问卷标题字符过长");
							return false;
						}
						//验证标题的不可重复
						$.ajax({
							url:url,
							type:"post",
							datatype:"json",
							data:{"surveyName":surveyNameReal},
							success:function(msg){
								if(msg == "1"){
									window.location.href="${ctx}/design/my-survey-design!copySurveyWithoutLogic.action?"+params;
								}else{
									alert("该问卷标题已存在");
									return false;
								}
							}
						})

					}

				},
				"CENCEL":{
					text: "取消",
					addClass:"dialogBtn1 dialogBtn1Cencel",
					click: function() {
						$( this ).dialog( "close" );
					}
				}
			},
			open:function(event,ui){
				$(".ui-dialog-titlebar-close").hide();
				$("#surTitleTemp").val(titleValue+"－副本");
			},
			close:function(event,ui){
				$("#myDialogRoot").remove();
			}
		});
	}

$(".copySurvey").click(function(){

	var surveyId=$(this).parents("tr").find("input[name='surveyId']").val();
	var titleValue=$(this).parents("tr").find(".titleTag").text();
	var model_groupId1=$(this).parents("tr").find("input[name='groupId1']").val();
	var model_groupId2=$(this).parents("tr").find("input[name='groupId2']").val();

	$("body").append("<div id=\"myDialogRoot\"><div class='dialogMessage' style='padding-top:40px;margin-left:20px;padding-bottom:0px;'>"+
			"<div>复制标题：<input id='surTitleTemp' type='text' style='padding:3px;width:320px;color:rgb(14, 136, 158);' value=''></div></div></div>");

	var myDialog=$( "#myDialogRoot" ).dialog({
		width:500,
		height:220,
		autoOpen: true,
		modal:true,
		position:["center","center"],
		title:"复制问卷、表单",
		resizable:false,
		draggable:false,
		closeOnEscape:false,
		show: {effect:"blind",direction:"up",duration: 500},
		hide: {effect:"blind",direction:"left",duration: 200},
		buttons: {
			"OK":{
				text: "确认复制",
				addClass:'dialogMessageButton dialogBtn1',
				click: function() {
					//执行发布
					var surveyName=$("#surTitleTemp").val();
					var surveyNameReal=$("#surTitleTemp").val();
					surveyName=optionValue=escape(encodeURIComponent(surveyName));

					var params="surveyName="+surveyName;
					params+="&fromBankId="+surveyId;
					
					//判断问卷标题不为空而且长度不能过长
				   if(surveyName == "" || surveyName == undefined){
	                	alert("问卷标题不能为空");
	                	return false;
	                }
	             
	                if(surveyNameReal.replace(/[\u4e00-\u9fa5]/g,"a").length > 80){
	                	alert("问卷标题字符过长");
	                	return false;
	                }
				
					
					window.location.href="${ctx}/design/my-survey-design!copySurvey.action?"+params;
				}
			},
			"CENCEL":{
				text: "取消",
				addClass:"dialogBtn1 dialogBtn1Cencel",
				click: function() {
					$( this ).dialog( "close" );
				}
			}
		},
		open:function(event,ui){
			$(".ui-dialog-titlebar-close").hide();
			$("#surTitleTemp").val(titleValue+"－副本");
		},
		close:function(event,ui){
			$("#myDialogRoot").remove();
		}
	});
});

$("#surveyAdd-a").click(function(){
	
	var surveyId=$(this).parents("tr").find("input[name='surveyId']").val();
	var titleValue=$(this).parents("tr").find(".titleTag").text();
	

	
	$("body").append("<div id=\"myDialogRoot\"><div class='dialogMessage' style='padding-top:40px;margin-left:20px;padding-bottom:0px;'>"+
			"<div>问卷标题：<input id='surTitleTemp' type='text' style='padding:5px;width:320px;color:rgb(14, 136, 158);' value=''></div></div></div>");

	var myDialog=$( "#myDialogRoot" ).dialog({
		width:500,
		height:220,
		autoOpen: true,
		modal:true,
		position:["center","center"],
		title:"新建问卷、表单",
		resizable:false,
		draggable:false,
		closeOnEscape:false,
		show: {effect:"blind",direction:"up",duration: 500},
		hide: {effect:"blind",direction:"left",duration: 200},
		buttons: {
			"OK":{
	            text: "确认新建",
	            addClass:'dialogMessageButton dialogBtn1',
	            click: function() {
	                //执行发布
	                var surveyName=$("#surTitleTemp").val();
	                var surveyNameReal = $("#surTitleTemp").val();
	                surveyName=optionValue=escape(encodeURIComponent(surveyName));
	                var params="surveyName="+surveyName;
	                var url="${ctx}/design/my-survey-create!checkSurveyName.action";
	                
	                if(surveyName == "" || surveyName == undefined){
	                	alert("问卷标题不能为空");
	                	return false;
	                }
	             
	                if(surveyNameReal.replace(/[\u4e00-\u9fa5]/g,"a").length > 80){
	                	alert("问卷标题字符过长");
	                	return false;
	                }
	                //验证标题的不可重复
	               $.ajaxSettings.async = false;
	               $.ajax({
	                	url:url,
	                	type:"post",
	                	datatype:"json",
	                	data:{"surveyName":surveyNameReal},
	                	success:function(msg){
	                		if(msg == "1"){
	                			window.location.href="${ctx}/design/my-survey-create!save.action?"+params;
	                		}else{
	                			alert("该问卷标题已存在");
	                			return false;
	                		}
	                	}
	                })
	                
	            }
			},
			"CENCEL":{
	            text: "取消",
	            addClass:"dialogBtn1 dialogBtn1Cencel",
	            click: function() {
	              $( this ).dialog( "close" );
	            }
			}
		},
		open:function(event,ui){
			$(".ui-dialog-titlebar-close").hide();
			$("#surTitleTemp").val(titleValue+"");
		},
		close:function(event,ui){
			$("#myDialogRoot").remove();
		}
	});
	return false;
});


function setSelectText(el) {
    try {
        window.getSelection().selectAllChildren(el[0]); //全选
        window.getSelection().collapseToEnd(el[0]); //光标置后
    } catch (err) {
        //在此处理错误
    }
}
$("#surveyfile").change(function(){
	$("#exportI").attr({"class":"fa fa-spinner fa-spin"});
	var timer=setTimeout(function(){$("#exportI").attr({"class":"fa fa-check"});},1000);
})
$("#submitButton").click(function(){
	var ctxpath=$("#ctxpath").val();
	var url="${ctx}/design/my-survey!tonewSurvey.action";
	var filename=$("#surveyfile").val().replace('C:\\fakepath\\',"");
	if(filename==""){
		alert("请选择导入文件");
		return false;
	}
	 $.ajax({
		url:url,
		type:"get",
		datatype:"json",
		data:{"filename":filename},
		success:function(result){
			
			if(result != "error"){
				tonewSurvey(result);
				$("#exportI").attr({"class":"fa fa-upload"});
				$("#surveyfile").val("");
			}else{
				alert("上传文件有误");
			}
		
			
		}
		
	})
})

function  tonewSurvey(surveyId){

	var titleValue="复制问卷";

	$("body").append("<div id=\"myDialogRoot\"><div class='dialogMessage' style='padding-top:40px;margin-left:20px;padding-bottom:0px;'>"+
			"<div>复制标题：<input id='surTitleTemp' type='text' style='padding:3px;width:320px;color:rgb(14, 136, 158);' value=''></div></div></div>");

	var myDialog=$( "#myDialogRoot" ).dialog({
		width:500,
		height:220,
		autoOpen: true,
		modal:true,
		position:["center","center"],
		title:"复制问卷、表单",
		resizable:false,
		draggable:false,
		closeOnEscape:false,
		show: {effect:"blind",direction:"up",duration: 500},
		hide: {effect:"blind",direction:"left",duration: 200},
		buttons: {
			"OK":{
				text: "确认复制",
				addClass:'dialogMessageButton dialogBtn1',
				click: function() {
					//执行发布
					var surveyName=$("#surTitleTemp").val();
					var surveyNameReal = $("#surTitleTemp").val();
					surveyName=optionValue=escape(encodeURIComponent(surveyName));

					var params="surveyName="+surveyName;
					params+="&fromBankId="+surveyId;
					
					 var url="${ctx}/design/my-survey-create!checkSurveyName.action";
					   if(surveyName == "" || surveyName == undefined){
		                	alert("问卷标题不能为空");
		                	return false;
		                }
		             
		                if(surveyNameReal.replace(/[\u4e00-\u9fa5]/g,"a").length > 80){
		                	alert("问卷标题字符过长");
		                	return false;
		                }
		                //验证标题的不可重复
			               $.ajax({
			                	url:url,
			                	type:"post",
			                	datatype:"json",
			                	data:{"surveyName":surveyNameReal},
			                	success:function(msg){
			                		if(msg == "1"){
			                			window.location.href="${ctx}/design/my-survey-design!copySurvey.action?"+params;
			                		}else{
			                			alert("该问卷标题已存在");
			                			return false;
			                		}
			                	}
			                })
			                
						}  
	        
			},
			"CENCEL":{
				text: "取消",
				addClass:"dialogBtn1 dialogBtn1Cencel",
				click: function() {
					$( this ).dialog( "close" );
				}
			}
		},
		open:function(event,ui){
			$(".ui-dialog-titlebar-close").hide();
			$("#surTitleTemp").val(titleValue+"－副本");
		},
		close:function(event,ui){
			$("#myDialogRoot").remove();
		}
	});
}

//解决问卷页面状态带不过来的问题
  function  jumpPage(pageNo){
	//${ctx }/design/my-survey.action?page.pageNo=${page.pageNo+1}
    var surveyState=$("select[name='surveyState']").val();
    var surveyName=$("input[name='surveyName']").val();
    window.location.href="${ctx }/design/my-survey.action?page.pageNo="+pageNo+"&surveyState="+surveyState+"&surveyName="+surveyName;
}

  $("select[name='surveyState']").val("${surveyState}");


</script>
</body>
</html>