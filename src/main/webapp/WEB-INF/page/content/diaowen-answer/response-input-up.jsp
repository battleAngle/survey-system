<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
<title>${surveyName}</title>
<link href="${ctx }/css/response.css" rel="stylesheet" type="text/css" />
<link href="${ctx }/css/preview-dev.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/js/plugs/layer/skin/default/layer.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="${ctx }/js/plugs/jquery-ui-1.10.3.custom/js/jquery-1.10.1.js"></script>
<script src="${ctx}/js/plugs/layer/layer.js" type="text/javascript"></script>
</head>
<body style="background: rgb(245, 245, 245);">
	<div class="root-body" style="padding-top: 80px;">
		<div class="middle-body" style="padding-top:10px;">
		<input type="hidden" name="sid" value="${sid }">
		<div>
		<h1 style="text-align: center;color: #676767;">${directory.surveyName}</h1>
		<p style="color: #676767;">${directory.surveyDetail.surveyNote }</p>
		</div>
		<form action="" method="post" id="submitForm">
			<div class="middle-body-content" style="text-align: center;">
				<p class="msg1" style="font-size: 26px;padding:26px;">
					请先输入用户信息进入问卷
				</p>
				<p  style="font-size: 18px;line-height: 18px;">
					用户姓名：<input type="text" size="10" name="surveyuser_username"  style="padding: 5px;outline: none;border: 1px solid #83ABCB;"/>&nbsp;&nbsp;
					用户密码：<input type="text" size="10" name="surveyuser_password"  style="padding: 5px;outline: none;border: 1px solid #83ABCB;"/>&nbsp;&nbsp;
					<input type="button"  class="sbtn24 sbtn24_0 checkUser" value="继续">
				</p>
			</div>
			</form>
			<div style="font-size: 12px;color: #323232;text-align: right;display: none;"><p>	如有疑问可以与管理员&nbsp;<a href="#" class="msg1" style="color: rgb(53, 117, 136);">联系</a>&nbsp;！</p></div>
		</div>
		
		<div class="footer-copyright" style="color: gray;">
			<%--尊重开源、保留声明，感谢您的大力支持--%>
<%--				 <a href="#" style="text-decoration: none;color: rgb(53, 117, 136);">苏州奥科星</a> 提供支持--%>
				<img style="vertical-align: middle;height:16px;width:16px;margin-bottom:3px;margin-right:5px" src="${ctx }/images/logo/gongan.png">苏ICP备12065536号

		</div>
	</div>
	<script type="text/javascript">
	$(".checkUser").click(function(){
		var url="${ctx}/response!ajaxCheckSurveyUser.action";
		var surveyuser_username=$("input[name='surveyuser_username']").val();
		var surveyuser_password=$("input[name='surveyuser_password']").val();
		var sid=$("input[name='sid']").val();
		$.ajax({
			url:url,
			type:"post",
			data:{"surveyuser_username":surveyuser_username,"surveyuser_password":surveyuser_password,"sid":sid},
			success:function(msg){
				//msg == 1 通过 msg == 0 不通过 msg== -1 用户过期
				if(msg == 1){
					$("#submitForm").submit();
				}else if(msg == -1 ){
					layer.msg("用户已经过期");
				}else if(msg == -2){
					layer.msg("该用户名密码已被使用，请重新选择登录");
				}
				else{
					layer.msg("用户名或密码错误");
				}
				
			}
		})
	})
	</script>
	<%@ include file="/WEB-INF/page/layouts/other.jsp"%>
</body>
</html>