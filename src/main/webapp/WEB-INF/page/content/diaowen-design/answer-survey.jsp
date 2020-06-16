<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
<%@include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${survey.surveyName }</title>
<link href="${ctx }/js/plugs/jquery-ui-1.10.3.custom/css/mycss/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css" />
<%-- <link href="${ctx }/js/plugs/bootstrap-3.3.0-dist/dist/css/bootstrap.css" rel="stylesheet" type="text/css" /> --%>
<script type="text/javascript"
		src="${ctx }/js/plugs/jquery-ui-1.10.3.custom/js/jquery-1.10.1.js"></script>
<script type="text/javascript"
	src="${ctx }/js/plugs/bootstrap-3.3.0-dist/dist/js/bootstrap.min.js"></script>
		
<script type="text/javascript"
	src="${ctx }/js/plugs/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"></script>
<script type="text/javascript"
	src="${ctx }/js/plugs/jquery-ui-1.10.3.custom/js/jquery.ui.touch-punch.min.js"></script>	
<script type="text/javascript"
	src="${ctx }/js/plugs/colpick-jQuery/js/colpick.js"></script>
<link href="${ctx }/js/plugs/uploadify-v3.1/uploadify.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="${ctx }/js/plugs/uploadify-v3.1/jquery.uploadify-3.1.js"></script>
<script type="text/javascript" src="${ctx }/js/dw/uploadify.js"></script>
<script language="javascript" type="text/javascript"
	src="${ctx }/js/plugs/My97DatePickerBeta/My97DatePicker/WdatePicker.js"></script>
<link href="${ctx }/css/preview-dev.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet"
	href="${ctx }/js/plugs/colpick-jQuery/css/colpick.css" type="text/css" />

<link href="${ctx}/js/plugs/validate/jquery.validate.css"
	type="text/css" rel="stylesheet" />
<link href="${ctx }/js/plugs/font-awesome-4.2.0/css/font-awesome.css" rel="stylesheet">
	<style type="text/css">
		.edui-editor-iframeholder {
			display: none;
		}

		.edui-default .edui-editor-toolbarboxouter {
			border: none ! important;
		}

		#resultProgressRoot {
			right: 10px;
			bottom: 10px;
			width: 200px;
			z-index: 200;
			position: fixed;
		}

		.progress-label {
			font-size: 14px;
			font-family: "微软雅黑";
			margin: 0px auto;
			text-align: center;
			line-height: 1.4em;
			color: #83AE00;
		}

		.progress-labelB {
			font-size: 14px;
			font-family: "微软雅黑";
			margin: 0px auto;
			text-align: center;
			line-height: 1.4em;
			color: #83AE00;
		}

		.progressbarDiv {
			height: 10px ! important;
			box-shadow: none ! important;
			border: 1px solid #83AE00;
		}

		.progressbarDiv .ui-progressbar-value {
			background: #83AE00 ! important;
			border: none;
		}

		.ui-progressbar .ui-progressbar-value {
			margin: 0px;
		}

		.ui-progressbar {
			position: relative;
			background: none ! important;
		}

		.quOptionEditTd .editAble, .scoreNumTable tr td, .quCoItemTable {
			font-size: 16px;
		}

		label.error {
			font-size: 14px;
		}
	</style>
<style>
.quCoNum {
	display: none;
}

.isSelectTypeCss:hover{
background-color: white;
}

td p span{
 vertical-align:middle;
 display: inline-block;
}
.slider{
 background: lemonchiffon;
}
</style>
<script type="text/javascript">
$(document)
		.ready(
				function() {
					var tempUserName=$("#surveyuser_username").val();
					var tempPassWord=$("#surveyuser_password").val();
					if(tempUserName != undefined && tempUserName != ""){
						$("input[name='surveyuser_username']").val(tempUserName);
						$("input[name='surveyuser_password']").val(tempPassWord);
					} 
					
					//监听关闭事件
				
					//设置隔行变色
					//各种验证正则NO("无验证", 0), 
					/* EMAIL("Email", 1), 
					STRLEN("字符长度", 2), 
					UNSTRCN("禁止中文", 3),
					STRCN("仅许中文", 4),
					NUM("数值", 5),
					TELENUM("电话号码", 6),
					PHONENUM("手机号码", 7),
					DATE("日期", 8),
					IDENTCODE("身份证号", 9),
					ZIPCODE("邮政编码", 10),
					URL("网址", 11),
					TELE_PHONE_NUM("电话或手机号", 12); */

					//right
					var email = /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;

					//right
					var unstrcn = /^\w+$/;
					//right
					var strcn = /[\u4e00-\u9fa5]+/
					//right
					var num = /^[0-9]*$/
					//right
					var telenum = /0?(13|14|15|17|18|19)[0-9]{9}/

					var date = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])\s+(20|21|22|23|[0-1]\d):[0-5]\d:[0-5]\d$/
					var date_2 = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
					var identcode = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
					var zipcode = /^[0-9]\\d{5}$/
					var url = /^(?=^.{3,255}$)(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:\d+)*(\/\w+\.\w+)*$/
                       
							
				//table表格长度回显
				$(".li_surveyQuItemBody ").each(function(){
					var quType=$(this).find(".quType").val();
					var quId=$(this).find(".quId").val();
					var isSelectType=$(this).find(".isSelectType").val();
					if(quType=="CHENFBK" || quType=="CHENSCORE" || quType=="CHENRADIO" || quType == "CHENCHECKBOX"){
					var trWidthInfo=$(this).find(".trWidthInfo").val();
					if(trWidthInfo != "" && trWidthInfo != undefined){
					 var firstTr=$(this).find("table").find("tr").first();
					 var tdAll=firstTr.find("td");
					 var trWidthInfoArr=trWidthInfo.split(",");
					 tdAll.each(function(i){
						/*$(this).css("width",trWidthInfoArr[i]); */
						 tdAll[i].style.width=trWidthInfoArr[i]+"%";
					 })
					 }
						
					}else if(quType=="RADIO" && isSelectType == "1"){
						$(".dropdown_ul_"+quId).hide();
						$(".dropdownMenu_"+quId).unbind();
						$(".dropdownMenu_"+quId).click(function(){
							if($(".dropdown_ul_"+quId).is(":visible")){
								$(".dropdown_ul_"+quId).hide();
							}else{
								$(".dropdown_ul_"+quId).show();
							}
						})
					}
					
				})	
				
				
							
					//分页设置 nextPage_a prevPage_a
					$(".nextPage_a")
							.click(
									function() {

										//判断本页验证
										if (!validateForms_2()) {
											return false;
										}
										var thParent = $(this).parent();
										var nextPageNo = thParent.find(
												"input[name='nextPageNo']")
												.val();
										$(".li_surveyQuItemBody").hide();
										$(".surveyQu_" + nextPageNo)
												.fadeIn("slow");
										//$(window).scrollTop(10);
										$("html,body").animate({
											scrollTop : 10
										}, 500);
										
										//这里需要做逻辑判断
										$.each($(".li_surveyQuItemBody"),function(){
											var quInputCase=$(this).find(".quInputCase");
											runlogic_2(quInputCase);
										})
										return false;
									});
					$(".prevPage_a")
							.click(
									function() {
										// if (!validateForms_2()) {
										// 	return false;
										// }
										var thParent = $(this).parent();
										var prevPageNo = thParent.find(
												"input[name='prevPageNo']")
												.val();
										$(".li_surveyQuItemBody").hide();
										$(".surveyQu_" + prevPageNo)
												.fadeIn("slow");
										$(window).scrollTop(10);
										
										//这里需要做逻辑判断
								
										$.each($(".li_surveyQuItemBody"),function(){
											var quInputCase=$(this).find(".quInputCase");
											runlogic_2(quInputCase);
										})
										return false;
									    });

					//var prevHost="http://file.diaowen.net";
					var prevHost = $("#prevHost").val();
					//初始化弹出窗口参数
					var surveyStyleId = $("#surveyStyleId").val();
					if (surveyStyleId != "") {
						/** 背景样式 **/
						//surveyStyle.showBodyBi
						var showBodyBi = "${surveyStyle.showBodyBi}";

						//surveyStyle.bodyBgColor
						var bodyBgColor = "${surveyStyle.bodyBgColor}";
						var bodyBgColorObj = $("input[name='bodyBgColor']");
						bodyBgColorObj.val(bodyBgColor);
						var bodyBCThemeParamObj = bodyBgColorObj
								.parents(".theme_param");
						bodyBCThemeParamObj.find(".color_box").css({
							"background-color" : bodyBgColor
						});
						//$("#wrap").css({"background-color":bodyBgColor});
						$("body").css({
							"background-color" : bodyBgColor
						});

						//surveyStyle.bodyBgImage
						var bodyBgImage = "${surveyStyle.bodyBgImage}";
						var bodyBgImageObj = $("input[name='bodyBgImage']");
						var bodyBIThemeParamObj = bodyBgImageObj
								.parents(".theme_param");
						bodyBgImageObj.val(bodyBgImage);
						bodyBIThemeParamObj.find(".previewImage").attr(
								"src", prevHost + bodyBgImage);
						if (showBodyBi == 1) {
							//$("#wrap").css({"background-image":"url("+bodyBgImage+")"});
							$("body").css(
									{
										"background-image" : "url("
												+ prevHost + bodyBgImage
												+ ")"
									});
							$("input[name='showBodyBi']").prop("checked",
									true);
						}

						/** 表头样式 **/
						//surveyStyle.showBodyBi
						var showSurveyHbgi = "${surveyStyle.showSurveyHbgi}";

						//surveyStyle.bodyBgColor
						var surveyHeadBgColor = "${surveyStyle.surveyHeadBgColor}";
						var surveyHeadBgColorObj = $("input[name='surveyHeadBgColor']");
						var surveyHBCThemeParamObj = surveyHeadBgColorObj
								.parents(".theme_param");
						surveyHeadBgColorObj.val(surveyHeadBgColor);
						surveyHBCThemeParamObj.find(".color_box").css({
							"background-color" : surveyHeadBgColor
						});
						$("#dwSurveyHeader").css({
							"background-color" : surveyHeadBgColor
						});

						//surveyStyle.bodyBgImage
						var surveyHeadBgImage = "${surveyStyle.surveyHeadBgImage}";
						var surveyHeadBgImageObj = $("input[name='surveyHeadBgImage']");
						var surveyHBIThemeParamObj = surveyHeadBgImageObj
								.parents(".theme_param");
						surveyHeadBgImageObj.val(surveyHeadBgImage);
						surveyHBIThemeParamObj.find(".previewImage").attr(
								"src", prevHost + surveyHeadBgImage);
						if (showSurveyHbgi == 1) {
							$("#dwSurveyHeader").css(
									{
										"background-image" : "url("
												+ prevHost
												+ surveyHeadBgImage + ")"
									});
							$("input[name='showSurveyHbgi']").prop(
									"checked", true);
						}

						var surveyHeadPaddingTop = "${surveyStyle.surveyHeadPaddingTop}";
						var surveyHeadPaddingBottom = "${surveyStyle.surveyHeadPaddingBottom}";
						$("#dwSurveyHeader").css({
							"padding-top" : surveyHeadPaddingTop + "px"
						});
						$("#dwSurveyHeader")
								.css(
										{
											"padding-bottom" : surveyHeadPaddingBottom
													+ "px"
										});

						/** 内容中间样式 **/
						//surveyStyle.showBodyBi
						var showSurveyCbim = "${surveyStyle.showSurveyCbim}";

						//surveyStyle.bodyBgColor
						var surveyContentBgColorMiddle = "${surveyStyle.surveyContentBgColorMiddle}";
						var surveyContentBgColorMiddleObj = $("input[name='surveyContentBgColorMiddle']");
						var surveyCBCMThemeParamObj = surveyContentBgColorMiddleObj
								.parents(".theme_param");
						surveyContentBgColorMiddleObj
								.val(surveyContentBgColorMiddle);
						surveyCBCMThemeParamObj.find(".color_box").css({
							"background-color" : surveyContentBgColorMiddle
						});
						;
						$("#dwSurveyQuContentBg").css({
							"background-color" : surveyContentBgColorMiddle
						});

						//surveyStyle.bodyBgImage
						var surveyContentBgImageMiddle = "${surveyStyle.surveyContentBgImageMiddle}";
						var surveyContentBgImageMiddleObj = $("input[name='surveyContentBgImageMiddle']");
						var surveyCBIMThemeParamObj = surveyContentBgImageMiddleObj
								.parents(".theme_param");
						surveyContentBgImageMiddleObj
								.val(surveyContentBgImageMiddle);
						surveyCBIMThemeParamObj.find(".previewImage").attr(
								"src",
								prevHost + surveyContentBgImageMiddle);
						if (showSurveyCbim == 1) {
							$("#dwSurveyQuContentBg")
									.css(
											{
												"background-image" : "url("
														+ prevHost
														+ surveyContentBgImageMiddle
														+ ")"
											});
							$("input[name='showSurveyCbim']").prop(
									"checked", true);
						}

						/** 文本样式 **/
						var questionTitleTextColor = "${surveyStyle.questionTitleTextColor}";
						var questionTitleTextColorObj = $("input[name='questionTitleTextColor']");
						var questionTTCThemeParamObj = questionTitleTextColorObj
								.parents(".theme_param");
						questionTitleTextColorObj
								.val(questionTitleTextColor);
						questionTTCThemeParamObj.find(".color_box").css({
							"background-color" : questionTitleTextColor
						});
						$(".quCoTitle").css({
							"color" : questionTitleTextColor
						});

						var questionOptionTextColor = "${surveyStyle.questionOptionTextColor}";
						var questionOptionTextColorObj = $("input[name='questionOptionTextColor']");
						var questionOTCThemeParamObj = questionOptionTextColorObj
								.parents(".theme_param");
						questionOptionTextColorObj
								.val(questionOptionTextColor);
						questionOTCThemeParamObj.find(".color_box").css({
							"background-color" : questionOptionTextColor
						});
						$(".quCoOptionEdit").css({
							"color" : questionOptionTextColor
						});

						var surveyTitleTextColor = "${surveyStyle.surveyTitleTextColor}";
						var surveyTitleTextColorObj = $("input[name='surveyTitleTextColor']");
						var surveyTTCThemeParamObj = surveyTitleTextColorObj
								.parents(".theme_param");
						surveyTitleTextColorObj.val(surveyTitleTextColor);
						surveyTTCThemeParamObj.find(".color_box").css({
							"background-color" : surveyTitleTextColor
						});
						$("#dwSurveyTitle").css({
							"color" : surveyTitleTextColor
						});

						var surveyNoteTextColor = "${surveyStyle.surveyNoteTextColor}";
						var surveyNoteTextColorObj = $("input[name='surveyNoteTextColor']");
						var surveyNTCThemeParamObj = surveyNoteTextColorObj
								.parents(".theme_param");
						surveyNoteTextColorObj.val(surveyNoteTextColor);
						surveyNTCThemeParamObj.find(".color_box").css({
							"background-color" : surveyNoteTextColor
						});
						$("#dwSurveyNoteEdit").css({
							"color" : surveyNoteTextColor
						});

						var surveyBtnBgColor = "${surveyStyle.surveyBtnBgColor}";
						if (surveyBtnBgColor !== "") {
							$("#dw_body_content .sbtn24").css({
								"background" : "none"
							});
							$(
									"#dw_body_content .sbtn24,.progressbarDiv .ui-progressbar-value")
									.css(
											{
												"background-color" : surveyBtnBgColor
											});
							$(".progressbarDiv").css({
								"border-color" : surveyBtnBgColor
							});
							$(".progress-label ").css({
								"color" : surveyBtnBgColor
							});
							var surveyBtnBgColorObj = $("input[name='surveyBtnBgColor']");
							surveyBtnBgColorObj.val(surveyBtnBgColor);
							var btnBcThemeParamObj = surveyBtnBgColorObj
									.parents(".theme_param");
							btnBcThemeParamObj.find(".color_box").css({
								"background-color" : surveyBtnBgColor
							});
						}

						//显示序号及进度条
						var showTiNum = "${surveyStyle.showTiNum}";
						var showProgressbar = "${surveyStyle.showProgressbar}";
						if (showTiNum == 0) {
							$(".quCoNum").hide();
						}
						if (showProgressbar == 0) {
							$("#resultProgressRoot").hide();
						}

						//表头文本显示
						var showSurTitle = "${surveyStyle.showSurTitle}";
						var showSurNote = "${surveyStyle.showSurNote}";
						if (showSurTitle == 0) {
							$("#dwSurveyTitle").hide();
						}
						if (showSurNote == 0) {
							$("#dwSurveyNote").hide();
						}
					}

					$(".submitSurvey").click(
									function() {
										//表单检查
										if (validateForms()) {
											if ($("#jcaptchaImgBody").is(
													":visible")) {
												var jcaptchaInput = $("input[name='jcaptchaInput']").val();
												var url = "${ctx}/response!ajaxCheckJcaptchaInput.action";
												$.ajax({
															url : url,
															async:false,  
															data : {
																"jcaptchaInput" : jcaptchaInput
															},
															type : "post",
															success : function(msg) {
																var json = eval("(" + msg + ")");
							  
																if (msg === "false") {
																	//判断
																/* 	if($("#jcaptchaImgBody .errorItem")[0]){
																		$("#jcaptchaImgBody .errorItem")
																		.show();
																	}else{
																		$("#jcaptchaImgBody" ).find(".valid-msg fail").show();
																	} */
																	errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">验证码错误！</label></div>";
																	$("#jcaptchaImgBody" ).append(errorHtml);
																} else {
																	$("#surveyForm").submit();
																}
															}
														});
											} else {
												$("#surveyForm").submit();
											}
										}else{
											//window.scrollTo(0,100);
											return  false;
										}
									});
					// 定时保存
					window.setInterval(function() {
						var url = "${ctx}/response!tempSave.action"
						$.ajax({
							//几个参数需要注意一下
							type: "POST",//方法类型
							url: url ,//url
							data: $('#surveyForm').serialize(),
							success: function (result) {
								if (result) {
								}
							},
							error : function() {
								alert("异常！");
							}
						});
					}, 180000);

					//数据回显
					$.ajax({
						//几个参数需要注意一下
						type: "GET",
						//方法类型
						url: '${ctx}/ans/answer.action?surveyId=' + $('#surveyId').val() + '&surveyuser_username=' +  $("input[name='surveyuser_username']").val(),//url
						success: function (result) {
							if (result) {

								if (result) {
									result = JSON.parse(result);
									var answerQuSize = 0;
									for(var i = 0; i < result.length; i++) {
										var type = result[i].quType;
										if(type === 'RADIO'){
											if(result[i].anRadio.quItemId) {
												var inputs = $("input[name='qu_RADIO_" + result[i].id + "']");
												Array.from(inputs).forEach((item) => {

													if(item.value === result[i].anRadio.quItemId) {
														item.previousElementSibling.classList.add('checked');
														item.setAttribute('checked', 'checked')

													}
												})
												answerQuSize ++ ;
											}
										}else if(type === 'CHECKBOX'){
											if(result[i].anCheckboxs.length > 0) {
												answerQuSize ++ ;
												result[i].anCheckboxs.forEach((item)=>{
													var input = $("input[name='tag_qu_CHECKBOX_" + result[i].id + '_' + item.quItemId +"']");
													input[0].previousElementSibling.classList.add('checked');
													input[0].setAttribute('checked', 'checked')
												})
												result[i].anCheckboxs.forEach((item)=>{
													var input = $("input[name='tag_qu_CHECKBOX_" + result[i].quId + '_' + item.quItemId +"']");
													if(input[0]) {
														input[0].previousElementSibling.classList.add('checked');
														input[0].setAttribute('checked', 'checked')
													}
												})

											}

										}else if(type === 'FILLBLANK'){
											if(result[i].anFillblank.answer) {
												var input = $("input[name='qu_FILLBLANK_" + result[i].anFillblank.quId +"']");
												input[0].value = result[i].anFillblank.answer;
												answerQuSize ++ ;
											}

										}else if(type === 'SCORE'){
											if(result[i].anScores.length > 0) {
												result[i].anScores.forEach((item) => {
													var input = $("input[name='item_qu_SCORE_" + item.quId + '_' + item.quRowId +"']");
													for(var j =0 ; j < +item.answserScore;j++){
														input[0].previousElementSibling.rows[0].cells[j].style = null;
													}
													input[0].parentNode.nextElementSibling.innerText = item.answserScore + '分';
												});
												answerQuSize ++ ;
											}

										}else if(type === 'ORDERQU'){
											if(result[i].anOrders.length > 0) {
												result[i].anOrders.forEach((item) => {
													var input = $("input[name='qu_ORDERQU_" + item.quId + "']");
													var surveyQuItemBody= input[0].parentNode.parentNode;
													let rows = surveyQuItemBody.querySelector(".quOrderByTable").rows;
													Array.from(rows).forEach((r,index) => {
														if(+item.orderyNum === (index+1)) {
															var c = r.querySelector(".quOrderTabConnect");
															$("input[name='item_qu_ORDERQU_" + item.quId + '_' + item.quRowId + "']")[0].parentNode.classList.remove('editAble');
															$("input[name='item_qu_ORDERQU_" + item.quId + '_' + item.quRowId + "']")[0].parentNode.classList.remove('quCoOptionEdit')
															$("input[name='item_qu_ORDERQU_" + item.quId + '_' + item.quRowId + "']")[0].parentNode.classList.add('quOrderItemLabel')
															$("input[name='item_qu_ORDERQU_" + item.quId + '_' + item.quRowId + "']")[0].parentNode.style.display = 'inline-block'
															c.append($("input[name='item_qu_ORDERQU_" + item.quId + '_' + item.quRowId + "']")[0].parentNode);
														}
													})
												});
												answerQuSize ++ ;

											}

										}else if(type === 'MULTIFILLBLANK'){
											if(result[i].anDFillblanks.length > 0) {
												result[i].anDFillblanks.forEach((item) => {
													var input = $("input[name='text_qu_MULTIFILLBLANK_" + item.quId + '_' + item.quItemId +"']");
													input[0].value = item.answer;
												});
												answerQuSize ++ ;

											}

										}else if(type === 'CHENRADIO'){
											if(result[i].anChenRadios.length > 0) {
												result[i].anChenRadios.forEach((item) => {
													var inputs = $("input[name='item_qu_CHENRADIO_" + item.quId + '_' + item.quRowId + "']");
													Array.from(inputs).forEach((i) => {
														if(i.value === item.quColId) {
															i.previousElementSibling.previousElementSibling.classList.add('checked');
															i.setAttribute('checked', 'checked')
														}
													})
												});
												answerQuSize ++ ;

											}

										}else if(type === 'CHENCHECKBOX'){
											if(result[i].anChenCheckboxs.length > 0) {
												result[i].anChenCheckboxs.forEach((item) => {
													var input = $("input[name='ck_item_qu_CHENCHECKBOX_" + item.quId + '_' + item.quRowId + '_' + item.quColId + "']");
													input[0].previousElementSibling.previousElementSibling.classList.add('checked');
													input[0].setAttribute('checked', 'checked')
												});
												answerQuSize ++ ;

											}

										}else if(type === 'CHENSCORE'){
											if(result[i].anChenScores.length > 0) {
												result[i].anChenScores.forEach((item) => {
													var input = $("input[name='cs_item_qu_CHENSCORE_" + item.quId + '_' + item.quRowId + '_' + item.quColId + "']");
													input[0].value = +item.answserScore;
												});
												answerQuSize ++ ;

											}

										}else if(type === 'CHENFBK'){
											if(result[i].anChenFbks.length > 0) {
												result[i].anChenFbks.forEach((item) => {
													var input = $("input[name='fbk_item_qu_CHENFBK_" + item.quId + '_' + item.quRowId + '_' + item.quColId + "']");
													input[0].value = item.answerValue;
												});
												answerQuSize ++ ;

											}

										}
									}
									var totalQuSize = $(".answerTag:enabled").size();
									var newValue = parseInt(answerQuSize / totalQuSize
											* 100);
									$("#resultProgressRoot .progress-label").text(
											"完成度：" + newValue + "%");
									$("#resultProgressRoot .progress-labelB").text(
											"共：" + totalQuSize + "题，已答" + answerQuSize + "题");
									$("#resultProgress").progressbar("option", "value",
											newValue);
								}
							}
						},
						error : function() {
							alert("异常！");
						}
					});
					$(".tempSaveSurvey").click(
							function() {
								var url = "${ctx}/response!tempSave.action"
								$.ajax({
									//几个参数需要注意一下
									type: "POST",//方法类型
									url: url ,//url
									data: $('#surveyForm').serialize(),
									success: function (result) {

									},
									error : function() {
										alert("异常！");
									}
								});
							});
					$(".quitSurvey").click(
							function() {
								var url = "${ctx}/response!userLogout.action";
								var surveyId = $("#surveyId").val();
								var username = $("#surveyuser_username").val();
								var password = $("#surveyuser_password").val();
								$.ajax({
									url : url,
									async:false,
									data : {
										"surveyId": surveyId,
										"surveyuser_username": username,
										"surveyuser_password": password
									},
									type : "post",
									success : function(msg) {
										window.close();
									}
								});
							});
					//评分题
					$(".scoreNumTable tr td").click(
							function() {
								//scoreNumInput
								var quScoreOptionTr = $(this).parents(
										".quScoreOptionTr");
								var tdText = $(this).text();
								quScoreOptionTr
										.find(".scoreNumTable tr td").css({
											"background" : "white"
										});
								quScoreOptionTr.find(".scoreNumText").html(
										$(this).text() + "&nbsp;分");

								$(this).prevAll().css({
									"background" : ""
								});
								$(this).css({
									"background" : ""
								});

								quScoreOptionTr.find(".scoreNumInput").val(
										tdText);
								quScoreOptionTr.find(".scoreNumText").html(
										tdText + "&nbsp;分");

								//runlogic($(this));
								runlogic_2($(this));
								answerProgressbar($(this));
								validateCheck($(this).parents(
										".li_surveyQuItemBody"), false);
							});
                       
					//多重输入评分题
					 $(".isScoreInputText").change(function(){
						 var quScoreOptionTr = $(this).parents(
							".quScoreOptionTr");
						 var tdText=$(this).val();
							quScoreOptionTr.find(".scoreNumInput").val(
									tdText);
							quScoreOptionTr.find(".scoreNumText").html(
									tdText + "&nbsp;分");
							runlogic_2($(this));
							answerProgressbar($(this));
							validateCheck($(this).parents(
									".li_surveyQuItemBody"), false);
					 })
					
					
					//滑块评分题
					$(".li_surveyQuItemBody")
							.each(
									function() {
										var quitem = $(this);
										if (quitem.find(".quType").val() == "SCORE") {

											var quId = quitem.find(".quId")
													.val();
											var maxSliderLength = quitem
													.find(
															".maxSliderLength")
													.val();
											var minSliderLength = quitem
													.find(
															".minSliderLength")
													.val();
											var quScoreOptionTr = quitem
													.find(".quScoreOptionTr");
											var quCoItemTable = quitem
													.find(".quCoItemTable");
											quScoreOptionTr
													.each(function(i) {
														var thisQuScoreOptionTr = $(this);
														var socreText = thisQuScoreOptionTr
																.find("td")
																.last();
														$(
																".slider-range-"
																		+ quId
																		+ "-"
																		+ (i + 1))
																.slider(
																		{
																			range : false,
																			min : parseInt(minSliderLength),
																			max : parseInt(maxSliderLength),
																			step : 1,
																			slide : function(
																					event,
																					ui) {
																				socreText
																						.text(ui.value
																								+ "分");
																				$(
																						this)
																						.next()
																						.val(
																								ui.value);

																				//先获得所有的其余的所有的滑块
																				var scoreNumText = quCoItemTable
																						.find(".scoreNumText");
																				var nowSliderLength = 0;
																				$
																						.each(
																								scoreNumText,
																								function() {
																									var thisScoreNumText = $(this);
																									var thisScoreval = thisScoreNumText
																											.text()
																											.replace(
																													"分",
																													"");
																									nowSliderLength += parseInt(thisScoreval);
																								})

																				$(
																						".nowSliderLength_"
																								+ quId)
																						.text(
																								nowSliderLength);

																				runlogic_2(quScoreOptionTr);
																			}
																		});
														socreText
																.text(minSliderLength
																		+ "分");

													})
											$(".nowSliderLength_" + quId)
													.text(
															minSliderLength
																	* quScoreOptionTr.length);
										}
									})

					bindScoreNumTdHover();
					function bindScoreNumTdHover() {
						$(".scoreNumTable tr td")
								.hover(
										function() {
											var quScoreOptionTr = $(this)
													.parents(
															".quScoreOptionTr");
											var scoreNumInput = quScoreOptionTr
													.find(".scoreNumInput")
													.val();
											if (scoreNumInput == "") {
												$(this).prevAll().css({
													"background" : ""
												});
												$(this).css({
													"background" : ""
												});
												quScoreOptionTr
														.find(
																".scoreNumText")
														.html(
																$(this)
																		.text()
																		+ "&nbsp;分");
											}
										},
										function() {
											var quScoreOptionTr = $(this)
													.parents(
															".quScoreOptionTr");
											var scoreNumInput = quScoreOptionTr
													.find(".scoreNumInput")
													.val();
											if (scoreNumInput == "") {
												$(this).prevAll().css({
													"background" : "white"
												});
												$(this).css({
													"background" : "white"
												});
												quScoreOptionTr.find(
														".scoreNumText")
														.html("分");
											}
										});
					}

					//排序题
					//quOrderByCoItem
					bindQuOrderBySorts();
					function bindQuOrderBySorts() {
						var quOrderByCoItems = $(".quOrderByCoItem");
						$
								.each(
										quOrderByCoItems,
										function() {

											/* $(this).find( ".quOrderByLeftUl li" ).draggable({
												connectToSortable: $(this).find(".quOrderByTable td"),
												helper: "clone",
												zIndex:2000,
												//revert :true,
												start: function(event, ui) {
													var quOrderByCoItem=$(this).parents(".quOrderByCoItem");
													quOrderByCoItem.find( ".quOrderTabConnect" ).css({"background":"","border":"1px dotted red"});
												},
												drag: function(event, ui) {
													
												},
												stop: function(event,ui){
													var quOrderByCoItem=$(this).parents(".quOrderByCoItem");
													quOrderByCoItem.find( ".quOrderTabConnect" ).css({"background":"","border":"1px solid #dbdbdb"});
												}
											}); */

											$(this)
													.find(
															".quOrderByLeftUl li")
													.sortable(
															{
																zIndex : 1000,
																scroll : false,
																opacity : 0.8,
																placeholderType : false,
																connectWith : $(
																		this)
																		.find(
																				".quOrderByTable td"),
																helper : function(
																		event,
																		ui) {
																	return "<label class='quOrderItemLabel'>"
																			+ $(
																					this)
																					.text()
																			+ "</label>";
																},
																over : function(
																		event,
																		ui) {

																},
																start : function(
																		event,
																		ui) {

																},
																drag : function(
																		event,
																		ui) {

																},
																stop : function(
																		event,
																		ui) {
																	$(
																			".quOrderByTable td")
																			.css(
																					{
																						"background" : ""
																					});
																	//ui.item.html("<label class='quOrderItemLabel'>"+ui.item.text()+"</label>");
																	answerProgressbar($(this));
																	validateCheck(
																			$(
																					this)
																					.parents(
																							".li_surveyQuItemBody"),
																			false);
																}
															});
											var sortObjTempHtml = null;
											$(this)
													.find(
															".quOrderByTable td")
													.sortable(
															{
																//revert: true
																//dropOnEmpty:false,
																zIndex : 1000,
																scroll : false,
																opacity : 0.9,
																placeholderType : true,
																placeholder : "qu-order-highlight",
																connectWith : $(
																		this)
																		.find(
																				".quOrderByTable td"),
																over : function(
																		event,
																		ui) {
																	$(
																			".quOrderByTable td")
																			.css(
																					{
																						"background" : ""
																					});
																	$(this)
																			.css(
																					{
																						"background" : "#FAEDC0"
																					});
																	var quOrderItemLabel = $(
																			this)
																			.find(
																					"label.quOrderItemLabel");
																	sortObjTempHtml = "";
																	if (quOrderItemLabel[0]) {
																		sortObjTempHtml = quOrderItemLabel
																				.html();
																	}
																	/*sortObjTempHtml="";
																	 if(lastLabelHtml!=""){
																		sortObjTempHtml="<label class='quOrderItemLabel'>"+$(this).find("label:last-child").html()+"</label>";
																	} */
																	//console.debug($(ui.helper).css("zIndex")+$(ui.helper).css("position"));
																},
																receive : function(
																		event,
																		ui) {//当一个已连接的sortable对象接收到另一个sortable对象的元素后触发此事件。
																	//判断如果是从右边新移入的，但当前td中已经有了，就交换到右边去

																	var uiSenderClass = ui.sender
																			.attr("class");
																	ui.sender
																			.empty();
																	/* if(uiSenderClass.indexOf("quCoItemUlLi")<0){
																		ui.sender.append(sortObjTempHtml);
																	} */
																	if (uiSenderClass
																			.indexOf("quCoItemUlLi") < 0) {
																		if (sortObjTempHtml != "") {
																			ui.sender
																					.append("<label class='quOrderItemLabel'>"
																							+ sortObjTempHtml
																							+ "</label>");
																		}
																	} else {
																		if (sortObjTempHtml != "") {
																			ui.sender
																					.append("<label class='editAble quCoOptionEdit'>"
																							+ sortObjTempHtml
																							+ "</label>");
																		}
																	}

																	$(this)
																			.empty();
																	ui.item
																			.clone()
																			.appendTo(
																					$(this));
																	var quCoOptionEdit = $(
																			this)
																			.find(
																					".quCoOptionEdit");
																	if (quCoOptionEdit[0]) {
																		quCoOptionEdit
																				.removeClass();
																		quCoOptionEdit
																				.addClass("quOrderItemLabel");
																	}
																	$(
																			".quOrderByTable td")
																			.css(
																					{
																						"background" : ""
																					});
																	//更新排序ID  quCoItem quOrderByTableTr
																	//bindQuOrderBySorts();
																	var quOrderyByTrs = $(".quCoItem .quOrderByTableTr");
																	$
																			.each(
																					quOrderyByTrs,
																					function(
																							i) {
																						var quOrderItemHidInput = $(
																								this)
																								.find(
																										".quOrderItemHidInput");
																						quOrderItemHidInput
																								.val(i + 1);
																					});
																},
																start : function(
																		event,
																		ui) {
																	$(
																			".quOrderByTable td")
																			.css(
																					{
																						"background" : ""
																					});
																	$(this)
																			.css(
																					{
																						"background" : "#FAEDC0"
																					});
																},
																drag : function(
																		event,
																		ui) {
																	$(
																			".quOrderByTable td")
																			.css(
																					{
																						"background" : ""
																					});
																	$(this)
																			.css(
																					{
																						"background" : "#FAEDC0"
																					});
																},
																stop : function(
																		event,
																		ui) {
																	$(
																			".quOrderByTable td")
																			.css(
																					{
																						"background" : ""
																					});
																},
																out : function(
																		event,
																		ui) {
																	//$(".quOrderByTable td").css({"background":""});
																},
																activate : function(
																		event,
																		ui) {
																	//$(".quOrderByTable td").css({"background":""});
																	//$(this).css({"background":"#FAEDC0"});
																}
															});
										});
					}

					/**初始化表单骓证配置**/
					function validateForms() {
						var result = true;
						var surveyQuItemBodys = $(".li_surveyQuItemBody");
						var firstError = null;
						$.each(surveyQuItemBodys, function() {
							var quItemBody = $(this);
							if (!validateCheck(quItemBody, true)) {
								//定位到这题 
								if (firstError == null) {
									firstError = quItemBody;
								}
								result = false;
							}
							// || quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"
						});
						if (firstError != null) {
							$(window).scrollTop(firstError.offset().top);
						}
						//
						if ($("#jcaptchaImgBody").is(":visible")) {
							var jcaptchaInput = $(
									"input[name='jcaptchaInput']").val();
							/* var url="${ctx}/response!ajaxCheckJcaptchaInput.action";
							$.ajax({
								url:url,
								type:"post",
								data:{"jcaptchaInput":jcaptchaInput},
								datatype:"json",
								success:function(msg){
								   if(msg == "false"){
									   $("#jcaptchaImgBody .errorItem").show();
										result = false;
								   }else{
										$("#jcaptchaImgBody .errorItem").hide();
								   }
								   
								   return result;
								}
							});  */
							if (jcaptchaInput === "") {
								
								$("#jcaptchaImgBody .errorItem").show();
								if(!$("#jcaptchaImgBody .errorItem")[0]){
									$("#jcaptchaImgBody .valid-msg").show();
								}
								result = false;
							} else {
								$("#jcaptchaImgBody .errorItem").hide();
								$("#jcaptchaImgBody .valid-msg").hide();
							}
						}

						return result;

					}

					//上下页去掉验证码验证
					function validateForms_2() {
						var result = true;
						var surveyQuItemBodys = $(".li_surveyQuItemBody");
						var firstError = null;
						$.each(surveyQuItemBodys, function() {
							var quItemBody = $(this);
							if (!validateCheck(quItemBody, true)) {
								//定位到这题 
								if (firstError == null) {
									firstError = quItemBody;
								}
								result = false;
							}
							// || quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"
						});
						if (firstError != null) {
							$(window).scrollTop(firstError.offset().top);
						}
						return result;
					}

					function validateCheck(quItemBody, isSubForm) {

						//如果是可见的

						if (quItemBody.is(":visible")) {

							var quId = quItemBody.find(".quId").val();
							var quType = quItemBody.find(".quType").val();
							var isRequired = quItemBody.find(".isRequired")
									.val();
							var isSlider_2 = quItemBody.find(".isSlider")
									.val();
							var isScoreInput_2=quItemBody.find(".isScoreInput")
							.val();
							
							var validateStatus = false;

							if (isRequired === "0") {
								validateStatus = true;
								return true;
							}

							if (quType === "RADIO") {
								
								validateStatus = quItemBody
										.find("input[type='radio']:checked")[0];
							} else if (quType === "CHECKBOX") {
								
								var minNum=quItemBody.find(".minNum").val();
								if(minNum == "1" || minNum== undefined || minNum == ""){
									validateStatus = quItemBody
									.find("input[type='checkbox']:checked")[0];
								}else{
									var temp=quItemBody
									.find("input[type='checkbox']:checked");
									if(parseInt(temp.length) < parseInt(minNum)){
										validateStatus = false;
									}else{
										validateStatus = true;
									}
								}
								
							} else if (quType === "FILLBLANK") {
								var fillblankInput_Object = quItemBody
										.find(".fillblankInput");
								var checkType = quItemBody.find(
										".checkType").val();
								var fillblankInput = quItemBody.find(
										".fillblankInput").val();

								var flag = true;
								if (checkType == "EMAIL") {
									flag = email.test(fillblankInput);
								} else if (checkType == "UNSTRCN") {
									flag = unstrcn.test(fillblankInput);
								} else if (checkType == "STRCN") {
									flag = strcn.test(fillblankInput);
								} else if (checkType == "NUM") {
									flag = num.test(fillblankInput);
								} else if (checkType == "TELENUM"
										|| checkType == "PHONENUM"
										|| checkType == "TELE_PHONE_NUM") {
									flag = telenum.test(fillblankInput);
								} else if (checkType == "DATE") {
									flag = ((date.test(fillblankInput) | date_2
											.test(fillblankInput))) ? true
											: false;
								} else if (checkType == "IDENTCODE") {
									flag = identcode.test(fillblankInput);
								} else if (checkType == "ZIPCODE") {
									flag = zipcode.test(fillblankInput);
								} else if (checkType == "URL") {
									flag = url.test(fillblankInput);
								} else {

								}
								/*  if(fillblankInput_Object.is("visible")){
								  if(quItemBody.find(".fillblankInput").val() !=""){
									  validateStatus=flag;	 
								  }else{
									  validateStatus=false;
								  }
								 
								 }	else{
								  validateStatus=true;
								 } */
								if (fillblankInput_Object.is(":visible")) {
									validateStatus = (quItemBody.find(
											".fillblankInput").val() != "" && flag);
								} else {
									validateStatus = true;
								}

								//validateStatus=validateStatus | fillblankInput_Object.is("visible");
								//  alert(validateStatus);
								//flag=(flag | !fillblankInput_Object.is(":visible"));
							} else if (quType === "ORDERQU") {
								//quItemBody.find(".quOrderByLeftUl label");
								validateStatus = !quItemBody
										.find(".quOrderByLeftUl label")[0];
							} else if (quType === "SCORE") {

								validateStatus = true;
								var quScoreOptionTrs = quItemBody.find(".quScoreOptionTr");
								$.each(quScoreOptionTrs,function() {
													var scoreNumInput = $(this).find(".scoreNumInput");
													if (scoreNumInput.val() === ""
															&& scoreNumInput.is(":visible")) {
														validateStatus = false;
														return false;
													}
												});

								var isSlider = quItemBody.find(".isSlider").val();
								var isScoreInput=quItemBody.find(".isScoreInput").val();
								if (isSlider == 1) {
									var nowSliderLength = quItemBody.find(
											".nowSliderLength_"+quId).text();
									var totalSliderLength = quItemBody.find(".totalSliderLength").text();
									
									if (parseInt(nowSliderLength) > parseInt(totalSliderLength)) {
										 validateStatus = false;
									}
								}
								
								if(isScoreInput== 1){
									var nowScore = quItemBody.find(".isScoreInputText");
									var totalSliderLength = quItemBody.find(".totalSliderLength").val();
									var totalScore = 0;
									$.each(nowScore,function(){
										var nowScoreval=$(this).val();
										
										var maxSliderLength = quItemBody.find(".maxSliderLength").val();
										var minSliderLength = quItemBody.find(".minSliderLength").val();
										totalScore += parseInt(nowScoreval);
										if ((parseInt(nowScoreval) > parseInt(totalSliderLength)) || (parseInt(nowScoreval) < parseInt(minSliderLength)) || (parseInt(nowScoreval) > parseInt(maxSliderLength))) {
											if(nowScore.is(":visible")){
												validateStatus = false;
												return  false;
											}else{
												validateStatus = true;
											}
											
										}
									})
									
									if(totalScore > parseInt(totalSliderLength)){
										validateStatus = false;
									}
									
									
									
								}
								

							} else if (quType === "MULTIFILLBLANK") {

								validateStatus = true;
								var quScoreOptionTrs = quItemBody
										.find(".mFillblankTableTr");
								var paramInit01 = quItemBody.find(
										".paramInit01").val();
								var totalResult = 0;
								$.each(quScoreOptionTrs,
												function() {
													var scoreNumInput = $(
															this)
															.find(
																	".dwMFillblankInput");
													if (scoreNumInput.val() != ""
															&& scoreNumInput
																	.is(":visible")) {
														//validateStatus=false;
														//return false;
														totalResult += 1;
													}
												});
								if (totalResult < paramInit01) {
									validateStatus = false;
									//return false;
								}

							} else if (quType === "CHENRADIO") {
								validateStatus = true;
								var quScoreOptionTrs = quItemBody
										.find(".dwQuCoChenRowTr");
								$.each(quScoreOptionTrs, function() {
									var tempInputs = $(this).find(
											"input[type='radio']:checked");
									if (!tempInputs[0]) {
										validateStatus = false;
										return false;
									}
								});
							} else if (quType === "CHENCHECKBOX") {
								validateStatus = true;
								var quScoreOptionTrs = quItemBody
										.find(".dwQuCoChenRowTr");
								$
										.each(
												quScoreOptionTrs,
												function() {
													var tempInputs = $(this)
															.find(
																	"input[type='checkbox']:checked");
													if (!tempInputs[0]) {
														validateStatus = false;
														return false;
													}
												});
							} else if (quType === "CHENSCORE") {
								var quChenScores = quItemBody
										.find(".quChenScoreSelect");
								validateStatus = true;
								$.each(quChenScores, function() {
									var tempInputs = $(this);
									var maxSliderLength=quItemBody.find(".maxSliderLength").val();
									var minSliderLength=quItemBody.find(".minSliderLength").val();
									
									if(parseInt(tempInputs.val()) < parseInt(minSliderLength) || parseInt(tempInputs.val()) > parseInt(maxSliderLength) ){
										if(tempInputs.is(":visible")){
											validateStatus = false;
											return false;
										}else{
											validateStatus = true;
										}
										
									}
									
								});

							} else if (quType === "CHENFBK") {
								var dwCMFBKs = quItemBody
										.find(".dwChenMFillblankInput");
								validateStatus = true;
								$.each(dwCMFBKs, function() {
									var tempInputs = $(this);
									if (tempInputs.val() === ""
											&& tempInputs.is(":visible")) {
										validateStatus = false;
										return false;
									}
								});
							} else if (quType === "submitSurveyBtn"
									|| quType === "PARAGRAPH"
									|| quType === "PAGETAG") {
								return true;
							}

						} else {
							validateStatus = true;
						}

						if (validateStatus) {
							quItemBody.find(".errorItem").remove();
						} else {
							if (isSubForm
									&& !quItemBody.find(".errorItem")[0]) {

								var errorHtml;
								var quType = quItemBody.find(".quType")
										.val();
								var fillblankInput = quItemBody.find(
										".fillblankInput").val();
								var minNum=quItemBody.find(".minNum").val();
								if (quType == "FILLBLANK") {

									if (fillblankInput == ""
											&& quItemBody.find(
													".fillblankInput").is(
													":visible")) {
										errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">请检查题目答案，为必答项！</label></div>";
									} else {
										errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">录入格式有误！</label></div>";
									}

								} else if(quType=="CHECKBOX" && parseInt(minNum) > 1){
									errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">请选择至少"+minNum+"项！</label></div>";
									
								}else if (quType == "SCORE"
										&& isSlider_2 == 1) {
									var minSliderLength=quItemBody.find(".minSliderLength").val();
									var maxSliderLength=quItemBody.find(".maxSliderLength").val();
									var totalSliderLength=quItemBody.find(".totalSliderLength").val();
									errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">允许数值在"+minSliderLength+"和"+maxSliderLength+"之间，总值不超过"+totalSliderLength+"</label></div>";
								}else if(quType == "SCORE"
									&& isScoreInput == 1){
									var minSliderLength=quItemBody.find(".minSliderLength").val();
									var maxSliderLength=quItemBody.find(".maxSliderLength").val();
									var totalSliderLength=quItemBody.find(".totalSliderLength").val();
									errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">允许数值在"+minSliderLength+"和"+maxSliderLength+"之间，总值不超过"+totalSliderLength+"</label></div>";
								}
								
								else if(quType == "CHENSCORE") {
									
									var maxSliderLength=quItemBody.find(".maxSliderLength").val();
									var minSliderLength=quItemBody.find(".minSliderLength").val();
									errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">允许数值在"+minSliderLength+"和"+maxSliderLength+"之间</label></div>";
								} else if(quType == "MULTIFILLBLANK"){
									var paramInit01 = quItemBody.find(
									".paramInit01").val();
									var totalResult = 0;
									$
											.each(
													quScoreOptionTrs,
													function() {
														var scoreNumInput = $(
																this)
																.find(
																		".dwMFillblankInput");
														if (scoreNumInput.val() != ""
																&& scoreNumInput
																		.is(":visible")) {
															//validateStatus=false;
															//return false;
															totalResult += 1;
														}
													});
									if (totalResult < paramInit01) {
										errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">请至少回答"+paramInit01+"项！</label></div>";
									}
											
								}
								
								else {
									errorHtml = "<div class=\"errorItem\"><label for=\"\" class=\"error\">请检查题目答案，为必答项！</label></div>";
								}
								quItemBody.find(".quCoItem").append(
										errorHtml);
							}
						}
						return validateStatus;
					}

					/******************************处理题目逻辑设置 **************************************/
					//处理题目逻辑设置 

					/** 答题触发事件 **/

					//初始化 处理默认逻辑跳转为显示，则先隐藏元素
					/* 	var quLogics=$("#dwSurveyQuContent .quLogicItem");
					 $.each(quLogics,function(){
					 var loginItem=$(this);
					 var cgQuItemId=loginItem.find(".cgQuItemId").val();
					 var skQuId=loginItem.find(".skQuId").val();
					 var logicId=loginItem.find(".logicId").val();
					 var logicType=loginItem.find(".logicType").val();
					
					 if(logicType==="2"){
					 //逻辑类型为“显示”2  则初始化为隐藏
					 var hidQuItemBody=$(".quId[value='"+skQuId+"']").parents(".li_surveyQuItemBody");
					 hidQuItemBody.hide();
					 hidQuItemBody.addClass("hidFor"+logicId);
					 hidQuItemBody.find(".answerTag").attr("disabled",true);
					 }
					 }); */

					//初始化 处理默认逻辑跳转为显示，则先隐藏元素 --初始化逻辑--新--彭金龙--2018--20
					var quLogics = $("#dwSurveyQuContent .quLogicItem");
					$.each(quLogics, function() {

						var loginItem = $(this);
						var cgQuItemId = loginItem.find(".cgQuItemId")
								.val();
						var skQuId = loginItem.find(".skQuId").val();
						var logicId = loginItem.find(".logicId").val();
						var logicType = loginItem.find(".logicType").val();

						//如果存在逻辑的话
						if (cgQuItemId != "" && cgQuItemId != null
								&& logicType == "2") {
							var hidQuItemBody = loginItem
									.parents(".li_surveyQuItemBody");
							hidQuItemBody.hide();
							hidQuItemBody.find(".answerTag").attr(
									"disabled", true);
						}
					})

					function runlogic_2(obj) {

						//获得所有的逻辑选项中存在这个id的选项;
						var thisQuestionItem = obj
								.parents(".li_surveyQuItemBody");

						//找到所有存在逻辑的题
						var nextQuestionItem = thisQuestionItem.nextAll(".li_surveyQuItemBody").has(".quLogicItem");

						$.each(nextQuestionItem,function() {
											var tempQestionItem = $(this);
											var quType = tempQestionItem
													.find(".quType").val();
											var ckQuId = tempQestionItem
													.find(".quId").val();
											var quLogicitem = tempQestionItem
													.find(".quLogicItem");
											var logicType = tempQestionItem
													.find(".logicType")
													.val();

											//找到这个题目是否含有传过来的选项id --
											if (quLogicitem[0]) {
												//zhao到这个逻辑
												//	quLogicitem=tempQestionItem.find(".quLogicItem").eq(0);

												//判断逻辑是否存在

												var cgQuItemId = quLogicitem
														.find(".cgQuItemId")
														.eq(0).val();
												var ckquItemId = quLogicitem
														.find(".ckQuItemId")
														// .eq(0).val()
														.val()
														.replace(new RegExp(":","g"), "_");
												var target;
												var targets = [];

												//找到ckquItemId对应的选项
												if (logicType == "3") {
													//隐藏选中的选项
													//不同题型的不同操作
													//1
													if (quType == 'RADIO') {
														if(ckquItemId !== 'nochoose') {
															var ids = ckquItemId.split(',');
															ids.forEach((id) => {
																targets.push(tempQestionItem
																		.find(
																				"input[name='text_qu_RADIO_"
																				+ ckQuId
																				+ "_"
																				+ id
																				+ "']")
																		.parents(
																				".quCoItemUlLi"))
															})
														}
														// target = tempQestionItem
														// 		.find(
														// 				"input[name='text_qu_RADIO_"
														// 						+ ckQuId
														// 						+ "_"
														// 						+ ckquItemId
														// 						+ "']")
														// 		.parents(
														// 				".quCoItemUlLi");
													} else if (quType == 'CHECKBOX') {
														if(ckquItemId !== 'nochoose') {
															var ids = ckquItemId.split(',');
															ids.forEach((id) => {
																targets.push(tempQestionItem
																		.find(
																				"input[name='tag_qu_CHECKBOX_"
																				+ ckQuId
																				+ "_"
																				+ id
																				+ "']")
																		.parents(
																				".quCoItemUlLi"))
															})
														}
														//1
														// target = tempQestionItem
														// 		.find(
														// 				"input[name='tag_qu_CHECKBOX_"
														// 						+ ckQuId
														// 						+ "_"
														// 						+ ckquItemId
														// 						+ "']")
														// 		.parents(
														// 				".quCoItemUlLi");
													} else if (quType == 'SCORE') {
														if(ckquItemId !== 'nochoose') {
															var ids = ckquItemId.split(',');
															ids.forEach((id) => {
																targets.push(tempQestionItem
																		.find(
																				"input[name='item_qu_SCORE_"
																				+ ckQuId
																				+ "_"
																				+ id
																				+ "']")
																		.parents(
																				".quScoreOptionTr"))
															})
														}
														//1
														// target = tempQestionItem
														// 		.find(
														// 				"input[name='item_qu_SCORE_"
														// 						+ ckQuId
														// 						+ "_"
														// 						+ ckquItemId
														// 						+ "']")
														// 		.parents(
														// 				".quScoreOptionTr");
													} else if (quType == 'MULTIFILLBLANK') {
														if(ckquItemId !== 'nochoose') {
															var ids = ckquItemId.split(',');
															ids.forEach((id) => {
																targets.push(tempQestionItem
																		.find(
																				"input[name='text_qu_MULTIFILLBLANK_"
																				+ ckQuId
																				+ "_"
																				+ id
																				+ "']")
																		.parents(
																				".mFillblankTableTr"))
															})
														}
														//1
														// target = tempQestionItem
														// 		.find(
														// 				"input[name='text_qu_MULTIFILLBLANK_"
														// 						+ ckQuId
														// 						+ "_"
														// 						+ ckquItemId
														// 						+ "']")
														// 		.parents(
														// 				".mFillblankTableTr");
													} else if (quType == 'CHENFBK') {
														if(ckquItemId !== 'nochoose') {
															var ids = ckquItemId.split(',');
															ids.forEach((id) => {
																targets.push(tempQestionItem
																		.find(
																				"input[name='fbk_item_qu_CHENFBK_"
																				+ ckQuId
																				+ "_"
																				+ id
																				+ "']")
																		.parents(
																				".dwQuChenFbkOptionItemContent"))
															})
														}
														//1
														// target = tempQestionItem
														// 		.find(
														// 				"input[name='fbk_item_qu_CHENFBK_"
														// 						+ ckQuId
														// 						+ "_"
														// 						+ ckquItemId
														// 						+ "']")
														// 		.parents(
														// 				".dwQuChenFbkOptionItemContent");
													} else if (quType == 'CHENRADIO') {

														//1
														var temp = tempQestionItem
																.find(".dwChenInputTemp");

														$
																.each(
																		temp,
																		function() {
																			var thisTemp = $(this);
																			var tempVal = thisTemp
																					.val()
																					.replace(
																							":",
																							"_");
																			if (tempVal == ckquItemId) {
																				target = thisTemp
																						.parents(".dwQuOptionItemContent");
																			}
																		})

													} else if (quType == 'CHENCHECKBOX') {

														//1
														var temp = tempQestionItem
																.find(".dwChenInputTemp");
														$
																.each(
																		temp,
																		function() {
																			var thisTemp = $(this);
																			var tempVal = thisTemp
																					.val()
																					.replace(
																							":",
																							"_");
																			if (tempVal == ckquItemId) {
																				target = thisTemp
																						.parents(".dwQuOptionItemContent");
																			}
																		})
													} else if (quType == 'CHENSCORE') {

														//1
														var temp = tempQestionItem
																.find(".dwChenInputTemp");
														$
																.each(
																		temp,
																		function() {
																			var thisTemp = $(this);
																			var tempVal = thisTemp
																					.val()
																					.replace(
																							":",
																							"_");
																			if (tempVal == ckquItemId) {
																				target = thisTemp
																						.parents(".dwQuScoreOptionItemContent");
																			}
																		})
													} else if (quType == 'FILLBLANK') {
														target = tempQestionItem
																.find(".quFillblankItem");
													} else if(quType= "ORDERQU") {
														if(ckquItemId !== 'nochoose') {
															var ids = ckquItemId.split(',');
															var temp=tempQestionItem.find(".quOrderItemHidInput");
															$.each(temp,function(){
																var thisTemp = $(this);
																var thisTempName=thisTemp.attr("name");
																ids.forEach((id) => {
																	if(thisTempName == "item_qu_ORDERQU_"+ckQuId+"_"+id){
																		targets.push($(this).parent().parent())
																	}

																})

															})

														}
														//填空
													    // var temp=tempQestionItem.find(".quOrderItemHidInput");
														// $.each(temp,function(){
														// 	var thisTemp = $(this);
														// 	var thisTempName=thisTemp.attr("name");
														// 	if(thisTempName == "item_qu_ORDERQU_"+ckQuId+"_"+ckquItemId){
														// 		target=$(this).parent().parent();
														// 	}
														// })
													}

												}
												//找到这个题目是否含有传过来的选项id 结束--
												var skQuId = quLogicitem
														.find(".skQuId")
														.eq(0).val();
												var geLe = quLogicitem
														.find(".geLe")
														.eq(0).val();
												var eqAndNq = quLogicitem
												.find(".eqAndNq")
											    .eq(0).val();
												var scoreNum = quLogicitem
														.find(".scoreNum")
														.eq(0).val();
												var logicType = quLogicitem
														.find(".logicType")
														.eq(0).val();
												if (cgQuItemId != null
														&& cgQuItemId != "") {

													//判断是单个逻辑还是多个逻辑
													if (cgQuItemId
															.indexOf("_ad_") != -1) {
														var cgQuItemIdArray = new Array();
														var skQuIdArray = new Array();
														var geLeArray = new Array();
														var scoreNumArray = new Array();
														var eqAndNqArray=new Array();
														var logicflag = "1";
														cgQuItemIdArray = cgQuItemId
																.split("_ad_");
														skQuIdArray = skQuId
																.split("_ad_");
														eqAndNqArray =eqAndNq.split("_ad_");
														
														if (geLe != undefined) {
															geLeArray = geLe
																	.split("_ad_");
															scoreNumArray = scoreNum
																	.split("_ad_");
														}
														var total_condition = 0;

														//获得本题有多少个选项在逻辑中存在

														for (var i = 0; i < cgQuItemIdArray.length; i++) {

															//所有的题型分类 CHENCHECKBOX --矩阵多选题  --判断过了
															//CHENRADIO --矩阵单选题    --判断过了
															//ORDERQU --排序题
															//CHENFBK 矩阵填空题    --判断过了
															//CHENSCORE 矩阵评分题  
															//MULTIFILLBLANK 多项填空题   --判断过了
															//FILLBLANK 单项填空题    --判断过了
															//SCORE 评分题     --判断过了
															//CHECKBOX 多选题   --判断过了
															//RADIO 单选题       --判断过了
															var skQuId_temp = skQuIdArray[i];
															var ckQuId_temp = cgQuItemIdArray[i];
															var geLe_temp = geLeArray[i];
															var eqAndNq=eqAndNqArray[i];
															var score_temp = scoreNumArray[i];
															var score_temp_length = 0;
															
															//??
															for (var j = 0; j < skQuIdArray.length; j++) {
																if (skQuId_temp == skQuIdArray[j]) {
																	score_temp_length++;
																}
															}

															total_condition = runLogic_method_2(
																	skQuId_temp,
																	ckQuId_temp,
																	geLe_temp,
																	score_temp,
																	total_condition,
																	logicflag,
																	score_temp_length,
																	eqAndNq);
														}

														//说明逻辑吻合
														if (total_condition == cgQuItemIdArray.length) {
															//跳转逻辑
															if (logicType == "2") {
																
																//如果下个类型我是分页的话就不显示，翻到下一页时会重新执行逻辑条件
														   var  pagetagQestionItem=tempQestionItem.prevAll(".li_surveyQuItemBody:visible").has("input[value$='PAGETAG']");
																
														   var pageNowObject=$(".li_surveyQuItemBody:visible").has("input[name='nextPageNo']").find("input[name='nextPageNo']");
														   var pageNow=parseInt(pageNowObject.val())-1;	
											
																if (tempQestionItem
																		.is(":hidden") && (pagetagQestionItem ==null||pagetagQestionItem == undefined ||pagetagQestionItem.length == 0  )
																		&& "li_surveyQuItemBody surveyQu_"+pageNow ==tempQestionItem.attr("class")	) {
																	tempQestionItem
																			.show();
																}
															}

															if (logicType == "3") {
																// target.hide();
																// tempQestionItem
																// 		.hide();
																if(ckquItemId !== 'nochoose') {
																	console.log('targets',targets)
																	if(target) {
																		target.hide()
																	}else{
																		targets.forEach((item) => {
																			item.hide()
																		})
																	}
																}else{
																	tempQestionItem
																			.hide();
																}
															}
															
															if(logicType == "4"){
																tempQestionItem
																.hide();
															}

														} else {
                                                               
															//不满足条件却在下一页或者下几页
															if (logicType == "2") {
																tempQestionItem
																		.hide();
															}

															if (logicType == "3") {
																// target.show();
																// tempQestionItem
																// 		.show();
																if(ckquItemId !== 'nochoose') {
																	console.log('targets',targets)
																	if(target) {
																		target.show()
																	}else{
																		targets.forEach((item) => {
																			item.show()
																		})
																	}

																}else{
																	tempQestionItem
																			.show();
																}
															}
															
															if(logicType == "4"){
																 var  pagetagQestionItem=tempQestionItem.prevAll(".li_surveyQuItemBody:visible").has("input[value$='PAGETAG']");
																	
																   var pageNowObject=$(".li_surveyQuItemBody:visible").has("input[name='nextPageNo']").find("input[name='nextPageNo']");
																   var pageNow=parseInt(pageNowObject.val())-1;	
													
																		if (tempQestionItem
																				.is(":hidden") && (pagetagQestionItem ==null||pagetagQestionItem == undefined ||pagetagQestionItem.length == 0  )
																				&& "li_surveyQuItemBody surveyQu_"+pageNow ==tempQestionItem.attr("class")	) {
																			tempQestionItem
																					.show();
																		}
															}

														}
													} else {

														//只有一个条件
														var skQuId_temp = skQuId;
														var ckQuId_temp = cgQuItemId;
														var eqAndNq_temp=eqAndNq;
														var geLe_temp = geLe;
														var score_temp = scoreNum;
														var total_condition = 0;
														var logicflag = "0";
														var score_temp_length = 1;
														total_condition = runLogic_method_2(
																skQuId_temp,
																ckQuId_temp,
																geLe_temp,
																score_temp,
																total_condition,
																logicflag,
																score_temp_length,
																eqAndNq_temp);
														if (total_condition == "1") {

															if (logicType == "2") {
														   //判断当前的题是不是最后一道题
															var  pagetagQestionItem=tempQestionItem.prevAll(".li_surveyQuItemBody:visible").has("input[value$='PAGETAG']");
									                       
														  //判断逻辑满足的这道题是不是在本页
														    var pageNowObject=$(".li_surveyQuItemBody:visible").has("input[name='nextPageNo']").find("input[name='nextPageNo']");
														    var pageNow=parseInt(pageNowObject.val())-1;
														  //需要去判断这道题是否是当前的题目  
														   if (tempQestionItem
																		.is(":hidden")  && (pagetagQestionItem ==null||pagetagQestionItem == undefined ||pagetagQestionItem.length == 0  )
																	&& "li_surveyQuItemBody surveyQu_"+pageNow ==tempQestionItem.attr("class") 	) {
																	tempQestionItem
																			.show();
																}
															}

															if (logicType == "3") {
																// target.hide();
																// tempQestionItem
																// 		.hide();
																if(ckquItemId !== 'nochoose') {
																	console.log('targets',targets)
																	if(target) {
																		target.hide()
																	}else{
																		targets.forEach((item) => {
																			item.hide()
																		})
																	}
																}else{
																	tempQestionItem
																			.hide();
																}
															}
															
															if(logicType == "4"){
																tempQestionItem
																.hide();
															}
														} else {
															if (logicType == "2") {
																tempQestionItem
																		.hide();
															}

															if (logicType == "3") {
																// target
																// 		.show();
																// tempQestionItem
																// 		.show();
																if(ckquItemId !== 'nochoose') {
																	console.log('targets',targets)
																	if(target) {
																		target.show()
																	}else{
																		targets.forEach((item) => {
																			item.show()
																		})
																	}
																}else{
																	tempQestionItem
																			.show();
																}
															}
															
															if(logicType == "4"){
																 var  pagetagQestionItem=tempQestionItem.prevAll(".li_surveyQuItemBody:visible").has("input[value$='PAGETAG']");
																	
																   var pageNowObject=$(".li_surveyQuItemBody:visible").has("input[name='nextPageNo']").find("input[name='nextPageNo']");
																   var pageNow=parseInt(pageNowObject.val())-1;	
													
																		if (tempQestionItem
																				.is(":hidden") && (pagetagQestionItem ==null||pagetagQestionItem == undefined ||pagetagQestionItem.length == 0  )
																				&& "li_surveyQuItemBody surveyQu_"+pageNow ==tempQestionItem.attr("class")	) {
																			tempQestionItem
																					.show();
																		}
															}

														}
													}

												} else {
													return false;
												}
											}
										});

					}
                           function runLogic_method_2(skQuId_temp, ckQuId_temp,
							geLe_temp, score_temp, total_condition,
							logicflag, score_temp_length,eqAndNq_temp) {
						
					//现在的逻辑都是或逻辑能实现一个就可以判断通过
					//score_temp_length是用来做单选题的或判断的不用去掉
					var skQuId_temp_array =skQuId_temp.split("_or_");
					var eqAndNq_temp_array =eqAndNq_temp.split("_or_");
					var ckQuId_temp_array=ckQuId_temp.split("_or_");
					var geLe_temp_array=geLe_temp.split("_or_");
					var score_temp_array=score_temp.split("_or_");
					
					for(var i=0;i<skQuId_temp_array.length;i++){
						var skQuId_temp_array_temp=skQuId_temp_array[i];
						var ckQuId_temp_array_temp=ckQuId_temp_array[i];
						var geLe_temp_array_temp=geLe_temp_array[i];
						var score_temp_array_temp=score_temp_array[i];
						var eqAndNq_temp_array_temp=eqAndNq_temp_array[i];
						var count=runLogic_method(skQuId_temp_array_temp,
								ckQuId_temp_array_temp,geLe_temp_array_temp,
								score_temp_array_temp,0,logicflag,score_temp_length,eqAndNq_temp_array_temp);
						if(count > 0){
							total_condition+=count;
							break;
						}
						
					}	
					
				   return total_condition;
						
                             }
					function runLogic_method(skQuId_temp, ckQuId_temp,
							geLe_temp, score_temp, total_condition,
							logicflag, score_temp_length,eqAndNq_temp) {
                         
						//在拿到的字符串中都是或逻辑或者没有或逻辑
						var question_temp = $(".li_surveyQuItemBody").has(
								"input[value$='" + skQuId_temp + "']");
						//在逻辑里的一道题

						//判断题目的类型
						var quType_temp = question_temp.find(".quType")
								.val();

						//说明是在题目上的逻辑只要判断对应事件是否触发
						if (skQuId_temp == ckQuId_temp) {

							//检查是否已经触发事件
							if ("RADIO" === quType_temp
									|| "CHECKBOX" == quType_temp
									|| "CHENRADIO" === quType_temp
									|| "CHENCHECKBOX" === quType_temp) {
								var dwQuInputLabel = question_temp
										.find(".dwQuInputLabel");
								$.each(
												dwQuInputLabel,
												function() {
													var dwQuInputLabelTemp = $(this);
													var label_temp_class = dwQuInputLabelTemp
															.prop("className");
												
													if (label_temp_class
															.indexOf("checked") != -1) {
														total_condition++;
														return false;
													}
											})
							} else if ("FILLBLANK" === quType_temp) {
								var question_item_temp = question_temp
										.find(".fillblankInput");
								var question_item_temp_val = question_item_temp
										.val();
								var question_item_temp_val_length = question_item_temp_val.length;
								if (question_item_temp_val_length != 0) {
									total_condition++;
								}
							} else if ("MULTIFILLBLANK" === quType_temp) {
								var dwMFillblankInput = question_temp
										.find(".dwMFillblankInput");
								$
										.each(
												dwMFillblankInput,
												function() {
													var dwMFillblankInputTemp = $(this);
													if (dwMFillblankInputTemp
															.val().length != 0) {
														total_condition++;
														return false;
													}
												})
							} else if ("CHENFBK" === quType_temp) {

					

								var dwChenMFillblankInput = question_temp
										.find(".dwChenMFillblankInput");
								$
										.each(
												dwChenMFillblankInput,
												function() {
													var dwChenMFillblankInputTemp = $(this);
													if (dwChenMFillblankInputTemp
															.val().length != 0) {
														total_condition++;
														return false;
													}
												})
							} else if ("SCORE" === quType_temp) {
								var scoreNumInput = question_temp
										.find(".scoreNumInput");
								scoreNumInput
										.each(function() {
											var scoreNumInputTemp = $(this);
											var scoreNumInputTempVal = scoreNumInputTemp
													.val();
											if (parseInt(scoreNumInputTempVal) > 0) {
												total_condition++;
												return false;
											}
										})
							} else if ("CHENSCORE" === quType_temp) {
								var quChenScoreSelect=question_temp.find(".quChenScoreSelect");
								$.each(quChenScoreSelect,function(){
									var quChenScoreSelectTemp=$(this);
									var quChenScoreSelectTempVal=quChenScoreSelectTemp.val();
									if(parseInt(quChenScoreSelectTempVal) > 0){
										total_condition++;
										return false;
									}
									
								})
							} else {

							}
						} else {

							//过滤的单选题的或逻辑
							if ("RADIO" === quType_temp
									|| "CHECKBOX" == quType_temp) {
								var question_item_temp = question_temp
										.find("input[value$='" + ckQuId_temp
												+ "']");
								var label_temp = question_item_temp.prev();
								//判断是不是按行分，按行分可能会修改dom结构
								var label_temp_class = label_temp
										.prop("className");
								//checked 如果已经有选中的则也要加上本题存在的length;
                                             if(eqAndNq_temp == "1"){
                                            	 if(label_temp_class.indexOf("checked") != -1){
											if ("RADIO" === quType_temp) {
												total_condition += score_temp_length;
											} else {
												total_condition++;
											}	
										} 
                                             }else{
                                            	 //获得所有的标记元素
                                                var dwQuInputLabel = question_temp
										.find(".dwQuInputLabel");
								      $.each(
												dwQuInputLabel,
												function() {
													var dwQuInputLabelTemp = $(this);
													var label_temp_class = dwQuInputLabelTemp
															.prop("className");
												   
													if (label_temp_class
															.indexOf("checked") != -1 &&(dwQuInputLabelTemp.is(label_temp) == false) &&(label_temp.prop("className").indexOf("checked") == -1)) {
														if ("RADIO" === quType_temp) {
 															total_condition += score_temp_length;
 														} else {
 															total_condition++;
 														}	
														return false;
													}
											}) 
                                            	 
                                             }
									

							} else if ("CHENRADIO" === quType_temp
									|| "CHENCHECKBOX" === quType_temp) {
								ckQuId_temp = ckQuId_temp.replace(";", ":");
								var question_item_temp = question_temp
										.find("input[value='" + ckQuId_temp
												+ "']");
								var label_temp = question_item_temp.prev();
								var label_temp_class = label_temp
										.prop("className");
								//checked
							  if(eqAndNq_temp == "1"){
								  if (label_temp_class.indexOf("checked") != -1) {
										if ("CHENRADIO" === quType_temp) {
											total_condition += score_temp_length;
										} else {
											total_condition++;
										}

									} 
							  }	else {
								  var dwQuInputLabel = question_temp
									.find(".dwQuInputLabel");
							$.each(
											dwQuInputLabel,
											function() {
												var dwQuInputLabelTemp = $(this);
												var label_temp_class = dwQuInputLabelTemp
														.prop("className");
											
												if (label_temp_class
														.indexOf("checked") != -1 && (dwQuInputLabelTemp.is(label_temp) == false) &&(label_temp.prop("className").indexOf("checked") == -1)) {
													total_condition++;
													return false;
												}
							  })
							  }
								
							} else if ("FILLBLANK" === quType_temp) {

								var question_item_temp = question_temp
										.find(".fillblankInput");
								var question_item_temp_val = question_item_temp
										.val();
								var question_item_temp_val_length = question_item_temp_val.length;
								//说明是拒答逻辑
								if (ckQuId_temp == "0") {
                                        if(eqAndNq_temp == "1"){
                                       	 if (question_item_temp_val_length == 0) {
												total_condition++;
											} 
                                        }else{
                                       	 if (question_item_temp_val_length > 0) {
												total_condition++;
											} 
                                        }
									
								} else {
									//说明是回答逻辑
									if(eqAndNq_temp == "1"){
										if (question_item_temp_val_length > 0) {
											total_condition++;
										}	
									}else{
										 if (question_item_temp_val_length == 0) {
												total_condition++;
											} 
									}
									
								}
							} else if ("MULTIFILLBLANK" === quType_temp) {
								
								var question_item_temp = question_temp
										.find("input[name='text_qu_MULTIFILLBLANK_"
												+ skQuId_temp
												+ "_"
												+ ckQuId_temp + "']");
								var question_item_temp_val = question_item_temp
										.val();
								var question_item_temp_val_length = question_item_temp_val.length;
								
								if(eqAndNq_temp == "1"){
									if (question_item_temp_val_length > 0) {
										total_condition++;
									}
								}else{
									
									var dwMFillblankInput = question_temp
									.find(".dwMFillblankInput");
									$
									.each(
											dwMFillblankInput,
											function() {
												var dwMFillblankInputTemp = $(this);
												if (dwMFillblankInputTemp
														.val().length != 0 && (dwMFillblankInputTemp.is(question_item_temp) == false) && (question_item_temp.val().length == 0)) {
													total_condition++;
													return false;
												}
											})
								}
								
							} else if ("CHENFBK" === quType_temp) {
								ckQuId_temp = ckQuId_temp.replace(";", "_");
								var question_item_temp = question_temp
										.find("input[name='fbk_item_qu_CHENFBK_"
												+ skQuId_temp
												+ "_"
												+ ckQuId_temp + "']");
								var question_item_temp_val = question_item_temp
										.val();
								var question_item_temp_val_length = question_item_temp_val.length;
								
								if(eqAndNq_temp == "1"){
									if (question_item_temp_val_length > 0) {
										total_condition++;
									}
								}else{
									var dwChenMFillblankInput = question_temp
									.find(".dwChenMFillblankInput");
							$
									.each(
											dwChenMFillblankInput,
											function() {
												var dwChenMFillblankInputTemp = $(this);
												if (dwChenMFillblankInputTemp
														.val().length != 0 && (dwChenMFillblankInputTemp.is(question_item_temp) == false) && (question_item_temp.val().length == 0) ) {
													total_condition++;
													return false;
												}
											})
								}
							
							} else if ("SCORE" === quType_temp) {

								//获得当前被选中的分数的选项的分数
								var question_item_temp = question_temp
										.find("input[name='item_qu_SCORE_"
												+ skQuId_temp + "_"
												+ ckQuId_temp + "']");
								var question_item_temp_score = question_item_temp
										.val();
								if (geLe_temp == "ge") {
									if(eqAndNq_temp == "1"){
										if (parseInt(score_temp) <= parseInt(question_item_temp_score)) {
											total_condition++;
										}
									}else{
										if (parseInt(score_temp) > parseInt(question_item_temp_score)) {
											total_condition++;
										}
									}
									
								} else {
									
									if(eqAndNq_temp == "1"){
										if (parseInt(score_temp) >= parseInt(question_item_temp_score)) {
											total_condition++;
										}	
									}else{
										if (parseInt(score_temp) < parseInt(question_item_temp_score)) {
											total_condition++;
										}
									}
									
									
								}

							} else if ("CHENSCORE" === quType_temp) {
								ckQuId_temp = ckQuId_temp.replace(";", "_");
								var question_item_temp = question_temp
										.find("input[name='cs_item_qu_CHENSCORE_"
												+ skQuId_temp
												+ "_"
												+ ckQuId_temp + "']");
								var question_item_temp_val = question_item_temp
										.val();

								//说明回答了
								if(eqAndNq_temp == "1"){
									if (parseInt(question_item_temp_val) > 0) {
										total_condition++;
									}
								}else{
									var quChenScoreSelect=question_temp.find(".quChenScoreSelect");
									$.each(quChenScoreSelect,function(){
										var quChenScoreSelectTemp=$(this);
										var quChenScoreSelectTempVal=quChenScoreSelectTemp.val();
										if(parseInt(quChenScoreSelectTempVal) > 0 &&(quChenScoreSelectTemp.is(question_item_temp) == false) &&(parseInt(question_item_temp.val()) <= 0) ){
											total_condition++;
											return false;
										}
										
									})
								}
								
							} else {

							}
						}

						return total_condition;
					}
					/** 单选与多选条件触发 自定义单选多选效果 操作结束后得调用逻辑判断 **/
					/*选项点击后触发  */
					$(".dwQuOptionItemContent")
							.click(
									function() {
										var thObj = $(this);
										var quItemBody = thObj
												.parents(".li_surveyQuItemBody");
										var quId=quItemBody.find(".quId").val();
										var isSelectType=quItemBody.find(".isSelectType").val();
										var quCoOptionEdit=$(this).find(".quCoOptionEdit").text();
										var quType = quItemBody.find(
												".quType").val();
										var dwQuInputLabel = thObj
												.find(".dwQuInputLabel");
										if ("RADIO" === quType) {
											//单选题 将所有的选项的结果设置成空值
											quItemBody.find(
													".dwQuInputLabel")
													.removeClass("checked");
											quItemBody.find(
													"input[type='radio']")
													.prop("checked", false);

											//设置显示标识
											dwQuInputLabel
													.addClass("checked");

											//本选项选中
											thObj.find(
													"input[type='radio']")
													.prop("checked", true);
											
											//
											if(isSelectType == "1"){
												
												$(".dropdownMenu_"+quId).html(quCoOptionEdit+" <span class='caret'><i class='fa fa-angle-down' aria-hidden='true'></i></span>");
												$(".dropdown_ul_"+quId).hide();
											}
										

											//runlogic(thObj.find("input[type='radio']"));
											runlogic_2(thObj
													.find("input[type='radio']"));
										} else if ("CHECKBOX" === quType) {
											//多选题
											//quItemBody.find(".dwQuInputLabel").removeClass("checked");
											//改变显示状态的
											var quInputLabelClass = dwQuInputLabel
													.attr("class");
											if (quInputLabelClass
													.indexOf("checked") > 0) {
												dwQuInputLabel
														.removeClass("checked");
												thObj
														.find(
																"input[type='checkbox']")
														.prop("checked",
																false);
											} else {
												dwQuInputLabel
														.addClass("checked");
												thObj
														.find(
																"input[type='checkbox']")
														.prop("checked",
																true);
											}

											//如果他的前面选项是父选项的话

											//获得当前选项的
											var thObjparent = thObj
													.parent();
											var dwQuInputLabelhidden = thObjparent
													.prevUntil(
															"quCoItemUlLi")
													.has(
															".dwQuInputLabel:hidden")
													.find(
															".dwQuInputLabel:hidden");
											console
													.log(dwQuInputLabelhidden);
											if (dwQuInputLabelhidden[0]) {
												//更新父类的状态
												var quInputLabelClassparent = dwQuInputLabelhidden
														.attr("class");

												if (quInputLabelClass
														.indexOf("checked") > 0) {
													dwQuInputLabelhidden
															.removeClass("checked");
													dwQuInputLabelhidden
															.parent()
															.find(
																	"input[type='checkbox']")
															.prop(
																	"checked",
																	false);
												} else {
													dwQuInputLabelhidden
															.addClass("checked");
													dwQuInputLabelhidden
															.parent()
															.find(
																	"input[type='checkbox']")
															.prop(
																	"checked",
																	true);
												}

												//runlogic(dwQuInputLabelhidden.parent().find("input[type='checkbox']"));
												runlogic_2(thObj);
											} else {
												//runlogic(thObj.find("input[type='checkbox']"));
												runlogic_2(thObj);
											}
											//执行问卷逻辑
										} else if ("CHENRADIO" === quType) {
											//矩陈单选
											var chenRow = thObj
													.parents("tr");
											chenRow.find(".dwQuInputLabel")
													.removeClass("checked");
											chenRow.find(
													"input[type='radio']")
													.prop("checked", false);
											dwQuInputLabel
													.addClass("checked");
											thObj.find(
													"input[type='radio']")
													.prop("checked", true);

											//runlogic(thObj.find("input[type='radio']"));
											runlogic_2(thObj);
										} else if ("CHENCHECKBOX" === quType) {
											//矩陈多选
											var quInputLabelClass = dwQuInputLabel
													.attr("class");
											if (quInputLabelClass
													.indexOf("checked") > 0) {
												dwQuInputLabel
														.removeClass("checked");
												thObj
														.find(
																"input[type='checkbox']")
														.prop("checked",
																false);
											} else {
												dwQuInputLabel
														.addClass("checked");
												thObj
														.find(
																"input[type='checkbox']")
														.prop("checked",
																true);
											}

											//runlogic(thObj.find("input[type='checkbox']"));
											runlogic_2(thObj);
										}

										answerProgressbar(thObj);
										validateCheck(quItemBody, false);
									});

					//填空题
					$(
							".fillblankInput,.dwMFillblankInput,.dwChenMFillblankInput")
							.blur(
									function() {
										//$(this).css("borderColor","#D6D6FF");
										var thObj = $(this);
										var thVal = $(this).val();
										runlogic_2(thObj);
										answerProgressbar($(this));
										validateCheck($(this).parents(
												".li_surveyQuItemBody"),
												false);
									});

					$(".quChenScoreSelect").change(
							function() {
								var thObj = $(this);
								answerProgressbar($(this));
								runlogic_2(thObj);
								validateCheck($(this).parents(
										".li_surveyQuItemBody"), false);

							});

					//只要触发事件--具体的实现逻辑的方法
					function runlogic(thFormElementObj) {
						//thFormElementObj 当前关联的form表单元素
						var quItemBody = thFormElementObj
								.parents(".li_surveyQuItemBody");

						var quLogicItems = quItemBody.find(".quLogicItem");

						if (quLogicItems[0]) {

							var quInputCase = quItemBody
									.find(".quInputCase");
							var quId = quInputCase.find(".quId").val();
							var quType = quInputCase.find(".quType").val();

							//$("input[name='qu_"+quType+"_"+quId+"']").change(function(){});

							if (quType === "RADIO" || quType === "CHECKBOX"
									|| quType === "SCORE"
									|| quType === "MULTIFILLBLANK"
									|| quType === "CHENRADIO"
									|| quType === "CHENCHECKBOX"
									|| quType === "CHENSCORE"
									|| quType === "CHENFBK") {

								//判断是否选中
								var quLgoicItem = null;
								//var thVal=thFormElementObj.val();

								//遍历每个逻辑设置
								var quOptionItems = null;
								if (quType === "RADIO"
										|| quType === "CHECKBOX") {
									quOptionItems = quItemBody
											.find(".dwQuOptionItemContent");
									//thVal=thFormElementObj.val();
								} else if (quType === "SCORE") {
									quOptionItems = quItemBody
											.find(".quScoreOptionTr");
									//thVal=thFormElementObj.text();
								} else if (quType === "MULTIFILLBLANK") {
									quOptionItems = quItemBody
											.find(".mFillblankTableTr");
								} else if (quType === "CHENRADIO"
										|| quType === "CHENCHECKBOX") {
									quOptionItems = quItemBody
											.find(".dwQuOptionItemContent");
								} else if (quType === "CHENFBK") {
									quOptionItems = quItemBody
											.find(".dwQuChenFbkOptionItemContent");
								}

								$
										.each(
												quLogicItems,
												function() {
													var loginItem = $(this);
													var cgQuItemId = loginItem
															.find(
																	".cgQuItemId")
															.val();
													var skQuId = loginItem
															.find(".skQuId")
															.val();
													var logicId = loginItem
															.find(
																	".logicId")
															.val();
													var logicType = loginItem
															.find(
																	".logicType")
															.val();

													var geLe = null;
													var scoreNum = null;

													//如果是积分题，找到积分题的分数
													if (quType === "SCORE") {
														geLe = loginItem
																.find(
																		".geLe")
																.val();
														scoreNum = loginItem
																.find(
																		".scoreNum")
																.val();
													}

													//过滤优先级
													var isbreak = false;
													$
															.each(
																	quOptionItems,
																	function() {
																		var quCoItem = $(this);

																		var quInput = null;
																		var logicStatus = false;
																		var curQuItemId = null;

																		if (quType === "RADIO") {
																			quInput = quCoItem
																					.find("input[type='radio']");
																			logicStatus = quInput
																					.prop("checked");
																			curQuItemId = quInput
																					.val();
																		} else if (quType === "CHECKBOX") {
																			quInput = quCoItem
																					.find("input[type='checkbox']");
																			logicStatus = quInput
																					.prop("checked");
																			curQuItemId = quInput
																					.val();
																		} else if (quType === "SCORE") {
																			quInput = quCoItem
																					.find(".dwScoreOptionId");
																			var curScore = quCoItem
																					.find(
																							".scoreNumInput")
																					.val();
																			if (curScore != "") {
																				logicStatus = (geLe === "le" && curScore <= scoreNum)
																						|| (geLe === "ge" && curScore >= scoreNum);
																			}
																			curQuItemId = quInput
																					.val();
																		} else if (quType === "MULTIFILLBLANK") {
																			quInput = quCoItem
																					.find(".dwMFillblankOptionId");
																			logicStatus = quCoItem
																					.find(
																							".dwMFillblankInput")
																					.val() != "";
																			curQuItemId = quInput
																					.val();
																		} else if (quType === "CHENRADIO") {
																			quInput = quCoItem
																					.find("input[type='radio']");
																			logicStatus = quInput
																					.prop("checked");
																			curQuItemId = quCoItem
																					.find(
																							".dwChenInputTemp")
																					.val();
																		} else if (quType === "CHENCHECKBOX") {
																			quInput = quCoItem
																					.find("input[type='checkbox']");
																			logicStatus = quInput
																					.prop("checked");
																			curQuItemId = quCoItem
																					.find(
																							".dwChenInputTemp")
																					.val();
																		} else if (quType === "CHENFBK") {
																			quInput = quCoItem
																					.find(".dwChenMFillblankInput");
																			logicStatus = quInput
																					.val() != "";
																			curQuItemId = quCoItem
																					.find(
																							".dwChenInputTemp")
																					.val();
																		}

																		if (curQuItemId === cgQuItemId) {

																			if (logicType === "1") {
																				//跳转
																				if (logicStatus) {
																					//逻辑选项被选中状态，激活状态 ,隐藏所有没有被标记跳转的题
																					skQuestion(
																							quItemBody
																									.next(),
																							skQuId,
																							logicId,
																							function() {
																								//重新编题号
																							});
																					if (skQuId === "1"
																							|| skQuId === "2") {
																						isbreak = true;
																					}
																				} else {
																					/*
																					//逻辑选项未被选中状态，未激活
																					//$(".hidFor"+loginId).slideDown("slow");
																					$(".hidFor"+loginId).show();
																					//$(".hidFor"+loginId).fadeIn();
																					$(".hidFor"+loginId).removeClass("hidFor"+loginId);
																					//回答标记与逻辑设置没有关系
																					$(".hidFor"+loginId).find(".answerTag").attr("disabled",false);
																					 */
																					var hidQuItemBodys = $(".hidFor"
																							+ logicId);
																					$(
																							".hidFor"
																									+ logicId)
																							.removeClass(
																									"hidFor"
																											+ logicId);
																					$
																							.each(
																									hidQuItemBodys,
																									function() {
																										var thQuItemBodyClass = $(
																												this)
																												.attr(
																														"class");
																										if (thQuItemBodyClass
																												.indexOf("hidFor") < 0) {
																											$(
																													this)
																													.show();
																											//$(".hidFor"+loginId).fadeIn();
																											//回答标记与逻辑设置没有关系
																											$(
																													this)
																													.find(
																															".answerTag")
																													.attr(
																															"disabled",
																															false);
																										}
																									});
																				}
																			} else {
																				//逻辑类型为“显示” quType=2
																				if (logicStatus) {
																					//逻辑选项被选中状态，激活状态  显示题

																					var hidQuItemBodys = $(".hidFor"
																							+ logicId);
																					$(
																							".hidFor"
																									+ logicId)
																							.removeClass(
																									"hidFor"
																											+ logicId);
																					$
																							.each(
																									hidQuItemBodys,
																									function() {
																										var thQuItemBodyClass = $(
																												this)
																												.attr(
																														"class");
																										if (thQuItemBodyClass
																												.indexOf("hidFor") < 0) {
																											$(
																													this)
																													.show();
																											$(
																													this)
																													.find(
																															".answerTag")
																													.attr(
																															"disabled",
																															false);
																										}
																									});

																				} else {
																					/*  隐藏题
																					 */
																					var hidQuItemBody = $(
																							".quId[value='"
																									+ skQuId
																									+ "']")
																							.parents(
																									".li_surveyQuItemBody");
																					hidQuItemBody
																							.hide();
																					hidQuItemBody
																							.addClass("hidFor"
																									+ logicId);
																					hidQuItemBody
																							.find(
																									".answerTag")
																							.attr(
																									"disabled",
																									true);

																				}
																			}

																			return false;
																		}
																	});

													if (isbreak) {
														return false;
													}

												});

							} else if (quType === "FILLBLANK") {

								//遍历每个逻辑设置
								var quOptionItems = quItemBody
										.find(".dwQuOptionItemContent");
								var thVal = thFormElementObj.val();

								$
										.each(
												quLogicItems,
												function() {
													var loginItem = $(this);
													var cgQuItemId = loginItem
															.find(
																	".cgQuItemId")
															.val();
													var skQuId = loginItem
															.find(".skQuId")
															.val();
													var logicId = loginItem
															.find(
																	".logicId")
															.val();
													var logicType = loginItem
															.find(
																	".logicType")
															.val();
													if (logicType === "1") {
														//跳转
														if (thVal != "") {
															//逻辑选项被选中状态，激活状态
															skQuestion(
																	quItemBody
																			.next(),
																	skQuId,
																	logicId,
																	function() {
																		//重新编题号

																	});
															if (skQuId === "1"
																	|| skQuId === "2") {
																isbreak = true;
															}
														} else {
															//逻辑选项未被选中状态，未激活
															//$(".hidFor"+loginId).slideDown("slow");

															var hidQuItemBodys = $(".hidFor"
																	+ logicId);
															$(
																	".hidFor"
																			+ logicId)
																	.removeClass(
																			"hidFor"
																					+ logicId);

															$
																	.each(
																			hidQuItemBodys,
																			function() {
																				var thQuItemBodyClass = $(
																						this)
																						.attr(
																								"class");
																				if (thQuItemBodyClass
																						.indexOf("hidFor") < 0) {
																					$(
																							this)
																							.show();
																					//$(".hidFor"+loginId).fadeIn();
																					//回答标记与逻辑设置没有关系
																					$(
																							this)
																							.find(
																									".answerTag")
																							.attr(
																									"disabled",
																									false);
																				}
																			});
														}
													} else {
														//显示
														//逻辑类型为“显示” quType=1
														if (thVal != "") {
															//逻辑选项被选中状态，激活状态  显示题
															var hidQuItemBodys = $(".hidFor"
																	+ logicId);
															$(
																	".hidFor"
																			+ logicId)
																	.removeClass(
																			"hidFor"
																					+ logicId);
															$
																	.each(
																			hidQuItemBodys,
																			function() {
																				var thQuItemBodyClass = $(
																						this)
																						.attr(
																								"class");
																				if (thQuItemBodyClass
																						.indexOf("hidFor") < 0) {
																					$(
																							this)
																							.show();
																					$(
																							this)
																							.find(
																									".answerTag")
																							.attr(
																									"disabled",
																									false);
																				}
																			});

														} else {
															/*  隐藏题
															 */
															var hidQuItemBody = $(
																	".quId[value='"
																			+ skQuId
																			+ "']")
																	.parents(
																			".li_surveyQuItemBody");
															hidQuItemBody
																	.hide();
															hidQuItemBody
																	.addClass("hidFor"
																			+ logicId);
															hidQuItemBody
																	.find(
																			".answerTag")
																	.attr(
																			"disabled",
																			true);
														}
													}

												});

							}
						}

					}

					function skQuestion(nextQuItemBody, skQuId, logicId,
							callback) {

						if (nextQuItemBody[0]) {
							//submitSurveyBtn
							var nextQuType = nextQuItemBody.find(".quType")
									.val();
							var nextQuId = nextQuItemBody.find(".quId")
									.val();
							var nextAnswerTag = nextQuItemBody
									.find(".answerTag");

							//var quType=quItemBody.find(".quType").val();
							//var quId=quItemBody.find(".quId").val();

							//判断跳转类型
							if (skQuId == null) {
								//对于逻辑选项未被选中的情况

							} else if (nextQuItemBody.is(":hidden")) {
								skQuestion(nextQuItemBody.next(), skQuId,
										logicId, function() {

										});
							} else if (nextQuType != "submitSurveyBtn"
									&& nextQuType != "PAGETAG"
									&& (skQuId === "1" || skQuId === "2" || nextQuId != skQuId)) {
								//对于逻辑项是被选定的情况下
								nextAnswerTag.attr("disabled", true);
								//nextQuItemBody.slideUp("slow");
								nextQuItemBody.hide();
								//nextQuItemBody.fadeOut();
								nextQuItemBody.addClass("hidFor" + logicId);

								skQuestion(nextQuItemBody.next(), skQuId,
										logicId, function() {

										});
							}
						} else {
							callback();
						}
					}

					resetQuNum();
					function resetQuNum() {
						var quCoNums = $(".quCoNum");
						$.each(quCoNums, function(i, item) {
							$(this).html((i + 1) + "、");
						});

					}

					/**********************处理答题进度条************************/
					//$("#resultProgress").progressbar({value: bfbFloat});

					$("#resultProgressRoot .progress-labelB").text(
							"共：" + $(".answerTag:enabled").size() + "题，已答" + 0 + "题");
			
					function answerProgressbar(thObj) {
						var quItemBody = thObj
								.parents(".li_surveyQuItemBody ");
						var quType = quItemBody.find(".quType").val();

						if (quType === "RADIO") {
							//quItemBody.find(".answerTag").val(1);
							var checks = quItemBody
									.find("input[type='radio']:checked");
							if (checks[0]) {
								quItemBody.find(".answerTag").val(1);
							} else {
								quItemBody.find(".answerTag").val(0);
							}
						} else if (quType == "CHECKBOX") {
							var checks = quItemBody
									.find("input[type='checkbox']:checked");
							if (checks[0]) {
								quItemBody.find(".answerTag").val(1);
							} else {
								quItemBody.find(".answerTag").val(0);
							}
						} else if (quType === "FILLBLANK") {
							var thVal = thObj.val();
							if (thVal != "") {
								quItemBody.find(".answerTag").val(1);
							} else {
								quItemBody.find(".answerTag").val(0);
							}
						} else if (quType === "ORDERQU") {
							//quOrderByLeftUl
							var orderByLabels = quItemBody
									.find(".quOrderByLeftUl label");
							if (!orderByLabels[0]) {
								quItemBody.find(".answerTag").val(1);
							} else {
								quItemBody.find(".answerTag").val(0);
							}
						} else if (quType === "SCORE") {
							//<input type="hidden" class="answerTag" value="0" >
							var quScoreOptionTr = thObj
									.parents(".quScoreOptionTr");
							var scoreNumInput = quScoreOptionTr
									.find(".scoreNumInput");
							if (scoreNumInput.val() != "") {
								quScoreOptionTr.find(".answerTag").val(1);
							} else {
								quScoreOptionTr.find(".answerTag").val(0);
							}
						} else if (quType === "MULTIFILLBLANK") {
							var mFillblankTableTr = thObj
									.parents(".mFillblankTableTr");
							if (thObj.val() != "") {
								mFillblankTableTr.find(".answerTag").val(1);
							} else {
								mFillblankTableTr.find(".answerTag").val(0);
							}
						} else if (quType === "CHENRADIO") {
							// || || quType==="CHENFBK"
							var dwQuCoChenRowTr = thObj
									.parents(".dwQuCoChenRowTr");
							dwQuCoChenRowTr.find(".answerTag").val(1);
						} else if (quType === "CHENCHECKBOX") {
							var dwQuCoChenRowTr = thObj
									.parents(".dwQuCoChenRowTr");
							var checks = dwQuCoChenRowTr
									.find("input[type='checkbox']:checked");
							if (checks[0]) {
								dwQuCoChenRowTr.find(".answerTag").val(1);
							} else {
								dwQuCoChenRowTr.find(".answerTag").val(0);
							}
						} else if (quType === "CHENSCORE") {
							var dwQuScoreOptionItemContent = thObj
									.parents(".dwQuScoreOptionItemContent");
							if (thObj.val() != "0") {
								dwQuScoreOptionItemContent.find(
										".answerTag").val(1);
							} else {
								dwQuScoreOptionItemContent.find(
										".answerTag").val(0);
							}
						} else if (quType === "CHENFBK") {
							var dwQuChenFbkOptionItemContent = thObj
									.parents(".dwQuChenFbkOptionItemContent");
							if (thObj.val() != "") {
								dwQuChenFbkOptionItemContent.find(
										".answerTag").val(1);
							} else {
								dwQuChenFbkOptionItemContent.find(
										".answerTag").val(0);
							}
						}

						var totalQuSize = $(".answerTag:enabled").size();
						var answerTag1 = $(".answerTag[value='1']:enabled");
						var answerQuSize = 0;
						if (answerTag1[0]) {
							answerQuSize = answerTag1.size();
						}
						var newValue = parseInt(answerQuSize / totalQuSize
								* 100);
						$("#resultProgressRoot .progress-label").text(
								"完成度：" + newValue + "%");
						$("#resultProgressRoot .progress-labelB").text(
								"共：" + totalQuSize + "题，已答" + answerQuSize + "题");
						$("#resultProgress").progressbar("option", "value",
								newValue);
					}
					/*
					$("input").unbind("click");
					$("input").click(function(){
						var quItemBody=$(this).parents(".li_surveyQuItemBody ");
						var quType=quItemBody.find(".quType").val();
						if(quType=="RADIO"){
							quItemBody.find(".answerTag").val(1);
						}
						var totalQuSize=$(".answerTag:enabled").size();
						var answerTag1=$(".answerTag[value='1']:enabled");
						var answerQuSize=0;
						if(answerTag1[0]){
							answerQuSize=answerTag1.size();
						}
						var newValue = parseInt(answerQuSize/totalQuSize*100);
						$("#resultProgressRoot .progress-label").text(newValue+"%");
						$("#resultProgress").progressbar("option", "value", newValue);
					});
					 */

					$("#mobileTdId").click(function() {
						$(this).next().slideToggle();
						return false;
					});

					function vaildCheckthispage() {
						var result = true;
						var surveyQuItemBodys = $(".li_surveyQuItemBody:visible");
						var firstError = null;
						$.each(surveyQuItemBodys, function() {
							var quItemBody = $(this);
							if (!validateCheck(quItemBody, true)) {
								//定位到这题 
								if (firstError == null) {
									firstError = quItemBody;
								}
								result = false;
							}
							// || quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"
						});
						if (firstError != null) {
							$(window).scrollTop(firstError.offset().top);
						}
						//
						if ($("#jcaptchaImgBody").is(":visible")) {
							var jcaptchaInput = $(
									"input[name='jcaptchaInput']").val();
							if (jcaptchaInput === "") {
								$("#jcaptchaImgBody .errorItem").show();
								result = false;
							} else {
								$("#jcaptchaImgBody .errorItem").hide();
							}
						}
						return result;
					}

				});

</script>

</head>
<body>
	<div id="wrap">
		<input type="hidden" id="id" name="id" value="${survey.id }">
<input type="hidden" id="ctx" name="ctx" value="${ctx }"> <input
type="hidden" id="surveyStyleId" value="${surveyStyle.id }">
<input type="hidden" id="prevHost" value="${ctx }">

<form id="surveyForm" action="${ctx }/response!save.action"
method="post">
<input type="hidden" id="surveyId" name="surveyId"
	value="${survey.id }"> <input type="hidden" id="sid"
name="sid" value="${survey.sid }"> <input type="hidden"
	id="surveyuser_id" name="surveyuser_id">
<input type="hidden"  name="surveyuser_username" value="${surveyuser_username }">
<input type="hidden" name="surveyuser_password" value="${surveyuser_password }">
<div id="dw_body" style="padding-top: 10px;">
<div id="dw_body_content">
	<div id="dwSurveyHeader">
		<div id="dwSurveyLogo">
			<img src="${ctx }/images/logo/sample_logo.png" height="70" />
</div>
<%-- <div id="dwSurveyTitle" class="noLogoImg" >${survey.surveyName }</div>
<div id="dwSurveyNote">
	<div id="dwSurveyNoteTools">参考样例</div>
	<div id="dwSurveyNoteEdit"  >${survey.surveyDetail.surveyNote }</div>
</div> --%>
<div id="dwSurveyTitle" class="noLogoImg">
	<div id="dwSurveyName" class="editAble dwSvyName">${survey.surveyName }</div>
</div>
<div id="dwSurveyNote">
	<div id="dwSurveyNoteTools">参考样例</div>
	<div id="dwSurveyNoteEdit" class="editAble">${survey.surveyDetail.surveyNote }</div>
	</div>
</div>
<div id="dwSurveyQuContent" style="min-height: 300px;">
<div id="dwSurveyQuContentBg">
	<!-- <div style="border-top: 3px solid #81AB00;margin:0px auto;padding-bottom: 15px;"></div> -->
	<c:set var="pageNo" value="1"></c:set>
	<c:set var="isNextPage" value="0"></c:set>
	<ul id="dwSurveyQuContentAppUl">
		<!-- 题目内容 -->
		<c:forEach items="${survey.questions }" var="en" varStatus="i">

			<c:choose>
				<c:when test="${en.quType eq 'RADIO' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="RADIO">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="isSelectType" value="${en.isSelectType }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }"> <input
									type="hidden" class="answerTag" value="0">
									
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" />
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												 <input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">

								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit">
											<c:if test= "${en.isRequired == 1 }">
												<i style = "color:red">*</i>
											</c:if>
										 ${en.quTitle }
										</div>
									</div>
									<div class="quCoItem dropdown">
										<c:choose>
											<c:when test="${en.hv eq 3 }">
												<table class='tableQuColItem'>
													<c:forEach begin="0"
														end="${fn:length(en.quRadios)-1 }" var="j"
														step="${en.cellCount }">
														<tr>
															<c:forEach begin="1" end="${en.cellCount }" var="k">
																<td width="${600/en.cellCount }">
																	<!-- 判断不为空，访止数组越界 --> <c:set var="quOptionIndex"
																		value="${(j+k-1) }"></c:set> <c:choose>
																		<c:when
																			test="${quOptionIndex < fn:length(en.quRadios) }">
																			<div class="dwQuOptionItemContent">
																			<label class="dwRedioStyle dwQuInputLabel"></label>
																				<input type="radio"
																					name="qu_${en.quType }_${en.id }"
																					value="${en.quRadios[quOptionIndex].id }">
							
																				<label	style="width:${600/en.cellCount-10 }px;"	 class="editAble quCoOptionEdit quCoOptionPadding">${en.quRadios[quOptionIndex].optionName }</label>
																				<input type='text' class='inputSytle_1'
																					style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																					name="text_qu_${en.quType }_${en.id }_${en.quRadios[quOptionIndex].id }" />
																			</div>
																		</c:when>
																		<c:otherwise>
																			<div class="emptyTd"></div>
																		</c:otherwise>
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
															<div class="dwQuOptionItemContent">
																<label class="dwRedioStyle dwQuInputLabel"></label>
																<input type="radio"
																	name="qu_${en.quType }_${en.id }"
																	value="${item.id }">
																	<label class="editAble quCoOptionEdit quCoOptionPadding">${item.optionName }</label>
																<input type='text' class='inputSytle_1'
																	style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																	name="text_qu_${en.quType }_${en.id }_${item.id }" />
															</div>
														</li>
														<!-- <li><select> <option>可想而知</option> </select> </li> -->
													</c:forEach>
												</ul>
											</c:when>
											<c:when test="${en.isSelectType eq 1 }">
		
												     <button  style="position:relative;text-align:left;color: rgb(134, 128, 128);display:block;font-family:'微软雅黑';border:1px solid #ccc;background-color: white;padding: 5px 20px 5px 5px;min-width: 160px;max-width: 500px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" class="btn btn-default dropdown-toggle" type="button" class="dropdownMenu dropdownMenu_${en.id }" data-toggle="dropdown" aria-haspopup="true">
													           请选择任意一项 
													    <span class="caret"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
													  </button>
													 <ul class="dropdown-menu dropdown_ul_${en.id}" style="position: relative;overflow-x: hidden;overflow-y:auto;max-height:171px;text-overflow:ellipsis;white-space: nowrap;border:1px solid #ccc;min-width: 160px;max-width: 500px;">
													  <c:forEach items="${en.quRadios }" var="item">
														<li class="quCoItemUlLi">
															<div class="dwQuOptionItemContent">
																<label class="dwRedioStyle dwQuInputLabel" style="display:none"></label>
																<input type="radio" 
																	name="qu_${en.quType }_${en.id }"
																	value="${item.id }">
																	
																<label	class="editAble quCoOptionEdit quCoOptionPadding" style="" title="${item.optionName }">${item.optionName }</label>
																<input type='text' class='inputSytle_1'
																	style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																	name="text_qu_${en.quType }_${en.id }_${item.id }" />
															</div>
														</li>
														</c:forEach>
											         </ul>
											    

	
											</c:when>
											<c:otherwise>
												<ul>
													<c:forEach items="${en.quRadios }" var="item">
														<li class="quCoItemUlLi">
															<div class="dwQuOptionItemContent">
																<label class="dwRedioStyle dwQuInputLabel"></label>
																<input type="radio"
																	name="qu_${en.quType }_${en.id }"
																	value="${item.id }">
																	
																<label	class="editAble quCoOptionEdit quCoOptionPadding">${item.optionName }</label>
																<input type='text' class='inputSytle_1'
																	style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																	name="text_qu_${en.quType }_${en.id }_${item.id }" />
															</div>
														</li>
														<!-- <li><select> <option>可想而知</option> </select> </li> -->
													</c:forEach>
												</ul>
											</c:otherwise>
										</c:choose>
									</div>
								</div>

							</div>
						</div>
					</li>
				</c:when>

				<c:when test="${en.quType eq 'CHECKBOX' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="CHECKBOX">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }"> <input
									type="hidden" class="answerTag" value="0">
<%--									<input type="hidden" class="minNum" value="${en.minNum }">--%>
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="tag_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">

								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit">
											<c:if test= "${en.isRequired == 1 }">
												<i style = "color:red">*</i>
											</c:if>
												${en.quTitle}</div>
									</div>
									<div class="quCoItem">
										<c:choose>
											<c:when test="${en.hv eq 3 }">
												<table class='tableQuColItem'>
													<c:forEach begin="0"
														end="${fn:length(en.quCheckboxs)-1 }" var="j"
														step="${en.cellCount }">
														<tr>
															<c:forEach begin="1" end="${en.cellCount }" var="k">
																<td width="${600/en.cellCount }">
																	<!-- 判断不为空，访止数组越界 --> <c:set var="quOptionIndex"
																		value="${(j+k-1) }"></c:set> <c:choose>
																		<c:when
																			test="${quOptionIndex < fn:length(en.quCheckboxs) }">
																			<div class="dwQuOptionItemContent">
																				<label class="dwCheckboxStyle dwQuInputLabel"
																					<c:if test="${item.noCheckBox == 1}">style="display:none;" </c:if> ></label>
																				<input type="checkbox"
																					name="tag_qu_${en.quType }_${en.id }_${en.quCheckboxs[quOptionIndex].id }"
																					value="${en.quCheckboxs[quOptionIndex].id }"
																					<c:if test="${item.noCheckBox == 1}">style="display:none;" </c:if>>
																					
																				
																				<label	style="width:${600/en.cellCount-10 }px;" class="editAble quCoOptionEdit quCoOptionPadding">${en.quCheckboxs[quOptionIndex].optionName }</label>
																				<input type='text' class='inputSytle_1'
																					style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																					name="text_tag_qu_${en.quType }_${en.id }_${en.quCheckboxs[quOptionIndex].id }" />
																			</div>
																		</c:when>
																		<c:otherwise>
																			<div class="emptyTd"></div>
																		</c:otherwise>
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
															<div class="dwQuOptionItemContent">
																<label class="dwCheckboxStyle dwQuInputLabel"
																	<c:if test="${item.noCheckBox == 1}">style="display:none;" </c:if> ></label>
																<input type="checkbox"
																	name="tag_qu_${en.quType }_${en.id }_${item.id }"
																	value="${item.id }"
																	<c:if test="${item.noCheckBox == 1}">style="display:none;" </c:if>>
																<label	class="editAble quCoOptionEdit quCoOptionPadding">${item.optionName }</label>
																<input type='text' class='inputSytle_1'
																	style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																	name="text_tag_qu_${en.quType }_${en.id }_${item.id }" />
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
															<div class="dwQuOptionItemContent">
																<label class="dwCheckboxStyle dwQuInputLabel" <c:if test="${item.noCheckBox == 1}">style='display:none;'</c:if> > </label>
																	
																<input type="checkbox"
																	name="tag_qu_${en.quType }_${en.id }_${item.id }"
																	value="${item.id }"
																	<c:if test="${item.noCheckBox == 1}">style="display:none;" </c:if> >
																	<label class="editAble quCoOptionEdit quCoOptionPadding">${item.optionName }</label>
																<input type='text' class='inputSytle_1'
																	style="width:200px;padding:5px;${item.isNote eq 1 ? '':'display: none;'}"
																	name="text_tag_qu_${en.quType }_${en.id }_${item.id }" />
															</div>
														</li>
														<!-- <li><select> <option>可想而知</option> </select> </li> -->
													</c:forEach>
												</ul>
											</c:otherwise>
										</c:choose>
									</div>

								</div>

							</div>
						</div>
					</li>
				</c:when>

				<c:when test="${en.quType eq 'FILLBLANK' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="FILLBLANK">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }"> <input
									type="hidden" class="checkType" value="${en.checkType }">
								<input type="hidden" class="answerTag" value="0">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit">
											<c:if test= "${en.isRequired == 1 }">
												<i style = "color:red">*</i>
											</c:if>${en.quTitle}</div>
									</div>
									<div class="quCoItem">
										<ul>
											<li class="quCoItemUlLi">
												<div class="quFillblankItem">
													<%-- <input type="text" name="qu_${en.quType }_${en.id }" style="width:200px;padding:5px;" class="inputSytle_1 fillblankInput"> --%>
													<c:choose>
														<c:when test="${en.checkType eq 'DATE'}">
															<input type="text"
																name="qu_${en.quType }_${en.id }"
																style="width: 300px; padding: 6px 10px 5px; border: 1px solid #83ABCB; outline: none;"
																class=" fillblankInput Wdate"
																onClick="WdatePicker()">
														</c:when>
														<c:when test="${en.answerInputRow > 1 }">
															<textarea name="qu_${en.quType }_${en.id }"
																rows="${en.answerInputRow }"
																style="width:${empty(en.answerInputWidth)?'300':en.answerInputWidth}px;"
																class="inputSytle_2 fillblankInput"></textarea>
														</c:when>
														<c:otherwise>
															<input type="text"
																name="qu_${en.quType }_${en.id }"
																style="width:${empty(en.answerInputWidth)?'300':en.answerInputWidth}px;"
																class="inputSytle_1 fillblankInput">
														</c:otherwise>
													</c:choose>
													<div class="dwComEditMenuBtn"></div>
												</div>
											</li>
										</ul>
									</div>
								</div>

							</div>
						</div>
					</li>
				</c:when>

				<c:when test="${en.quType eq 'SCORE' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="SCORE">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }"> <input
									type="hidden" class="isSlider" value="${en.isSlider}">
								<input type="hidden" class="maxSliderLength"
									value="${en.maxSliderLength}"> <input
									type="hidden" class="minSliderLength"
									value="${en.minSliderLength}"> <input
									type="hidden" class="totalSliderLength"
									value="${en.totalSliderLength}">
									<input type="hidden" class="isScoreInput"
									value="${en.isScoreInput}">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="item_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>
										<div class="editAble quCoTitleEdit"><c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>
									<div class="quCoItem">
										<table class="quCoItemTable" cellpadding="0"
											cellspacing="0">
											<c:forEach items="${en.quScores }" var="item"
												varStatus="vs">
												<tr class="quScoreOptionTr">

													<td class="quCoItemTableTd quOptionEditTd"><label
														class="editAble quCoOptionEdit">${item.optionName }</label>
														<input class="dwScoreOptionId" value="${item.id }"
														disabled="disabled" type="hidden" /> <input
														type="hidden" class="answerTag" value="0">
													</td>
													<td class="quCoItemTableTd"><c:if
															test="${en.isSlider eq 0 }">
															<c:if test="${en.isScoreInput eq 0 }">
															<table class="scoreNumTable" border="0"
																cellspacing="0" cellpadding="1">
																<tr>
																	<c:forEach begin="1" end="${en.paramInt02 }"
																		var="scoreNum">
																		<td style="background-color: white;">${scoreNum }</td>
																	</c:forEach>
																</tr>
															</table>
															</c:if>
															<c:if test="${en.isScoreInput eq 1 }">
															  <input name="isScoreInput_${en.id}_${item.id}" value="0" class="isScoreInputText"  type="number" min="${en.minSliderLength }" max="${en.maxSliderLength }"/>
															</c:if>
															<input
																name="item_qu_${en.quType }_${en.id }_${item.id }"
																value="" type="hidden" class="scoreNumInput">
														</c:if> 
														<c:if test="${en.isSlider eq 1 }">
															<div
																class="slider slider-range-${en.id }-${vs.count}"
																style="width: 400px; border: 1px solid gray;"></div>
															<input
																name="item_qu_${en.quType }_${en.id }_${item.id }"
																value="${en.minSliderLength }" type="hidden"
																class="scoreNumInput">
														</c:if></td>
													<td class="quCoItemTableTd scoreNumText">分</td>
												</tr>
											</c:forEach>
										</table>
										<c:if test="${ en.isSlider eq 1 }">
											<div class="socrePercentage">
												当前<span class="nowSliderLength_${en.id}"></span>分/总分<span
													class="totalSliderLength">${en.totalSliderLength }</span>分
											</div>
										</c:if>
									</div>
								</div>

							</div>
						</div>
					</li>
				</c:when>

				<c:when test="${en.quType eq 'ORDERQU' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="ORDERQU">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }"> <input
									type="hidden" class="answerTag" value="0">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="item_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit"><c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>
									<div class="quCoItem quOrderByCoItem">
										<div class="quOrderByRight">
											<table class="quOrderByTable" style="padding: 5px;">
												<c:forEach items="${en.quOrderbys }" var="item"
													varStatus="itemVarStatus">
													<tr class="quOrderByTableTr">
														<td class="quOrderyTableTd">${itemVarStatus.count }</td>
														<td class="quOrderTabConnect">
															<%-- <label class="quOrderItemLabel">drag content ${itemVarStatus.count }</label> --%>
														</td>
													</tr>
												</c:forEach>
											</table>
										</div>
										<%-- <div class="quOrderByLeft">
					<ul class="quOrderByNumUl">
					<c:forEach items="${en.quOrderbys }" var="item" varStatus="itemVarStatus">
							<li><label class="quOrderyNumLabel">${itemVarStatus.count }</label>&nbsp;请夺</li>
					</c:forEach>
					</ul>
				</div> --%>
										<div class="quOrderByLeft">
											<ul class="quOrderByLeftUl">
												<c:forEach items="${en.quOrderbys }" var="item">
													<li class="quCoItemUlLi"><label
														class="editAble quCoOptionEdit">${item.optionName }
															<input
															name="item_qu_${en.quType }_${en.id }_${item.id }"
															value="1" type="hidden" class="quOrderItemHidInput">
													</label></li>
												</c:forEach>
											</ul>
										</div>
										<div style="clear: both;"></div>
									</div>
								</div>

							</div>
						</div>
					</li>
				</c:when>

				<%-- 分页题 --%>
				<c:when test="${en.quType eq 'PAGETAG' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="PAGETAG">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" />
										</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="pageBorderTop nohover"></div>
								<div class="surveyQuItemContent"
									style="padding-top: 12px; height: 30px; min-height: 30px;">
									<!-- <div class="pageQuContent">下一页（1/2）</div> -->
									<c:if test="${pageNo > 1 }">
										<a href="#" class="sbtn24 sbtn24_0 prevPage_a">上一页</a>
										<input type="hidden" name="prevPageNo"
											value="${pageNo-1 }">
									</c:if>
									<a href="#" class="sbtn24 sbtn24_0 nextPage_a">下一页</a>&nbsp;&nbsp;
									<c:set var="pageNo" value="${pageNo+1 }"></c:set>
									<input type="hidden" name="nextPageNo" value="${pageNo }">

									<a href="#" id="tempSaveSurvey"
									   class="sbtn24 sbtn24_0 tempSaveSurvey">临时保存</a>&nbsp;&nbsp;
									<a href="#" id="quitSurvey"
									   class="sbtn24 sbtn24_0 quitSurvey">退&nbsp;出</a>&nbsp;
								</div>
							</div>
						</div>
					</li>
				</c:when>

				<%--段落说明 --%>
				<c:when test="${en.quType eq 'PARAGRAPH' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="PARAGRAPH">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" />
										</div>
									</c:forEach>
								</div>
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemContent" style="min-height: 35px;">
									<div class="quCoTitle"
										style="background: rgb(243, 247, 247);">
										 <div class="quCoNum" >${i.count }、</div>

										<div class="editAble quCoTitleEdit"
											style="padding-left: 15px;">
											<c:if test= "${en.isRequired == 1 }">
												<i style = "color:red">*</i>
											</c:if>
											${en.quTitle}</div>
									</div>
								</div>
							</div>
						</div>
					</li>
				</c:when>

				<%--多项填空题 --%>
				<c:when test="${en.quType eq 'MULTIFILLBLANK' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="MULTIFILLBLANK">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }"> <input
									type="hidden" class="paramInit01"
									value="${en.paramInt01 }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="text_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">

								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit"> <c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>
									<div class="quCoItem">
										<table class="mFillblankTable" cellpadding="0"
											cellspacing="0">
											<c:forEach items="${en.quMultiFillblanks }" var="item">
												<tr class="mFillblankTableTr">
													<td align="right" class="mFillblankTableEditTd"><label
														class="editAble quCoOptionEdit">${item.optionName }</label>
														<input class="dwMFillblankOptionId"
														value="${item.id }" disabled="disabled"
														type="hidden" /> <input type="hidden"
														class="answerTag" value="0"></td>
													<td><input
														name="text_qu_${en.quType }_${en.id }_${item.id }"
														type="text" style="width: 200px; padding: 5px;"
														class="inputSytle_1 dwMFillblankInput"></td>
												</tr>
											</c:forEach>
										</table>

									</div>
								</div>

							</div>
						</div>
					</li>
				</c:when>

				<%-- 矩阵单选题 --%>
				<c:when test="${en.quType eq 'CHENRADIO' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="CHENRADIO">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="item_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">
								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit"><c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
											<table class="quCoChenTable">
												<tr>
													<td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label
															class="editAble quCoOptionEdit">${columnItem.optionName }</label></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem" varStatus="vs">
													<tr class='dwQuCoChenRowTr'>
														<td class="quChenRowTd"><label
															class="editAble quCoOptionEdit">${rowItem.optionName }</label>
															<input type="hidden" class="answerTag" value="0">
														</td>
														<c:forEach items="${en.columns }" var="columnItem">
															<td>
																<div class="dwQuOptionItemContent">
																	<label class="dwRedioStyle dwQuInputLabel"></label>
																	<input type="hidden" class="dwChenInputTemp"
																		disabled="disabled"
																		value="${rowItem.id }:${columnItem.id }">
																	<input
																		name="item_qu_${en.quType }_${en.id }_${rowItem.id }"
																		value="${columnItem.id }" type="radio">
																</div>
															</td>
														</c:forEach>
													</tr>
												</c:forEach>
											</table>
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</div>
						</div>
					</li>
				</c:when>



				<%--矩阵多选题 --%>
				<c:when test="${en.quType eq 'CHENCHECKBOX' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="CHENCHECKBOX">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="item_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">

								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit"> <c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
											<table class="quCoChenTable">
												<tr>
													<td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label
															class="editAble quCoOptionEdit">${columnItem.optionName }</label></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
													<tr class="dwQuCoChenRowTr">
														<td class="quChenRowTd"><label
															class="editAble quCoOptionEdit">${rowItem.optionName }</label>
															<input type="hidden"
															name="item_qu_${en.quType }_${en.id }_${rowItem.id }"
															value="ck_item_qu_${en.quType }_${en.id }_${rowItem.id }_" />
															<input type="hidden" class="answerTag" value="0">
														</td>
														<c:forEach items="${en.columns }" var="columnItem">
															<td>
																<div class="dwQuOptionItemContent">
																	<label class="dwCheckboxStyle dwQuInputLabel"></label>
																	<input type="hidden" class="dwChenInputTemp"
																		disabled="disabled"
																		value="${rowItem.id }:${columnItem.id }">
																	<input
																		name="ck_item_qu_${en.quType }_${en.id }_${rowItem.id }_${columnItem.id}"
																		value="${columnItem.id }" type="checkbox">
																</div>
															</td>
														</c:forEach>
													</tr>
												</c:forEach>
											</table>
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</div>
						</div>
					</li>
				</c:when>

				<%-- 矩阵填空题 --%>
				<c:when test="${en.quType eq 'CHENFBK' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="CHENFBK">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" /> 
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												<input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="item_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">

								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit"><c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
											<table class="quCoChenTable">
												<tr>
													<td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label
															class="editAble quCoOptionEdit">${columnItem.optionName }</label></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
													<tr class="dwQuCoChenRowTr">
														<td class="quChenRowTd"><label
															class="editAble quCoOptionEdit">${rowItem.optionName }</label>
															<input type="hidden"
															name="item_qu_${en.quType }_${en.id }_${rowItem.id }"
															value="fbk_item_qu_${en.quType }_${en.id }_${rowItem.id }_" />
														</td>
														<c:forEach items="${en.columns }" var="columnItem">
															<td>
																<div class="dwQuChenFbkOptionItemContent">
																	<input type="hidden" class="dwChenInputTemp"
																		disabled="disabled"
																		value="${rowItem.id }:${columnItem.id }">
																	<input
																		name="fbk_item_qu_${en.quType }_${en.id }_${rowItem.id }_${columnItem.id }"
																		type="text"
																		class="inputSytle_1 dwChenMFillblankInput">
																	<input type="hidden" class="answerTag" value="0">
																</div>
															</td>
														</c:forEach>
													</tr>
												</c:forEach>
											</table>
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</div>
						</div>
					</li>
				</c:when>


				<%-- 矩阵评分题 --%>
				<c:when test="${en.quType eq 'CHENSCORE' }">
					<li class="li_surveyQuItemBody surveyQu_${pageNo }"
						style="${pageNo gt 1 ?'display: none':''}">
						<div class="surveyQuItemBody">
							<div class="initLine"></div>
							<div class="quInputCase" style="display: none;">
								<input type="hidden" class="quType" value="CHENSCORE">
								<input type="hidden" class="quId" value="${en.id }">
								<input type="hidden" class="trWidthInfo" value="${en.trWidthInfo }">
								<input type="hidden" class="orderById"
									value="${en.orderById }" /> <input type="hidden"
									class="isRequired" value="${en.isRequired }">
								<input type="hidden" class="maxSliderLength" value="${en.maxSliderLength }">
                                   <input type="hidden" class="minSliderLength" value="${en.minSliderLength }">
								<div class="quLogicInputCase">
									<c:forEach items="${en.questionLogics }" var="quLogicEn"
										varStatus="logicSts">
										<div class="quLogicItem quLogicItem_${logicSts.count }">
											<input type="hidden" class="cgQuItemId"
												value="${quLogicEn.cgQuItemId }" /> <input
												type="hidden" class="ckQuItemId"
												value="${quLogicEn.ckQuItemId }" /> <input
												type="hidden" class="skQuId"
												value="${quLogicEn.skQuId }" /> <input type="hidden"
												class="logicId" value="${quLogicEn.id }" />
												<input type="hidden"
												class="eqAndNq" value="${quLogicEn.eqAndNq }" />
												 <input
												type="hidden" class="geLe" value="${quLogicEn.geLe }" />
											<input type="hidden" class="scoreNum"
												value="${quLogicEn.scoreNum }" /> <input type="hidden"
												class="logicType" value="${quLogicEn.logicType }" />
										</div>
									</c:forEach>
								</div>
								<input type="hidden" name="qu_${en.quType }_${en.id }"
									value="item_qu_${en.quType }_${en.id }_" />
							</div>
							<div class="surveyQuItem">

								<div class="surveyQuItemContent">
									<div class="quCoTitle">
										<div class="quCoNum">${i.count }、</div>

										<div class="editAble quCoTitleEdit"><c:if test= "${en.isRequired == 1 }">
											<i style = "color:red">*</i>
										</c:if>${en.quTitle}</div>
									</div>

									<div class="quCoItem">
										<div class="quCoItemLeftChenTableDiv">
											<table class="quCoChenTable">
												<tr>
													<td></td>
													<c:forEach items="${en.columns }" var="columnItem">
														<td class="quChenColumnTd"><label
															class="editAble quCoOptionEdit">${columnItem.optionName }</label></td>
													</c:forEach>
												</tr>
												<c:forEach items="${en.rows }" var="rowItem">
													<tr class="dwQuCoChenRowTr">
														<td class="quChenRowTd"><label
															class="editAble quCoOptionEdit">${rowItem.optionName }</label>
															<input type="hidden"
															name="item_qu_${en.quType }_${en.id }_${rowItem.id }"
															value="cs_item_qu_${en.quType }_${en.id }_${rowItem.id }_" />
														</td>
														<c:forEach items="${en.columns }" var="columnItem">
															<td>
																<div class="dwQuScoreOptionItemContent">
																	<input type="hidden" class="dwChenInputTemp"
																		disabled="disabled"
																		value="${rowItem.id }:${columnItem.id }">
																	<input  type="number"
																		name="cs_item_qu_${en.quType }_${en.id }_${rowItem.id }_${columnItem.id}"
																		class="quChenScoreSelect"  value="" max="${en.maxSliderLength }"/>
														           <input type="hidden" class="answerTag" value="0">
																</div>
															</td>
														</c:forEach>
													</tr>
												</c:forEach>
											</table>
										</div>

									</div>
									<div style="clear: both;"></div>
								</div>

							</div>
						</div>
					</li>
				</c:when>
			</c:choose>

		</c:forEach>


		<li class="li_surveyQuItemBody surveyQu_${pageNo }"
			style="${pageNo gt 1 ?'display: none':''}">
			<div class="surveyQuItemBody">
				<div class="surveyQuItem">
					<!-- <div class="pageBorderTop nohover"  ></div> -->
					<div id="jcaptchaImgBody" class="r-qu-body"
						style="display: none;">

						<div class="frmItem" style="">
							<label for="" class="frm_label">验证码</label>
							<div class="frm_controls">
								<span class="auth-code" id="verifycodeImgArea"> <input
									name="jcaptchaInput" type="text" class=""
									style="width: 100px;" autocomplete="off"> <img
									id="register-jcaptchaImg"
									onclick="refreshAutoCode('register-jcaptchaImg')"
									src="${ctx }/jcaptcha.action" alt="验证码" height="40"></span>
								<a
									href="javascript:refreshAutoCode('register-jcaptchaImg');"
									style="margin-left: 5px;" hidefocus="true">换一张</a> <span
									class="frm_desc">输入下面图片的字符，区分大小写</span>
								<p class="valid-msg fail" style="display: none;">
									<i>●</i><span class="msg_content">验证码错误，请重新输入</span>
								</p>
							</div>
						</div>
						<div class="errorItem" style="display: none;">
							<label for="" class="error">验证码错误，请重新输入！</label>
						</div>
					</div>
					<input type="hidden" class="quType" value="submitSurveyBtn">
					<div class="surveyQuItemContent"
						style="padding-top: 12px; height: 30px; min-height: 30px;">
                        <c:if test="${pageNo > 1 }">
                            <a href="#" class="sbtn24 sbtn24_0 prevPage_a">上一页</a>
                            <input type="hidden" name="prevPageNo" value="${pageNo-1 }">
                        </c:if>
                        <c:set var="pageNo" value="${pageNo+1 }"></c:set>
                        <input type="hidden" name="nextPageNo" value="${pageNo }">
						<a href="#" id="submitSurvey"
							class="sbtn24 sbtn24_0 submitSurvey">提&nbsp;交</a>&nbsp;&nbsp;
						&nbsp;&nbsp;
						<%-- <a href="${ctx }/report.action?sid=${survey.sid}" style="color: gray;text-decoration: none;" target="_blank">查看结果</a> --%>
                        <a href="#" id="tempSaveSurvey"
                           class="sbtn24 sbtn24_0 tempSaveSurvey">临时保存</a>&nbsp;&nbsp;
                        <a href="#" id="quitSurvey"
                           class="sbtn24 sbtn24_0 quitSurvey">退&nbsp;出</a>&nbsp;&nbsp;
						</div>
					</div>
				</div>
			</li>

		</ul>
	</div>
</div>
<%--答题进度 --%>
				<div id="resultProgressRoot">
					<div class="progress-label">完成度：0%</div>
					<div id="resultProgress" class="progressbarDiv"></div>
					<div class="progress-labelB">共0题，已答0题</div>
				</div>

			</div>
		</div>
	</form>

</div>


<div class="footer-copyright footer-pb"
	style="color: gray; padding-bottom: 5px;">
<%--尊重开源、保留声明，感谢您的大力支持--%>
Powered by <a href=":;" style="text-decoration: none; color: gray;">Auxing</a>&nbsp;
<%-- 自定义内容版：已为您准备好内容版权声明模版，您可以为自己的卷子加上内容版权声明 --%>
<%--内容版权 <a href="http://www.diaowen.net" style="text-decoration: none;color: gray;">调问网</a>--%>
</div>

<div id="fixedMsg"
	style="position: fixed; top: 0px; width: 100%; padding: 10px; text-align: center; font-size: 18px; letter-spacing: 4px; line-height: 56px; background-color: #111; background-color: rgba(17, 17, 17, 0.5); color: #fff; color: rgba(255, 255, 255, 0.5); z-index: 200; display: none;"></div>
<script type="text/javascript">
var bfbFloat = 0;
$("#resultProgress").progressbar({
	value : bfbFloat,
	orientation : "vertical"
});

function refreshAutoCode(codeImgId) {
	var ctx = $("#ctx").val();
	$("#" + codeImgId).attr("src",
			ctx + "/jcaptcha.action" + "?t=" + Math.random());
}

//判则判断 
var url = "${ctx}/response!ajaxCheckSurvey.action";
var data = "surveyId=${survey.id}";
$.ajax({
	url : url,
	data : data,
	type : "post",
	success : function(msg) {
		var json = eval("(" + msg + ")");
		if (json.isCheckCode === "3") {
			$("#jcaptchaImgBody").show();
		}

		if (json.surveyStatus != "0") {
			$("#fixedMsg").show();
			$("#fixedMsg").html("您已经回答过此问卷！");
			$("#submitSurvey").remove();
			$("form").attr("action", "#");
		}

		$("#surveyuser_id").val(json.surveyuser_id);
	}
});

var errorcode = "${param['errorcode']}";
if (errorcode == "3") {
	var errorHtml = "<div class=\"errorItem\" style=\"padding-left:30px;\" ><label for=\"\" class=\"error\">验证码不正确，请重新回答！</label></div>";
	$("#dwSurveyHeader").append(errorHtml);
}



</script>
<%@ include file="/WEB-INF/page/layouts/other.jsp"%>

<!-- Diaowen.net Button BEGIN -->
<div id="webSiteFixedRight" class="websiteFixed"
	style="position: fixed; right: 0px; top: 20px; z-index: 9999;">
<a id="mobileTdId" href="＃"
	style="background: #1C658B; width: 15px; background: #8CBCD1; display: block; padding: 5px; padding-top: 10px; padding-bottom: 10px; font-weight: bold; color: white; cursor: pointer; float: right; vertical-align: middle; text-decoration: none; font-size: 12px;">手机地址</a>
<img alt="" src="${ctx }/survey!answerTD.action?surveyId=${survey.id}"
height="130" style="padding: 10px; background: white; display: none;" />
</div>
<!-- Diaowen.net Button END -->
<%--<script type="text/javascript">
	window.onunload = function (e) {
		var surveyuser_username = $("input[name='surveyuser_username']").val();
		var surveyuser_password = $("input[name='surveyuser_password']").val();
		var url = "${ctx}/response!checkIsSubmit.action";

		$.ajax({
			url: url,
			data: {
				"surveyuser_username": surveyuser_username,
				"surveyuser_password": surveyuser_password
			},
			type: "post",
			success: function (msg) {

			}
		})
	};
</script>
</body>--%>
</html>