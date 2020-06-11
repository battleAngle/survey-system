/**
 *
 * DWSurvey 3.0 中关于问卷设计Javascript
 *
 * @desc: design survey
 * @author: keyuan（@keyuan, keyuan258@gmail.com）
 * @github: https://github.com/wkeyuan/DWSurvey
 *
 * Copyright 2012, 2017 调问问卷(DWSurvey,http://dwsurvey.net)
 *
 */
//窗口的html原型
//判断浏览窗口大小
var browseWidth=$(window).width();
var browseHeight=$(window).height();
var ctx="";
var questionBelongId="";
var svTag=2;//表示题目是问卷题还是题库中题
var _paragrapItem;//分段标识

//题目保存后回调时机比较参数
var quCBNum=0;//比较值1
var quCBNum2=0;//比较值2
var zTree;

var curEditObj=null;
var curEditObjOldHtml="";
var dwDialogObj=null;
var ueEditObj=null;//UE编辑器，关联的编辑对象

var isDrag=false;
var appQuObj=null;

var myeditor=null;
var ueDialog=null;

var ueDialogBatchOption=null;
var myeditorBatchOption=null;
var curBatchObject=null;
var curClickObject=null;


var isSaveProgress=false;
$(document).ready(function(){

	ctx=$("#ctx").val();
	questionBelongId=$("#id").val();
	
	browseWidth=$(window).width();
	resizeWrapSize();
	
	
	
	
	//table表格长度回显
	$(".li_surveyQuItemBody ").each(function(){
		var quType=$(this).find("input[name='quType']").val();
		if(quType=="CHENFBK" || quType=="CHENSCORE" || quType=="CHENRADIO" || quType == "CHENCHECKBOX"){
		var trWidthInfo=$(this).find("input[name='trWidthInfo']").val();
		if(trWidthInfo != "" && trWidthInfo != undefined){
		 var firstTr=$(this).find("table").find("tr").first();
		 var tdAll=firstTr.find("td");
		 var trWidthInfoArr=trWidthInfo.split(",");
		 tdAll.each(function(i){
			/*$(this).css("width",trWidthInfoArr[i]); */
			 tdAll[i].style.width=trWidthInfoArr[i]+"%";
		 })
		 }
			
		}
		
	})
	
	//table表格调节
	
	//$("table").resizableRows();
    $("table").resizableColumns();
	
	
	//全选反选的js
	$(".checkTotal").click(function(){
		
		var  checkTotalChecked =$(this).prop("checked");
		$(".checkSingle").prop("checked",checkTotalChecked);
		
	})
	//窗口大小发生改变时
	$(window).resize(function(){
		browseWidth=$(window).width();
		resizeWrapSize();
		//修正当前编辑的浮动编辑区位置 
		if(curEditObj!=null){
			var editOffset=$(curEditObj).offset();
			$("#dwCommonEditRoot").show();
			$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
		}
		if(dwDialogObj!=null){
			setShowDialogOffset(dwDialogObj);
		}
		
		//添加复制click事件

	});
	
	
	//添加样式点击的保存事件
	

	ueDialog=$( "#dialog" ).dialog({
		width:680,
		/*height:450,*/
		autoOpen: false,
		modal:true,
		position:["center","top"],
		title:"高级编辑器",
		show: {effect:"blind",direction:"up",duration: 500},
		hide: {effect:"blind",direction:"left",duration: 200,
		open:function(event,ui){
		}
		}
	});
	
	//实例化一个不带ui的编辑器,注意此处的实例化对象是baidu.editor下的Editor，而非baidu.editor.ui下的Editor
	//ueeditor
	
	myeditor = UE.getEditor("dialogUeditor",{
	    //toolbars:[[]],
	    initialContent: "",//初始化编辑器的内容
	    elementPathEnabled:false,
        wordCount:false,
        autosave:false,
        //下面注释参数不要随便调，在滚动时效果更好
        //enableAutoSave:false,
        //autoHeightEnabled:false,
        //topOffset:60,
        //imagePopup:true,
	    initialFrameWidth : 680,
	    initialFrameHeight : 300
	});
	
	
  //初始化第二个Ueditor编辑器
	ueDialogBatchOption=$( "#dialogBatchOption" ).dialog({
		width:680,
		/*height:450,*/
		autoOpen: false,
		modal:true,
		position:["center","top"],
		title:"批量编辑器",
		show: {effect:"blind",direction:"up",duration: 500},
		hide: {effect:"blind",direction:"left",duration: 200,
		open:function(event,ui){
		}
		}
	});
	
	//实例化一个不带ui的编辑器,注意此处的实例化对象是baidu.editor下的Editor，而非baidu.editor.ui下的Editor
	//ueeditor
	
	myeditorBatchOption = UE.getEditor("dialogUeditorBatchOption",{
	    //toolbars:[[]],
	    initialContent: "",//初始化编辑器的内容
	    elementPathEnabled:false,
        wordCount:false,
        autosave:false,
        enterTag:'' ,
        //下面注释参数不要随便调，在滚动时效果更好
        //enableAutoSave:false,
        //autoHeightEnabled:false,
        //topOffset:60,
        //imagePopup:true,
	    initialFrameWidth : 680,
	    initialFrameHeight : 300
	});
	
	
	
	
	//窗口滚动条发生scroll时
	$(window).scroll( function() {
		var scrollTop=$(window).scrollTop();
		var quDesignDialog=$("#tools_wrap");
		
		var headerHeight=55;
		var quDesignHeight=125;
		if(scrollTop>=headerHeight){
			quDesignDialog.css({ top: "0px"});
		}else{
			quDesignDialog.css({ top: (headerHeight-scrollTop)+"px"});
		}
		var dwBodyLeft=$("#dw_body_left");
		var dwBodyRight=$("#dw_body_right");
		if(scrollTop>=headerHeight){
			dwBodyLeft.css({top:"136px"});
			dwBodyRight.css({top:"136px"});
		}else{
			dwBodyLeft.css({ top: (headerHeight+quDesignHeight+10-scrollTop)+"px"});
			dwBodyRight.css({ top: (headerHeight+quDesignHeight+10-scrollTop)+"px"});
		}
		
		if(scrollTop>=headerHeight && scrollTop<=100){
			//console.debug("(135+(30-(100-scrollTop)))+px:"+(135+(30-(100-scrollTop)))+"px,scrollTop"+scrollTop);
			$("#dw_body").css({"margin-top":(135+((100-headerHeight)-(100-scrollTop)))+"px"});
		}else{
			$("#dw_body").css({"margin-top":"135px"});
		}
		
		//修正当前编辑的浮动编辑区位置 
		if(curEditObj!=null){
			var editOffset=$(curEditObj).offset();
			$("#dwCommonEditRoot").show();
			$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
		}
		if(dwDialogObj!=null){
			setShowDialogOffset(dwDialogObj);
		}
		//ueDialog.dialog( "option",{position:["center","top"]} );
	} );
	
	//定时保存逻辑  三分钟检查一次
	function intervalSaveSurvey(){
		var saveTag=$("#dwSurveyQuContentAppUl input[name='saveTag'][value='0']");
		var nmSaveTag=$("#dw_body_content input[name='svyNmSaveTag'][value='0']");
		var noteSaveTag=$("#dw_body_content input[name='svyNoteSaveTag'][value='0']");
		
		//curEditObj!=null dwDialogObj
	if(!isSaveProgress && ( saveTag[0] || nmSaveTag[0] || noteSaveTag[0]) && !isDrag && curEditObj==null && dwDialogObj==null){
			notify("自动保存中...",5000);
			saveSurvey(function(){
				isSaveProgress=false;
				notify("自动保存成功",5000);
			});
		}
	}
	
	
	$(".surveyStyleEditToolbar_a").click(function(){
		var rootpath=RootPath();
		var id=$("#id").val();
		var url="/design/my-survey-design!previewDev.action?surveyId="+id;
		$("#saveBtn").trigger("click");
		window.location.href=rootpath+url;
	})
	
	//var intervalSave=setInterval(intervalSaveSurvey, 10000);
	//window.clearInterval(intervalSave);
	
	var isSort=false;
	//拖入题目到问卷中
	$( ".dragQuUl li" ).draggable({
			connectToSortable: "#dwSurveyQuContentAppUl",
			zIndex:27000,
			cursor: "move",cursorAt:{left: 40, top: 25},
			scroll: true ,
			scrollSensitivity: 30,
			scrollSpeed: 30,
			appendTo: "#dw_body_content",
			helper: function(event){
				return $(this).find(".dwQuTypeModel").html();
		
			},
			start: function(event, ui) {
				isDrag=true;
				//$("#tools_wrap").fadeTo("slow", 0.6);
				$("#tools_wrap").css({"zIndex":30});
				/*
				var scrollTop=$(window).scrollTop();
				if(scrollTop>=70){
					$("#tools_wrap").hide("slide",{direction:"up"},300,function(){
						$("#tools_wrap").css({"zIndex":30});
					}).show("slide",{direction:"up"},500);
				}else{
					$("#tools_wrap").css({"zIndex":30});	
				}
				*/
				resetQuItemHover(null);
				//$("#tools_wrap").hide();
				//console.debug($(this).attr("class")+":"+$(this).css("zIndex"));
				dwCommonDialogHide();
				curEditCallback();
			},
		    drag: function(event, ui) {

		    	//console.debug( $( "#designQutypes li" ).draggable('option', 'zIndex'));
		    	//console.debug($(ui.helper).css("zIndex")+$(ui.helper).css("position"));
		    	isDrag=true;
		    },
		    stop: function(event, ui) {
		        
		    	
		     	 /*   alert($(".dwQuLogicCopy").length);
			    	$(".dwQuLogicCopy").unbind();
			    	$(".dwQuLogicCopy").click(function(){
			    		var  dwQuLogicCopyThis=$(this);
						
						var quItemBody=dwQuLogicCopyThis.parents(".li_surveyQuItemBody");
						var nextUtilBody=$("#nextUtilBody");
						
						//现将thisItemforHidden的item装进去
						nextUtilBody.html("");
						showDialog($(this));
						var quItemBodyElse=quItemBody.prevAll(".li_surveyQuItemBody");
						quItemBodyElse.each(function(){
						   var quItemBodyElseThis=$(this);
						   var quType=quItemBodyElseThis.find("input[name='quType']").val();
						   var quId=quItemBodyElseThis.find("input[name='quId']").val();
						   var quTitle=quItemBodyElseThis.find(".quCoTitleEdit").text();
						   if(quType != "PARAGRAPH" && quType != "PAGETAG"){
							   var option = "<option id='"+quId+"' value='"+quId+"'>"+quTitle+"</option>";
							   nextUtilBody.append(option);
						   }
						})
						
						//获得当前选项的Id
						var selectQuId =nextUtilBody.val();
						var targetQuItemBody=quItemBodyElse.has("input[name='quId'][value='"+selectQuId+"']");
						var logicType = targetQuItemBody.find("input[name='logicType']").val();
						
						var thisItemforHidden=$("#thisItemforHidden");
						//是移除逻辑
						selectChange(thisItemforHidden,quItemBody,logicType);
						return false;
			       });*/
		    	
		    	  //window.location.reload();
		    	 _paragrapItem=$(this).find('.paragraphQuItemBody').length>0;
		    	//$("#tools_wrap").fadeTo("slow", 0.6).fadeTo("slow", 1);
		    	//$("#tools_wrap").css({"zIndex":200});
		    	if(!isSort){
		    		
			    	$("#tools_wrap").animate({zIndex: 200}, 200 ,function(){
			    		//$("#tools_wrap").css({"zIndex":200});
						resetQuItem();
			    		bindQuHoverItem();
			    	});
			    	
			  
		    	}
		    	if(_paragrapItem){
		    		
		    		console.log()
		    	}
		    	
		    	if(false){
			    	isDrag=false;
			    	//alert(this); 
			    	//判断加入----根据initLine显示状态来判断是否加入进去
			    	if(appQuObj!=null){
				    	//$("#defaultAppQuObj").before($(this).find(".quTypeModel").html());
				    	$(appQuObj).before($(this).find(".dwQuTypeModel").html());
				    	$(appQuObj).prev().hide();
				    	$(appQuObj).prev().removeClass("quDragBody");
				    	$(appQuObj).prev().show("slow");
				    	//更新orderById
				    	/* var orderById=$(appQuObj).find("input[name='orderById']").val();
				    	//$(".initLine").hide();
				    	//执行题目-保存
				    	$(appQuObj).prev().find("input[name='orderById']").val(orderById);
				    	saveQu($(appQuObj).prev());
				    	//修改数据 quItem*/
				    	
				    	resetQuItem();
				    	bindQuHoverItem();
				    	/*$(".dwQuLogicCopy").unbind().bind("click",function(){
				    		dwQuLogicCopy($(this));
				    	})*/
				    	
			    	}
		    	}
		    }
	}); 
	
	$( "#dwSurveyQuContentAppUl" ).sortable({
		revert: true,
		delay:800,
		placeholder:"showLine",
		tolerance:"pointer",
		opacity :0.7,
		//helper : "clone",
		handle : ".dwQuMove",
		scrollSensitivity: 30,
		scrollSpeed: 30,
		start: function(event,ui){
			//$("#tools_wrap").fadeTo("slow", 0.6);
			$("#tools_wrap").css({"zIndex":30});
			$(".showLine").height(ui.item.height());
			dwCommonDialogHide();
			curEditCallback();
			isSort=true;
		},
		sort: function(event,ui){
			isSort=true;
			$(".ui-sortable-placeholder").css({"background":"red"});
		},
		receive:function(event,ui){
			//当一个已连接的sortable对象接收到另一个sortable对象的元素后触发此事件。 
		},
		out:function(event,ui){
			//当一个元素拖拽移出sortable对象移出并进入另一个sortable对象后触发此事件。 
			isSort=false;
		},
		update: function( event, ui ) {
			if(!isDrag){
				//根据排序ID，计算出是前排序，还是后排序
				//ui.item.find("input[name='saveTag']").val(0);
				//$(this).find("input[name='saveTag']").val(0);
				$("#dwSurveyQuContentAppUl input[name='saveTag']").val(0);
			}
		},
		stop: function(event,ui){
			//console.debug("sort isDrag:"+isDrag+",isSort:"+isSort);
			if(isDrag){
				isDrag=false;
				isSort=false;
				ui.item.html(ui.item.find(".dwQuTypeModel").html());
				ui.item.removeClass("ui-draggable");
				ui.item.find(".quDragBody").removeClass("quDragBody");
				//新加入题-选定题目标题
				ui.item.find(".surveyQuItemBody").addClass("hover");
				ui.item.addClass("li_surveyQuItemBody");
				var quType=ui.item.find(".surveyQuItemBody input[name='quType']").val();
				if(quType!="PAGETAG"){
					editAble(ui.item.find(".surveyQuItemBody .quCoTitleEdit"));	
				}
				//判断是否会初头部工具条盖住
				//var curItemBodyOffset=ui.item.offset();
				//alert(curItemBodyOffset.top);
				//$(document).scrollTop(curItemBodyOffset.top-370);
				//$(document).animate({scrollTop:curItemBodyOffset.top-370}, 800);
				//$("body").animate({scrollTop:curItemBodyOffset.top-370}, 800);
			}
			
			var curItemBodyOffset=ui.item.offset();
			$("html,body").animate({scrollTop:curItemBodyOffset.top-370}, 500,function(){
				$("#tools_wrap").css({"zIndex":200});
				resetQuItem();
		    	bindQuHoverItem();
			});
			/*
			 //之前的实现
			 $("#tools_wrap").css({"zIndex":200});
			//$("#tools_wrap").animate({zIndex: 200}, 1000 );
			//$("#tools_wrap").fadeTo("slow", 0.6).fadeTo("slow", 1);
			resetQuItem();
	    	bindQuHoverItem();*/
		}
	});
	
	/* $("#dwSurveyTitle").keydown(function(event){
		if(event.keyCode==13){
			return false;
		}
	}); */

	/*$(".tools_tabs_left ul li").hover(function(){
		var curId=$(this).attr("id");
		var tabId=curId.replace("_li","");
		$(".tools_tab_div").hide();
		$("#"+tabId).show();
		$(".tools_tabs_left ul li").removeClass("current");
		$(this).addClass("current");
	},function(){});*/

	var isDialogClick=false;
	
	$(document).click(function(){
		curEditCallback();
		if(!isDialogClick){
			dwCommonDialogHide();
			resetQuItemHover(null);
		}
		isDialogClick=false;
	});
	

	$("#dwCommonEditRoot").unbind();
	$("#dwCommonEditRoot").click(function(){
		return false;
	});
	
	$("#dwCommonDialog").click(function(){
		isDialogClick=true;
	});
	
	$( "#modelUIDialog" ).click(function(){
		isDialogClick=true;
	});
	
	$( "#modelUIDialog" ).dialog({
		title: "选项设置",
		height: 260,
		width: 550,
		modal: true,
		autoOpen: false
	});
	
	
	$(".tools_tabs_left ul li").click(function(){
		var curId=$(this).attr("id");
		var tabId=curId.replace("_li","");
		$(".tools_tab_div").hide();
		$("#"+tabId).show();
		$(".tools_tabs_left ul li").removeClass("current");
		$(this).addClass("current");
	});
	//绑定变动
	bindQuHoverItem();
	
	//问卷设置,收集规则什么的
	$("#surveyAttrSetToolbar").click(function(){
		showUIDialog($(this));
		/*$(".tabbarDialog").offset({top:$(this).offset().top+60});
		$(".tabbarDialog").show();
		$(this).addClass("hover");*/
		return false;
	});
	
	$("#surveyAttrSetToolbar_person").click(function(){
		showUIDialog($(this));
		/*$(".tabbarDialog").offset({top:$(this).offset().top+60});
		$(".tabbarDialog").show();
		$(this).addClass("hover");*/
		return false;
	});
	
	$("#surveyAttrViewPersonDialog").click(function(){
		showUIDialog($(this));
		/*$(".tabbarDialog").offset({top:$(this).offset().top+60});
		$(".tabbarDialog").show();
		$(this).addClass("hover");*/
		return false;
	});
	
	$("#logicToolbar").click(function(){
		showUIDialog($(this));
		return false;
	});
	
	//绑定设置关联联系人属性设置 
	$("input[name='setAutoContacts']").change(function(){
		var check=$(this).prop("checked");
		if(check){
			$(".contactsFieldLi").show();
		}else{
			$(".contactsFieldLi").hide();
		}
	});
	
	//切换设置题目时，选项排列个数 option_range
	$(".option_range").change(function(){
		var selVal=$(this).val();
		$(this).next().hide();
		if(selVal==3){
			$(this).next().show();
			validateGen();
		}
	});
	
	//逻辑设置时添加逻辑项

   $(".dwQuDialogAddLogic").click(function(){
	    /*addQuDialogLogicTr(true,function(){},function(){alert("此题已经设置了任意选项!");});*/
         
		var quItemBody=$(dwDialogObj).parents(".li_surveyQuItemBody");
		
		var elseQuitemBody=quItemBody.prevAll(".li_surveyQuItemBody");
		
		if(! elseQuitemBody[0]){
			alert("没有逻辑可以添加");
			return false;
		}
	   //addQuDialogLogic_2($(this))
	    addQuDialogLogicTrZtree();
	    $(this).hide();
		return false;
	});
	
	//添加排除逻辑js
	$("select[name='option_event']").change(function(){
		
		var quItemBody=$(dwDialogObj).parents(".li_surveyQuItemBody");
		var quType=quItemBody.find("input[name='quType']").val();
		var model="<select name='option_name_id'></select>";	
		var thisParentTr=$(this).parent();
		var thisVal=$(this).val();
		thisParentTr.append(model);
		if(thisVal == 3){
			//添加select选项款
			 if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				 var quChenColumnTds=quItemBody.find(".quChenColumnTd");
				 var quChenRowTds=quItemBody.find(".quChenRowTd");
				 $.each(quChenColumnTds,function(){
						//获得行的名称和id
						var rowText=$(this).find(".quCoOptionEdit").text();
					    var rowQuItemId=$(this).find("input[name='quItemId']").val();
					    $.each(quChenRowTds,function(){
					    	//获得列的名称和id
					    	var colText=$(this).find(".quCoOptionEdit").text();
							var colQuItemId=$(this).find("input[name='quItemId']").val();
						
							
					   	    var optionString="<option value='"+colQuItemId+":"+rowQuItemId+"'>"+rowText+"+"+colText+"</option>";
							$("select[name='option_name_id']").prepend(optionString);
					    })
					});
			 }else{
				 if(quType==="FILLBLANK"){
					 
					 var optionString="<option value='1'>选项1</option>"
					 $("select[name='option_name_id']").prepend(optionString);
				 }else{
					 
				   var quItemInputCases=quItemBody.find(".quItemInputCase");
		            	
		           $.each(quItemInputCases,function(){
					var optionText=$(this).parent().find("label.quCoOptionEdit").text();
	    			var optionId=$(this).find("input[name='quItemId']").val();	
	    				
	    			var option="<option value='"+optionId+"'>"+optionText+"</option>";
	    			$("select[name='option_name_id']").prepend(option); 
		           });	
				 }	
			 }
			
		}else{
			$("select[name='option_name_id']").remove();
		}
		
	  return false;
	})
	
	
	
	function addQuDialogLogicTr_2(obj){
		
		//获得当前弹出框的li下面的div对象
		var quItemBody=$(dwDialogObj).parents(".li_surveyQuItemBody");
		
		//获得选项信息
		var quItemInputCases=quItemBody.find(".quItemInputCase");
		
		//获得逻辑的信息
		var quLogicInputCase=quItemBody.find(".quLogicInputCase");
		
		//问题的ID
		var curQuId=quItemBody.find("input[name='quId']").val();
		
		//问题的类型
		var quType=quItemBody.find("input[name='quType']").val();
		
		var quCoNum=quItemBody.find(".quCoNum").text();
		var quCoTitleEdit=quItemBody.find(".quCoTitleEdit").text();
		
		//获得逻辑起始
		var logicQuOptionSels=$("#dwQuLogicTable").find(".logicQuOptionSel");
		
		//获得逻辑结束
		var dwLogicQuSels=$("#dwQuLogicTable").find(".logicQuSel");
		
		var elsequItemBody=quItemBody.prevAll();
		
		var dwQuLogicTable=$("#dwQuLogicTable");
		
		//添加一个tr模板
		var elsequItemBody=quItemBody.prevAll();
		if(!elsequItemBody[0]){
			dwQuLogicTable.html("");
			dwQuLogicTable.append("<tr><td>没有逻辑可以添加<td><tr>");
			return false;
		}
		
	    var tr=dwQuLogicTable.find("tr");
	    var thisOption="<option  value='"+curQuId+"'>"+quCoNum+quCoTitleEdit+"<option>";
	    var model_1=$("#setQuLogicItemTrModel").clone(true);
	    model_1.find(".logicQuSel").append(thisOption);
	    var model_2=$("#setQuLogicItemTrModel_new").clone(true);
	    var model_3=$('#setQuLogicItemTrModel_score').clone(true);
	    model_3.find(".logicQuSel").append(thisOption);
	    var model_4=$('#setQuLogicItemTrModel_score_new').clone(true);	
	     
	    if(tr[0] == undefined){
	    	var hasTrFlag=false;
	    }
	    //判断当前加入的题型 将所有的可选逻辑加上
	    elsequItemBody.each(function(){
	    	var tempElsequItemBody=$(this);
	    	var thisModel;
	    	var quType=tempElsequItemBody.find("input[name='quType']").val();
	    	//是第一个 且是 评分题
            if(quType=='SCORE' && !hasTrFlag){
                thisModel=model_3;
                
                //获得所有的选项
                
                //dwQuLogicTable.append(thisModel);
                
                //hasTrFlag=true;
                hasTrFlag=loadModel(hasTrFlag,tempElsequItemBody,model_1,model_2,model_3,model_4,dwQuLogicTable);
            }
            //是第一个 且 不是评分题
            else if(!hasTrFlag && quType != 'SCORE'){
            	thisModel=model_1;
            	/*dwQuLogicTable.append(thisModel);
            	hasTrFlag=true;*/
            	hasTrFlag=loadModel(hasTrFlag,tempElsequItemBody,model_1,model_2,model_3,model_4,dwQuLogicTable);
            }
            //不是第一个且是评分题
            else if(quType=='SCORE' && hasTrFlag){
            	thisModel=model_4;
            	/*dwQuLogicTable.append(thisModel);*/
            	hasTrFlag=loadModel(hasTrFlag,tempElsequItemBody,model_1,model_2,model_3,model_4,dwQuLogicTable);
            }
            //不是第一个且不是评分题
            else{
            	thisModel=model_2;
            	/*dwQuLogicTable.append(thisModel);*/
            	hasTrFlag=loadModel(hasTrFlag,tempElsequItemBody,model_1,model_2,model_3,model_4,dwQuLogicTable);
            } 
	    })
	   
	    
	    //查看当前的题的逻辑设置,将已经选的逻辑打钩
	    var quLogicitem=quItemBody.find(".quLogicItem");
	    var allTr=dwQuLogicTable.find("tr");
	    if(quLogicitem[0]){
	    	quLogicitem=quItemBody.find(".quLogicItem").eq(0);
	    	var cgQuItemId=quLogicitem.find("input[name='cgQuItemId']").val();
	    	var skQuId=quLogicitem.find("input[name='skQuId']").val();
	    	var geLe=quLogicitem.find("input[name='geLe']").val();
	    	var ckQuItemId=quLogicitem.find("input[name='ckQuItemId']").val();
	    	var scoreNum=quLogicitem.find("input[name='scoreNum']").val();
	    	var logicType=quLogicitem.find("input[name='logicType']").val();
	    	//说明不是一个条件
	    	if(cgQuItemId.indexOf(",") != -1){
	    		var cgQuItemIdArray=new Array();
	    		var skQuIdArray=new Array();
	    		var geLeArray=new Array();
	    		var scoreNumArray=new Array();
	    		cgQuItemIdArray=cgQuItemId.split(",");
	    		skQuIdArray=skQuId.split(",");
	            geLeArray=geLe.split(",");
	            scoreNumArray=scoreNum.split(",");
	    
	    		for(var i=0;i<cgQuItemIdArray.length;i++){
	    			allTr.each(function(){
	    			  var thisTr=$(this);
	    			  var logicQuOptionSel=thisTr.find(".logicQuOptionSel").val();
	    			  if((skQuIdArray[i]+":"+cgQuItemIdArray[i]) == logicQuOptionSel){
	    				 thisTr.find("input:checkbox").prop("checked",true); 
	    				 if(geLeArray[i]!="none" || scoreNumArray[i] !="-1"){
	    					 thisTr.find(".logicScoreGtLt").val(geLeArray[i]);
	    					 thisTr.find(".logicScoreNum").val(scoreNumArray[i]);
	    				 }
	    			  }
	    			})
	    			
	    		}
	    		
	    		
	    	}else{
	    		//只有一个条件
	    	
	    		allTr.each(function(){
	    			var thisTr=$(this);
	    			var logicQuOptionSel=thisTr.find(".logicQuOptionSel").val();
	    			if(logicQuOptionSel == skQuId+":"+cgQuItemId){
	    				thisTr.find("input:checkbox").prop("checked",true);
	    				 if(geLe!="none" || scoreNum !="-1"){
	    					 thisTr.find(".logicScoreGtLt").val(geLe);
	    					 thisTr.find(".logicScoreNum").val(scoreNum);
	    				 }
	    			}
	    			
	    		})
	    	}
	    	
	    	//跳转逻辑和跳转选项的回显
	    	var firstTr=dwQuLogicTable.find("tr").eq(0);
	        
	    	//移除逻辑回显
	    	if(logicType == 3){
	    		
	    		//最后一个td添加一个select;
	    		var lastTd=firstTr.find("td").eq(-2);
	    		var model="<select name='option_name_id'></select>";
	    		lastTd.append(model);
	    		 if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
					 var quChenColumnTds=quItemBody.find(".quChenColumnTd");
					 var quChenRowTds=quItemBody.find(".quChenRowTd");
					 $.each(quChenColumnTds,function(){
							//获得行的名称和id
							var rowText=$(this).find(".quCoOptionEdit").text();
						    var rowQuItemId=$(this).find("input[name='quItemId']").val();
						    $.each(quChenRowTds,function(){
						    	//获得列的名称和id
						    	var colText=$(this).find(".quCoOptionEdit").text();
								var colQuItemId=$(this).find("input[name='quItemId']").val();
							
								
						   	    var optionString="<option value='"+colQuItemId+":"+rowQuItemId+"'>"+rowText+"+"+colText+"</option>";
								$("select[name='option_name_id']").prepend(optionString);
						    })
						});
				 }else{
					 if(quType==="FILLBLANK"){
						 
						 var optionString="<option value='1'>选项1</option>"
						 $("select[name='option_name_id']").prepend(optionString);
					 }else{
						 
					   var quItemInputCases=quItemBody.find(".quItemInputCase");
			            	
			           $.each(quItemInputCases,function(){
						var optionText=$(this).parent().find("label.quCoOptionEdit").text();
		    			var optionId=$(this).find("input[name='quItemId']").val();	
		    				
		    			var option="<option value='"+optionId+"'>"+optionText+"</option>";
		    			$("select[name='option_name_id']").prepend(option); 
			           });	
					 }	
				 }
	    		
	    	}
	        firstTr.find("select[name='option_event']").val(logicType);
	    	
	    }
	  
		//获得本quItemBody之前的所有的.surveyQuItemBody
	   // trueCallBack(quItemBody);

	}
	
    //定义Ztree对象
	 function ztreeObject(Id,pId,type,isParent,name) {
	      const  temp=new Object();
	      temp.id=Id;
	      temp.pId=pId;
	      temp.questionType=type;
	      temp.isParent=isParent;
	      temp.name=name;
	      temp.checked=false;
	      /*temp.font ={'font-weight':'bold','font-size':'16px','color':'red'};
	      temp.icon="./zTree/css/img/6.png";*/
	      return temp;
	    }
		//创建Ztree的方法
	  
	    function  createTree(treeId,treeArray){
	        //用于保存创建的树节点
	        var setting = {
	       // 设置
	        check: {
	            enable: true,
	            chkStyle: "checkbox",
	    		chkboxType: { "Y": "", "N": "" }
	        },
	         view: {
	              showLine: true,
	              dblClickExpand: true,
	              addDiyDom: addDiyDom
	         },
	        data: {
	            simpleData: {
	                enable: true,
	                idKey: "id",
	                pIdKey: "pId",
	                rootPId: "0"
	            }
	         }
	        };
	        zTree = $.fn.zTree.init($(treeId), setting, treeArray);
	    }
	    
	    function addDiyDom(treeId, treeNode){
	    	var  quType=treeNode.questionType;
	    	var  isParent=treeNode.isParent;
	    	if(quType == 'SCORE' && isParent == false){
	    	    var editdom="评分&nbsp;<select name='logicScoreGtLt' class='logicScoreGtLt' style='width:60px;font-size:10px;height:16px !important;margin:0px;padding:0px;'><option value='le'>小等于</option><option value='ge'>大等于</option></select>"+
			"&emsp;&emsp;<input name='logicScoreNum' value='5'class='logicScoreNum'  style='width:30px;border: 1px #77a5b4 solid;height:16px;'/>&nbsp;分, &emsp;<select name='"+treeNode.tId+"_logicOrAnd' style='width:43px;font-size:10px;height:16px !important;margin:0px;padding:0px;'><option value='_ad_'>和</option><option value='_or_'>或</option></select>";
	    		$("#"+treeNode.tId).append(editdom);
	    	}/*else if(quType == 'SCORE' && isParent == false && treeNode.isLastNode == true){
	    		var editdom="评分&nbsp;<select name='logicScoreGtLt' class='logicScoreGtLt' style='width:60px;font-size:10px;height:16px !important;margin:0px;padding:0px;'><option value='le'>小等于</option><option value='ge'>大等于</option></select>"+
				"&emsp;&emsp;<input name='logicScoreNum' value='5'class='logicScoreNum'  style='width:30px;border: 1px #77a5b4 solid;height:16px;'/>&nbsp;分,";
	    		$("#"+treeNode.tId).append(editdom);
	    	}*/
	    	else{
	    		
	    	      var normalEditDom="&emsp;<select name='"+treeNode.tId+"_logicOrAnd' style='width:43px;font-size:10px;height:16px !important;margin:0px;padding:0px;'><option value='_ad_'>和</option> <option value='_or_'>或</option>  </select>"
	    	     
	    			$("#"+treeNode.tId).append(normalEditDom);
	    	    
	    	}
	    	
	    	if(isParent == false){
	    		 var normalEditDom_2="&emsp;<select name='"+treeNode.tId+"_logicEqNq' class='eqAndNq'  style='width:60px;font-size:10px;height:16px !important;margin:0px;padding:0px;'><option value='1'>等于</option> <option value='0'>不等于</option>  </select>"
	    		  $("#"+treeNode.tId+"_a").prepend(normalEditDom_2);
	    	}
	    	
	    }
	 
	function addQuDialogLogicTrZtree(){
		 
		//获得当前弹出框的li下面的div对象
		var quItemBody=$(dwDialogObj).parents(".li_surveyQuItemBody");
		
		//获得选项信息
		var quItemInputCases=quItemBody.find(".quItemInputCase");
		
		//获得逻辑的信息
		var quLogicInputCase=quItemBody.find(".quLogicInputCase");
		
		//问题的ID
		var curQuId=quItemBody.find("input[name='quId']").val();
		
		//问题的类型
		var quType=quItemBody.find("input[name='quType']").val();
		
		var quCoNum=quItemBody.find(".quCoNum").text();
		var quCoTitleEdit=quItemBody.find(".quCoTitleEdit").text();
		
		
		//添加跳转的题的选项
		var model=$(".logicQuSel");
		
		var option_thisModel="<option value='"+curQuId+"'>"+quCoTitleEdit+"<option>";
		model.html(option_thisModel);
		
		
		
		var elsequItemBody=quItemBody.prevAll();
		
		var logicTree=$("#logicTree");
		
		//添加一个tr模板
		var elsequItemBody=quItemBody.prevAll();
		
		var ztreeArray=new Array();
		
		elsequItemBody.each(function(){
			var tempElsequItemBody=$(this);
	    	var quType=tempElsequItemBody.find("input[name='quType']").val();
	    	var quId=tempElsequItemBody.find("input[name='quId']").val();
	    	var quName=tempElsequItemBody.find(".quCoTitleEdit").text();
	    	
	    	//过滤掉分段和分项
	    	if(quType != "PAGETAG" && quType != "PARAGRAPH" && quType != "ORDERQU"){
	    		 var ztreeparentObject=ztreeObject(quId+":"+quId,"0",quType,true,quName);
	             ztreeArray.push(ztreeparentObject);
	             loadZtreeModel(ztreeArray,tempElsequItemBody);
	    	}
		});
		
		createTree("#logicTree",ztreeArray);
		
		
		//逻辑回显
	    //查看当前的题的逻辑设置,将已经选的逻辑打钩
	    var quLogicitem=quItemBody.find(".quLogicItem");
	    var nodes= zTree.transformToArray(zTree.getNodes());
	    if(quLogicitem[0]){
	    	quLogicitem=quItemBody.find(".quLogicItem").eq(0);
	    	var cgQuItemId=quLogicitem.find("input[name='cgQuItemId']").val();
	    	var skQuId=quLogicitem.find("input[name='skQuId']").val();
	    	var geLe=quLogicitem.find("input[name='geLe']").val();
	    	var ckQuItemId=quLogicitem.find("input[name='ckQuItemId']").val();
	    	var scoreNum=quLogicitem.find("input[name='scoreNum']").val();
	    	var logicType=quLogicitem.find("input[name='logicType']").val();
	    	var eqAndNq=quLogicitem.find("input[name='eqAndNq']").val();
	    	//说明不是一个条件
	    	if(cgQuItemId.indexOf("_ad_") != -1 || cgQuItemId.indexOf("_or_") != -1){
	    		var cgQuItemIdArray=new Array();
	    		var skQuIdArray=new Array();
	    		var geLeArray=new Array();
	    		var scoreNumArray=new Array();
	    		//cgQuItemIdArray=cgQuItemId.split(/_ad_|_or_/);
	    		cgQuItemIdArray =splitArray(cgQuItemId);
	  
	    		//skQuIdArray=skQuId.split(/_ad_|_or_/);
	    		skQuIdArray=splitArray(skQuId);
	            geLeArray=geLe.split(/_ad_|_or_/);
	            scoreNumArray=scoreNum.split(/_ad_|_or_/);
	            eqAndNqArray=eqAndNq.split(/_ad_|_or_/);
	       
	    		for(var i=0;i<cgQuItemIdArray.length;i++){
	    			
	    			
	    			
	    			for(var j=0;j<nodes.length;j++){
	    				
	    				var skQuIdArraytemp=skQuIdArray[i];
	    				var cgQuItemIdArraytemp=cgQuItemIdArray[i];
	    				var skQuIdArrayTempNoandOr=skQuIdArraytemp.replace(/[&]/g,"").replace(/[|]/g,"");
	    				var cgQuItemIdArraytempNoandOr=cgQuItemIdArraytemp.replace(/[&]/g,"").replace(/[|]/g,"");
	    				var andOr="_ad_";
	    				if(cgQuItemIdArraytemp.indexOf("&") != -1){
	    					andOr="_ad_";
	    				}else if(cgQuItemIdArraytemp.indexOf("|") != -1){
	    					andOr="_or_";
	    				}
	    				
	    				
	    				var nodeId=nodes[j].id;
	    				if(skQuIdArrayTempNoandOr+":"+cgQuItemIdArraytempNoandOr== nodeId){
	    					
	    					var parent = nodes[j].getParentNode();
	    					if(parent != null){
	    						 if(!parent.open){
	         		            	zTree.expandNode(parent,true,true);
	         		            }
	    					}
        		            zTree.checkNode(nodes[j], true, true);
        		            
        		            //回显且或逻辑
        		           
        		         
        		            $("select[name='"+nodes[j].tId+"_logicOrAnd']").val(andOr);
        		       	   // $("#"+nodes[j].tId).find(".eqAndNq").val(eqAndNqArray[i]);
        		            $("select[name='"+nodes[j].tId+"_logicEqNq']").val(eqAndNqArray[i]);
        		            
	    					if(geLeArray[i]!="none" || scoreNumArray[i] !="-1"){
	    						
	    						//这里必须展开节点不然会获取不到回显数据
		    					 $("#"+nodes[j].tId).find(".logicScoreGtLt").val(geLeArray[i]);
		    					 $("#"+nodes[j].tId).find(".logicScoreNum").val(scoreNumArray[i]);
		    				
		    				 }
	    				}
	    			}
	    			
	    		}
	    		
	    		
	    	}else{
	    		//只有一个条件
	    		
	    		for(var j=0;j<nodes.length;j++){
    				var nodeId=nodes[j].id;
    				var nodeTId=nodes[j].tId;
    				if(skQuId+":"+cgQuItemId == nodeId){
    					zTree.checkNode(nodes[j], true, true);
    					
    					//这里必须展开节点不然会获取不到回显数据
    		            var parent = nodes[j].getParentNode();
    		            if(parent != null){
   						 if(!parent.open){
        		            	zTree.expandNode(parent,true,true);
        		            }
   					    }
    		            
    		            $("#"+nodes[j].tId).find(".eqAndNq").val(eqAndNq);
    					if(geLe!="none" || scoreNum !="-1"){
    						 //这里没有成功赋值
	    					 $("#"+nodeTId).find(".logicScoreGtLt").val(geLe);
	    					 $("#"+nodeTId).find(".logicScoreNum").val(scoreNum);
	    				 }
    				}
    			}
	    	
	    	}
	    } 	
	    
	    
	   //将移除逻辑和移除选项显示出来
	  //移除逻辑回显
    	if(logicType == 3){
    		
    		//最后一个td添加一个select;
    		var lastTd=$(".dwQuDialogLogicTitle");
    		
    		var model="<select name='option_name_id'></select>";
    		$(".dwQuDialogLogicTitle select[name='option_name_id']").remove();
    		lastTd.append(model);
    		 if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				 var quChenColumnTds=quItemBody.find(".quChenColumnTd");
				 var quChenRowTds=quItemBody.find(".quChenRowTd");
				 $.each(quChenColumnTds,function(){
						//获得行的名称和id
						var rowText=$(this).find(".quCoOptionEdit").text();
					    var rowQuItemId=$(this).find("input[name='quItemId']").val();
					    $.each(quChenRowTds,function(){
					    	//获得列的名称和id
					    	var colText=$(this).find(".quCoOptionEdit").text();
							var colQuItemId=$(this).find("input[name='quItemId']").val();
						
							
					   	    var optionString="<option value='"+colQuItemId+":"+rowQuItemId+"'>"+rowText+"+"+colText+"</option>";
							$("select[name='option_name_id']").prepend(optionString);
					    })
					});
			 }else{
				 if(quType==="FILLBLANK"){
					 
					 var optionString="<option value='1'>选项1</option>"
					 $("select[name='option_name_id']").prepend(optionString);
				 }else{
					 
				   var quItemInputCases=quItemBody.find(".quItemInputCase");
		            	
		           $.each(quItemInputCases,function(){
					var optionText=$(this).parent().find("label.quCoOptionEdit").text();
	    			var optionId=$(this).find("input[name='quItemId']").val();	
	    				
	    			var option="<option value='"+optionId+"'>"+optionText+"</option>";
	    			$("select[name='option_name_id']").prepend(option); 
		           });	
				 }	
			 }
    		 lastTd.find("select[name='option_event']").val(logicType);
    		 lastTd.find("select[name='option_name_id']").val(ckQuItemId);
    		 //将ckquitemid的值选中
    		 
    	}else if(logicType == 4){
    		var lastTd=$(".dwQuDialogLogicTitle");
    		 lastTd.find("select[name='option_event']").val(logicType);
    	}
	    
	    
		
		
		
	}
	function splitArray(obj){
		var arr =new Array();
		obj=obj.replace(/_ad_/g,"&").replace(/_or_/g,"|");
		var startIndex=0;
		for(var i=0;i<obj.length;i++){
			if((obj[i] == "&" || obj[i] == "|") && i < obj.length -1){
				var str=obj.substring(startIndex,i+1);
				arr.push(str);
				startIndex=(i+1)
			}
		}
		arr.push(obj.substring(startIndex));
		
		return arr;
	}
	
	function loadZtreeModel(ztreeArray,quItemBody){
		  var quType=quItemBody.find("input[name='quType']").val();
	      var isSubentry=quItemBody.find("input[name='isSubentry']").val();
	      var  quCoNum=quItemBody.find(".quCoNum").text();
		  var  quCoTitleEdit=quItemBody.find(".quCoTitleEdit").text();
		  var  curQuId=quItemBody.find("input[name='quId']").val();
		
		  
		  if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
			  var quChenColumnTds=quItemBody.find(".quChenColumnTd");
			  var quChenRowTds=quItemBody.find(".quChenRowTd");
			  
				$.each(quChenColumnTds,function(){
					//获得行的名称和id
					var rowText=$(this).find(".quCoOptionEdit").text();
				    var rowQuItemId=$(this).find("input[name='quItemId']").val();
				    $.each(quChenRowTds,function(){
				    	//获得列的名称和id
				    	var colText=$(this).find(".quCoOptionEdit").text();
						var colQuItemId=$(this).find("input[name='quItemId']").val();
					
						var id=curQuId+":"+colQuItemId+";"+rowQuItemId;
						var pId=curQuId+":"+curQuId;
						var itemName=rowText+"-"+colText;
						var type=quType;
						var isParent=false;
						var ztreeChildObject=ztreeObject(id,pId,type,isParent,itemName);
						ztreeArray.push(ztreeChildObject);
				    })
				});
		  }else if(quType==="FILLBLANK"){
			  
			  for(var i=1;i<3;i++){
				  var id=curQuId+":"+(i-1);
				  var pId=curQuId+":"+curQuId;
				  var itemName= (i-1== 1) ? quCoTitleEdit+"回答":quCoTitleEdit+"拒答";
				  var type=quType;
				  var isParent=false;
				  var ztreeChildObject=ztreeObject(id,pId,type,isParent,itemName);
				  ztreeArray.push(ztreeChildObject);
			  }
		  }else{
		    	if(quType !="ORDERQU"){
	        		
	            	var quItemInputCases=quItemBody.find(".quItemInputCase");
	            	
	            	$.each(quItemInputCases,function(i){
	           
            			var optionText=$(this).parent().find("label.quCoOptionEdit").text();
        				var optionId=$(this).find("input[name='quItemId']").val();
        				var noCheckBox=$(this).find("input[name='noCheckBox']").val();
	        			var id=curQuId+":"+optionId;
	       			    var pId=curQuId+":"+curQuId;
	       				var itemName=optionText;
	       				var type=quType;
	       				var isParent=false;
	       				if(noCheckBox != "1"){
	       					var ztreeChildObject=ztreeObject(id,pId,type,isParent,itemName);
		       				ztreeArray.push(ztreeChildObject);
	       				}
	            	})
	        	}
		  }
	}
	
	//复制逻辑

	
	
	
	
	
	
	//COPYCHANGE逻辑
	function selectChange(thisItemforHidden,quItemBody,logicType){
		thisItemforHidden.html("");
		var  quType=quItemBody.find("input[name='quType']").val();
		if(logicType == 3){
			$(".logicType_three").show();
			//添加select选项款
			 if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				 var quChenColumnTds=quItemBody.find(".quChenColumnTd");
				 var quChenRowTds=quItemBody.find(".quChenRowTd");
				 $.each(quChenColumnTds,function(){
						//获得行的名称和id
						var rowText=$(this).find(".quCoOptionEdit").text();
					    var rowQuItemId=$(this).find("input[name='quItemId']").val();
					    $.each(quChenRowTds,function(){
					    	//获得列的名称和id
					    	var colText=$(this).find(".quCoOptionEdit").text();
							var colQuItemId=$(this).find("input[name='quItemId']").val();
						
							
					   	    var optionString="<option value='"+colQuItemId+":"+rowQuItemId+"'>"+rowText+"+"+colText+"</option>";
					   	    thisItemforHidden.prepend(optionString);
					    })
					});
			 }else{
				 if(quType==="FILLBLANK"){
					 
					 var optionString="<option value='1'>选项1</option>"
					 thisItemforHidden.prepend(optionString);
				 }else{
					 
				   var quItemInputCases=quItemBody.find(".quItemInputCase");
		            	
		           $.each(quItemInputCases,function(){
					var optionText=$(this).parent().find("label.quCoOptionEdit").text();
	    			var optionId=$(this).find("input[name='quItemId']").val();	
	    				
	    			var option="<option value='"+optionId+"'>"+optionText+"</option>";
	    			thisItemforHidden.prepend(option); 
		           });	
				 }	
			 }
			
		}else{
			$(".logicType_three").hide();
		}
		
	  return false;
	}
	
   //保存复制逻辑
	$("#dwDialogLogicSetSave").click(function(){
		
		//逻辑保存模板
		var quLogicItemHtml=$("#quLogicItemModel").html();
		var quItemBody=$(dwDialogObj).parents(".li_surveyQuItemBody ");
		//
		
		
		var selectQuId=$("#nextUtilBody").val();
		var thisItemforHiddenVal =$("#thisItemforHidden").val();
		
		//当前需要逻辑的qus
		
		
		var quLogicItem=quItemBody.find(".quLogicItem");
		var quId=quItemBody.find(".quId").val();
		
		//逻辑所在的qus
		var targetQuItemBody = quItemBody.prevAll().has("input[name='quId'][value='"+selectQuId+"']");
		var targetQuLogicItem=targetQuItemBody.find(".quLogicItem");
		if(!targetQuLogicItem[0]){
				alert("本题没有设置逻辑");
				return false;
				
		}else{
			
			//如果当前问题没有提前设置逻辑则添加逻辑模板
			if(!quLogicItem[0]){
				quItemBody.find(".quLogicInputCase").append(quLogicItemHtml);
			}
			
			var cgQuItemId=targetQuItemBody.find("input[name='cgQuItemId']").val();
			var skQuId=targetQuItemBody.find("input[name='skQuId']").val();
			var ckQuItemId="";
			var geLe=targetQuItemBody.find("input[name='geLe']").val();
			var scoreNum=targetQuItemBody.find("input[name='scoreNum']").val();
			var logicType=targetQuItemBody.find("input[name='logicType']").val();
			var eqAndNq=targetQuItemBody.find("input[name='eqAndNq']").val();
			
			//将现有逻辑加入目标题目
			quItemBody.find("input[name='saveTag']").val("0");
			quItemBody.find(".quLogicItem").find("input[name='logicSaveTag']").val("0");
			quItemBody.find("input[name='visibility']").val("1");
			quItemBody.find("input[name='cgQuItemId']").val(cgQuItemId);
			quItemBody.find("input[name='skQuId']").val(skQuId);
			quItemBody.find("input[name='eqAndNq']").val(eqAndNq);
			
			if($(".logicType_three").is(":visible") == true){
				 ckQuItemId=thisItemforHiddenVal;
			}else{
				ckQuItemId=targetQuItemBody.find("input[name='ckQuItemId']").val();
			}
			
			quItemBody.find("input[name='ckQuItemId']").val(ckQuItemId);
			quItemBody.find("input[name='geLe']").val(geLe);
			quItemBody.find("input[name='scoreNum']").val(scoreNum);
			quItemBody.find("input[name='logicType']").val(logicType);
			
		}
		//保存题目
		$.ajaxSettings.async = false;
		saveQus(quItemBody,function(){	
		});
		$("#dwCommonDialogClose").trigger("click");
		refreshQuLogicInfo(quItemBody);
		
	})
	
	function loadModel(hasTrFlag,quItemBody,model_1,model_2,model_3,model_4,dwQuLogicTable){
		
		
        var quType=quItemBody.find("input[name='quType']").val();
        var isSubentry=quItemBody.find("input[name='isSubentry']").val();
    	var  quCoNum=quItemBody.find(".quCoNum").text();
		var  quCoTitleEdit=quItemBody.find(".quCoTitleEdit").text();
		var  curQuId=quItemBody.find("input[name='quId']").val();
		var model;
        if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
        	var quChenColumnTds=quItemBody.find(".quChenColumnTd");
			var quChenRowTds=quItemBody.find(".quChenRowTd");
			
			//获得提标题和题的id
		
			$.each(quChenColumnTds,function(){
				//获得行的名称和id
				var rowText=$(this).find(".quCoOptionEdit").text();
			    var rowQuItemId=$(this).find("input[name='quItemId']").val();
			    $.each(quChenRowTds,function(){
			    	//获得列的名称和id
			    	var colText=$(this).find(".quCoOptionEdit").text();
					var colQuItemId=$(this).find("input[name='quItemId']").val();
				
					if(hasTrFlag){
						model=model_2.clone(true);
					}else{
						model=model_1.clone(true);
						hasTrFlag=true;
					}
					
			   	    var optionString="<option value='"+curQuId+":"+colQuItemId+";"+rowQuItemId+"'>"+quCoTitleEdit+":"+rowText+"+"+colText+"</option>"
					model.find(".logicQuOptionSel").append(optionString);
					dwQuLogicTable.append(model);
			    })
			})
        	
        }else if(quType==="FILLBLANK"){
        	//获得模板
         
        	if(hasTrFlag){
 				model=model_2.clone(true);
 			}else{
 				model=model_1.clone(true);
 				hasTrFlag=true;
 			}
            model.find(".ifSpanText1").text("如果"); 
        	 
           model.find("td").has(".logicQuOptionSel").after("<td>回答</td>");
           var option="<option value='"+curQuId+":1'>"+quCoTitleEdit+"</option>";
           model.find(".logicQuOptionSel").append(option);
           dwQuLogicTable.append(model); 
           
	       	if(hasTrFlag){
					model=model_2.clone(true);
				}else{
					model=model_1.clone(true);
					hasTrFlag=true;
			} 
       	   model.find(".ifSpanText1").text("如果"); 
           model.find("td").has(".logicQuOptionSel").after("<td>拒答</td>");	
           var option="<option value='"+curQuId+":0'>"+quCoTitleEdit+"</option>";
           model.find(".logicQuOptionSel").append(option);
           dwQuLogicTable.append(model); 
         	
        }else{
        	
        	//改变评分题 的模板
        	
            //除掉排序题的model
        	
        	if(quType !="ORDERQU"){
        		
            	var quItemInputCases=quItemBody.find(".quItemInputCase");
            	
            	$.each(quItemInputCases,function(i){
            		
            		if(quType=='SCORE'){
                		
                		
                		if(hasTrFlag){
                			model=model_4.clone(true);
                			
                		}else{
                			model=model_3.clone(true);
                			hasTrFlag=true;
                		}
                		
                		var logicScoreNum=model.find(".logicScoreNum");
            			logicScoreNum.empty();
            			for(var j=0;j<=10;j++){
            			  logicScoreNum.append("<option value=\""+j+"\" >"+j+"</option>");		
            		    }
                		
                	}else{
                		if(hasTrFlag ){
                			model=model_2.clone(true);
                			
                		}else{
                			model=model_1.clone(true);
                			hasTrFlag=true;
                		}
            
                	}
            	
	            	//分项题的标题选项不计入逻辑  加入逻辑
            		var noCheckBox=$(this).find("input[name='noCheckBox']").val();
            		if(quType !="CHECKBOX" || (quType =="CHECKBOX" &&  noCheckBox  != "1" )){
            			
            			if(quType =="CHECKBOX" && noCheckBox  != "1" && i == 1 && isSubentry == 1 && !dwQuLogicTable.find(".logicQuSel")[0]){
            				model = model_1.clone(true);
            			}
            			var optionText=$(this).parent().find("label.quCoOptionEdit").text();
        				var optionId=$(this).find("input[name='quItemId']").val();
        				var option="<option value='"+curQuId+":"+optionId+"'>"+quCoTitleEdit+":"+optionText+"</option>";
        				model.find(".logicQuOptionSel").append(option);
        				dwQuLogicTable.append(model);
            		}
            	})
        	}

        }
        
        return hasTrFlag;
	}
	
	function trueCallBack(quItemBody){
		var dwQuLogicTable=$("#dwQuLogicTable");
		var lastTr=dwQuLogicTable.find("tr").last();
		var elsequItemBody=quItemBody.prevAll();
		$.each(elsequItemBody,function(){
			var tempquItemBody=$(this);
			var quType=tempquItemBody.find("input[name='quType']").val();
			var quCoNum=tempquItemBody.find(".quCoNum").text();
			var quCoTitleEdit=tempquItemBody.find(".quCoTitleEdit").text();
			var curQuId=quItemBody.find("input[name='quId']").val();
			var quCoItemUlLi=tempquItemBody.find(".quCoItemUlLi");
			$.each(quCoItemUlLi,function(){
				
				//判断上面题组的类型
				if(true){
					
				}else{
					var tempquCoItemUlLi=$(this);
					var quCoOptionEdit=tempquCoItemUlLi.find(".quCoOptionEdit").text();
					var quItemId=tempquCoItemUlLi.find("input[name='quItemId']").val();
					var preTr=lastTr.prev().prev();
					var option=preTr.find(".logicQuOptionSel").find("option");
					var nowOptionvalue=curQuId+":"+quItemId;
					/*if(option[0]){
						$.each(option,function(){
							var value=$(this).val();
							if(value !=nowOptionvalue){
								var option="<option value='"+curQuId+":"+quItemId+"'>"+quCoNum+quCoTitleEdit+":"+quCoOptionEdit+"</option>"
								lastTr.find(".logicQuOptionSel").append(option);
							}
						})
					}*/
					var option="<option value='"+curQuId+":"+quItemId+"'>"+quCoNum+quCoTitleEdit+":"+quCoOptionEdit+"</option>"
					lastTr.find(".logicQuOptionSel").append(option);
				}
			})
			
		})
	}
	
	
	function haslogicInfo(obj,skQuId,cgQuItemId,logicType){
		var temp=null;
		obj.each(function(){
			var sobj=$(this);
			var oldSkQuId=sobj.find("input[name='skQuId']").val();
			var oldCgQuItemId=sobj.find("input[name='cgQuItemId']").val();
			var oldLogicType=sobj.find("input[name='logicType']").val();
			if(oldSkQuId ==skQuId && oldCgQuItemId == cgQuItemId && logicType == oldLogicType){
				
				temp=$(this);
			}
		});
		return temp;
	}
	//保存逻辑设置  --删除的逻辑保存策略
/*	$("#dwDialogSaveLogic").click(function(){
		var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
		var quLogicInputCase=quItemBody.find(".quLogicInputCase");
		var quType=quItemBody.find("input[name='quType']").val();
		
		var dwQuLogicTrs=$("#dwQuLogicTable tr");
		var quLogicItemHtml=$("#quLogicItemModel").html();
		$.each(dwQuLogicTrs,function(){
			var cgQuItemId=$(this).find(".logicQuOptionSel").val();
			var skQuId=$(this).find(".logicQuSel").val();
			var logicType=$(this).find(".logicType").val();
			var quLogicItemClass=$(this).attr("class");
		
			//判断已经保存过的，保存过的只做修改
			if(skQuId!="" && cgQuItemId!=""){
				
				//var quLogicItem=quLogicInputCase.find("."+quLogicItemClass);
				var quLogicItem=quLogicInputCase.find(".quLogicItem");
				var quLogicItemobj=haslogicInfo(quLogicItem,skQuId,cgQuItemId,logicType);
				if(quLogicItemobj){
					
					//已经有值--检查值是否有发生变化 
					var oldSkQuId=quLogicItem.find("input[name='skQuId']").val();
					var oldCgQuItemId=quLogicItem.find("input[name='cgQuItemId']").val();
					var oldLogicType=quLogicItem.find("input[name='logicType']").val();
					
					//在这里改逻辑 oldSkQuId!=skQuId || cgQuItemId!=oldCgQuItemId || oldLogicType!=logicType
					    quLogicItemobj.find("input[name='logicSaveTag']").val("0");
					    quLogicInputCase.find("input[name='saveTag']").val("0");
						//后来修复的
						quLogicItemobj.find("input[name='skQuId']").val(skQuId);
						quLogicItemobj.find("input[name='cgQuItemId']").val(cgQuItemId);
						quLogicItemobj.find("input[name='logicType']").val(logicType);
						quLogicItemobj.find("input[name='visibility']").val("1");
					
					//如果是评分题
					if(quType==="SCORE"){
						//geLe scoreNum
						//logicScoreGtLt logicScoreNum logicEvent
						var logicScoreGtLt=$(this).find(".logicScoreGtLt").val();
						var logicScoreNum=$(this).find(".logicScoreNum").val();
//						var logicEvent=$(this).find(".logicEvent").val();
						quLogicItemobj.find("input[name='geLe']").val(logicScoreGtLt);
						quLogicItemobj.find("input[name='scoreNum']").val(logicScoreNum);
						quLogicItemobj.find("input[name='logicType']").val(logicType);
//						quLogicItem.find("input[name='logicEvent']").val(logicEvent);
						//状态
						quLogicItemobj.find("input[name='logicSaveTag']").val("0");
						quItemBody.find("input[name='saveTag']").val("0");
						
					}
				}else{
					quLogicInputCase.append(quLogicItemHtml);
					quLogicItem=quLogicInputCase.find(".quLogicItem").last();
					quLogicItem.addClass(quLogicItemClass);
					//修改值
					quLogicItem.find("input[name='quLogicId']").val("");
					quLogicItem.find("input[name='skQuId']").val(skQuId);
					quLogicItem.find("input[name='cgQuItemId']").val(cgQuItemId);
					quLogicItem.find("input[name='visibility']").val("1");
					quLogicItem.find("input[name='logicType']").val(logicType);
					quItemBody.find("input[name='saveTag']").val("0");
					
					//如果是评分题
					if(quType==="SCORE"){
						//geLe scoreNum  //logicScoreGtLt logicScoreNum logicEvent
						var logicScoreGtLt=$(this).find(".logicScoreGtLt").val();
						var logicScoreNum=$(this).find(".logicScoreNum").val();
//						var logicEvent=$(this).find(".logicEvent").val();
						quLogicItem.find("input[name='geLe']").val(logicScoreGtLt);
						quLogicItem.find("input[name='scoreNum']").val(logicScoreNum);
						quLogicItem.find("input[name='logicType']").val(logicType);
//						quLogicItem.find("input[name='logicEvent']").val(logicEvent);
					}
				}
			}
		});
		
		refreshQuLogicInfo(quItemBody);
		dwCommonDialogHide();
		return false;
	});*/
	
	//保存逻辑设置  --pjl的逻辑保存策略
	$("#dwDialogSaveLogic").click(function(){
		
		//当前所在的题
		var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
		//保存逻辑的div
		var quLogicInputCase=quItemBody.find(".quLogicInputCase");
		var quType=quItemBody.find("input[name='quType']").val();
		
		//获得每个被选中逻辑的t
		
		
		//逻辑保存模板
		var quLogicItemHtml=$("#quLogicItemModel").html();
	   
		//请空以前的逻辑
		//quLogicInputCase.find(".quLogicItem").remove();
		
		var logicType=$(".dwQuDialogLogicTitle").find(".logicType").val();
		var skQuId=$(".dwQuDialogLogicTitle").find(".logicQuSel").val();
		
		//找到移除选项的id
		var ckQuItemId=$(".dwQuDialogLogicTitle").find("select[name='option_name_id']").val();
		
	    var cgQuItemIdtotal="";
		var ckQuIdtotal="";
		
		var logicScoreGtLtAll="";
		var logicScoreNumAll="";
		
		var eqAndNqAll="";
		
		//获得所有被勾选的节点
	  
		var nodes = zTree.getCheckedNodes(true);
		
		for(var i=0;i<nodes.length;i++){
			//判断父选项是否被选中
			if(nodes[i].isParent == false){
				var parentStatus=nodes[i].getParentNode().getCheckStatus().checked;
				if(parentStatus == true){
					continue;
				}
			}
			var cgQuItemId=nodes[i].id;
			var cgQuItemIdArray=new Array();
			cgQuItemIdArray=cgQuItemId.split(":");
	        var orAnd=$("select[name='"+nodes[i].tId+"_logicOrAnd']").val();
	        var eqAndNq=$("select[name='"+nodes[i].tId+"_logicEqNq']").val();
			var ck=cgQuItemIdArray[0]+orAnd;
			var cg=cgQuItemIdArray[1]+orAnd;
			var logicScoreGtLt=$("#"+nodes[i].tId).find(".logicScoreGtLt");
			var logicScoreNum=$("#"+nodes[i].tId).find(".logicScoreNum");
            if(logicScoreGtLt[0]){
				
				logicScoreGtLtAll += (logicScoreGtLt.eq(0).val()+orAnd);
				logicScoreNumAll += (logicScoreNum.eq(0).val()+orAnd);

			}else{
				logicScoreGtLtAll += "none"+orAnd;
				logicScoreNumAll += "-1"+orAnd;
			}
          //分割成题目,按顺序存储
			cgQuItemIdtotal +=cg;
			ckQuIdtotal+=ck;
			eqAndNqAll+=eqAndNq+orAnd;
		}
		

		
		//将最后的逗号出去(_ad_ 或者_or_)
		var cgQuItemIdtotalLength=cgQuItemIdtotal.length;
		cgQuItemIdtotal=cgQuItemIdtotal.substring(0, cgQuItemIdtotalLength-4);
		var ckQuIdtotallength=ckQuIdtotal.length;
		ckQuIdtotal=ckQuIdtotal.substring(0, ckQuIdtotallength-4);
		var logicScoreGtLtAllLength=logicScoreGtLtAll.length;
		logicScoreGtLtAll=logicScoreGtLtAll.substring(0, logicScoreGtLtAllLength-4);
		var logicScoreNumAllLength=logicScoreNumAll.length;
		logicScoreNumAll=logicScoreNumAll.substring(0, logicScoreNumAllLength-4);
		var eqAndNqAllLength=eqAndNqAll.length;
		eqAndNqAll=eqAndNqAll.substring(0, eqAndNqAllLength-4);
		
		//将获得的存储获得的逻辑
		var quLogicItem=quLogicInputCase.find(".quLogicItem");
		
		if(quLogicItem[0]){
			quLogicItem.find("input[name='skQuId']").val("");
			quLogicItem.find("input[name='cgQuItemId']").val("");
			quLogicItem.find("input[name='geLe']").val("");
			quLogicItem.find("input[name='scoreNum']").val("");
			quLogicItem.find("input[name='eqAndNq']").val("");
		}else{
			quLogicInputCase.append(quLogicItemHtml);
		}
		quLogicItem=quLogicInputCase.find(".quLogicItem").last();
		//quLogicItem.find("input[name='quLogicId']").val("");
		quLogicItem.find("input[name='skQuId']").val(ckQuIdtotal);
		quLogicItem.find("input[name='cgQuItemId']").val(cgQuItemIdtotal);
		//quLogicItem.find("input[name='ckQuId']").val(ckQuIdtotal);
		quLogicItem.find("input[name='visibility']").val("1");
		quLogicItem.find("input[name='logicType']").val(logicType);
		quItemBody.find("input[name='saveTag']").val("0");
		
		quLogicItem.find("input[name='geLe']").val(logicScoreGtLtAll);
		quLogicItem.find("input[name='scoreNum']").val(logicScoreNumAll);
		quLogicItem.find("input[name='eqAndNq']").val(eqAndNqAll);
		quLogicItem.find("input[name='logicSaveTag']").val("0");
		if(ckQuItemId != undefined && ckQuItemId != ""){
			quLogicItem.find("input[name='ckQuItemId']").val(ckQuItemId);
		}
		quItemBody.find("input[name='saveTag']").val("0");
        
		saveQus(quItemBody,function(){
		});
		refreshQuLogicInfo(quItemBody);
		$.fn.zTree.destroy("logicTree");
		$(".dwQuDialogAddLogic").show();
		dwCommonDialogHide();
		return false;
	})
	//批量添加弹出窗口-保存事件
	$("#dwDialogSaveMoreItem").click(function(){
		var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
		// var quItemCheckBox=$(dwDialogObj).parents(".quCoBottomTools").prev();
		var quType=quItemBody.find("input[name='quType']").val();
		var areaVal=$("#dwQuMoreTextarea").val();
		var areaValSplits=areaVal.split("\n");
		$.each(areaValSplits,function(i,item){
			item=$.trim(item);
			if(item!=""){
				if(quType=="RADIO"){
					//添加单选选项
					addRadioItem(quItemBody,item);
				}else if(quType=="CHECKBOX" || quType=="CHECKBOXCLASSIFY"){
					var quItemBody_subentry=quItemBody.find("input[name='isSubentry']").val();
					if(quItemBody_subentry == "1"){
						addCheckboxItem_subentry(quItemBody,item,'.addMoreOption');	
					}else{
						addCheckboxItem(quItemBody,item);
					}
					//添加多选选项
					
				}else if(quType=="SCORE"){
					addScoreItem(quItemBody,item);
				}else if(quType=="ORDERQU"){
					addOrderquItem(quItemBody, item);
				}else if(quType=="MULTIFILLBLANK"){
					addMultiFillblankItem(quItemBody, item);
				}else if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
					addChenItem(dwDialogObj,quItemBody, item);
				}
			}
		});
		$("#dwQuMoreTextarea").val("");
		bindQuHoverItem();
		dwCommonDialogHide();
	});
	
	//高级编辑器OK事件
	$("#dwDialogUeOk").click(function(){
		var myeditorContent=myeditor.getContent();
		curEditObj=ueEditObj;
		setCurEditContent(myeditorContent);
		curEditCallback();
		ueDialog.dialog("close");
		ueEditObj=null;
		curEditObj=null;
		return false;
	});
	
	//设置窗口保存事件
	$("#dwDialogQuSetSave").click(function(){
		if(dwDialogObj!=null){
			var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
			//var quType=quItemBody.find("input[name='quType']").val();
			var setIsRequired=$("#dwCommonDialog input[name='setIsRequired']:checked");
			var setRandOrder=$("#dwCommonDialog input[name='setRandOrder']:checked");
			var setHv=$("#dwCommonDialog select[name='setHv']").val();
			var setCellCount=$("#dwCommonDialog input[name='setCellCount']").val();
			var setAutoContacts=$("#dwCommonDialog input[name='setAutoContacts']:checked");
			var setContactsField=$("#dwCommonDialog select[name='setContactsField']").val();
			var minNum=$("#dwCommonDialog input[name='minNum']").val();
			var isSelectType=$("#dwCommonDialog input[name='isSelectType']:checked");
			
			var oldHv=quItemBody.find("input[name='hv']").val();
			var oldCellCount=quItemBody.find("input[name='cellCount']").val();
			//alert(set_isRequired+":"+set_randOrder+":"+set_hv);
			quItemBody.find("input[name='isRequired']").val(setIsRequired[0]?1:0);
			quItemBody.find("input[name='hv']").val(setHv);
			quItemBody.find("input[name='randOrder']").val(setRandOrder[0]?1:0);
			quItemBody.find("input[name='cellCount']").val(setCellCount);
			quItemBody.find("input[name='saveTag']").val(0);
			
			var quType=quItemBody.find("input[name='quType']").val();
			var isSubentry=quItemBody.find("input[name='isSubentry']").val();
			if(quType=="RADIO" || quType=="CHECKBOX" || quType=="FILLBLANK" || quType=="CHECKBOXCLASSIFY"){
				quItemBody.find("input[name='contactsAttr']").val(setAutoContacts[0]?1:0);
				quItemBody.find("input[name='contactsField']").val(setContactsField);
				if(quType=="CHECKBOX" && isSubentry != "1"){
					quItemBody.find("input[name='minNum']").val(minNum);
				}
				if(quType=="RADIO"){
					quItemBody.find("input[name='isSelectType']").val(isSelectType[0]?1:0);
				}
				
			}else if(quType=="SCORE"){
				/*var paramInt01=$("#dwCommonDialog .scoreMinMax .minScore");
				if(paramInt01[0]){
					quItemBody.find("input[name='paramInt01']").val(paramInt01.val());
				}*/
				quItemBody.find("input[name='paramInt01']").val(1);
				var paramInt02=$("#dwCommonDialog .scoreMinMax .maxScore");
				if(paramInt02[0]){
					quItemBody.find("input[name='paramInt02']").val(paramInt02.val());
				}
				
				//保存滑块题的所需数据
				var isSlider=$("#dwCommonDialog").find("input[name='isSlider']:checked");
				if(isSlider[0]){
					var maxSliderLength=$("#dwCommonDialog").find("input[name='maxSliderLength']").val();
					var minSliderLength=$("#dwCommonDialog").find("input[name='minSliderLength']").val();
					var totalSliderLength=$("#dwCommonDialog").find("input[name='totalSliderLength']").val();
					quItemBody.find("input[name='isSlider']").val(1);
					quItemBody.find("input[name='minSliderLength']").val(minSliderLength);
					quItemBody.find("input[name='maxSliderLength']").val(maxSliderLength);
					quItemBody.find("input[name='totalSliderLength']").val(totalSliderLength);
				}else{
					quItemBody.find("input[name='isSlider']").val(0);
				}
				
				var isScoreInput=$("#dwCommonDialog").find("input[name='isScoreInput']:checked");
				if(isScoreInput[0]){
					var maxSliderLength=$("#dwCommonDialog").find("input[name='maxSliderLength']").val();
					var minSliderLength=$("#dwCommonDialog").find("input[name='minSliderLength']").val();
					var totalSliderLength=$("#dwCommonDialog").find("input[name='totalSliderLength']").val();
					quItemBody.find("input[name='isScoreInput']").val(1);
					quItemBody.find("input[name='minSliderLength']").val(minSliderLength);
					quItemBody.find("input[name='maxSliderLength']").val(maxSliderLength);
					quItemBody.find("input[name='totalSliderLength']").val(totalSliderLength);
				}else{
					quItemBody.find("input[name='isScoreInput']").val(0);
				}
				//根据分数设置评分选项
				var paramInt01Val=1;
				var paramInt02Val=paramInt02.val();
				var scoreNumTableTr=quItemBody.find(".scoreNumTable tr");
				$.each(scoreNumTableTr,function(){
					$(this).empty();
					for(var i=paramInt01Val;i<=paramInt02Val;i++){
						$(this).append("<td>"+i+"</td>");
					}
				});
			}else if(quType==="MULTIFILLBLANK"){
				var paramInt01=$("#dwCommonDialog .minMaxLi .minNum");
				if(paramInt01[0]){
					quItemBody.find("input[name='paramInt01']").val(paramInt01.val());
				}
				quItemBody.find("input[name='paramInt02']").val(10);
			}else if(quType === "CHENSCORE"){
				var maxSliderLength=$("#dwCommonDialog").find("input[name='maxSliderLength']").val();
				var minSliderLength=$("#dwCommonDialog").find("input[name='minSliderLength']").val();
				quItemBody.find("input[name='minSliderLength']").val(minSliderLength);
				quItemBody.find("input[name='maxSliderLength']").val(maxSliderLength);
			}
			
			var selVal=$(".option_range").val();
			if(selVal==1){
				//横排 transverse
				if(oldHv==3){
					quTableOptoin2Li(quItemBody);
				}
				quItemBody.find(".quCoItem ul").addClass("transverse");	
			}else if(selVal==2){
				if(oldHv==3){
					quTableOptoin2Li(quItemBody);
				}else{
					//竖排
					quItemBody.find(".quCoItem ul").removeClass("transverse");
					quItemBody.find(".quCoItem ul li").width("");
				}
			}else if(selVal==3){
				if(!$("#dwCommonDialogForm").valid()){
					notify("参数不对，请检查！",800);
					return false;
				}
				if(oldHv==3){
					if(oldCellCount!=setCellCount){
						quTableOption2Table(quItemBody);
					}
				}else{
					quLiOption2Table(quItemBody);					
				}
			}
		}
		
	    
		//隐藏评分题的选项
		dwCommonDialogHide();
		return false;
	});
	
	 //保存设置规则属性
	$("#dwDialogSurveyAttrSave").click(function(){
		//调用保存事件 
		
		//逻辑格式验证
		var endNum=$("input[name='endNum']").val();
		var ynEndNum=$("input[name='ynEndNum']:checked");
		var endTime=$("input[name='endTime']").val().trim();
		var ynEndTime=$("input[name='ynEndTime']:checked");
		var endTimeRexp =/^\d{4}-(?:0\d|1[0-2])-(?:[0-2]\d|3[01])( (?:[01]\d|2[0-3])\:[0-5]\d\:[0-5]\d)?$/;
		var endNumRexp=/^[0-9]*[1-9][0-9]*$/;
		

	  if(!endNumRexp.test(endNum)){
			layer.msg("收集数量格式有误");
			return false;
		}  
			
		if(!endTimeRexp.test(endTime) && ynEndTime[0] ){
			layer.msg("收集时间格式有误");
			return false;
		}

		
		
		$("input[name='svyAttrSaveTag']").val(0);
		notify("保存中...",5000);
		saveSurvey(function(){
			isSaveProgress=false;
			notify("保存成功",1000);
		});
		//关闭窗口
		$("#modelUIDialog").dialog("close");
		dwCommonDialogHide();
		/*var url="";
		var data="";
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				alert(msg);
			}
		});*/
		return false;
	});
	
	//选项设置-保存事件
	$("#dwDialogQuOptionSetSave").unbind();
	$("#dwDialogQuOptionSetSave").click(function(){
		var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
		var quOptionParent=$(dwDialogObj).parent();
		//设置回显值 isNote checkType
		var quOption_isNote=$("#modelUIDialog input[name='quOption_isNote']");
		var quOption_checkType=$("#modelUIDialog select[name='quOption_checkType']");
		var quOption_isRequiredFill=$("#modelUIDialog input[name='quOption_isRequiredFill']");
		
		var isNote=quOptionParent.find("input[name='isNote']");
		var checkType=quOptionParent.find("input[name='checkType']");
		var isRequiredFill=quOptionParent.find("input[name='isRequiredFill']");
		
		if(quOption_isNote.prop("checked")&&(isNote.val()=="0" || isNote.val()=="")){
			quItemBody.find("input[name='saveTag']").val(0);
			quOptionParent.find("input[name='quItemSaveTag']").val(0);
		}
		if(quOption_checkType.val()!=checkType.val()){
			quItemBody.find("input[name='saveTag']").val(0);
			quOptionParent.find("input[name='quItemSaveTag']").val(0);
		}
		if(quOption_isRequiredFill.val()!=isRequiredFill.val()){
			quItemBody.find("input[name='saveTag']").val(0);
			quOptionParent.find("input[name='quItemSaveTag']").val(0);
		}
		//alert(isNote.attr("name"));
		if(quOption_isNote.prop("checked")){
			isNote.val(1);	
		}else{
			isNote.val(0);
		}
		var checkTypeVal=quOption_checkType.val();
		if(checkTypeVal==""){
			checkTypeVal="NO";
		}
		checkType.val(checkTypeVal);
		if(quOption_isRequiredFill.prop("checked")){
			isRequiredFill.val(1);
		}else{
			isRequiredFill.val(0);
		}
		//显示填空框
		//$(dwDialogObj).after("<input type='text' class='optionInpText' />");
		quOptionParent.find(".optionInpText").show();
		
		$("#modelUIDialog").dialog("close");
		//resetQuItemHover(null);
		dwCommonDialogHide();p
		return false;
	});
	
	//填空题--填空框设置
	$("#dwDialogQuFillOptionSave").click(function(){
		//alert("..dwDialogObj:"+$(dwDialogObj).attr("class"));
		// if($(dwDialogObj).parents(".mFillblankTableTr")){
		// 	var quItemBody=$(dwDialogObj).parents("td");
		// }else{
		// }
		var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");

        //设置回显值 isNote checkType
		var quFill_checkType=$("#modelUIDialog select[name='quFill_checkType']");
		var qu_inputWidth=$("#modelUIDialog input[name='qu_inputWidth']");
		var qu_inputRow=$("#modelUIDialog input[name='qu_inputRow']");
		
		
		var qu_inputWidthVal=qu_inputWidth.val();
		var qu_inputRowVal=qu_inputRow.val();
		//数字的验证
		var  regx=/^[0-9]*$/;
		
		if(!regx.test(qu_inputWidthVal)){
			layer.msg("请录入有效宽度");
			return false;
		}
        if(!regx.test(qu_inputRowVal)){
        	layer.msg("请录入有效长度");
        	return false;
		}
		
		
		//var quFill_checkType=$("#dwCommonDialog select[name='quFill_checkType']");
		//var quOption_isRequiredFill=$("#dwCommonDialog input[name='quOption_isRequiredFill']");
		
		var checkType=quItemBody.find("input[name='checkType']");
		//输入框 input 大小调整 quFillblankAnswerInput  quFillblankAnswerTextarea
		var answerInputWidth=quItemBody.find("input[name='answerInputWidth']");
		var answerInputRow=quItemBody.find("input[name='answerInputRow']");
		
		//	var saveTag=quItemBody.find("input[name='saveTag']").val();
		if(checkType.val()!=quFill_checkType.val() || answerInputWidth.val()!=qu_inputWidth.val() || answerInputRow.val()!=qu_inputRow.val()){
			quItemBody.find("input[name='saveTag']").val(0);
		}
		
		var checkTypeVal=quFill_checkType.val();
		if(checkTypeVal==""){
			checkTypeVal="NO";
		}
		checkType.val(checkTypeVal);

		answerInputWidth.val(qu_inputWidth.val());
		answerInputRow.val(qu_inputRow.val());
		console.log(555, answerInputWidth)

		//alert(qu_inputRow);
		if(qu_inputRow.val()>1){
			quItemBody.find(".quFillblankAnswerTextarea").show();
			quItemBody.find(".quFillblankAnswerInput").hide();
			quItemBody.find(".quFillblankAnswerTextarea").attr("rows",qu_inputRow.val());
			quItemBody.find(".quFillblankAnswerTextarea").width(qu_inputWidth.val());
		}else{
			quItemBody.find(".quFillblankAnswerTextarea").hide();
			quItemBody.find(".quFillblankAnswerInput").show();
			quItemBody.find(".quFillblankAnswerInput").width(qu_inputWidth.val());
		}
		
		//quItemBody.find(".quCoItemUlLi").removeClass("menuBtnClick");
		quItemBody.find(".quCoItemUlLi").removeClass("hover");
		$("#modelUIDialog").dialog("close");
		resetQuItemHover(null);
		dwCommonDialogHide();
		return false;
	});
	
	
	
	function quTableOptoin2Li(quItemBody){
		var quCoItemTds=quItemBody.find(".quCoItem .tableQuColItem tr td");
		var ulLiHtml="<ul>";
		$.each(quCoItemTds,function(){
			var tdHtml=$(this).html();
			if(tdHtml!=""){
				ulLiHtml+="<li class='quCoItemUlLi'>"+tdHtml+"</li>";
			}
		});
		ulLiHtml+="<ul>";
		quItemBody.find(".quCoItem table.tableQuColItem").remove();
		quItemBody.find(".quCoItem").append(ulLiHtml);
		quItemBody.find(".quCoItem ul li").width("");
		quItemBody.find(".quCoItem ul li label").width("");
		bindQuHoverItem();
	}
	
	function quLiOption2Table(quItemBody){
		var quCoItemlis=quItemBody.find(".quCoItem ul li");
		var quCoItemLiSize=quCoItemlis.size();
		var cellCount=$("#dwCommonDialog input[name='setCellCount']").val();
		var rowCount=parseInt(quCoItemLiSize/cellCount);
		var remainder=quCoItemLiSize%cellCount;
		
		var tdWidth=parseInt(600/cellCount);
		var tdLabelWidth=tdWidth-10;
		if(remainder>0){
			rowCount=rowCount+1;
		}
		var tableHtmlBuild="<table class='tableQuColItem'>";
		for(var i=0;i<rowCount;i++){
			tableHtmlBuild+="<tr>";
			//0*2+(1)=1    0*2+(2)=2     1*2+(1)=3   1*2+(2)=4    2*2+1=5    2*2+2=6
			for(var j=0;j<cellCount;j++){
				var liIndex=(i*cellCount)+j;
				if(liIndex<quCoItemLiSize){
					var liObj=$(quCoItemlis).get(liIndex);
					tableHtmlBuild+="<td>"+$(liObj).html()+"</td>";	
				}else{
					tableHtmlBuild+="<td><div class='emptyTd'></div></td>";
				}
			}
			tableHtmlBuild+="</tr>";
		}
		
		tableHtmlBuild+="</table>";
		quItemBody.find(".quCoItem ul").remove();
		quItemBody.find(".quCoItem").append(tableHtmlBuild);
		//设置亮度
		quItemBody.find(".quCoItem .tableQuColItem tr td").width(tdWidth);
		quItemBody.find(".quCoItem .tableQuColItem tr td label").width(tdLabelWidth);
		
		bindQuHoverItem();
	}
	
	//表格变换了行数之后
	function quTableOption2Table(quItemBody){
		var quCoItemTds=quItemBody.find(".quCoItem .tableQuColItem tr td");
		var quCoItemTdSize=quCoItemTds.size();
		var cellCount=$("#dwCommonDialog input[name='setCellCount']").val();
		var rowCount=parseInt(quCoItemTdSize/cellCount);
		var remainder=quCoItemTdSize%cellCount;
		
		var tdWidth=parseInt(600/cellCount);
		var tdLabelWidth=tdWidth-10;
		if(remainder>0){
			rowCount=rowCount+1;
		}
		var tableHtmlBuild="<table class='tableQuColItem'>";
		for(var i=0;i<rowCount;i++){
			tableHtmlBuild+="<tr>";
			//0*2+(1)=1    0*2+(2)=2     1*2+(1)=3   1*2+(2)=4    2*2+1=5    2*2+2=6
			for(var j=0;j<cellCount;j++){
				var tdIndex=(i*cellCount)+j;
				if(tdIndex<quCoItemTdSize){
					var tdObj=$(quCoItemTds).get(tdIndex);
					tableHtmlBuild+="<td>"+$(tdObj).html()+"</td>";	
				}else{
					tableHtmlBuild+="<td><div class='emptyTd'></div></td>";
				}
			}
			tableHtmlBuild+="</tr>";
		}
		
		tableHtmlBuild+="</table>";
		quItemBody.find(".quCoItem table.tableQuColItem").remove();
		quItemBody.find(".quCoItem").append(tableHtmlBuild);
		//设置亮度
		quItemBody.find(".quCoItem .tableQuColItem tr td").width(tdWidth);
		quItemBody.find(".quCoItem .tableQuColItem tr td label").width(tdLabelWidth);
		
		bindQuHoverItem();
	}
	
	
	//点击加边框编辑
	/*$("#dwSurveyNote").click(function(){
		curEditCallback();
		$(this).addClass("click");
		//editAble($(this));
		return false;
	});
	*/
	$("#dwSurveyName").click(function(){
		editAble($(this));
		return false;
	});
	$("#dwSurveyNoteEdit").click(function(){
		editAble($(this));
		return false;
	});
	

	
	$(".dwComEditMenuBtn").click(function(){
		//dwComEditMenuBtn
		var dwMenuUl=$(".dwComEditMenuUl:visible");
		//根据当前编辑的对象
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		var quType=quItemBody.find("input[name='quType']").val();
		var curEditClass=$(curEditObj).attr("class");
		if(quType=="RADIO" || quType=="CHECKBOX"){
			if(curEditClass.indexOf("quCoTitleEdit")<0){
				$(".dwComEditMenuUl .option_Set_Li").show();
			}else{
				$(".dwComEditMenuUl .option_Set_Li").hide();
			}
		}else{
			$(".dwComEditMenuUl .option_Set_Li").hide();
		}
		
		if(dwMenuUl[0]){
			$(".dwComEditMenuUl").hide();	
		}else{
			$(".dwComEditMenuUl").show();
		}
		return false;
	});
	
	$("#dwCommonDialogClose").click(function(){
		
		//销毁ztree树
		$.fn.zTree.destroy("logicTree");
		dwCommonDialogHide();
		$(".dwQuDialogAddLogic").show();
		resetQuItemHover(null);
	});
	
	$("#dwComEditContent").keyup(function(){
		$(curEditObj).html($("#dwComEditContent").html());
		$(curEditObj).css("display","inline-block");
		
		var dwEditWidth=$(curEditObj).width();
		//var dwEditWidth=$("#dwComEditContent").width();
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		
		var thClass=curEditObj.attr("class");
		if(thClass.indexOf("dwSvyNoteEdit")<0 &&  thClass.indexOf("dwSvyName")<0){
			var hv=quItemBody.find("input[name='hv']").val();
			if(hv==3){
				dwEditWidth>600?dwEditWidth=600:dwEditWidth;
			}else{
				dwEditWidth<200?dwEditWidth=200:dwEditWidth>600?dwEditWidth=600:dwEditWidth;
			}
		}else{
			dwEditWidth=680;
		}
		
		//dwEditWidth>600?dwEditWidth=600:dwEditWidth;
		$("#dwCommonEditRoot .dwCommonEdit").css("width",dwEditWidth);
		//设置坐标
		if(curEditObj!=null){
			var editOffset=$(curEditObj).offset();
			$("#dwCommonEditRoot").show();
			$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
		}
	});
	
	
   //提交保存的按钮
	$("#saveBtn").click(function(){
		
		curEditCallback();
		dwCommonDialogHide();
		resetQuItemHover(null);
		
		notify("保存中...",5000);
		saveSurvey(function(){
			isSaveProgress=false;
			notify("保存成功",1000);
		});
		/*var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();
		saveQus(fristQuItemBody,function(){});*/
		/*var quBodys=$("#dwSurveyQuContent .surveyQuItemBody");
		$.each(quBodys,function(i){
			var quType=$(this).find("input[name='quType']").val();
			if(quType=="RADIO"){
				//保存单选
				saveRadio($(this),i);
				quCBNum++;
			}else if(quType=="CHECKBOX"){
				callbackNum++;
			}
		});
		*/
	});
	
	$("#publishBtn").click(function(){
		curEditCallback();
		dwCommonDialogHide();
		resetQuItemHover(null);

		saveSurvey(function(){
			isSaveProgress=false;
			window.location.href=ctx+"/design/my-survey-design!previewDev.action?surveyId="+questionBelongId;
		});
		/*
		var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();
		saveQus(fristQuItemBody,function(){
			window.location.href=ctx+"/design/my-survey-design!previewDev.action?surveyId="+questionBelongId;
		});*/

	});
	$("#previewBtn").click(function(){
		curEditCallback();
		dwCommonDialogHide();
		resetQuItemHover(null);
		saveSurvey(function(){
			isSaveProgress=false;
			window.location.href=ctx+"/design/my-survey-design!previewDevLogic.action?surveyId="+questionBelongId;
		});
		/*
		var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();
		saveQus(fristQuItemBody,function(){
			window.location.href=ctx+"/design/my-survey-design!previewDev.action?surveyId="+questionBelongId;
		});*/

	});
	
	
	
	function saveSurvey(callback){
		isSaveProgress=true;
		//保存问卷级别信息--之后财保存问卷中的题
		var svyNmSaveTag=$("input[name='svyNmSaveTag']").val();
		var svyNoteSaveTag=$("input[name='svyNoteSaveTag']").val();
		var svyAttrSaveTag=$("input[name='svyAttrSaveTag']").val();
		if( svyNmSaveTag==="0" || svyNoteSaveTag==="0" || svyAttrSaveTag==="0"){
			var url=ctx+"/design/my-survey-design!ajaxSave.action";
			var data="surveyId="+questionBelongId;
			if(svyNmSaveTag==="0"){
				var dwSurveyName=$("#dwSurveyName").html();
				dwSurveyName=escape(encodeURIComponent(dwSurveyName));
				data+="&svyName="+dwSurveyName;
			}
			
			if(svyNoteSaveTag==="0"){
				var dwSurveyNoteEdit=$("#dwSurveyNoteEdit").html();
				dwSurveyNoteEdit=escape(encodeURIComponent(dwSurveyNoteEdit));
				data+="&svyNote="+dwSurveyNoteEdit;
			}
			//规则属性
			//收集规则 
			var effective=$("input[name='effective']:checked")[0]?"4":"0";
			var effectiveIp=$("input[name='effectiveIp']:checked")[0]?"1":"0";
			var rule=$("input[name='rule']:checked")[0]?"3":"0";
			var ruleCode=$("input[name='ruleCode']").val();
			var refresh=$("input[name='refresh']:checked")[0]?"1":"0";
			var mailOnly=$("input[name='mailOnly']:checked")[0]?"1":"0";
			var ynEndNum=$("input[name='ynEndNum']:checked")[0]?"1":"0";
			var ynEndTime=$("input[name='ynEndTime']:checked")[0]?"1":"0";
			var endTime=$("input[name='endTime']").val();
			var endNum=$("input[name='endNum']").val();
			var showShareSurvey=$("input[name='showShareSurvey']:checked")[0]?"1":"0";
			var showAnswerDa=$("input[name='showAnswerDa']:checked")[0]?"1":"0";
			
			data+="&effective="+effective+"&effectiveIp="+effectiveIp+"&rule="+rule+"&refresh="+refresh+"&ruleCode="+ruleCode+"&mailOnly="+mailOnly;
			data+="&ynEndNum="+ynEndNum+"&ynEndTime="+ynEndTime+"&endTime="+endTime+"&endNum="+endNum;
			data+="&showShareSurvey="+showShareSurvey+"&showAnswerDa="+showAnswerDa;
			
			//effective
/*			var effectiveObj=$("input[name='effective']:checked");
			if(effectiveObj[0]){
				data+="&effective="+effectiveObj.val();
			}
			var effectiveIpObj=$("input[name='effectiveIp']:checked");
			if(effectiveIpObj[0]){
				data+="&effectiveIp="+effectiveIpObj.val();
			}
			var ruleObj=$("input[name='rule']:checked");
			if(ruleObj[0]){
				data+="&rule="+ruleObj.val();
				var ruleCodeVal=$("input[name='ruleCode']").val();
				data+="&ruleCode="+ruleCodeVal;
			}
			var refreshObj=$("input[name='refresh']:checked");
			if(refreshObj[0]){
				data+="&refresh="+refreshObj.val();
			}
			var mailOnlyObj=$("input[name='mailOnly']:checked");
			if(mailOnlyObj[0]){
				data+="&mailOnly="+mailOnlyObj.val();
			}
			var ynEndNumObj=$("input[name='ynEndNum']:checked");
			if(ynEndNumObj[0]){
				data+="&ynEndNum="+ynEndNumObj.val();
				data+="&endNum="+$("input[name='endNum']").val();
			}
			var ynEndTimeObj=$("input[name='ynEndTime']:checked");
			if(ynEndTimeObj[0]){
				data+="&ynEndTime="+ynEndTimeObj.val();
				data+="&endTime="+$("input[name='endTime']").val();
			}
			var showShareSurveyObj=$("input[name='showShareSurvey']:checked");
			if(showShareSurveyObj[0]){
				data+="&showShareSurvey="+showShareSurveyObj.val();
			}
			var showAnswerDaObj=$("input[name='showAnswerDa']:checked");
			if(showAnswerDaObj[0]){
				data+="&showAnswerDa="+showAnswerDaObj.val();
			}
*/
			//alert(data);
			
			$.ajax({
				url:url,
				data:data,
				type:"post",
				success:function(msg){
					$("input[name='svyNmSaveTag']").val(1);
					$("input[name='svyNoteSaveTag']").val(1);
					$("input[name='svyAttrSaveTag']").val(1);
					var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();

					saveQus(fristQuItemBody,callback);
				}
			});
		}else{
			var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();
			saveQus(fristQuItemBody,callback);
		}
	}
	
	resetQuItem();
});

function resetQuItem(){
	if(isDrag){
		isDrag=false;
	}
	var surveyQuItems=$("#dwSurveyQuContent .surveyQuItemBody");
	var indexNum=1;
	$.each(surveyQuItems,function(i,e){
		$(this).find(".quInputCase input[name='orderById']").val(i+1);
		var quType=$(this).find("input[name='quType']").val();
		if(quType!="PAGETAG" && quType!="PARAGRAPH"){
			$(this).find(".quCoTitle .quCoNum").text((indexNum++)+"、");
		}
		if($(this).hasClass("paragraphQuItemBody")){
			$(this).parent().addClass('paragraphQuItemBody_li');
		}
		
		
		
	});
	//更新分标标记
	var pageTags=$("#dwSurveyQuContent .surveyQuItemBody input[name='quType'][value='PAGETAG']");
	var pageTagSize=pageTags.size()+1;
	$.each(pageTags,function(i){
		var quItemBody=$(this).parents(".surveyQuItemBody");
		var pageQuContent=quItemBody.find(".pageQuContent");
		pageQuContent.text("下一页（"+(i+1)+"/"+pageTagSize+"）");
	});
}

function bindQuHoverItem(){
	
	$(".SeniorEdit").unbind();
	$(".SeniorEdit").click(function(){
		ueDialog.dialog( "open" );
		ueEditObj=curEditObj;
		myeditor.destroy();
		myeditor = null;
		myeditor = UE.getEditor("dialogUeditor",{
		    //toolbars:[[]],
		    initialContent: "",//初始化编辑器的内容
		    elementPathEnabled:false,
	        wordCount:false,
	        autosave:false,
	        //下面注释参数不要随便调，在滚动时效果更好
	       enableAutoSave:false,
	        /*autoHeightEnabled:false,
	        topOffset:60,inputSytle_1:fillblankInput,
	        imagePopup:true,*/
		    initialFrameWidth : 678,
		    initialFrameHeight : 300
		});
		//先出加载提示图标
		myeditor.ready(function(){
			setTimeout(function(){
				if(curEditObj!=null){
					myeditor.setContent($(curEditObj).html());
					myeditor.focus(true);
				}
	        },800);
		});
		return false;
	});
	

	
	$(".option_Set").unbind();
	$(".option_Set").click(function(){
		/*var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		quItemBody.addClass("hover");*/
		//showDialog($(curEditObj));
		showUIDialog($(curEditObj));
		/*resetQuItemHover(quItemBody);
		$(this).parents(".quCoItemUlLi").addClass("menuBtnClick");*/
		return false;
	});
	
	//获得
	$("table").unbind();
	$("table").mouseup(function(){
		
		//将width存入数据库
		var li_surveyQuItemBody=$(this).parents(".li_surveyQuItemBody");
		var quType=li_surveyQuItemBody.find("input[name='quType']").val();
		var trWidthInfoObject=li_surveyQuItemBody.find("input[name='trWidthInfo']");
		if(quType=="CHENFBK" || quType=="CHENSCORE" || quType=="CHENRADIO" || quType == "CHENCHECKBOX"){
			var trFirst=$(this).find("tr").first();
			var tdAll=trFirst.find("td");
			var str ="";
			$.each(tdAll,function(i){
				var widthInfo=tdAll[i].style.width;
				widthInfo=widthInfo.replace("%","");
				str+=widthInfo+",";
			})
			
			str=str.substring(0,str.length-1);
			
			trWidthInfoObject.val(str);
			
			li_surveyQuItemBody.find("input[name='saveTag']").val("0");
		}
	})
	
	
	$("input[name='quOption_isNote']").unbind();
	$("input[name='quOption_isNote']").click(function(){
		var optionCk=$(this).prop("checked");
		if(optionCk){
			$(".quOptionFillContentLi,.quOptionFillRequiredLi").show();
			//$("#modelUIDialog").dialog("open");
			$("#modelUIDialog").dialog("option","height",230);
		}else{
			$(".quOptionFillContentLi,.quOptionFillRequiredLi").hide();
		}
	});
	
	$("#dwSurveyQuContent .surveyQuItemBody").unbind();
	$("#dwSurveyQuContent .surveyQuItemBody").hover(function(){
		//显示
		if(isDrag){
			//$(this).addClass("showLine");
			appQuObj=$(this);
		}else{
			//显示
			$(this).addClass("hover");
			$(".pageBorderTop").removeClass("nohover");
			//如果是填空
			appQuObj=$(this);
		}
	},function(){
		$(".pageBorderTop").addClass("nohover");
		$(this).removeClass("showLine");
		var hoverTag=$(this).find("input[name='hoverTag']").val();
		if(hoverTag!="hover"){
			$(this).removeClass("hover");
		}
		appQuObj=null;
		
	});
	
	$("#dwSurveyQuContent .surveyQuItemBody").click(function(){
		curEditCallback();
		dwCommonDialogHide();
		$(".surveyQuItemBody").removeClass("hover");
		$(".surveyQuItemBody").find("input[name='hoverTag']").val("0");
		$(this).addClass("hover");
		return false;
	});
//	复制题目
	$(".dwQuCopy").unbind();
	$(".dwQuCopy").click(function(){
		dwCommonDialogHide();
		$(".surveyQuItemBody").removeClass("hover");
		$(".surveyQuItemBody").find("input[name='hoverTag']").val("0");
		$(this).addClass("hover");
		var quBody=$(this).parents(".surveyQuItemBody");
		
		//quBody.parent()
		$('#dwSurveyQuContentAppUl').append(clonequestion(quBody.parent()));
		quBody.show("slow",function(){resetQuItem();});
		return false;
	});
	
	function clonequestion(obj){
		var temp=obj.clone(true);
		temp.find("input[name='quId']").val("");
		temp.find("input[name='saveTag']").val("");
		temp.find("input[name='quTitleSaveTag']").val("");
		temp.find("input[name='quItemId']").val("");
		temp.find("input[name='quItemSaveTag']").val("");
		temp.find(".quLogicItem").remove();
		temp.find(".quLogicInfo").text("0");
		return temp;
	}
      
	
	$("#nextUtilBody").change(function(){
		   var quItemBody=$(dwDialogObj).parents(".li_surveyQuItemBody");
		   var quItemBodyElse=quItemBody.prevAll(".li_surveyQuItemBody");
		   var nextUtilBody=$(this);
		   var selectQuId =nextUtilBody.val();
		   var targetQuItemBody=quItemBodyElse.has("input[name='quId'][value='"+selectQuId+"']");
		   var logicType = targetQuItemBody.find("input[name='logicType']").val();
		   selectChange($("#thisItemforHidden"),quItemBody,logicType);
		})
	
	//COPYCHANGE逻辑
	function selectChange(thisItemforHidden,quItemBody,logicType){
		thisItemforHidden.html("");
		var  quType=quItemBody.find("input[name='quType']").val();
		if(logicType == 3){
			$(".logicType_three").show();
			//添加select选项款
			 if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				 var quChenColumnTds=quItemBody.find(".quChenColumnTd");
				 var quChenRowTds=quItemBody.find(".quChenRowTd");
				 $.each(quChenColumnTds,function(){
						//获得行的名称和id
						var rowText=$(this).find(".quCoOptionEdit").text();
					    var rowQuItemId=$(this).find("input[name='quItemId']").val();
					    $.each(quChenRowTds,function(){
					    	//获得列的名称和id
					    	var colText=$(this).find(".quCoOptionEdit").text();
							var colQuItemId=$(this).find("input[name='quItemId']").val();
						
							
					   	    var optionString="<option value='"+colQuItemId+":"+rowQuItemId+"'>"+rowText+"+"+colText+"</option>";
					   	    thisItemforHidden.prepend(optionString);
					    })
					});
			 }else{
				 if(quType==="FILLBLANK"){
					 
					 var optionString="<option value='1'>选项1</option>"
					 thisItemforHidden.prepend(optionString);
				 }else{
					 
				   var quItemInputCases=quItemBody.find(".quItemInputCase");
		            	
		           $.each(quItemInputCases,function(){
					var optionText=$(this).parent().find("label.quCoOptionEdit").text();
	    			var optionId=$(this).find("input[name='quItemId']").val();	
	    				
	    			var option="<option value='"+optionId+"'>"+optionText+"</option>";
	    			thisItemforHidden.prepend(option); 
		           });	
				 }	
			 }
			
		}else{
			$(".logicType_three").hide();
		}
		
	  return false;
	}
	
	//复制逻辑
	$(".dwQuLogicCopy").unbind();
	$(".dwQuLogicCopy").click(function(){
		var  dwQuLogicCopyThis=$(this);
				
				dwCommonDialogHide();
				$(".surveyQuItemBody").removeClass("hover");
				$(".surveyQuItemBody").find("input[name='hoverTag']").val("0");
				$(this).addClass("hover");
				
				var quItemBody=dwQuLogicCopyThis.parents(".li_surveyQuItemBody");
				var nextUtilBody=$("#nextUtilBody");
				
				//现将thisItemforHidden的item装进去
				nextUtilBody.html("");
				showDialog($(this));
				var quItemBodyElse=quItemBody.prevAll(".li_surveyQuItemBody");
				quItemBodyElse.each(function(){
				   var quItemBodyElseThis=$(this);
				   var quType=quItemBodyElseThis.find("input[name='quType']").val();
				   var quId=quItemBodyElseThis.find("input[name='quId']").val();
				   var quTitle=quItemBodyElseThis.find(".quCoTitleEdit").text();
				   if(quType != "PARAGRAPH" && quType != "PAGETAG"){
					   var option = "<option id='"+quId+"' value='"+quId+"'>"+quTitle+"</option>";
					   nextUtilBody.append(option);
				   }
				})
				
				//获得当前选项的Id
				var selectQuId =nextUtilBody.val();
				var targetQuItemBody=quItemBodyElse.has("input[name='quId'][value='"+selectQuId+"']");
				var logicType = targetQuItemBody.find("input[name='logicType']").val();
				
				var thisItemforHidden=$("#thisItemforHidden");
				//是移除逻辑
				selectChange(thisItemforHidden,quItemBody,logicType);
				$.ajaxSettings.async = false;
				saveQus(quItemBody,function(){	
				});
				return false;
	});
	
//	复制分段
	$(".dwQuCopy_paragraph").unbind();
	$(".dwQuCopy_paragraph").click(function(){
		dwCommonDialogHide();
		$(".surveyQuItemBody").removeClass("hover");
		$(".surveyQuItemBody").find("input[name='hoverTag']").val("0");
		$(this).addClass("hover");
		
		var quBody=$(this).parents(".surveyQuItemBody");
		var itemParent=$(quBody).parent();
		var para_next_li=itemParent.nextUntil('.paragraphQuItemBody_li');
		
		//itemParent.clone(true)
		$('#dwSurveyQuContentAppUl').append(dwQuCopy_paragraphChange2(itemParent.clone(true)));
		$('#dwSurveyQuContentAppUl').append(dwQuCopy_paragraphChange1(para_next_li.clone(true)));
		quBody.show("slow",function(){resetQuItem();});
		
		return false;
	});
	
	
	function dwQuCopy_paragraphChange1(obj){
		
		obj.each(function(){
			var temp=$(this);
			clonequestion2(temp);
		})
		return obj;
	}
	
	function clonequestion2(obj){
		obj.find("input[name='quId']").val("");
		obj.find("input[name='saveTag']").val("");
		obj.find("input[name='quTitleSaveTag']").val("");
		obj.find("input[name='quItemId']").val("");
		obj.find("input[name='quItemSaveTag']").val("");
	}
	
	function dwQuCopy_paragraphChange2(obj){
		obj.find("input[name='quId']").val("");
		obj.find("input[name='saveTag']").val("");
		obj.find("input[name='quTitleSaveTag']").val("");
		return obj;
	}
   
	
   $("table").resizableColumns();
	
//复制分项
$(".dwQuCopy_classify").unbind();
$(".dwQuCopy_classify").click(function(){
    var noCheckBoxLi_classify=$(this).parents('.noCheckBoxLi_classify');
    noCheckBoxLi_classify.attr("class","quCoItemUlLi noCheckBoxLi_classify");
    var quCoItem=noCheckBoxLi_classify.nextUntil('.noCheckBoxLi_classify');
    quCoItem.attr("class","quCoItemUlLi ui-draggable");
    
    console.log(quCoItem.last());
    quCoItem.last().attr("class","quCoBottomTools ui-draggable");
    var checkboxClassifyContentUl=$(this).parents('.checkboxClassifyContentUl');
    checkboxClassifyContentUl.append(addSaveTag(noCheckBoxLi_classify.clone(true))).append(addSaveTag(quCoItem.clone(true)));
    $(this).parents(".li_surveyQuItemBody").find("input[name='saveTag']").val("0");
    saveQus( $(this).parents(".li_surveyQuItemBody")[0],function(){});
    $("#saveBtn").trigger("click");
    resetNum( $(this).parents(".li_surveyQuItemBody"));
    return false;
})

function resetNum(obj){
	
	var quItems=obj.find("quCoItemUlLi");
	$.each(quItems,function(){
		$(this).find("input[name='quItemSaveTag']").val(0);
	})
}


//多个li都要改变字段
function addSaveTag(obj){
	
	obj.each(function(){
		var temp=$(this);
		
		obj.find("input[name='quItemId']").val("0");
		obj.find("input[name='quItemSaveTag']").val("0");
	})
	return obj;
}


//删除分项
$(".dwQuDelete_classify").unbind();
$(".dwQuDelete_classify").click(function(){
	var li_surveyQuItemBody=$(this).parents('.li_surveyQuItemBody');
    var noCheckBoxLi_classify=$(this).parents('.noCheckBoxLi_classify');
    var quCoItem=noCheckBoxLi_classify.nextUntil('.noCheckBoxLi_classify');
    var checkboxClassifyContentUl=$(this).parents('.checkboxClassifyContentUl');
    var del_length=checkboxClassifyContentUl.find('.dwQuDelete_classify').length;
    if(del_length==1){
	       var quBody=$(this).parents(".surveyQuItemBody");
			if(confirm("确认要删除此题吗？")){
				var quId=quBody.find("input[name='quId']").val();
				if(quId!=""){
					var url=ctx+"/design/question!ajaxDelete.action";
					var data="quId="+quId;
					$.ajax({
						url:url,
						data:data,
						type:"post",
						success:function(msg){
							if(msg=="true"){
								quBody.hide("slow",function(){$(this).parent().remove();resetQuItem();});
							}else{
								alert("删除失败，请重试！");
							}
						}
					});
				}else{
					quBody.hide("slow",function(){$(this).parent().remove();resetQuItem();});
				}
			}
			$(document).click();
			return false;
       //
    }else{
    	
       var ids="";
      
       $.each(noCheckBoxLi_classify,function(){
    	   var temp=$(this).find("input[name='quItemId']").val();
    	   if(temp!="" && temp !=undefined){
    		   ids+=temp+",";
    	   }
       })
       
        $.each(quCoItem,function(){
    	   var temp=$(this).find("input[name='quItemId']").val();
    	   if(temp!="" && temp !=undefined){
    		   ids+=temp+",";
    	   }
    	  
       })
       ids=ids.substring(0,(ids.length)-1);
       var url=ctx+"/design/qu-checkbox!ajaxdeleteSubentry.action";
       var data={"ids":ids};
       $.ajax({
    	   url:url,
    	   type:"post",
    	   datatype:"json",
    	   data:data,
    	   success:function(result){
    		   
    		   if(result == "1"){
    			   noCheckBoxLi_classify.remove();
        	       quCoItem.remove();  
    		   }
    	   }
    	   
       })
       //ajax根据id删除
    }
    //checkboxClassifyContentUl.remove(classifyQuItemBody_li).remove(quCoItem);
    return false;
})



	$(".quCoItemUlLi").unbind();
	$(".quCoItemUlLi").hover(function(){
		if(!isDrag){
			$(this).addClass("hover");	
		}
	},function(){
		var thClass=$(this).attr("class");
		if(thClass.indexOf("menuBtnClick")<=0){
			$(this).removeClass("hover");
		}
	});
	
	//绑定编辑
	$("#dwSurveyQuContent .editAble").unbind();
	$("#dwSurveyQuContent .editAble").click(function(){
		editAble($(this));
		return false;
	});
	
	//绑定题目删除事件
	$(".dwQuDelete").unbind();
	$(".dwQuDelete").click(function(){
		var quBody=$(this).parents(".surveyQuItemBody");
		if(confirm("确认要删除此题吗？")){
			var quId=quBody.find("input[name='quId']").val();
			console.log(123, quBody)
			if(quId){
				var url=ctx+"/design/question!ajaxDelete.action";
				var data="quId="+quId;
				$.ajax({
					url:url,
					data:data,
					type:"post",
					success:function(msg){
                        console.log(123, msg)
						if(msg=="true"){
							quBody.hide("slow",function(){$(this).parent().remove();resetQuItem();});
						}else{
							alert("删除失败，请重试！");
						}
					}
				});
			}else{
				quBody.hide("slow",function(){$(this).parent().remove();resetQuItem();});
			}
		}
		$(document).click();
		return false;
	});
	
	$(".questionUp").unbind();
	$(".questionUp").click(function(){
		var nextQuBody=$(this).parents(".li_surveyQuItemBody");
		var prevQuBody=$(nextQuBody).prev();
		if(prevQuBody[0]){
			var prevQuBodyHtml=prevQuBody.html();
			$(nextQuBody).after("<li class='li_surveyQuItemBody'>"+prevQuBodyHtml+"</li>");
			var newNextObj=$(nextQuBody).next();
			newNextObj.hide();
			newNextObj.slideDown("slow");
			prevQuBody.slideUp("slow",function(){prevQuBody.remove();resetQuItem();bindQuHoverItem();});
			
			nextQuBody.find("input[name='saveTag']").val(0);
			newNextObj.find("input[name='saveTag']").val(0);
		}else{
			notify("已经是第一个了！",1000);
			//alert("已经是第一个了！");
		}
	});
	
	$(".questionDown").unbind();
	$(".questionDown").click(function(){
		var prevQuBody=$(this).parents(".li_surveyQuItemBody");
		var nextQuBody=$(prevQuBody).next();
		var prevQuBodyId=prevQuBody.find("input[name='quId']").val();
		if(nextQuBody[0]){
			
			//这里判断是不是这题设置了本题的逻辑
			var quLogicItem=nextQuBody.find(".quLogicItem");
			if(quLogicItem[0]){
				var skQuId=quLogicItem.find("input[name='skQuId']").val();
				if(skQuId.indexOf(prevQuBodyId) != -1){
					alert("下移会影响现有逻辑！");
					return false;
				}
			}
			
			
			
			var nextQuBodyHtml=nextQuBody.html();
			$(prevQuBody).before("<li class='li_surveyQuItemBody' >"+nextQuBodyHtml+"</li>");
			var newPrevObj=$(prevQuBody).prev();
			newPrevObj.hide();
			newPrevObj.slideDown("slow");
			nextQuBody.slideUp("slow",function(){nextQuBody.remove();resetQuItem();bindQuHoverItem();});
			
			prevQuBody.find("input[name='saveTag']").val(0);
			newPrevObj.find("input[name='saveTag']").val(0);
		}else{
			alert("已经是最后一个了！");
		}
	});
	
	$(".dwQuSet").unbind();
	$(".dwQuSet").click(function(){
		showDialog($(this));
		var quItemBody=$(this).parents(".surveyQuItemBody");
		resetQuItemHover(quItemBody);
		validateGen();
		return false;
	});
	
	//表格可调节
	
	
	//逻辑设置 
	$(".dwQuLogic").unbind();
	$(".dwQuLogic").click(function(){
		
		//显示弹出框
		showDialog($(this));
		$(".dwQuDialogAddLogic").show();
		
		//将所有的选项重置
		$("select[name='option_event']").val("2");
		$("select[name='option_name_id']").hide();
		
		//获得本题的li对象
		var quItemBody=$(this).parents(".surveyQuItemBody");
		
		//获得本题类型
		var quType=quItemBody.find("input[name='quType']").val();
		//默认加载图标
		var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();
		
		//存储所有的问题
		saveQus(fristQuItemBody,function(){
			
			//关闭所有的弹出框
			$(".dwQuDialogCon").hide();
			
			//逻辑弹出框显示
			$("#dwCommonDialog .dwQuDialogLogic").show();
			
			
			//当前题被选中
			resetQuItemHover(quItemBody);
			
			//绑定逻辑设置中选项删除事件
			bindDialogRemoveLogic();
			
			//清空逻辑框的数据
			//$("#dwQuLogicTable").empty();
			//逻辑数据回显示
			//找到所有的存在的逻辑 --在并没有保存之前可以找到
			var quLogicItems=quItemBody.find(".quLogicItem");
			
			$.fn.zTree.destroy("logicTree");
			$(".dwQuDialogAddLogic").show();
			$('.dwQuDialogAddLogic').trigger("click")
			
	/*		if(quLogicItems[0]){
				$.each(quLogicItems,function(){
					var skQuId=$(this).find("input[name='skQuId']").val();
					var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
					var logicType=$(this).find("input[name='logicType']").val();
					var visibility=$(this).find("input[name='visibility']").val();
					// 设置分数 geLe scoreNum
					var geLe="";
					var scoreNum="";
					if(quType==="SCORE"){
						geLe=$(this).find("input[name='geLe']").val();
						scoreNum=$(this).find("input[name='scoreNum']").val();
					}
					var thClass=$(this).attr("class");
					thClass=thClass.replace("quLogicItem", "");
					thClass=thClass.replace(" ", "");
					
					//修改的标识
					if(visibility == "1"){
						addQuDialogLogicTr(false,function(){
							//执行成功--设置值
							var lastTr=$("#dwQuLogicTable").find("tr").last();
							lastTr.attr("class",thClass);
							lastTr.find(".logicQuOptionSel").val(cgQuItemId);
							lastTr.find(".logicQuSel").val(skQuId);
							lastTr.find(".logicType").val(logicType);
							lastTr.find(".logicQuOptionSel").change();
							lastTr.find(".logicQuSel").change();
							// 设置分数 geLe scoreNum
							if(quType==="SCORE"){
								lastTr.find(".logicScoreGtLt").val(geLe);
								lastTr.find(".logicScoreNum").val(scoreNum);
							}
						},function(){});
					}
					//回显相应的选项
				});
			}else{
				
				//添加一个新的选项(未保存)
				//$(".dwQuDialogAddLogic").click();
			}*/
		});
		return false;
	});
	
	

	

	//添加行选项
	$(".addOption,.addColumnOption,.addRowOption").unbind();
	$(".addOption,.addColumnOption,.addRowOption").click(function(){
		var quItemBody=$(this).parents(".surveyQuItemBody");
		var quItemCheckBox=$(this).parents(".quCoBottomTools").prev();
		var quType=quItemBody.find("input[name='quType']").val();
		if(quType=="RADIO"){
			//添加单选选项
			editAble(addRadioItem(quItemBody,""));
			//editAble(quItemBody.find(".quCoItem table .editAble").last());
		}else if(quType=="CHECKBOX"){
			var isSubentry=quItemBody.find("input[name='isSubentry']").val();
			if(isSubentry == "1"){
				editAble(addCheckboxItem_subentry(quItemBody, "",this));
			}else{
				editAble(addCheckboxItem(quItemBody, ""));
			}
			
			//editAble(quItemBody.find(".quCoItem ul li:last .editAble"));
		}else if(quType=="SCORE"){
			editAble(addScoreItem(quItemBody, "新选项"));
		}else if(quType=="ORDERQU"){
			editAble(addOrderquItem(quItemBody, "新选项"));
		}else if(quType=="MULTIFILLBLANK"){
			editAble(addMultiFillblankItem(quItemBody, "新选项"));
		}else if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){//矩陈单选题,矩阵多选题
			editAble(addChenItem($(this),quItemBody, "新选项"));
		}
		bindQuHoverItem();
		//resetNum(quItemBody);
		if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
			
			//矩陈单选题,矩阵多选题
			$.ajaxSettings.async = false;
			$("#saveBtn").trigger("click");
			history.go(0);
		}
		//window.reload();
		
		return false;
	});
	
	//批量添加事件
	$(".addMoreOption,.addMoreRowOption,.addMoreColumnOption").unbind();
	$(".addMoreOption,.addMoreRowOption,.addMoreColumnOption").click(function(){
		//showDialog($(this));
		curClickObject=$(this);
		var quItemBody=$(this).parents(".surveyQuItemBody");
		$("#dwDialogUeOkBatch").addClass("Column");
		//myeditorBatchOption.destory();
		curBatchObject=quItemBody;
		ueDialogBatchOption.dialog( "open" );
		myeditorBatchOption.destroy();
		myeditorBatchOption = null;
		myeditorBatchOption = UE.getEditor("dialogUeditorBatchOption",{
		    //toolbars:[[]],
		    initialContent: "",//初始化编辑器的内容
		    elementPathEnabled:false,
	        wordCount:false,
	        autosave:false,
	        //下面注释参数不要随便调，在滚动时效果更好
	        enableAutoSave:false,
	        /*autoHeightEnabled:false,
	        topOffset:60,inputSytle_1:fillblankInput,
	        imagePopup:true,*/
		    initialFrameWidth : 678,
		    initialFrameHeight : 300
		});
		//先出加载提示图标
		myeditorBatchOption.ready(function(){
			setTimeout(function(){
				if(curEditObj!=null){
					//myeditorBatchOption.setContent($(curEditObj).html());
					myeditorBatchOption.focus(true);
				}
	       },800);
		});
		
		resetQuItemHover(quItemBody);
		return false;
	});
	

	$("#dwDialogUeOkBatch").click(function(){
		/*var quItemBody=curBatchObject;
		console.log(quItemBody);*/
		//curClickObject=$(this);
		var quItemBody=curBatchObject;
		// var quItemCheckBox=$(dwDialogObj).parents(".quCoBottomTools").prev();
		var quType=quItemBody.find("input[name='quType']").val();
		var areaVal=myeditorBatchOption.getContent();
		
		//将多个<p>标签包裹的样式拿出来
		var areaValSplits="";
		var areaValSplits=areaVal.split(/<[/]p>/);
		for(var j=0;j<areaValSplits.length;j++){
			if(areaValSplits[j]!=""){
				areaValSplits[j]+="</p>";
			}else{
				areaValSplits.splice(j,1);
			}
		}
	
		$.each(areaValSplits,function(i,item){
			item=$.trim(item);
			//这里要去判断是不是空的p标签
			var regx=/^<p.*?><br\/><\/p>$/;
			if(regx.test(item) == false){
				if(quType=="RADIO"){
					//添加单选选项 1
					addRadioItem(quItemBody,item);
				}else if(quType=="CHECKBOX" || quType=="CHECKBOXCLASSIFY"){
					var quItemBody_subentry=quItemBody.find("input[name='isSubentry']").val();
					if(quItemBody_subentry == "1"){
						//1
						addCheckboxItem_subentry(quItemBody,item,curClickObject);	
					}else{
						//1
						addCheckboxItem(quItemBody,item);
					}
					//添加多选选项
					
				}else if(quType=="SCORE"){
					//1
					addScoreItem(quItemBody,item);
				}else if(quType=="ORDERQU"){
					//1
					addOrderquItem(quItemBody, item);
				}else if(quType=="MULTIFILLBLANK"){
					//1
					addMultiFillblankItem(quItemBody, item);
				}else if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
					
					addChenItem(curClickObject,quItemBody, item);
					$.ajaxSettings.async = false;
					$("#saveBtn").trigger("click");
					history.go(0);
				}else{
					
				}
				
			}else{
				
			}

		});
		
		//history.go(0);
		//
		myeditorBatchOption.setContent("");
		ueDialogBatchOption.dialog("close");
		bindQuHoverItem();
		dwCommonDialogHide();
		$(this).removeClass("Column");
		//
	})
	
	//填空题选项设置
	$(".quFillblankItem .dwFbMenuBtn").unbind();
	$(".quFillblankItem .dwFbMenuBtn").click(function(){
		//showDialog($(this));
		showUIDialog($(this));
		return false;
	});
	//多项填空题选项设置
	$(".mFillblankTableTr td .dwFbMenuBtn").unbind();
	$(".mFillblankTableTr td .dwFbMenuBtn").click(function(){
		//showDialog($(this));

		showUIDialog($(this));
		return false;
	});

	$(".dwOptionUp").unbind();
	$(".dwOptionUp").click(function(){
		//curEditObj
		//判断类型区别table跟ul中的排序
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		var quType=quItemBody.find("input[name='quType']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		if(hv==3){
			var nextTd=$(curEditObj).parents("td");
			var prevTd=nextTd.prev();
			if(prevTd[0]){
				dwOptionUp(prevTd, nextTd);
			}else{
				var nextTr=$(curEditObj).parents("tr");
				var prevTr=nextTr.prev();
				if(prevTr[0]){
					prevTd=prevTr.find("td").last();
					dwOptionUp_1(prevTr, nextTr);
				}else{
					alert("已经是第一个了！");
				}
			}
		}else{
			var nextLi=null;
			var prevLi=null;
			var nextLiAfterHtml="";
			if(quType==="RADIO" || quType==="CHECKBOX" || quType==="ORDERQU"){
				nextLi=$(curEditObj).parents("li.quCoItemUlLi");
				prevLi=nextLi.prev();
				var prevLiHtml=prevLi.html();
				nextLiAfterHtml="<li class='quCoItemUlLi'>"+prevLiHtml+"</li>";
			}else if(quType==="SCORE"){
				nextLi=$(curEditObj).parents("tr.quScoreOptionTr");
				prevLi=nextLi.prev();
				var prevLiHtml=prevLi.html();
				nextLiAfterHtml="<tr class='quScoreOptionTr'>"+prevLiHtml+"</tr>";
			}else if(quType==="MULTIFILLBLANK"){
				nextLi=$(curEditObj).parents("tr.mFillblankTableTr");
				prevLi=nextLi.prev();
				var prevLiHtml=prevLi.html();
				nextLiAfterHtml="<tr class='mFillblankTableTr'>"+prevLiHtml+"</tr>";
			}else if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				nextLi=$(curEditObj).parents("tr.quChenRowTr");
				if(nextLi[0]){
					prevLi=nextLi.prev();
					var prevLiHtml=prevLi.html();
					nextLiAfterHtml="<tr class='quChenRowTr'>"+prevLiHtml+"</tr>";
				}else{
					nextLi=$(curEditObj).parents("td.quChenColumnTd");
					prevLi=nextLi.prev();
					var prevLiHtml=prevLi.html();
					nextLiAfterHtml="<td class='quChenColumnTd'>"+prevLiHtml+"</td>";
				}
			}
			if(nextLi!=null){
				if(prevLi[0]){
					$(nextLi).after(nextLiAfterHtml);
					prevLi.hide();
					prevLi.remove();
					var editOffset=nextLi.find("label.editAble").offset();
					$("#dwCommonEditRoot").show();
					$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
					bindQuHoverItem();
					$(curEditObj).click();
					$(nextLi).find("input[name='quItemSaveTag']").val(0);
					$(nextLi).next().find("input[name='quItemSaveTag']").val(0);
					var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
					quItemBody.find("input[name='saveTag']").val(0);
				}else{
					alert("已经是第一个了！");
				}
			}
		}
		return false;
	});
	
	function dwOptionUp(prevTd,nextTd){
		var prevTdHtml=prevTd.html();
		$(nextTd).after("<td>"+prevTdHtml+"</td>");
		prevTd.hide();
		prevTd.remove();
		var editOffset=nextTd.find("label.editAble").offset();
		$("#dwCommonEditRoot").show();
		$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
		bindQuHoverItem();
		$(curEditObj).click();
		$(nextTd).find("input[name='quItemSaveTag']").val(0);
		$(nextTd).next().find("input[name='quItemSaveTag']").val(0);
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		quItemBody.find("input[name='saveTag']").val(0);
	}
	
	function dwOptionUp_1(prevTr,nextTr){
		var prevTd=prevTr.find("td").last();
		var nextTd=nextTr.find("td").first();
		
		var prevTdHtml=prevTd.html();
		var nextTdHtml=nextTd.html();
		
		prevTd.before("<td>"+nextTdHtml+"</td>");
		$(nextTd).after("<td>"+prevTdHtml+"</td>");
		
		prevTd.hide();
		prevTd.remove();
		
		nextTd.hide();
		nextTd.remove();
		
		 prevTd=prevTr.find("td").last();
		 nextTd=nextTr.find("td").first();
		
		curEditObj=prevTd.find("label.editAble");
		var editOffset=prevTd.find("label.editAble").offset();
		$("#dwCommonEditRoot").show();
		$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
		bindQuHoverItem();
		$(curEditObj).click();
		$(prevTd).find("input[name='quItemSaveTag']").val(0);
		$(nextTd).find("input[name='quItemSaveTag']").val(0);
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		quItemBody.find("input[name='saveTag']").val(0);
	}
	
	$(".dwOptionDown").unbind();
	$(".dwOptionDown").click(function(){
		//判断类型区别table跟ul中的排序
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		var quType=quItemBody.find("input[name='quType']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		if(hv==3){
			var prevTd=$(curEditObj).parents("td");
			var nextTd=prevTd.next();
			if(nextTd[0]){
				dwOptionDown(prevTd, nextTd);
			}else{
				var nextTr=$(curEditObj).parents("tr");
				var prevTr=nextTr.prev();
				if(prevTr[0]){
					prevTd=prevTr.find("td").last();
					dwOptionUp_1(prevTr, nextTr);
				}else{
					alert("已经是第一个了！");
				}
			}
		}else{
			var prevLi=null;
			var nextLi=null;
			var prevLiBeforeHtml="";
			if(quType==="RADIO" || quType==="CHECKBOX" || quType==="ORDERQU" || quType=="CHECKBOXCLASSIFY"){
				prevLi=$(curEditObj).parents("li.quCoItemUlLi");
				nextLi=prevLi.next();
				var nextLiHtml=nextLi.html();
				prevLiBeforeHtml="<li class='quCoItemUlLi'>"+nextLiHtml+"</li>";
			}else if(quType==="SCORE"){
				prevLi=$(curEditObj).parents("tr.quScoreOptionTr");
				nextLi=prevLi.next();
				var nextLiHtml=nextLi.html();
				prevLiBeforeHtml="<tr class='quScoreOptionTr'>"+nextLiHtml+"</tr>";
			}else if(quType==="MULTIFILLBLANK"){
				prevLi=$(curEditObj).parents("tr.mFillblankTableTr");
				nextLi=prevLi.next();
				var nextLiHtml=nextLi.html();
				prevLiBeforeHtml="<tr class='mFillblankTableTr'>"+nextLiHtml+"</tr>";
			}else if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				prevLi=$(curEditObj).parents("tr.quChenRowTr");
				if(prevLi[0]){
					nextLi=prevLi.next();
					var nextLiHtml=nextLi.html();
					prevLiBeforeHtml="<tr class='quChenRowTr'>"+nextLiHtml+"</tr>";
				}else{
					prevLi=$(curEditObj).parents("td.quChenColumnTd");
					nextLi=prevLi.next();
					var nextLiHtml=nextLi.html();
					prevLiBeforeHtml="<td class='quChenColumnTd'>"+nextLiHtml+"</td>";
				}
			}
			
			if(nextLi[0]){
				$(prevLi).before(prevLiBeforeHtml);
				nextLi.hide();
				nextLi.remove();
				var editOffset=prevLi.find("label.editAble").offset();
				$("#dwCommonEditRoot").show();
				$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
				bindQuHoverItem();
				$(curEditObj).click();
				$(prevLi).find("input[name='quItemSaveTag']").val(0);
				$(prevLi).prev().find("input[name='quItemSaveTag']").val(0);
				var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
				quItemBody.find("input[name='saveTag']").val(0);
			}else{
				alert("已经是最后一个了！");
			}
		}
		
		return false;
	});
	
	function dwOptionDown(prevTd,nextTd){
		var nextTdHtml=nextTd.html();
		$(prevTd).before("<td>"+nextTdHtml+"</td>");
		nextTd.hide();
		nextTd.remove();
		var editOffset=prevTd.find("label.editAble").offset();
		$("#dwCommonEditRoot").show();
		$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
		bindQuHoverItem();
		$(curEditObj).click();
		$(prevTd).find("input[name='quItemSaveTag']").val(0);
		$(prevTd).next().find("input[name='quItemSaveTag']").val(0);
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		quItemBody.find("input[name='saveTag']").val(0);
	}
	
	
	$(".dwOptionDel").unbind();
	$(".dwOptionDel").click(function(){
		deleteDwOption();
		return false;
	});
	
	//引用自address.js
	bindAddrChange();
}

function deleteDwOption(){
	if(curEditObj!=null){
		var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
		var quType=quItemBody.find("input[name='quType']").val();
		if(quType=="RADIO"){
			//添加单选选项
			deleteRadioOption();
		}else if(quType=="CHECKBOX" || quType=="CHECKBOXCLASSIFY"){
			deleteCheckboxOption();
		}else if(quType=="SCORE"){
			deleteScoreOption();
		}else if(quType=="ORDERQU"){
			deleteOrderquOption();
		}else if(quType=="MULTIFILLBLANK"){
			deleteMultiFillblankOption();
		}else if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
			deleteChenOption();
		}
	}
}

function curEditCallback(){
	if(curEditObj!=null){
		var dwEditHtml=$("#dwComEditContent").html();
		//var curEditObjHtml=$(curEditObj).html();
		setCurEditContent(dwEditHtml);
	}
	$("#dwSurveyNote").removeClass("click");
}

function setCurEditContent(dwEditHtml){
	
	var thClass=$(curEditObj).attr("class");
	var dwEditHtmlTrim=trimStr(dwEditHtml);
	var regx = /<[^>]*>|<\/[^>]*>/gm;
	dwEditHtmlTrim=dwEditHtmlTrim.replace(/<[^>]*>|<\/[^>]*>/gm,"");
	if(dwEditHtmlTrim =="" && thClass.indexOf("dwSvyNoteEdit")<0){
		deleteDwOption();
	}else if(dwEditHtml!=curEditObjOldHtml){
		//更新值
		$(curEditObj).html(dwEditHtml);
		//修改保存状态
		setSaveTag0();
	}
	dwCommonEditHide();
}
function trimStr(str){return str.replace(/(^\s*)|(\s*$)/g,"");}

function dwCommonEditHide(){
	$("#dwCommonEditRoot").hide();
	$(".dwComEditMenuUl").hide();
	curEditObj=null;
}

function setShowDialogOffset(thDialogObj){
	var thObjClass=thDialogObj.attr("class");
	if(thObjClass.indexOf("dwFbMenuBtn")<0 && thObjClass.indexOf("quCoOptionEdit")<0){
		var thOffset=thDialogObj.offset();
		$("#dwCommonDialog").show(0,function(){
			var thOffsetTop=thOffset.top;
			var thOffsetLeft=thOffset.left+40;
			var dwCommonRefIcon=$("#dwCommonDialog").find(".dwCommonRefIcon");
			dwCommonRefIcon.removeClass("right");
			dwCommonRefIcon.removeClass("left");
			browseWidth=$(window).width();			
			browseHeight=$(window).height();
			if((thOffsetLeft-100)>browseWidth/2){
				thOffsetLeft=thOffsetLeft-$("#dwCommonDialog").width()-50;
				dwCommonRefIcon.addClass("right");
			}else{
				dwCommonRefIcon.addClass("left");
			}
			$("#dwCommonDialog").offset({ top: thOffsetTop, left: thOffsetLeft });
		});
	}
	
}
//显示模式窗口
function showUIDialog(thDialogObj){
	var thObjClass=thDialogObj.attr("class");
	$("#modelUIDialog").dialog("open");
	$(".dwQuDialogCon").hide();
	if(thObjClass.indexOf("dwFbMenuBtn")>=0){
		$("#modelUIDialog .dwQuFillDataTypeOption").show();
		$("#modelUIDialog").dialog("open");
		var quItemBody=$(thDialogObj).parents(".surveyQuItemBody");
		var checkType_val=quItemBody.find("input[name='checkType']").val();
		var answerInputWidth_val=quItemBody.find("input[name='answerInputWidth']").val();
		var answerInputRow_val=quItemBody.find("input[name='answerInputRow']").val();
		if(checkType_val==""){
			checkType_val="NO";
		}
		var checkType=$("#modelUIDialog select[name='quFill_checkType']");
		checkType.val(checkType_val);
		var qu_inputWidth=$("#modelUIDialog input[name='qu_inputWidth']");
		var qu_inputRow=$("#modelUIDialog input[name='qu_inputRow']");
		console.log(answerInputWidth_val);
		if(answerInputWidth_val==""){
			answerInputWidth_val="300";
		}
		if(answerInputRow_val==""){
			answerInputRow_val="1";
		}
		qu_inputWidth.val(answerInputWidth_val);
		qu_inputRow.val(answerInputRow_val);
		resetQuItemHover(quItemBody);
		$(thDialogObj).parents(".quCoItemUlLi").addClass("menuBtnClick");
		$("#modelUIDialog").dialog("option","width",650);
		$("#modelUIDialog").dialog("option","height",220);
		$("#modelUIDialog").dialog("option","title", "选项设置");
	}else if(thObjClass.indexOf("quCoOptionEdit")>=0) {
		$("#modelUIDialog .dwQuRadioCheckboxOption").show();
		//设置回显值 isNote checkType
		var quOption_isNote=$("#modelUIDialog input[name='quOption_isNote']");
		var quOption_checkType=$("#modelUIDialog select[name='quOption_checkType']");
		var quOption_isRequiredFill=$("#modelUIDialog input[name='quOption_isRequiredFill']");
		var quOptionParent=$(thDialogObj).parent();
		var isNote_val=quOptionParent.find("input[name='isNote']").val();
		var checkType_val=quOptionParent.find("input[name='checkType']").val();
		var isRequiredFill_val=quOptionParent.find("input[name='isRequiredFill']").val();
		if(isNote_val=="1"){
			quOption_isNote.prop("checked",true);
			$(".quOptionFillContentLi,.quOptionFillRequiredLi").show();
			$("#modelUIDialog").dialog("option","width",650);
			$("#modelUIDialog").dialog("option","height",250);
			$("#modelUIDialog").dialog("option","title", "选项设置");
		}else{
			quOption_isNote.prop("checked",false);
			$(".quOptionFillContentLi,.quOptionFillRequiredLi").hide();
			$("#modelUIDialog").dialog("option","width",650);
			$("#modelUIDialog").dialog("option","height",180);
			$("#modelUIDialog").dialog("option","title", "选项设置");
		}
		if(checkType_val==""){
			checkType_val="NO";
		}
		quOption_checkType.val(checkType_val);
		if(isRequiredFill_val=="1"){
			quOption_isRequiredFill.prop("checked",true);
		}else{
			quOption_isRequiredFill.prop("checked",false);
		}
	}else if(thObjClass.indexOf("surveyAttrSetToolbar_li_person")>=0){
		$("#modelUIDialog .dwSurveyAttrSetDialog_person").show();
		$("#modelUIDialog").dialog("option","width",1000);
		$("#modelUIDialog").dialog("option","height",500);
		$("#modelUIDialog").dialog("option","title", "用户创建");
	}
	else if(thObjClass.indexOf("surveyAttrSetToolbar_li")>=0){
		$("#modelUIDialog .dwSurveyAttrSetDialog").show();
		$("#modelUIDialog").dialog("option","width",650);
		$("#modelUIDialog").dialog("option","height",390);
		$("#modelUIDialog").dialog("option","title", "选项设置");
	}
	else if(thObjClass.indexOf("surveyAttrViewPerson_Dialog")>=0){
		
		//
		var page_now=$("#page_now").val();
		var id=$("#id").val();
		var url=ctx+"/surveyuser/survey-user!list.action";
		$.ajax({
			url:url,
			data:{"page_now":page_now,"survey_id":id},
			type:"post",
			datatype:"json",
			success:function(page){
				$(".content_1").remove();
				$("#content_2").remove();
				$("#modelUIDialog .surveyAttrViewPerson_Dialog").show();
				$("#modelUIDialog").dialog("option","width",1266);
				$("#modelUIDialog").dialog("option","height",731);
				$("#modelUIDialog").dialog("option","title", "用户查看");
				tablepage(page);
			}
		})
	}
	dwDialogObj=thDialogObj;
	
}

//拼table的function

function tablepage(page){
	
	var pageObject=eval('('+page+')')
	if(pageObject.totalItems <= 0){
		$("#noresultpage").remove();
		$("#surveyusertable").append('<tr id="noresultpage">'
				+'<td colspan="7">'
				+'<div style="padding: 60px;font-size: 22px;text-align: center;color: #b1aeae;">还没有数据！</div>'
			+'</td>'
		+'</tr>');
	}else{
		for(var i=0;i<pageObject.result.length;i++){
			var Survey=pageObject.result[i];
			var status=Survey.status == 1?"有效":"无效"; 
			
			$("#noresultpage").remove();
			//添加表格
			$("#surveyusertable").append(
			 '<tr class="content_1">'
					+'<td align="center">'
					+'<input type="checkBox" class="checkSingle" name="surveyId" value="'+Survey.id+'"/>'
				+'</td>'
				+'<td align="left">'+Survey.userName+'</td>'
				+'<td align="left" width="100" >'+Survey.passWord+'</td>'
				+'<td align="left">'+Survey.startTime+'</td>'
				+'<td align="left">'+Survey.endTime+'</td>'
				+'<td align="left" >'
				+status+'</td>'
				+'<td align="left">'
					+'<div class="btn-group surveyLeftBtnGroup">'
					  +'<a style="color:red;" class="btn btn-default" data-toggle="tooltip" data-placement="top" href="javascript:deletesurveyuser(\''+Survey.id+'\')">删除</a>'
					+'</div>'
				+'</td>'
			+'</tr>'	
			)
		}
		
	    var str1="";
	    if(pageObject.pageNo > 1 ){
	    	str1='<a href="javascript:fypage('+(pageObject.pageNo-1)+')" class="btn btn-default">&lt;</a>'
	    }else{
	    	str1='';
	    }
	     var str2="";
	     
	     if(pageObject.startpage > 1){
	    	 
	    	 str2='<a href="javascript:fypage(1)" class="btn btn-default">1</a>';
	    	 if(pageObject.startpage >2){
	    		 str2+='<a class="btn btn-default"><span>...</span></a>';
	    	 }
	     }else{
	    	 str2="";
	     }
	     
	     var str3="";
	     
	     for(var i=pageObject.startpage;i<=pageObject.endpage;i++){
	    	 if(pageObject.pageNo == i){
	    		 str3+='<a href="javascript:fypage('+i+')" class="btn btn-default" style="background:#D3DEED;">'+i+'</a>'
	    	 }else{
	    		 str3+='<a href="javascript:fypage('+i+')" class="btn btn-default">'+i+'</a>';
	    	 }
	     }
	     
	     var str4="";
	     if(pageObject.totalPage > pageObject.endpage){

	    	 if( pageObject.totalPage > (pageObject.endpage+1)){
	    		 str4='<a class="btn btn-default"><span>...</span></a>';
	    	 }
	    	 str4+='<a href="javascript:fypage('+pageObject.totalPage+')" class="btn btn-default">'+pageObject.totalPage+'</a>';
	    	
	     }else{
	    	 str4='';
	     }
	     
	     var str5="";
	   
	     if(pageObject.totalPage > pageObject.pageNo ){
	    	 str5='<a href="javascript:fypage('+(pageObject.pageNo+1)+')" class="btn btn-default">&gt;</a>';
	     } else{
	    	 str5="";
	     }
		   //添加分页条
		  $("#pageconent").append(
				  '<div style="padding-top: 15px;text-align: center;" id="content_2">'
					+'<div class="btn-group">'
					 +str1
	                 +str2
	                 +str3
					 +str4
					 +str5
					+'</div>'
				+'</div>'
		  )
	}
}

//分页函数
function fypage(pageNow){
	var url=ctx+"/surveyuser/survey-user!list.action";
	var id=$("#id").val();
	$.ajax({
		url:url,
		data:{"page.pageNo":pageNow,"survey_id":id},
		type:"get",
		datatype:"json",
		success:function(page){
			$(".content_1").remove();
			$("#content_2").remove();
			tablepage(page);
		}
	})
}

//筛选函数
function selectByName(){
	 
	var survey_user_name=$("input[name='survey_user_name_2']").eq(0).val();
	console.log(survey_user_name);
	var url=ctx+"/surveyuser/survey-user!list.action";
	var id=$("#id").val();
	$.ajax({
		url:url,
		data:{"userName":survey_user_name,"survey_id":id},
		datatype:"json",
		type:"get",
		success:function(page){
			$(".content_1").remove();
			$("#content_2").remove();
			tablepage(page);
		}	
	})
}
//显示弹出层
function showDialog(thDialogObj){
	var thObjClass=thDialogObj.attr("class");
	curEditCallback();
	setShowDialogOffset(thDialogObj);
	var quItemBody=$(thDialogObj).parents(".surveyQuItemBody");
	$("#dwCommonDialog .dwQuDialogCon").hide();
	if(thObjClass.indexOf("addMoreOption")>=0){
		$('.addMoreOptionId').removeClass('addMoreOptionId');
		$("#dwCommonDialog .dwQuAddMore").show();
		$(thDialogObj).addClass('addMoreOptionId');
	}else if(thObjClass.indexOf("dwQuLogicCopy")>=0){
		
		$("#dwCommonDialog .dwQuLogicCopyCon").show();
		
		
		
	}else if(thObjClass.indexOf("dwQuSet")>=0){
		$("#dwCommonDialog .dwQuSetCon").show();
		var quType=quItemBody.find("input[name='quType']").val();
		var isSubentry=quItemBody.find("input[name='isSubentry']").val();
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var paramInt01=quItemBody.find("input[name='paramInt01']");
		var paramInt02=quItemBody.find("input[name='paramInt02']");
		
		var isScoreInput=quItemBody.find("input[name='isScoreInput']").val();
		var isSlider=quItemBody.find("input[name='isSlider']").val();
		var isSelectType=quItemBody.find("input[name='isSelectType']").val();
		var minNum=quItemBody.find("input[name='minNum']").val();
		var maxSliderLength=quItemBody.find("input[name='maxSliderLength']").val();
		var minSliderLength=quItemBody.find("input[name='minSliderLength']").val();
		var totalSliderLength=quItemBody.find("input[name='totalSliderLength']").val();
	
		
		var contactsAttr=quItemBody.find("input[name='contactsAttr']").val();
		var contactsField=quItemBody.find("input[name='contactsField']").val();
		$("#dwCommonDialog input[name='setIsRequired']").prop("checked",false);
		$("#dwCommonDialog input[name='setRandOrder']").prop("checked",false);
		$("#dwCommonDialog select[name='setHv']").val(2);
		$("#dwCommonDialog input[name='setAutoContacts']").prop("checked",false);
		$("#dwCommonDialog .contactsFieldLi").hide();
		$("#dwCommonDialog .contactsAttrLi").hide();
		$("#dwCommonDialog .optionAutoOrder").hide();
		$("#dwCommonDialog .optionRangeHv").hide();
		$("#dwCommonDialog .scoreMinMax").hide();
		$("#dwCommonDialog .minMaxLi").hide();
		$("#dwCommonDialog .isSelectType").hide();
		//minNumLi
		$("#dwCommonDialog .minNumLi").hide();
		$("#dwCommonDialog .isSilder").hide();
		$("#dwCommonDialog .isScoreInput").hide();
		$("#dwCommonDialog .maxSilderLength").hide();
		$("#dwCommonDialog .minSilderLength").hide();
		$("#dwCommonDialog .totalSilderLength").hide();
		
		if(isRequired==1){
			$("#dwCommonDialog input[name='setIsRequired']").prop("checked",true);
		}
		if(randOrder==1){
			$("#dwCommonDialog input[name='setRandOrder']").prop("checked",true);
		}
		if(hv==3){
			$("#dwCommonDialog .option_range_3").show();
		}else{
			$("#dwCommonDialog .option_range_3").hide();
		}
		$("#dwCommonDialog select[name='setHv']").val(hv);
		$("#dwCommonDialog input[name='setCellCount']").val(cellCount);

		//单选，多选 才启用选项随机排列
		if(quType==="RADIO" || quType==="CHECKBOX"){
			$("#dwCommonDialog .optionAutoOrder").show();
			$("#dwCommonDialog .optionRangeHv").show();
			if(quType==="CHECKBOX" && isSubentry != "1"){
				$("#dwCommonDialog .minNumLi").show();
				$("#dwCommonDialog .minNumLi").find("input[name='minNum']").val(minNum)
			}
			if(quType==="RADIO"){
				$("#dwCommonDialog .isSelectType").show();
				if(isSelectType == "1"){
					$("#dwCommonDialog .isSelectType").find("input[name='isSelectType']").prop("checked",true);
				}
				
			}
			
		}else if(quType==="ORDERQU"){
			$("#dwCommonDialog .optionAutoOrder").show();
		}else if(quType==="SCORE"){
			
			$("#dwCommonDialog .optionAutoOrder").show();
			$("#dwCommonDialog .scoreMinMax").show();
			$("#dwCommonDialog .isSilder").show();
			if(isSlider == 1){
				$("#dwCommonDialog .isSilder input[name='isSlider']").prop("checked",true);	
			}
			
			$("#dwCommonDialog .isScoreInput").show();
			if(isScoreInput == 1){
				$("#dwCommonDialog .isScoreInput input[name='isScoreInput']").prop("checked",true);	
			}
			
			$("#dwCommonDialog .maxSilderLength").show();
			$("#dwCommonDialog .maxSilderLength input[name='maxSliderLength']").val(maxSliderLength);
			$("#dwCommonDialog .minSilderLength").show();
			$("#dwCommonDialog .minSilderLength input[name='minSliderLength']").val(minSliderLength);
			$("#dwCommonDialog .totalSilderLength").show();
			$("#dwCommonDialog .totalSilderLength input[name='totalSliderLength']").val(totalSliderLength)
			
			if(paramInt02[0]){
				$("#dwCommonDialog .scoreMinMax .maxScore").val(paramInt02.val());
			}
			
		}else if(quType==="MULTIFILLBLANK"){
			$("#dwCommonDialog .optionAutoOrder").show();
			$("#dwCommonDialog .minMaxLi").show();
			$("#dwCommonDialog .minMaxLi .minSpan .lgleftLabel").text("最少回答");
			$("#dwCommonDialog .minMaxLi .maxSpan").hide();
			$("#dwCommonDialog .minMaxLi .lgRightLabel").text("项");
			if(paramInt01[0]){
				$("#dwCommonDialog .minMaxLi .minNum").val(paramInt01.val());				
			}
		}else if(quType="CHENSCORE"){
			$("#dwCommonDialog .maxSilderLength").show();
			$("#dwCommonDialog .maxSilderLength input[name='maxSliderLength']").val(maxSliderLength);
			$("#dwCommonDialog .minSilderLength").show();
			$("#dwCommonDialog .minSilderLength input[name='minSliderLength']").val(minSliderLength);
		}

		//单选，多选，填空题情况下才启用关联到联系设置项
		if((quType=="RADIO" || quType=="CHECKBOX" || quType=="FILLBLANK")){
			$("#dwCommonDialog .contactsAttrLi").show();
			if( contactsAttr==1){
				$("#dwCommonDialog input[name='setAutoContacts']").prop("checked",true);
				$("#dwCommonDialog .contactsFieldLi").show();
				$("#dwCommonDialog select[name='setContactsField']").val(contactsField);
			}
		}
	}else if(thObjClass.indexOf("dwQuLogic")>=0){
		$("#dwCommonDialog .dwQuDialogLoad").show();
	}else if(thObjClass.indexOf("dwFbMenuBtn")>=0){
		$("#dwCommonDialog .dwQuFillDataTypeOption").show();
		var checkType_val=quItemBody.find("input[name='checkType']").val();
		if(checkType_val==""){
			checkType_val="NO";
		}
		var checkType=$("#dwCommonDialog select[name='quFill_checkType']");
		checkType.val(checkType_val);
	}else if(thObjClass.indexOf("quCoOptionEdit")>=0){
		$("#dwCommonDialog .dwQuRadioCheckboxOption").show();
		//设置回显值 isNote checkType
		var quOption_isNote=$("#dwCommonDialog input[name='quOption_isNote']");
		var quOption_checkType=$("#dwCommonDialog select[name='quOption_checkType']");
		var quOption_isRequiredFill=$("#dwCommonDialog input[name='quOption_isRequiredFill']");
		
		var quOptionParent=$(thDialogObj).parent();
		var isNote_val=quOptionParent.find("input[name='isNote']").val();
		var checkType_val=quOptionParent.find("input[name='checkType']").val();
		var isRequiredFill_val=quOptionParent.find("input[name='isRequiredFill']").val();
		
		if(isNote_val=="1"){
			quOption_isNote.prop("checked",true);
			$(".quOptionFillContentLi,.quOptionFillRequiredLi").show();
		}else{
			quOption_isNote.prop("checked",false);
			$(".quOptionFillContentLi,.quOptionFillRequiredLi").hide();
		}
		if(checkType_val==""){
			checkType_val="NO";
		}
		quOption_checkType.val(checkType_val);
		if(isRequiredFill_val=="1"){
			quOption_isRequiredFill.prop("checked",true);
		}else{
			quOption_isRequiredFill.prop("checked",false);
		}
		
	}else{
		//暂时加的
		$("#dwCommonDialog .dwQuAddMore").show();
	}
	dwDialogObj=thDialogObj;

}

function dwCommonDialogHide(){
	$("#dwCommonDialog").hide();
	$(".menuBtnClick").removeClass("menuBtnClick");
	dwDialogObj=null;
}

function resetQuItemHover(quItemBody){
	$(".surveyQuItemBody").removeClass("hover");
	$(".surveyQuItemBody").find("input[name='hoverTag']").val("0");
	if(quItemBody!=null){
		quItemBody.addClass("hover");
		quItemBody.find("input[name='hoverTag']").val("hover");
	}
}

function setSaveTag0(){
	var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
	quItemBody.find("input[name='saveTag']").val(0);

	var thClass=$(curEditObj).attr("class");
	if(thClass.indexOf("quCoTitleEdit")>0){
		//题目标题
		$(curEditObj).parent().find("input[name='quTitleSaveTag']").val(0);
	}else if(thClass.indexOf("quCoOptionEdit")>0){
		//题目选项
		$(curEditObj).parent().find("input[name='quItemSaveTag']").val(0);
	}else if(thClass.indexOf("dwSvyNoteEdit")>=0){
		//问卷欢迎语
		$("input[name='svyNoteSaveTag']").val(0);
	}else if(thClass.indexOf("dwSvyName")>=0){
		$("input[name='svyNmSaveTag']").val(0);
	}
}

//触发显示编辑框 
function editAble(editAbleObj){
	dwCommonDialogHide();
	curEditCallback();

	var quItemBody=$(editAbleObj).parents(".surveyQuItemBody");
	resetQuItemHover(quItemBody);
    
	var obj=$(editAbleObj).next(".quCoItemUlLi");

	var thClass=$(editAbleObj).attr("class");  

	//--带option的class
	var editOffset=$(editAbleObj).offset();
	$("#dwCommonEditRoot").removeClass();
	if(thClass.indexOf("quCoTitleEdit")>0){
		//题目标题
		$("#dwCommonEditRoot").addClass("quEdit");
	}else if(thClass.indexOf("quCoOptionEdit")>0){
		//题目选项
		$("#dwCommonEditRoot").addClass("quOptionEdit");
	}else if(thClass.indexOf("dwSvyNoteEdit")>=0){
		//问卷欢迎语
		$("#dwCommonEditRoot").addClass("svyNoteEdit");
	}else if(thClass.indexOf("dwSvyName")>=0){
		$("#dwCommonEditRoot").addClass("svyName");
	}
	$("#dwCommonEditRoot").show();
	$("#dwCommonEditRoot").offset({top:editOffset.top,left:editOffset.left});
	$("#dwComEditContent").focus();
	$("#dwComEditContent").html($(editAbleObj).html());
	var dwEditWidth=$(editAbleObj).width();

	//dwEditWidth<200?dwEditWidth=200:dwEditWidth;
	if(thClass.indexOf("dwSvyNoteEdit")<0 && thClass.indexOf("dwSvyName")<0){
		var hv=quItemBody.find("input[name='hv']").val();
		if(hv==3){
			var dwEditText=$(editAbleObj).text();
			if(dwEditText==""){
				dwEditWidth=$(editAbleObj).parents("td").width()-52;
			}
			dwEditWidth>600?dwEditWidth=600:dwEditWidth;
		}else{
			dwEditWidth<200?dwEditWidth=200:dwEditWidth>600?dwEditWidth=600:dwEditWidth;
		}
	}else{
		dwEditWidth=680;
	}
	
	$("#dwCommonEditRoot .dwCommonEdit").css("width",dwEditWidth);
	setSelectText($("#dwComEditContent"));
	curEditObj=$(editAbleObj);
	curEditObjOldHtml=$(editAbleObj).html();
}

function resizeWrapSize(){
	if(browseWidth<950){
		$("#wrap").width(950);
		$("#tools_wrap").width(950);
	}else{
		$("#wrap").width("100%");
		$("#tools_wrap").width("100%");
	}
	//保证居中
	if(browseWidth<780){
		$("#dw_body_content").offset({left:0});
	}else{
		var leftOffset=(browseWidth-780)/2;
		$("#dw_body_content").offset({left:leftOffset});
	}
}
/**
 * 保存标记说明
 * saveTag  标记本题有无变动
 * quTitleSaveTag  标记题标题变动
 * quItemSaveTag 标记题选项变动
 * 0=表示有变动，未保存
 * 1=表示已经保存同步
 */
function saveQus(quItemBody,callback){
	if(quItemBody[0]){
		var quType=quItemBody.find("input[name='quType']").val();
		if(quType=="RADIO"){
			//保存单选 
			//--1
			saveRadio(quItemBody,callback);
		}else if(quType=="CHECKBOX"){
			//--1
			saveCheckbox(quItemBody, callback);
		}else if(quType=="FILLBLANK"){
			//--逻辑
			saveFillblank(quItemBody, callback);
		}else if(quType=="SCORE"){
			//--逻辑
			saveScore(quItemBody, callback);
		}else if(quType=="ORDERQU"){
			//--逻辑
			saveOrderqu(quItemBody, callback);
		}else if(quType=="PAGETAG"){
			savePagetag(quItemBody, callback);
		}else if(quType=="PARAGRAPH"){
			saveParagraph(quItemBody, callback);
		}else if(quType=="MULTIFILLBLANK"){
			//--逻辑
			saveMultiFillblank(quItemBody, callback);
		}else if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
			
			//--逻辑
			saveChen(quItemBody, callback);
		}else{
			callback();
		}
	}else{
		callback();
	}
}

//*****单选题****//
/**
** 新保存单选题
**/
function saveRadio(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-radio!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var contactsAttr=quItemBody.find("input[name='contactsAttr']").val();
		var contactsField=quItemBody.find("input[name='contactsField']").val();
		var isSelectType=quItemBody.find("input[name='isSelectType']").val();

		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&contactsAttr="+contactsAttr+"&contactsField="+contactsField+"&isSelectType="+isSelectType;

		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}

		var quItemOptions=null;
		if(hv==3){
			//还有是table的情况需要处理
			quItemOptions=quItemBody.find(".quCoItem table.tableQuColItem tr td");
		}else{
			quItemOptions=quItemBody.find(".quCoItem li.quCoItemUlLi");
		}

		$.each(quItemOptions,function(i){
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			var isNote=$(this).find(".quItemInputCase input[name='isNote']").val();
			var checkType=$(this).find(".quItemInputCase input[name='checkType']").val();
			var isRequiredFill=$(this).find(".quItemInputCase input[name='isRequiredFill']").val();
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&optionValue_"+i+"="+optionValue;
				data+="&optionId_"+i+"="+optionId;
				data+="&isNote_"+i+"="+isNote;
				data+="&checkType_"+i+"="+checkType;
				data+="&isRequiredFill_"+i+"="+isRequiredFill;
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quOption_"+i);
		});

		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");

			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var ckQuId=$(this).find("input[name='ckQuId']").val();
			var ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var itemIndex=thClass;
			
		
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&logicType_"+itemIndex+"="+logicType;
				if(ckQuItemId !=undefined && ckQuItemId !=""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
			}
		});
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});

					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});

					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);

					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

/** 添加选项 **/
/** 添加单选选项   **/
function addRadioItem(quItemBody,itemText){
	//得判断是否是table类型
	var hv=quItemBody.find("input[name='hv']").val();
	var cellCount=quItemBody.find("input[name='cellCount']").val();
	var newEditObj=null;
	if(hv==3){
		//表格处理
		var quRadioItemHtml=$("#quRadioItem").html();
		//var quCoItemUl=quItemBody.find(".quCoItem table");
		var quTableObj=quItemBody.find(".quCoItem table.tableQuColItem");
		var emptyTdDiv=quTableObj.find("div.emptyTd");
		if(emptyTdDiv[0]){
			//表示有空位
			var emptyTd=emptyTdDiv.first().parents("td");
			emptyTd.empty();
			emptyTd.append(quRadioItemHtml);
		}else{
			//木有空位，根据cellCount生成新的tr,td
			var appendTr="<tr>";
			for(var i=0;i<cellCount;i++){
				appendTr+="<td>";
				if(i==0){
					appendTr+=quRadioItemHtml;
				}else{
					appendTr+="<div class='emptyTd'></div>";
				}
				appendTr+="</td>";
			}
			appendTr+="</tr>";
			quTableObj.append(appendTr);
		}
		var tdWidth=parseInt(600/cellCount);
		var tdLabelWidth=tdWidth-10;
		quItemBody.find(".quCoItem .tableQuColItem tr td").width(tdWidth);
		quItemBody.find(".quCoItem .tableQuColItem tr td label").width(tdLabelWidth);
		newEditObj=quItemBody.find(".quCoItem table").find(".editAble").last();
	}else{
		//ul li处理
		var quRadioItemHtml=$("#quRadioItem").html();
		var quCoItemUl=quItemBody.find(".quCoItem ul");
		quCoItemUl.append("<li class='quCoItemUlLi'>"+quRadioItemHtml+"</li>");
		quItemBody.find("input[name='saveTag']").val(0);
		newEditObj=quCoItemUl.find("li:last .editAble");
	}
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}
/** 删除单选题选项 **/
function deleteRadioOption(){
	//判断是否是table类型
	var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
	var hv=quItemBody.find("input[name='hv']").val();
	var optionParent=null;
	if(hv==3){
		optionParent=$(curEditObj).parents("td");
	}else{
		optionParent=$(curEditObj).parents("li.quCoItemUlLi");
	}
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-radio!ajaxDelete.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
	}
}

//*******多选题*******//
/**
** 新保存多选题
**/
function saveCheckbox(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		
		var url=ctx+"/design/qu-checkbox!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();;
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var isSubentry=quItemBody.find("input[name='isSubentry']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var contactsAttr=quItemBody.find("input[name='contactsAttr']").val();
		var contactsField=quItemBody.find("input[name='contactsField']").val();
		var minNum=quItemBody.find("input[name='minNum']").val();
	
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&contactsAttr="+contactsAttr+"&contactsField="+contactsField+"&minNum="+minNum;
		if(isSubentry == undefined || isSubentry == ""){
			isSubentry = "0";
		}
		data+="&isSubentry="+isSubentry;
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		var quItemOptions=null;
		if(hv==3){
			//还有是table的情况需要处理
			quItemOptions=quItemBody.find(".quCoItem table.tableQuColItem tr td");
		}else{
			quItemOptions=quItemBody.find(".quCoItem li.quCoItemUlLi");
		}
		
		$.each(quItemOptions,function(i){
			$(this).find(".quItemInputCase input[name='quItemSaveTag']").val(0);
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			var isNote=$(this).find(".quItemInputCase input[name='isNote']").val();
			var checkType=$(this).find(".quItemInputCase input[name='checkType']").val();
			var isRequiredFill=$(this).find(".quItemInputCase input[name='isRequiredFill']").val();
			var noCheckBox=$(this).find(".quItemInputCase input[name='noCheckBox']").val();
			
			
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&optionValue_"+i+"="+optionValue;
				data+="&optionId_"+i+"="+optionId;
				data+="&isNote_"+i+"="+isNote;
				data+="&checkType_"+i+"="+checkType;
				data+="&isRequiredFill_"+i+"="+isRequiredFill
				if(noCheckBox != undefined && noCheckBox != ""){
				data+="&noCheckBox_"+i+"="+noCheckBox;	
				}
				
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quOption_"+i);
		});
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			//设置逻辑的id
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			
			//设置选择的选型id
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			
			var  ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			//要跳转的题的ID
			var skQuId=$(this).find("input[name='skQuId']").val();
			
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			
			//是否需要保存的标识
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			
			//是否显示的标识
			var visibility=$(this).find("input[name='visibility']").val();
			
			//
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			
			//是跳转还是显示的标识
			var logicType=$(this).find("input[name='logicType']").val();
			
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&logicType_"+itemIndex+"="+logicType;
				if(ckQuItemId !=undefined && ckQuItemId != ""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
			}
		});
		
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				
				//成功则将要保存的标识变成1
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					//将题目和title的标识变成1 -- 不会重复保存
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}
/** 添加选项 **/
/** 添加多选选项 --普通  **/
function addCheckboxItem(quItemBody,itemText){
	//得判断是否是table类型
	var hv=quItemBody.find("input[name='hv']").val();
	var cellCount=quItemBody.find("input[name='cellCount']").val();
	var newEditObj=null;
	if(hv==3){
		//表格处理
		var quRadioItemHtml=$("#quCheckboxItem").html();
		//var quCoItemUl=quItemBody.find(".quCoItem table");
		var quTableObj=quItemBody.find(".quCoItem table.tableQuColItem");
		var emptyTdDiv=quTableObj.find("div.emptyTd");
		if(emptyTdDiv[0]){
			//表示有空位
			var emptyTd=emptyTdDiv.first().parents("td");
			emptyTd.empty();
			emptyTd.append(quRadioItemHtml);
		}else{
			//木有空位，根据cellCount生成新的tr,td
			var appendTr="<tr>";
			for(var i=0;i<cellCount;i++){
				appendTr+="<td>";
				if(i==0){
					appendTr+=quRadioItemHtml;
				}else{
					appendTr+="<div class='emptyTd'></div>";
				}
				appendTr+="</td>";
			}
			appendTr+="</tr>";
			quTableObj.append(appendTr);
		}
		var tdWidth=parseInt(600/cellCount);
		var tdLabelWidth=tdWidth-10;
		quItemBody.find(".quCoItem .tableQuColItem tr td").width(tdWidth);
		quItemBody.find(".quCoItem .tableQuColItem tr td label").width(tdLabelWidth);
		newEditObj=quItemBody.find(".quCoItem table").find(".editAble").last();
		//itemText="fsdfsdf";
	}else{
		//ul li处理
		var quRadioItemHtml=$("#quCheckboxItem").html();
		var quCoItemUl=quItemBody.find(".quCoItem ul");
		quCoItemUl.append("<li class='quCoItemUlLi'>"+quRadioItemHtml+"</li>");
		quItemBody.find("input[name='saveTag']").val(0);
		newEditObj=quCoItemUl.find("li:last .editAble");
	}
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}




/** 添加选项 **/
/** 添加多选选项 --分项  **/
function addCheckboxItem_subentry(quItemBody,itemText,node){
	//得判断是否是table类型
	var hv=quItemBody.parents('.surveyQuItemBody').find("input[name='hv']").val();
	var cellCount=quItemBody.parents('.surveyQuItemBody').find("input[name='cellCount']").val();
	var newEditObj=null;
	if(hv==3){
		//表格处理
		var quRadioItemHtml=$("#quCheckboxItem").html();
		//var quCoItemUl=quItemBody.find(".quCoItem table");
		var quTableObj=quItemBody.parents('.surveyQuItemBody').find(".quCoItem table.tableQuColItem");
		var emptyTdDiv=quTableObj.find("div.emptyTd");
		if(emptyTdDiv[0]){
			//表示有空位
			var emptyTd=emptyTdDiv.first().parents("td");
			emptyTd.empty();
			emptyTd.append(quRadioItemHtml);
		}else{
			//木有空位，根据cellCount生成新的tr,td
			var appendTr="<tr>";
			for(var i=0;i<cellCount;i++){
				appendTr+="<td>";
				if(i==0){
					appendTr+=quRadioItemHtml;
				}else{
					appendTr+="<div class='emptyTd'></div>";
				}
				appendTr+="</td>";
			}
			appendTr+="</tr>";
			quTableObj.append(appendTr);
		}
		var tdWidth=parseInt(600/cellCount);
		var tdLabelWidth=tdWidth-10;
		quItemBody.parents('.surveyQuItemBody').find(".quCoItem .tableQuColItem tr td").width(tdWidth);
		quItemBody.parents('.surveyQuItemBody').find(".quCoItem .tableQuColItem tr td label").width(tdLabelWidth);
		newEditObj=quItemBody.parents('.li_surveyQuItemBody').find(".quCoItem table").find(".editAble").last();
		//itemText="fsdfsdf";
	}else{
		//ul li处理
		var quRadioItemHtml=$("#quCheckboxItem").html();
		var quCoItemUl=quItemBody.find('.quCoItem').children("ul");
		var quCoBottomTools=$(node).parent('.quCoBottomToolsUl').parent('li');
		var quCoItemUlLi=quCoItemUl.find('.quCoItemUlLi:last');
		if(quCoBottomTools.length>0){
           $("<li class='quCoItemUlLi'>"+quRadioItemHtml+"</li>").insertBefore(quCoBottomTools);
		}else{
		    $("<li class='quCoItemUlLi'>"+quRadioItemHtml+"</li>").insertAfter(quCoItemUlLi);
		}
		// quCoItemUl.append("<li class='quCoItemUlLi'>"+quRadioItemHtml+"</li>");
		//quItemBody.parents('.surveyQuItemBody').find("input[name='saveTag']").val(0);
		quItemBody.find("input[name='saveTag']").val(0);
		// var li_length=quCoItemUl.find('li').length;
		// newEditObj=quCoItemUl.find("li").eq(li_length - 1).find('.editAble');
		newEditObj=$(node).parent('.quCoBottomToolsUl').parent('li').prev().find('.editAble');
	}
	newEditObj.html(itemText);
	//resetNum(quItemBody);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}
/** 删除多选题选项 **/
function deleteCheckboxOption(){
	//判断是否是table类型
	var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
	var hv=quItemBody.find("input[name='hv']").val();
	var optionParent=null;
	if(hv==3){
		optionParent=$(curEditObj).parents("td");
	}else{
		optionParent=$(curEditObj).parents("li.quCoItemUlLi");
	}
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-checkbox!ajaxDelete.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
	}
}

function delQuOptionCallBack(optionParent){
	var quItemBody=$(optionParent).parents(".surveyQuItemBody");
	var quType=quItemBody.find("input[name='quType']").val();
	if(quType=="CHECKBOX" || quType=="RADIO"){
		var hv=quItemBody.find("input[name='hv']").val();
		if(hv==3){
			//emptyTd
			var optionTr=$(optionParent).parents("tr");
			var optionNextTr=optionTr.next();
			if(optionNextTr[0]){
				//则后面还有是中间选项，则删除，再依次后面的td往前移动
				$(optionParent).remove();
				moveTabelTd(optionNextTr);
			}else{
				//非中间选项，删除-再添加一个空td
				$(optionParent).remove();
				movePareseLastTr(optionTr);
			}
		}else{
			optionParent.remove();	
		}
	}else if(quType=="CHENRADIO"  || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
		//$(curEditObj).parents("td.quChenColumnTd");
		var quCoChenTable=optionParent.parents("table.quCoChenTable");
		var optionParentClass=optionParent.attr("class");
		if(optionParentClass.indexOf("Column")>=0){
			var removeTrs=quCoChenTable.find("tr:gt(0)");
			$.each(removeTrs,function(){
				$(this).find("td:last").remove();
			});
			optionParent.remove();
		}else{
			optionParent.parent().remove();
		}
	}else{
		optionParent.remove();	
	}
	dwCommonEditHide();
	bindQuHoverItem();
}
function moveTabelTd(nextTr){
	if(nextTr[0]){
		var prevTr=nextTr.prev();
		var nextTds=nextTr.find("td");
		$(nextTds.get(0)).appendTo(prevTr);
		//判断当前next是否是最后一个，是则：判断如果没有选项，则删除tr,如果有选项，则填一个空td
		var nextNextTr=nextTr.next();
		if(!nextNextTr[0]){
			movePareseLastTr(nextTr);
		}
		moveTabelTd($(nextTr).next());
	}
}
function movePareseLastTr(nextTr){
	var editAbles=nextTr.find(".editAble");
	if(editAbles[0]){
		//有选项，则补充一个空td
		var editAbleTd=editAbles.parents("td");
		editAbleTd.clone().prependTo(nextTr);
		nextTr.find("td").last().html("<div class='emptyTd'></div>");
	}else{
		nextTr.remove();
	}
}

//*******填空题*******//
/**
** 新保存填空题
*  逻辑注释。测试
**/
function saveFillblank(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-fillblank!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();;
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		
		var answerInputWidth=quItemBody.find("input[name='answerInputWidth']").val();
		var answerInputRow=quItemBody.find("input[name='answerInputRow']").val();
		
		var contactsAttr=quItemBody.find("input[name='contactsAttr']").val();
		var contactsField=quItemBody.find("input[name='contactsField']").val();
		
		var checkType=quItemBody.find("input[name='checkType']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&answerInputWidth="+answerInputWidth+"&answerInputRow="+answerInputRow;
		data+="&contactsAttr="+contactsAttr+"&contactsField="+contactsField+"&checkType="+checkType;
		
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&logicType_"+itemIndex+"="+logicType;
				if(ckQuItemId != undefined && ckQuItemId != ""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
			}

		});
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}



//*****评分题****//
/**
** 新保存评分题
**/
function saveScore(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-score!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		
		var paramInt01=quItemBody.find("input[name='paramInt01']").val();
		var paramInt02=quItemBody.find("input[name='paramInt02']").val();
		
		var isSlider=quItemBody.find("input[name='isSlider']").val(); 
		var isScoreInput=quItemBody.find("input[name='isScoreInput']").val();
		var maxSliderLength=quItemBody.find("input[name='maxSliderLength']").val();
		var minSliderLength=quItemBody.find("input[name='minSliderLength']").val();
		var totalSliderLength=quItemBody.find("input[name='totalSliderLength']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&paramInt01="+paramInt01+"&paramInt02="+paramInt02+"&isSlider="+isSlider+"&maxSliderLength="+maxSliderLength;
		data+="&minSliderLength="+minSliderLength+"&totalSliderLength="+totalSliderLength+"&isScoreInput="+isScoreInput ;
		
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//评分题选项td
		var quItemOptions=quItemBody.find(".quCoItem table.quCoItemTable tr td.quOptionEditTd");
		$.each(quItemOptions,function(i){
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&optionValue_"+i+"="+optionValue;
				data+="&optionId_"+i+"="+optionId;
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quOption_"+i);
		});
		
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			
			
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&logicType_"+itemIndex+"="+logicType;
				
				if(ckQuItemId != undefined && ckQuItemId != ""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
			}
			
		});
		
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

/** 添加选项 **/
/** 添加评分项   **/
function addScoreItem(quItemBody,itemText){
	//得判断是否是table类型
	var newEditObj=null;
	//ul li处理
	var quScoreItemHtml=$("#quScoreItemModel").html();
	var quCoItemTable=quItemBody.find("table.quCoItemTable");
	quCoItemTable.append("<tr class='quScoreOptionTr'>"+quScoreItemHtml+"</tr>");
	quItemBody.find("input[name='saveTag']").val(0);
	
	var scoreNumTableTr=quCoItemTable.find("tr.quScoreOptionTr:last  .scoreNumTable tr");
	var paramInt02=quItemBody.find("input[name='paramInt02']").val();
	scoreNumTableTr.empty();
	for(var i=1;i<=paramInt02;i++){
		scoreNumTableTr.append("<td>"+i+"</td>");
	}
	quCoItemTable.find("tr.quScoreOptionTr:last input[name='quItemSaveTag']").val(0);
	
	newEditObj=quCoItemTable.find("tr.quScoreOptionTr:last .editAble");
	
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}
/** 删除评分Score选项 **/
function deleteScoreOption(){
	var optionParent=null;
	optionParent=$(curEditObj).parents("tr.quScoreOptionTr");
	
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-score!ajaxDelete.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
	}
}


//*****排序题****//
/**
** 新保存排序题
**/
function saveOrderqu(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-orderqu!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//评分题选项td
		var quItemOptions=quItemBody.find(".quCoItem .quOrderByLeft  li.quCoItemUlLi");
		$.each(quItemOptions,function(i){
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&optionValue_"+i+"="+optionValue;
				data+="&optionId_"+i+"="+optionId;
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quOption_"+i);
		});
		
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&logicType_"+itemIndex+"="+logicType;
				if(ckQuItemId != undefined && ckQuItemId != ""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
			}
			
		});
		
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

/** 添加选项 **/
/** 添加排序项   **/
function addOrderquItem(quItemBody,itemText){
	//得判断是否是table类型
	var newEditObj=null;
	//ul li处理 <li class="quCoItemUlLi">
	var quOrderItemLeftHtml=$("#quOrderItemLeftModel").html();
	var quOrderItemRightHtml=$("#quOrderItemRightModel").html();
	
	var quOrderItemLeftUl=quItemBody.find(".quOrderByLeft ul");
	var quOrderByRightTable=quItemBody.find(".quOrderByRight table.quOrderByTable");
	quOrderItemLeftUl.append("<li class='quCoItemUlLi'>"+quOrderItemLeftHtml+"</li>");
	quOrderByRightTable.append("<tr>"+quOrderItemRightHtml+"</tr>");
	
	quItemBody.find("input[name='saveTag']").val(0);
	newEditObj=quOrderItemLeftUl.find("li:last .editAble");
	
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	//quOrderyTableTd
	refquOrderTableTdNum(quOrderByRightTable);
	return newEditObj;
}
function refquOrderTableTdNum(quOrderByRightTable){
	var quOrderyTableTds=quOrderByRightTable.find(".quOrderyTableTd");
	$.each(quOrderyTableTds,function(i){
		$(this).text(i+1);
	});
}
/** 删除排序选项 **/
function deleteOrderquOption(){
	var optionParent=null;
	optionParent=$(curEditObj).parents("li.quCoItemUlLi");
	var quItemBody=$(curEditObj).parents(".surveyQuItemBody");
	var rmQuOrderTableTr=quItemBody.find(".quOrderByRight table.quOrderByTable tr:last");
	
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-orderqu!ajaxDelete.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
					rmQuOrderTableTr.remove();
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
		rmQuOrderTableTr.remove();
	}
}


//*******分页标记*******//
/**
** 新保存分页标记
**/
function savePagetag(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-pagetag!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();;
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&logicType_"+itemIndex+"="+logicType;
			}
			
		});
		
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

//*******段落说明题*******//
/**
** 新保存段落题
**/
function saveParagraph(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-paragraph!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();;
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&logicType_"+itemIndex+"="+logicType;
			}
			
		});
		
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

/** 多项填空题 **/
/**
** 新保存多项填空题
**/
function saveMultiFillblank(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-multi-fillblank!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var answerInputWidth=quItemBody.find("input[name='answerInputWidth']").val();
		var answerInputRow=quItemBody.find("input[name='answerInputRow']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var paramInt01=quItemBody.find("input[name='paramInt01']").val();
		var paramInt02=quItemBody.find("input[name='paramInt02']").val();
		var mustAnswerNum=$(".minNum").val();
		
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&paramInt01="+paramInt01+"&paramInt02="+paramInt02;
		data+="&answerInputWidth="+answerInputWidth+"&answerInputRow="+answerInputRow;
		console.log(999, answerInputRow)
        if(mustAnswerNum != undefined && mustAnswerNum != ""){
			data+="&mustAnswerNum="+mustAnswerNum;
		}
		
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//评分题选项td
		var quItemOptions=quItemBody.find(".quCoItem table.mFillblankTable tr td.mFillblankTableEditTd");
		$.each(quItemOptions,function(i){
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&optionValue_"+i+"="+optionValue;
				data+="&optionId_"+i+"="+optionId;
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quOption_"+i);
		});
		
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&logicType_"+itemIndex+"="+logicType;
				if(ckQuItemId != undefined && ckQuItemId != ""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
				
			}
			
		});
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				//alert(msg);// resultJson quItemId
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

/** 添加选项 **/
/** 添加多项填空题项   **/
function addMultiFillblankItem(quItemBody,itemText){
	//得判断是否是table类型
	var newEditObj=null;
	//ul li处理
	var quScoreItemHtml=$("#mFillblankTableModel").html();
	var quCoItemTable=quItemBody.find("table.mFillblankTable");
	quCoItemTable.append("<tr class='mFillblankTableTr'>"+quScoreItemHtml+"</tr>");
	quItemBody.find("input[name='saveTag']").val(0);
	newEditObj=quCoItemTable.find("tr.mFillblankTableTr:last .editAble");
	
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}
/** 删除多项填空题选项 **/
function deleteMultiFillblankOption(){
	var optionParent=null;
	optionParent=$(curEditObj).parents("tr.mFillblankTableTr");
	
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-multi-fillblank!ajaxDelete.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
	}
}



/** 矩阵单选题 **/
/**
** 新保存矩阵单选题
**/
function saveChen(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-chen!ajaxSave.action";
		var quType=quItemBody.find("input[name='quType']").val();
	    var trWidthInfo=quItemBody.find("input[name='trWidthInfo']").val();
		var quId=quItemBody.find("input[name='quId']").val();
		var orderById=quItemBody.find("input[name='orderById']").val();
		var isRequired=quItemBody.find("input[name='isRequired']").val();
		var hv=quItemBody.find("input[name='hv']").val();
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var maxSliderLength=quItemBody.find("input[name='maxSliderLength']").val();
		var minSliderLength=quItemBody.find("input[name='minSliderLength']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount+"&trWidthInfo="+trWidthInfo;
		
		if(maxSliderLength != undefined && maxSliderLength !="" ){data+="&maxSliderLength="+maxSliderLength};
		if(minSliderLength != undefined && minSliderLength !="" ){data+="&minSliderLength="+minSliderLength};
		var quTitleSaveTag=quItemBody.find("input[name='quTitleSaveTag']").val();
		if(quTitleSaveTag==0){
			var quTitle=quItemBody.find(".quCoTitleEdit").html();
			quTitle=escape(encodeURIComponent(quTitle));
			data+="&quTitle="+quTitle;
		}
		//var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quTitle="+quTitle+"&quId="+quId;
		//var quItemLis=quItemBody.find(".quCoItem li.quCoItemUlLi");
		//矩阵列选项td
		var quColumnOptions=quItemBody.find(".quCoItem table.quCoChenTable tr td.quChenColumnTd");
		$.each(quColumnOptions,function(i){
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&columnValue_"+i+"="+optionValue;
				data+="&columnId_"+i+"="+optionId;
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quColumnOption_"+i);
		});
		
		//矩阵行选项td
		var quColumnOptions=quItemBody.find(".quCoItem table.quCoChenTable tr td.quChenRowTd");
		$.each(quColumnOptions,function(i){
			var optionValue=$(this).find("label.quCoOptionEdit").html();
			var optionId=$(this).find(".quItemInputCase input[name='quItemId']").val();
			var quItemSaveTag=$(this).find(".quItemInputCase input[name='quItemSaveTag']").val();
			if(quItemSaveTag==0){
				optionValue=escape(encodeURIComponent(optionValue));
				data+="&rowValue_"+i+"="+optionValue;
				data+="&rowId_"+i+"="+optionId;
			}
			//更新 字母 title标记到选项上.
			$(this).addClass("quRowOption_"+i);
		});
		
		//逻辑选项
		var quLogicItems=quItemBody.find(".quLogicItem");
		$.each(quLogicItems,function(i){
			var thClass=$(this).attr("class");
			thClass=thClass.replace("quLogicItem quLogicItem_","");
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			var ckQuItemId=$(this).find("input[name='ckQuItemId']").val();
			var skQuId=$(this).find("input[name='skQuId']").val();
			
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			var eqAndNq=$(this).find("input[name='eqAndNq']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&eqAndNq_"+itemIndex+"="+eqAndNq;
				data+="&logicType_"+itemIndex+"="+logicType;
				if(ckQuItemId != undefined && ckQuItemId != ""){
					data+="&ckQuItemId_"+itemIndex+"="+ckQuItemId;
				}
			}
		});
		$.ajax({
			url:url,
			data:data,
			type:'post',
			success:function(msg){
				if(msg!="error"){
					var jsons=eval("("+msg+")");
					//alert(jsons);
					var quId=jsons.id;
					quItemBody.find("input[name='quId']").val(quId);
					//列选项
					var quColumnItems=jsons.quColumnItems;
					$.each(quColumnItems,function(i,item){
						var quItemOption=quItemBody.find(".quColumnOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					//行选项
					var quRowItems=jsons.quRowItems;
					$.each(quRowItems,function(i,item){
						var quItemOption=quItemBody.find(".quRowOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem");
						logicItem.find("input[name='quLogicId']").val(item.id);
						logicItem.find("input[name='logicSaveTag']").val(1);
					});
					
					quItemBody.find("input[name='saveTag']").val(1);
					quItemBody.find(".quCoTitle input[name='quTitleSaveTag']").val(1);
					
					//执行保存下一题
					saveQus(quItemBody.next(),callback);
					//同步-更新题目排序号
					quCBNum2++;
					exeQuCBNum();
				}
			}
		});
	}else{
		saveQus(quItemBody.next(),callback);
	}
}

/** 添加列选项 **/
function addChenItem(eventObj,quItemBody,itemText){
	var eventObjClass=eventObj.attr("class");
	if(eventObjClass.indexOf("Column")>=0){
	    return  addChenColumnItem(quItemBody, itemText);
	}else{
		return  addChenRowItem(quItemBody, itemText);
	}
}
/** 添加矩阵单选题列选项   **/
function addChenColumnItem(quItemBody,itemText){
	//得判断是否是table类型
	var newEditObj=null;
	//ul li处理
	var quRadioColumnHtml=$("#quChenColumnModel").html();
	var quCoChenTable=quItemBody.find("table.quCoChenTable");
	var quCoChenTableTrs=quCoChenTable.find("tr");
	var quType=quItemBody.find("input[name='quType']").val();
	$.each(quCoChenTableTrs,function(i){
		if(i==0){
			$(this).append(quRadioColumnHtml);
		}else{
			if(quType=="CHENRADIO"){
				$(this).append("<td><input type='radio'> </td>");	
			}else if(quType=="CHENCHECKBOX"){
				$(this).append("<td><input type='checkbox'> </td>");
			}else if(quType=="CHENFBK"){
				$(this).append("<td><input type='text'> </td>");
			}else if(quType=="CHENSCORE"){
				 $(this).append("<td>评分</td>");
			}
		}
	});
	quItemBody.find("input[name='saveTag']").val(0);
	newEditObj=quCoChenTable.find("tr:first .editAble:last");
	
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}

//添加矩阵单选题行选项
function addChenRowItem(quItemBody,itemText){
	//得判断是否是table类型
	var newEditObj=null;
	//ul li处理
	var quChenRowHtml=$("#quChenRowModel").html();
	var quCoChenTable=quItemBody.find("table.quCoChenTable");
	var quCoChenTableTds=quCoChenTable.find("tr:first td");
	var quType=quItemBody.find("input[name='quType']").val();
	var appendTrHtml="<tr>";
	$.each(quCoChenTableTds,function(i){
		if(i==0){
			appendTrHtml+=quChenRowHtml;
		}else{
			if(quType=="CHENRADIO"){
				appendTrHtml+="<td><input type='radio'> </td>";
			}else if(quType=="CHENCHECKBOX"){
				appendTrHtml+="<td><input type='checkbox'> </td>";
			}else if(quType=="CHENFBK"){
				appendTrHtml+="<td><input type='text'> </td>";
			}else if(quType=="CHENSCORE"){
				appendTrHtml+="<td>评分</td>";
			}
		}
	});
	appendTrHtml+="</tr>";
	quCoChenTable.append(appendTrHtml);
	
	quItemBody.find("input[name='saveTag']").val(0);
	newEditObj=quCoChenTable.find("tr:last .editAble");
	
	newEditObj.html(itemText);
	if(itemText==""){
		newEditObj.css("display","inline");
	}
	return newEditObj;
}
//删除矩陈单选题选项
function deleteChenOption(){
	var curEditTd=$(curEditObj).parents("td");
	var curEditTdClass=curEditTd.attr("class");
	if(curEditTdClass.indexOf("Column")>=0){
		// deleteChenRadioColumnOption();
		deleteChenColumnOption();
	}else{
		// deleteChenRadioRowOption();
		deleteChenRowOption();
	}
}
/** 删除矩阵单选题列选项 **/
function deleteChenColumnOption(){
	var optionParent=null;
	optionParent=$(curEditObj).parents("td.quChenColumnTd");
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-chen!ajaxDeleteColumn.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
	}
}
/** 删除矩阵单选题行选项 **/
function deleteChenRowOption(){
	var optionParent=null;
	optionParent=$(curEditObj).parents("td.quChenRowTd");
	var quOptionId=$(optionParent).find("input[name='quItemId']").val();
	if(quOptionId!="" && quOptionId!="0" ){
		var url=ctx+"/design/qu-chen!ajaxDeleteRow.action";
		var data="quItemId="+quOptionId;
		$.ajax({
			url:url,
			data:data,
			type:"post",
			success:function(msg){
				if(msg=="true"){
					delQuOptionCallBack(optionParent);
				}
			}
		});
	}else{
		delQuOptionCallBack(optionParent);
	}
}

/**逻辑设置**/
//添加逻辑选项
//传参 false function() 空的function()
function addQuDialogLogicTr(autoClass,trueCallback,falseCallback){
	//当前题的选项
	//找到当前的li
	var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
	
	//获得选项信息
	var quItemInputCases=quItemBody.find(".quItemInputCase");
	
	//获得逻辑的信息
	var quLogicInputCase=quItemBody.find(".quLogicInputCase");
	
	//问题的ID
	var curQuId=quItemBody.find("input[name='quId']").val();
	
	//问题的类型
	var quType=quItemBody.find("input[name='quType']").val();
	
	//获得逻辑起始
	var logicQuOptionSels=$("#dwQuLogicTable").find(".logicQuOptionSel");
	
	//获得逻辑结束
	var dwLogicQuSels=$("#dwQuLogicTable").find(".logicQuSel");
	
	//判断有无选项任意选项
	var executeTag=true;
	$.each(logicQuOptionSels,function(){
		var selOptionVal=$(this).val();
		if(selOptionVal=="0"){
			executeTag=false;
			return false;
		}
	});
	
	if(executeTag){
		
		//获得一个逻辑模板
		var appendTrHtml=$("#setQuLogicItemTrModel").html();
		
		//如果是分数题的话获得另一个模板
		if(quType==="SCORE"){
			appendTrHtml=$("#setQuLogicItemTrModel_score").html();
		}
		
		//添加一个模板
		$("#dwQuLogicTable").append("<tr>"+appendTrHtml+"</tr>");
		
		//获得最后一个tr
		var lastTr=$("#dwQuLogicTable").find("tr").last();
		
		if(quType==="FILLBLANK"){
			lastTr.find(".ifSpanText1").text("如果回答");
		}
		
		//如果增加td的话数量标识童虎更新
		if(autoClass){
			var quLogicItemNum=quLogicInputCase.find("input[name='quLogicItemNum']");
			var newQuLogicItemNum=(parseInt(quLogicItemNum.val())+1);
			quLogicItemNum.val(newQuLogicItemNum);
			var newQuLogicItemClass="quLogicItem_"+newQuLogicItemNum;
			
			//最后加入
			lastTr.attr("class",newQuLogicItemClass);
		}
		
		var dwQuOptionSel=lastTr.find(".logicQuOptionSel");
		var eachTag=true;
		if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
			
			var quChenColumnTds=quItemBody.find(".quChenColumnTd");
			var quChenRowTds=quItemBody.find(".quChenRowTd");
			$.each(quChenRowTds,function(){
				var rowText=$(this).find(".quCoOptionEdit").text();
				var rowQuItemId=$(this).find("input[name='quItemId']").val();	
				$.each(quChenColumnTds,function(){
					var colText=$(this).find(".quCoOptionEdit").text();
					var colQuItemId=$(this).find("input[name='quItemId']").val();
					var optionId=rowQuItemId+":"+colQuItemId;
					eachTag=true;
					$.each(logicQuOptionSels,function(){
						var selOptionVal=$(this).val();
						if(selOptionVal==optionId){
							eachTag=false;
							return false;
						}
					});
					if(eachTag){
						dwQuOptionSel.append("<option value='"+optionId+"'>"+rowText+":"+colText+"</option>");	
					}
				});
			});
			
			/*
			$.each(quItemInputCases,function(){
//				var optionText=$(this).prev().text();
				var optionText=$(this).parent().find("label.quCoOptionEdit").text();
				var optionId=$(this).find("input[name='quItemId']").val();
				eachTag=true;
				$.each(logicQuOptionSels,function(){
					var selOptionVal=$(this).val();
					if(selOptionVal==optionId){
						eachTag=false;
						return false;
					}
				});
				//alert(optionText);
				if(eachTag){
					dwQuOptionSel.append("<option value='"+optionId+"'>"+optionText+"</option>");	
				}
			});
			*/
		}else{
			$.each(quItemInputCases,function(){
//				var optionText=$(this).prev().text();
				var optionText=$(this).parent().find("label.quCoOptionEdit").text();
				var optionId=$(this).find("input[name='quItemId']").val();
				eachTag=true;
				$.each(logicQuOptionSels,function(){
					var selOptionVal=$(this).val();
					if(selOptionVal==optionId){
						eachTag=false;
						return false;
					}
				});
				if(eachTag){
					dwQuOptionSel.append("<option value='"+optionId+"'>"+optionText+"</option>");	
				}
			});
		}
		
		if(logicQuOptionSels.size()==0){
			dwQuOptionSel.append("<option value='0'>任意选项</option>");	
		}else{
			$("#dwQuLogicTable").find(".logicQuOptionSel option[value='0']").remove();
		}
		if(quType==="FILLBLANK"){
			dwQuOptionSel.val("0");
		}
		var logicQuSel=lastTr.find(".logicQuSel");
		var quItemBodys=$("#dwSurveyQuContent .surveyQuItemBody");
		$.each(quItemBodys,function(){
			//logicQuSels
			if($(this).find(".quCoTitleEdit")[0]){
				var quCoNumText=$(this).find(".quCoNum").text();
				var quTitleText=$(this).find(".quCoTitleEdit").text();
				var quId=$(this).find("input[name='quId']").val();
				eachTag=true;
				if(curQuId==quId){
					eachTag=false;
				}
				if(eachTag){
					$.each(dwLogicQuSels,function(){
						var dwLogicQuSelVal=$(this).val();
						if(dwLogicQuSelVal==quId){
							eachTag=false;
							return false;
						}
					});
				}
				if(eachTag){
					logicQuSel.append("<option value='"+quId+"'>"+quCoNumText+quTitleText+"</option>");	
				}
			}
		});
		logicQuSel.append("<option value='1'>正常结束（计入结果）</option><option value='2'>提前结束（不计入结果）</option>");
		if(quType==="SCORE"){
			var logicScoreNum=lastTr.find(".logicScoreNum");
			logicScoreNum.empty();
			for(var i=1;i<=10;i++){
				logicScoreNum.append("<option value=\""+i+"\">"+i+"</option>");
			}
			
		}else if(quType==="ORDERQU"){
			dwQuOptionSel.empty();
			dwQuOptionSel.append("<option value='0'>回答完成</option>");
			lastTr.find(".ifSpanText1").text("如果本题");
		}
		if(autoClass){
			logicQuSel.prepend("<option value=''>-请选择题目-</option>");
			dwQuOptionSel.prepend("<option value=''>-请选择选项-</option>");
		}
		bindDialogRemoveLogic();
		trueCallback();
	}else{
		falseCallback();
	}
	
}

//绑定逻辑设置中选项删除事件
function bindDialogRemoveLogic(){
	$(".dialogRemoveLogic").unbind();
		$(".dialogRemoveLogic").click(function(){
		var logicItemTr=$(this).parents("tr");
		var logicItemTrClass=logicItemTr.attr("class");
		//同时移除页面只保存的信息--注意如果已经保存到库中，修改
		var quItemBody=$(dwDialogObj).parents(".surveyQuItemBody");
		var quLogicItem=quItemBody.find("."+logicItemTrClass);
		if(quLogicItem[0]){
			//有则判断，是否已经加入到数据库
			var quLogicIdVal=quLogicItem.find("input[name='quLogicId']").val();
			if(quLogicIdVal!=""){
				quLogicItem.find("input[name='visibility']").val(0);
				quLogicItem.find("input[name='logicSaveTag']").val(0);
				quItemBody.find("input[name='saveTag']").val(0);
				
			}else{
				quLogicItem.remove();
			}
			//更新select option信息
			var logicQuOptionSel=logicItemTr.find(".logicQuOptionSel option:selected");
			var logicQuSel=logicItemTr.find(".logicQuSel option:selected");
			if(logicQuOptionSel.val()!=""){
				$("#dwQuLogicTable").find(".logicQuOptionSel").append("<option value='"+logicQuOptionSel.val()+"'>"+logicQuOptionSel.text()+"</option>");
			}
			if(logicQuSel.val()!=""){
				$("#dwQuLogicTable").find(".logicQuSel").append("<option value='"+logicQuSel.val()+"'>"+logicQuSel.text()+"</option>");
			}
		}
		logicItemTr.remove();
		refreshQuLogicInfo(quItemBody);
		return false;
	});
	/*设置逻辑时，选中某个选项时的操作
	$(".logicQuOptionSel").unbind();
	$(".logicQuOptionSel").change(function(){
		var thVal=$(this).val();
		//刷新
		$("#dwQuLogicTable").find(".logicQuOptionSel").not(this).find("option[value='"+thVal+"']").remove();
	});*/
	$(".logicQuSel").unbind();
	$(".logicQuSel").change(function(){
		var thVal=$(this).val();
		//当题目选项中选项 提前结束，或正常结束，则不作处理
		if(thVal!=="1" && thVal!=="2"){
			//移除前面选项中存在的当前被选择的选项
			$("#dwQuLogicTable").find(".logicQuSel").not(this).find("option[value='"+thVal+"']").remove();			
		}
	});
}

//刷新每题的逻辑显示数目
function refreshQuLogicInfo(quItemBody){
	var quLogicItems=quItemBody.find(".quLogicItem input[name='visibility'][value='1']");
	var cgQuItemId=quItemBody.find("input[name='cgQuItemId']").val();
    var skQuId=quItemBody.find("input[name='skQuId']").val();
    if(cgQuItemId == "" && skQuId == ""){
    	quItemBody.find(".quLogicInfo").text("0");
    }else{
    	quItemBody.find(".quLogicInfo").text("1");
    }
	
}

function exeQuCBNum(){
	if(quCBNum==quCBNum2){
		quCBNum=0;
		quCBNum2=0;
		//全部题排序号同步一次
		//对如新增插入题-需要同步调整其它题的排序
		//对如删除题-需要同步调整其它题的排序
	}
}

function setSelectText(el) {
    try {
        window.getSelection().selectAllChildren(el[0]); //全选
        window.getSelection().collapseToEnd(el[0]); //光标置后
       /*var Check = check_title_select(el.text());
        window.getSelection().selectAllChildren(el[0]); //全选
        if (!Check) {
            window.getSelection().collapseToEnd(el[0]); //光标置后
        }*/
    } catch (err) {
        //在此处理错误
    }
    //      if(document.selection){
    //          
    //      }else{
    //         var Check = check_title_select(el.text());
    //
    //          window.getSelection().selectAllChildren(el[0]);//全选
    //         if(!Check){
    //          window.getSelection().collapseToEnd(el[0]);//光标置后
    //         }
    //      }
}

function validateGen(){
	$("#dwCommonDialogForm").validate({
		rules:{
			setCellCount:{
				required:true,
				digits:true,
				min:1
			}
		},
		errorPlacement: function(error, element) {
			//error.appendTo(element.parent().parent());
			element.parent().append(error);
			//	$(element).css("borderColor","#C40000");
		}
	});
	$("input[name='setCellCount']").unbind();
	$("input[name='setCellCount']").blur(function(){
		$("#dwCommonDialogForm").validate();
	});
	$("input[name='setCellCount']").blur();
}

function notify(msg,delayHid) {
	$(".notification").remove();
	if(delayHid==null){
		delayHid=5000;
	}
	$( "<div>" )
		.appendTo( document.body )
		.text( msg )
		.addClass( "notification ui-state-default ui-corner-bottom" )
		.position({
			my: "center top",
			at: "center top",
			of: window
		})
		.show({
			effect: "blind"
		})
		.delay( delayHid )
		.hide({
			effect: "blind",
			duration: "slow"
		}, function() {
			$( this ).remove();
		});
}

//批量生成问卷用户的方法
function saveSurveyUser(){
	var survey_id=$("#id").val();
	var survey_user_count=$("input[name='survey_user_count']").eq(0).val();
	var password_setting=$("input[name='password_type']:checked").val();
	var password=$("input[name='password']").eq(0).val();
	var password_length=$("input[name='password_length']").eq(0).val();
	var survey_user_name=$("input[name='survey_user_name']").eq(0).val();
	var alarmstarttime=$("input[name='alarmstarttime']").eq(0).val();
	var alarmendtime=$("input[name='alarmendtime']").eq(0).val();
	var survey_state=$("#survey_state").val();
	if(survey_state == undefined || survey_state == ""){
		survey_state == "1";
	}
	var url=ctx+"/surveyuser/survey-user!save.action";
	
	/*if(survey_user_count==""||password_length==""||survey_user_name==""||alarmstarttime==""||alarmendtime==""){
		alert("请将信息填写完整");
		return false;
	}*/
	if(checkInput(survey_user_count,"survey_user_count")|checkInput(survey_user_name,"survey_user_name")|
			checkInput(alarmstarttime,"alarmstarttime")|checkInput(alarmendtime,"alarmendtime")	){
		return false;
	}
	
	var endTimeRexp =/^\d{4}-(?:0\d|1[0-2])-(?:[0-2]\d|3[01])( (?:[01]\d|2[0-3])\:[0-5]\d\:[0-5]\d)?$/;
	var endNumRexp=/^[0-9]*[1-9][0-9]*$/;
	
	if(!endNumRexp.test(survey_user_count)){
		layer.msg("输入用户数量格式有误");
		return false;
	}
	
	if(password_length && !endNumRexp.test(password_length)){
		layer.msg("输入密码长度格式有误");
		return false;
	}
	
	if(password_length && password_length > 255){
		layer.msg("密码长度过长");
		return false;
	}
	
	if(survey_user_count > 10000){
		layer.msg("用户数量过多");
		return false;
	}
	

	//alert(survey_id+"-"+survey_user_count+"-"+password_length+"-"+survey_user_name+"-"+alarmstarttime+"-"+alarmendtime)
	$.ajax({
	   url:url,
	   data:{"survey_id":survey_id,"survey_user_count":survey_user_count,"password_setting":password_setting,"password":password,"password_length":password_length,
		   "survey_user_name":survey_user_name,"alarmstarttime":alarmstarttime,"alarmendtime":alarmendtime,
		   "survey_state":survey_state},
	   datatype:"json",
	   type:"post",
	   success:function(result){
		   
		   if(result=="批量生成成功"){
			   $("#modelUIDialog").dialog("close");  
		   }
		   alert(result);
	   }
	   
	})
}

//前端验证函数
function checkInput(obj,name){
	if(obj==""){
		$(".check_"+name).show();
		return true;
	}
}
//处理不同的密码类型
var handlePwdType = function (type) {
    if(type === '3') {
		document.getElementById('password_length_input').style.display = '';
		document.getElementById('password_content_input').style.display = 'none';
	}else if(type === '2' || type === '4') {
		document.getElementById('password_content_input').style.display = '';
		document.getElementById('password_length_input').style.display = 'none';
	}else if(type === '1') {
		document.getElementById('password_content_input').style.display = 'none';
		document.getElementById('password_length_input').style.display = 'none';
	}
};

function hideItem(obj){
	$(".check_"+obj).hide();
}
//js获取网站根路径(站点及虚拟目录)
function RootPath() {
  var strFullPath = window.document.location.href;
  var strPath = window.document.location.pathname;
  var pos = strFullPath.indexOf(strPath);
  var prePath = strFullPath.substring(0, pos);
  var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
  return (prePath + postPath);
}


function deletesurveyuser(surveyuser_id){
	
	var url=ctx+"/surveyuser/survey-user!delete.action";
	var id=$("#id").val();
	layer.confirm('确定要删除吗', {
		  btn: ['是','否'] //按钮
		}, function(){
			$.ajax({
				url:url,
				data:{"surveyuser_id":surveyuser_id,"survey_id":id},
				type:"get",
				datatype:"json",
				success:function(page){
					//jquery局部刷新
					layer.close(layer.index);
					$(".content_1").remove();
					$("#content_2").remove();
					tablepage(page);
					layer.msg("删除成功");

				}
					
			})
		}, function(){
		   layer.close(layer.index);
		   return false;
		});
	
	

	
}

function bactchDelete(){
	
	var url=ctx+"/surveyuser/survey-user!deleteBatch.action";
	var id=$("#id").val();
	var surveyuser_id="";
	
	$(".checkSingle:checked").each(function(){
		surveyuser_id+=$(this).val()+",";
	})
	
  
	surveyuser_id=surveyuser_id.substring(0, surveyuser_id.length-1);
	console.log(surveyuser_id);
	if(surveyuser_id.length ===  0){
		layer.confirm('请选择任意选项');
		return false;
	}
	
	layer.confirm('确定要删除吗', {
		  btn: ['是','否'] //按钮
		}, function(){
			$.ajax({
				url:url,
				data:{"surveyuser_id":surveyuser_id,"survey_id":id},
				type:"post",
				datatype:"json",
				success:function(page){
					//jquery局部刷新
					layer.close(layer.index);
					$(".content_1").remove();
					$("#content_2").remove();
					tablepage(page);
					$(".checkTotal").prop("checked",false);
					layer.msg("删除成功");

				}
					
			})
		}, function(){
		   layer.close(layer.index);
		   return false;
		});
	
	

	
}


function  deleteAll(){
	var url=ctx+"/surveyuser/survey-user!deleteAll.action";
	var id=$("#id").val();
	layer.confirm('确定要删除吗', {
		  btn: ['是','否'] //按钮
		}, function(){
			$.ajax({
				url:url,
				data:{"survey_id":id},
				type:"post",
				datatype:"json",
				success:function(page){
					//jquery局部刷新
					layer.close(layer.index);
					$(".content_1").remove();
					$("#content_2").remove();
					tablepage(page);
					$(".checkTotal").prop("checked",false);
					layer.msg("删除成功");
				}
					
			})
		}, function(){
		   layer.close(layer.index);
		   return false;
		});
	
}


//table表格调节


function exportUser(){
	var id=$("#id").val();
	window.location.href=ctx+"/surveyuser/survey-user!exportuser.action?survey_id="+id;
}

function importUser() {
	$('#uploadCsv').val("");
	$('#uploadCsv').click();
}
function uploadFile() {
	var myform = new FormData();
	myform.append('file', $('#uploadCsv')[0].files[0]);
	myform.append('survey_id', $("#id").val());
	$.ajax({
		url: ctx + "/surveyuser/import-user.action",
		type: "post",
		data: myform,
		contentType: false,
		processData: false,
		success: function (result) {
			var resultJson = JSON.parse(result)
			if (!resultJson.success) {
				layer.msg(resultJson.msg);
			} else {
				layer.msg("导入成功");
				//jquery局部刷新
				layer.close(layer.index);
				$(".content_1").remove();
				$("#content_2").remove();
				tablepage(JSON.stringify(resultJson.data));
				$(".checkTotal").prop("checked",false);
			}
		},
		error: function (data) {
			layer.msg(data.responseText);
		}
	});
}





