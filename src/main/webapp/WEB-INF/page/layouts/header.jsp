<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/common/taglibs.jsp" %>
<%@include file="/WEB-INF/page/layouts/other.jsp"%>
<div id="header" >
		<div id="headerCenter"  class="bodyCenter">
			<div class="header_Item header_logo">
			<%-- 
			<a href="${ctx }/">
				<img alt="调问网" src="${ctx }/images/logo/LOGO.png" >
			</a> 
			--%>
			<%@ include file="logo-img.jsp"%>
			</div>
			<shiro:guest>
				<div class="header_Item header_menu">
				<ul>
				<%--<li><a href="/" class="active dw-menu-a" id="indexMenu">首页</a></li>--%>
				<%--<li><a href="/feature.jsp" class="dw-menu-a" id="featureMenu">功能</a></li>--%>
				<%--<li><a href="${ctx }/survey-model.action" class="dw-menu-a">下载</a></li>--%>
				<%--<li><a href="${ctx }/survey-model.action" class="dw-menu-a">帮助</a></li>--%>
				<%--<li><a href="${ctx }/survey-model.action" class="dw-menu-a">GITHUB</a></li>--%>
				<!--
				<li><a href="http://support.diaowen.net/" class="dw-menu-a" id="helpMenu">帮助</a></li>
				-->
				</ul>
				</div>
				<div class="header_Item header_user" style="float: right;">
					<a href="${ctx }/login.jsp" class="btn-a-1">登录</a>
				</div>
			</shiro:guest>
			
			<shiro:user>
				<div class="header_Item header_menu">
					<ul>
					<%-- <li><a href="${ctx }/" >首页</a></li> --%>
					<li><a href="${ctx }/design/my-survey.action" id="mysurvey">问卷</a></li>
						<shiro:hasRole name="admin" >
					<li><a href="${ctx }/sy/user/user-admin.action" id="usermanager">用户</a></li>
					<li><a href="${ctx }/sy/system/sys-property!input.action" id="systemset">设置</a></li>
						</shiro:hasRole>
					<li style="display: none"><a href="http://support.diaowen.net/">帮助</a></li>
					</ul>
				</div>
				<div class="header_Item header_user" style="float: right;margin-top: 12px;position: relative;zoom: 1;z-index: 165;">
					<a href="#" class="clickHideUserMenu">
						<span class="head_use_name" title="<shiro:principal></shiro:principal>">
						<shiro:principal></shiro:principal>
						</span>
						<span class="header_user_icon">&nbsp;</span>
					</a>
					<div class="a-w-sel a-w-sel-head" style="">
		            	<div class="w-sel" style="margin-top: 16px;">
		                	<div class="selc">
		                    	<div class="selcc tbtag">
		                            <div class="seli"><a class="nx-1" href="${ctx }/ic/user!myaccount.action">修改密码</a></div>
		                            <div class="seli" style="display: none;"><a class="nx-7" href="#">帮助及反馈</a></div>
		                            <div class="seli"><a class="nx-8"  onclick="loginOutCheck(this)">退出</a></div>
		                            <script type="text/javascript">
		                               function loginOutCheck(obj){
		                            			if(confirm("确定退出系统吗？")){
		                            				var url="${ctx }/login!logout.action";
		                            				window.location.href=url;
		                            			}else{
		                            				return false;
		                            			}
		                                   }
		                            </script>
		                        </div>
		                    </div>
		                </div>
		            </div>
				</div>
			</shiro:user>
		</div>
		<div style="clear: both;"></div>
	</div>