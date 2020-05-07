<%@ page language="java" pageEncoding="UTF-8"%>
 <%@include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=9;IE=10;IE=11;IE=EDGE">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<link href="${ctx }/css/design-survey.css" rel="stylesheet" type="text/css" />
<link href="${ctx }/css/dw-user.css" rel="stylesheet" type="text/css" />
<title>Insert title here</title>
</head>
<body>
 <div class="surveyAttrViewPerson_Dialog dwQuFormSetDialog dwQuDialogCon" style="width: 100%;height: 100%;" id="surveyUserSelect" >
			<!--内容  -->	
             <div >
					<table class="contacts-table" width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<th style="text-align: center;" width="30"><!-- <input type="checkbox">  --></th>
										<th align="left" >测试用户姓名</th>
										<th align="left" width="100">测试用户密码</th>
										<th align="left" width="200">有效起始</th>
										<th align="left" width="60">有效终止</th>
										<th align="left" width="80">状态</th>
										<th align="center" width="220" style="padding-left: 10px;">操作</th>
									</tr>
									<c:choose>
									<c:when test="${surveyuserpage.totalItems > 0}">
									<c:forEach items="${surveyuserpage.result}" var="en">
									<tr>
										<td align="center">
											<input type="hidden" name='surveyId' value="${en.id }">
										</td>
										<td align="left">${en.userName}</td>
										<td align="left" width="100" >${en.passWord}</td>
										<td align="left">
											${en.startTime}
										</td>
										<td align="left">${en.endTime }</td>
										<td align="left" >
											${en.status eq 0 ? '有效':'无效'}
										</td>
										<td align="left">
											<div class="btn-group surveyLeftBtnGroup">
											  <a class="btn btn-default" data-toggle="tooltip" data-placement="top" onclick='deletesurveyuser("${en.id}")' >删除</a>
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
										<c:if test="${surveyuserpage.pageNo > 1}">
											<a href="${ctx }/design/my-survey.action?page.pageNo=${surveyuserpage.pageNo-1}" class="btn btn-default">&lt;</a>
										</c:if>
										<c:if test="${surveyuserpage.startpage > 1}">
											<a href="${ctx }/design/my-survey.action?page.pageNo=1" class="btn btn-default">1</a>
											<c:if test="${surveyuserpage.startpage > 2 }">
												<span>...</span>
											</c:if>
										</c:if>
										<c:forEach begin="${surveyuserpage.startpage }" end="${surveyuserpage.endpage }" var="en">
											<c:choose>
												<c:when test="${surveyuserpage.pageNo eq en }"><a href="${ctx }/design/my-survey.action?page.pageNo=${en }" class="btn btn-default" style="background: #D3DEED;">${en }</a></c:when>
												<c:otherwise><a href="${ctx }/design/my-survey.action?page.pageNo=${en}" class="btn btn-default">${en }</a></c:otherwise>
											</c:choose>
										</c:forEach>
										<c:if test="${surveyuserpage.totalPage > (surveyuserpage.endpage)}">
											<c:if test="${surveyuserpage.totalPage > (surveyuserpage.endpage+1)}">
												<span>...</span>
											</c:if>
											<a href="${ctx }/design/my-survey.action?page.pageNo=${surveyuserpage.totalPage}" class="btn btn-default">${surveyuserpage.totalPage }</a>
										</c:if>
										<c:if test="${surveyuserpage.totalPage > surveyuserpage.pageNo}">
											<a href="${ctx }/design/my-survey.action?page.pageNo=${surveyuserpage.pageNo+1}" class="btn btn-default">&gt;</a>
										</c:if>
										
									</div>
								</div>
							</div>
			<!--内容  -->	
</div>
</body>
</html>