
var svTag=2;
$(document).ready(function(){
	
	ctx=$("#ctx").val();
	questionBelongId=$("#id").val();
	resetlogicItem();
	
	$(".dwQuDialogAddLogic").click(function(){
		 var obj=$(this);
		addQuDialogLogicTr(obj,true,truecallback,function(){alert("此题已经设置了任意选项!");});
	});
	
    $(".dialogRemoveLogic").unbind();
	$(".dialogRemoveLogic").click(function(){
		var obj=$(this);
		removelogictr(obj);
     })
     
    $("select").change(function(){
    	var select=$(this);
    	var thisclass=select.attr("class");
    	var text=select.val();
    	var parentclass=select.parents("tr").attr("class");
    	changeselected(text,parentclass,thisclass);
    	var surveyQuItemBody=select.parents(".li_surveyQuItemBody");
    	var saveTag=surveyQuItemBody.find("input[name=saveTag]");
    	saveTag.val("0");
    }) 
    
    $("#saveButton").click(function(){
    	var fristQuItemBody=$("#dwSurveyQuContent .li_surveyQuItemBody").first();
    	saveQus(fristQuItemBody,function(){});
    	alert("保存成功");
    })
})

//当table下的option变化时,将对应的隐藏逻辑的save标识变成0,并将对应隐藏域的信息变更
function changeselected(text,parentclass,thisclass){
	
	if(thisclass == "logicQuOptionSel"){
		$("."+parentclass).find("input[name='cgQuItemId']").val(text);
	}else if(thisclass == "logicType"){
		$("."+parentclass).find("input[name='logicType']").val(text);
	}else if(thisclass == "logicQuSel"){
		$("."+parentclass).find("input[name='skQuId']").val(text);
	}else if(thisclass == "logicScoreGtLt"){
		$("."+parentclass).find("input[name='geLe']").val(text);
	}else if(thisclass == "logicScoreNum"){
		$("."+parentclass).find("input[name='scoreNum']").val(text);
	}else{
		
	}
	$("."+parentclass).find("input[name='visibility']").val("1");
	$("."+parentclass).find("input[name='logicSaveTag']").val("0");
	
}

function addlogicItem(quLogicItem,quLogicInputCase,quLogicItemNum,quLogicItemNumval,surveyQuItemBodyobj,newclass,type,lasttr){
	
	//直接添加---
	var qulogicItemhtml=$("#quLogicItemModel").html();
	quLogicInputCase.append(qulogicItemhtml);
	var lastqulogicItem=quLogicInputCase.find(".quLogicItem").last();
	lastqulogicItem.attr("class","quLogicItem "+newclass);
	
	//将tr的值传入lastqulogicItem
    var logicQuOptionSel=lasttr.find(".logicQuOptionSel").val();
    var logicType_tr=lasttr.find(".logicType").val();
    var logicQuSel=lasttr.find(".logicQuSel").val();
    
    var cgQuItemId=lastqulogicItem.find("input[name='cgQuItemId']");cgQuItemId.val(logicQuOptionSel);
    var skQuId=lastqulogicItem.find("input[name='skQuId']");skQuId.val(logicQuSel);
    var logicType=lastqulogicItem.find("input[name='logicType']");logicType.val(logicType_tr);
    
    if(type="SCORE"){
    	
    	var logicScoreGtLt=lasttr.find(".logicScoreGtLt").val();
    	var logicScoreNum=lasttr.find(".logicScoreNum").val();
    	lastqulogicItem.find("input[name='geLe']").val(logicScoreGtLt);
    	lastqulogicItem.find("input[name='scoreNum']").val(logicScoreNum);
    }
    lastqulogicItem.find("input[name='visibility']").val("1");
    
}

function truecallback(surveyQuItemBodyobj,newclass,type,lasttr){
	//这里要看有没有跟添加逻辑相等的逻辑，如果没有就创建逻辑
	var quLogicItem=surveyQuItemBodyobj.find(".quLogicItem");
	var quLogicInputCase=surveyQuItemBodyobj.find(".quLogicInputCase");
	var quLogicItemNum=quLogicInputCase.find("input[name='quLogicItemNum']");
	var quLogicItemNumval=quLogicItemNum.val();
	if(quLogicItem.length == 0){
		 addlogicItem(quLogicItem,quLogicInputCase,quLogicItemNum,quLogicItemNumval,surveyQuItemBodyobj,newclass,type,lasttr);
	}else{
		
		var quLogicItem=surveyQuItemBodyobj.find(".quLogicItem");
		//判断是否存在相同的逻辑,存在就修改
		 var logicQuOptionSel=lasttr.find(".logicQuOptionSel").val();
		 var logicType_tr=lasttr.find(".logicType").val();
		 var logicQuSel=lasttr.find(".logicQuSel").val();
		 var logicScoreGtLt=lasttr.find(".logicScoreGtLt").val();
	     var logicScoreNum=lasttr.find(".logicScoreNum").val();
		 
		 $.each(quLogicItem,function(){
			 var quLogicItemobj=$(this);
			 var cgQuItemId=quLogicItemobj.find("input[name='cgQuItemId']").val();
			 var skQuId=quLogicItemobj.find("input[name='skQuId']").val();
			 var logicType=quLogicItemobj.find("logicType").val();
			 var gele=quLogicItemobj.find("input[name='geLe']").val();
			 var scoreNum=quLogicItemobj.find("input[name='scoreNum']");
			 if(type="SCORE"){
				 if(logicQuOptionSel==cgQuItemId && logicQuSel==skQuId && logicType_tr==logicType && gele==logicScoreGtLt
						 && logicScoreNum == scoreNum){
					 quLogicItemobj.find("input[name='visibility']").val("1");
				 } else{
					 //执行添加代码
					 addlogicItem(quLogicItem,quLogicInputCase,quLogicItemNum,quLogicItemNumval,surveyQuItemBodyobj,newclass,type,lasttr);
				 }
			 }else{
				if(logicQuOptionSel==cgQuItemId && logicQuSel==skQuId && logicType_tr==logicType) {
					quLogicItemobj.find("input[name='visibility']").val("1");
				}else{
					//zhi执行添加代码
					addlogicItem(quLogicItem,quLogicInputCase,quLogicItemNum,quLogicItemNumval,surveyQuItemBodyobj,newclass,type,lasttr);
				}
				 
			 }
			 
		 })
	}
	
	surveyQuItemBodyobj.find("input[name='saveTag']").val("0");
	
}

function resetlogicItem(){
    var surveyQuItemBody=$(".li_surveyQuItemBody");
	
	surveyQuItemBody.each(function(){
		var surveyQuItemBodyobj=$(this);
		
		var quLogicItem=surveyQuItemBodyobj.find(".quLogicItem");
		
		var  quType=surveyQuItemBodyobj.find("input[name='quType']").val();
		
		var dwQuLogicTable=surveyQuItemBodyobj.find(".dwQuLogicTable");
		
		//获得选项信息
		var quItemInputCases=surveyQuItemBodyobj.find(".quItemInputCase");
		
		var quLogicInputCase=surveyQuItemBodyobj.find(".quLogicInputCase");
		
		dwQuLogicTable.html("");
		
		quLogicItem.each(function(){
			var quLogicItemobj=$(this);
			
			//获得id值
			var oldcgQuItemId=quLogicItemobj.find("input[name='cgQuItemId']").val();
			var oldskQuId=quLogicItemobj.find("input[name='skQuId']").val();
			var oldlogicType=quLogicItemobj.find("input[name='logicType']").val();
			
			//获得一个逻辑模板
			var appendTrHtml=$("#setQuLogicItemTrModel").html();
			//如果是分数题的话获得另一个模板
			if(quType==="SCORE"){
				appendTrHtml=$("#setQuLogicItemTrModel_score").html();
			}

			dwQuLogicTable.append("<tr>"+appendTrHtml+"</tr>");
			
			//获得最后一个tr赋值
			var lastTr=dwQuLogicTable.find("tr").last();
			
			//这里给tr添加class
			var trclass=quLogicItemobj.attr("class").replace("quLogicItem ","");
			lastTr.attr("class",trclass);
			
			if(quType==="FILLBLANK"){
				lastTr.find(".ifSpanText1").text("如果回答");
			}
			
			//让这个tr的class和当前的quLogicItem一致 先不加
			//给tr赋值的js
			
			//选择的
			var dwQuOptionSel=lastTr.find(".logicQuOptionSel");
		   
			var eachTag=true;
			//说明是多项选择题有行和列的概念
			//给逻辑起始赋值
			if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
				
				var quChenColumnTds=surveyQuItemBodyobj.find(".quChenColumnTd");
				var quChenRowTds=surveyQuItemBodyobj.find(".quChenRowTd");
				
				$.each(quChenRowTds,function(){
					var rowText=$(this).find(".quCoOptionEdit").text();
				    var rowQuItemId=$(this).find("input[name='quItemId']").val();
				    $.each(quChenColumnTds,function(){
				        var colText=$(this).find(".quCoOptionEdit").text();
						var colQuItemId=$(this).find("input[name='quItemId']").val();
						var optionId=rowQuItemId+":"+colQuItemId;
						if(oldcgQuItemId==optionId){
							dwQuOptionSel.append("<option value='"+optionId+"' selected>"+rowText+":"+colText+"</option>");	
						}else{
							dwQuOptionSel.append("<option value='"+optionId+"'>"+rowText+":"+colText+"</option>");	
						}
				    })
				})
				
			}else{
				$.each(quItemInputCases,function(){
					var optionText=$(this).parent().find("label.quCoOptionEdit").text();
					var optionId=$(this).find("input[name='quItemId']").val();	
					if(oldcgQuItemId==optionId){
						dwQuOptionSel.append("<option value='"+optionId+"' selected>"+optionText+"</option>");
					}else{
						dwQuOptionSel.append("<option value='"+optionId+"' >"+optionText+"</option>");
					}
				})
			}
			
			if(quItemInputCases.size()==0){
				dwQuOptionSel.append("<option value='0'>任意选项</option>");	
			}else{
				$("#dwQuLogicTable").find(".logicQuOptionSel option[value='0']").remove();
			}
			if(quType==="FILLBLANK"){
				dwQuOptionSel.val("0");
			}	
			
		//给逻辑终止赋值
			var logicQuSel=lastTr.find(".logicQuSel");
			var quItemBodys=$("#dwSurveyQuContent .surveyQuItemBody");
			$.each(quItemBodys,function(){
				if($(this).find(".quCoTitleEdit")[0]){
				var quCoNumText=$(this).find(".quCoNum").text();
				var quTitleText=$(this).find(".quCoTitleEdit").text();
				var quId=$(this).find("input[name='quId']").val();
				if(oldskQuId==quId){
					logicQuSel.append("<option value='"+quId+"' selected>"+quCoNumText+quTitleText+"</option>");	
				}else{
					logicQuSel.append("<option value='"+quId+"' >"+quCoNumText+quTitleText+"</option>");	
				}
				}
			})
			
			if(quType==="SCORE"){
				var oldscore=quLogicItemobj.find("input[name='scoreNum']").val();
				
				var logicScoreNum=lastTr.find(".logicScoreNum");
				logicScoreNum.empty();
				for(var i=1;i<=10;i++){
					if(oldscore == i){
						logicScoreNum.append("<option value=\""+i+"\" selected>"+i+"</option>");
					}else{
						logicScoreNum.append("<option value=\""+i+"\">"+i+"</option>");
					}
					
			 }
	          var  oldgeLe=quLogicItemobj.find("input[name='geLe']").val();
	          
	          var  logicgete=lastTr.find(".logicScoreGtLt");
	          var  logicgeteoption =logicgete.find("option");
	          $.each(logicgeteoption,function(){
	        	  var logicgeteoptionobj=$(this);
	        	  if(oldgeLe == logicgeteoptionobj.val()){
	        		  logicgeteoptionobj.prop("selected",true);
	        	  }
	          })
	          
			}else if(quType==="ORDERQU"){
				dwQuOptionSel.empty();
				dwQuOptionSel.append("<option value='0'>回答完成</option>");
				lastTr.find(".ifSpanText1").text("如果本题");
			}
		  //添加跳转的逻辑	
			var logicTypeOption=lastTr.find(".logicType").find("option");
			logicTypeOption.prop({"selected":false});
			$.each(logicTypeOption,function(){
				
				var value=$(this).val();
				if(value == oldlogicType){
					$(this).attr({"selected":"selected"})
				}
			})
			
			//table 添加模板
			
			
		})
		
		
	})
	
}

function removelogictr(obj){
	var trclass=obj.parents("tr").attr("class");
	
	//将保存逻辑变成空
	$("."+trclass).has("input[name='visibility']").find("input[name='visibility']").val("0");
	$("."+trclass).has("input[name='visibility']").find("input[name='logicSaveTag']").val("0");
	$("."+trclass).has("input[name='visibility']").parents(".li_surveyQuItemBody").find("input[name='saveTag']").val("0");
	$("."+trclass).has("td").remove();

	//这里需要将对应的logic的visibility变成0 -- 假删除
	
}


//添加还没有的逻辑
function addQuDialogLogicTr(obj,autoClass,truecallback,falseCallback){
	
	var surveyQuItemBodyobj=obj.parents(".li_surveyQuItemBody");
	
	var dwQuLogicTable=surveyQuItemBodyobj.find(".dwQuLogicTable");
	
	var  quType=surveyQuItemBodyobj.find("input[name='quType']").val();
	//找到table在当前table下装tr tr的选项起始或者选项终止不重复
	var quItemInputCases=surveyQuItemBodyobj.find(".quItemInputCase");
	var dwQuLogicTable=surveyQuItemBodyobj.find(".dwQuLogicTable");
	var logicQuOptionSel=dwQuLogicTable.find("tr").find(".logicQuOptionSel");
	var dwLogicQuSels=dwQuLogicTable.find(".logicQuSel");
	var quLogicItemNum=surveyQuItemBodyobj.find("input[name='quLogicItemNum']");
		//给逻辑起始赋值
		var appendTrHtml=$("#setQuLogicItemTrModel").html();
		//如果是分数题的话获得另一个模板
		if(quType==="SCORE"){
			appendTrHtml=$("#setQuLogicItemTrModel_score").html();
		}

		dwQuLogicTable.append("<tr>"+appendTrHtml+"</tr>");
		
		var lastTr=dwQuLogicTable.find("tr").last();
		var newQuLogicItemClass=""
		//更新tr的class，并更新逻辑的数量值
		if(autoClass){
			var newQuLogicItemNum=(parseInt(quLogicItemNum.val())+1);
			quLogicItemNum.val(newQuLogicItemNum);
			newQuLogicItemClass="quLogicItem_"+newQuLogicItemNum;
			//最后加入
			lastTr.attr("class",newQuLogicItemClass);
		}
		
		
		
		lastTr.find(".dialogRemoveLogic").unbind();
		lastTr.on("click",".dialogRemoveLogic",function(){
			var obj=$(this);
			removelogictr(obj);
		})
		
		if(logicQuOptionSel.length == 0){
			
		}
		
		//逻辑起始添加
		var dwQuOptionSel=lastTr.find(".logicQuOptionSel");
		if(quType==="CHENRADIO" || quType==="CHENCHECKBOX" || quType==="CHENSCORE" || quType==="CHENFBK"){
			
			
			var quChenColumnTds=surveyQuItemBodyobj.find(".quChenColumnTd");
			var quChenRowTds=surveyQuItemBodyobj.find(".quChenRowTd");
			
			$.each(quChenRowTds,function(){
				
				var rowText=$(this).find(".quCoOptionEdit").text();
			    var rowQuItemId=$(this).find("input[name='quItemId']").val();
			    $.each(quChenColumnTds,function(){
			        var colText=$(this).find(".quCoOptionEdit").text();
					var colQuItemId=$(this).find("input[name='quItemId']").val();
					var optionId=rowQuItemId+":"+colQuItemId;
					if(logicQuOptionSel.length == 0){
						dwQuOptionSel.append("<option value='"+optionId+"' >"+rowText+colText+"</option>");
					}else{
						var tag=true
						logicQuOptionSel.each(function(){
							var logicQuOptionSelobj=$(this);
							if($(this).val() == optionId){
							    tag=false;
							    return false;
							}
						})
						
						if(tag){
							dwQuOptionSel.append("<option value='"+optionId+"' >"+rowText+colText+"</option>");
						}
						
					}
			    })
			})
		}else{
			$.each(quItemInputCases,function(){
				var optionText=$(this).parent().find("label.quCoOptionEdit").text();
				var optionId=$(this).find("input[name='quItemId']").val();	
				
				if(logicQuOptionSel.length == 0){
					dwQuOptionSel.append("<option value='"+optionId+"' >"+optionText+"</option>");
				}else{
					var tag=true
					logicQuOptionSel.each(function(){
						var logicQuOptionSelobj=$(this);
						if($(this).val() == optionId){
						    tag=false;
						    return false;
						}
					})
					
					if(tag){
						dwQuOptionSel.append("<option value='"+optionId+"' >"+optionText+"</option>");
					}
				}
				
			})
		}
		
		if(logicQuOptionSel.size()==0){
			dwQuOptionSel.append("<option value='0'>任意选项</option>");	
		}else{
			$("#dwQuLogicTable").find(".logicQuOptionSel option[value='0']").remove();
		}
		if(quType==="FILLBLANK"){
			dwQuOptionSel.val("0");
		}
		//逻辑结束添加
		var logicQuSel=lastTr.find(".logicQuSel");
		var quItemBodys=$("#dwSurveyQuContent .surveyQuItemBody");
		$.each(quItemBodys,function(){
			if($(this).find(".quCoTitleEdit")[0]){
			var quCoNumText=$(this).find(".quCoNum").text();
			var quTitleText=$(this).find(".quCoTitleEdit").text();
			var quId=$(this).find("input[name='quId']").val();
			if(dwLogicQuSels.length==0){
				logicQuSel.append("<option value='"+quId+"'>"+quCoNumText+quTitleText+"</option>");
			}else{
				var tag=true
				dwLogicQuSels.each(function(){
					if($(this).val() == quId ){
						tag=false;
						return false;
					}
					
				})
				if(tag){
					logicQuSel.append("<option value='"+quId+"'>"+quCoNumText+quTitleText+"</option>");
				}
			}
			}
		})
		
		
		if(quType==="SCORE"){
		var logicScoreNum=lastTr.find(".logicScoreNum");
			logicScoreNum.empty();
			for(var i=1;i<=10;i++){
			  logicScoreNum.append("<option value=\""+i+"\" >"+i+"</option>");		
		 }
          
		}else if(quType==="ORDERQU"){
			dwQuOptionSel.empty();
			dwQuOptionSel.append("<option value='0'>回答完成</option>");
			lastTr.find(".ifSpanText1").text("如果本题");
		}
	  //添加跳转的逻辑
		
	//对应题目添加逻辑
   truecallback(surveyQuItemBodyobj,newQuLogicItemClass,quType,lastTr);
   
   //给所有新增的select绑定事件
   lastTr.find("select").on("change",$(this),function(){
	    var select=$(this);
    	var thisclass=select.attr("class");
    	var text=select.val();
    	var parentclass=select.parents("tr").attr("class");
    	changeselected(text,parentclass,thisclass);
   })
	
}

//逻辑设置时添加逻辑项

//逻辑存储的js
function saveQus(quItemBody,callback){
	if(quItemBody[0]){
		var quType=quItemBody.find("input[name='quType']").val();
		if(quType=="RADIO"){
			//保存单选
			saveRadio(quItemBody,callback);
		}else if(quType=="CHECKBOX"){
			saveCheckbox(quItemBody, callback);
		}else if(quType=="FILLBLANK"){
			saveFillblank(quItemBody, callback);
		}else if(quType=="SCORE"){
			saveScore(quItemBody, callback);
		}else if(quType=="ORDERQU"){
			saveOrderqu(quItemBody, callback);
		}else if(quType=="PAGETAG"){
			savePagetag(quItemBody, callback);
		}else if(quType=="PARAGRAPH"){
			saveParagraph(quItemBody, callback);
		}else if(quType=="MULTIFILLBLANK"){
			saveMultiFillblank(quItemBody, callback);
		}else if(quType=="CHENRADIO" || quType=="CHENCHECKBOX" || quType=="CHENFBK" || quType=="CHENSCORE"){
			saveChen(quItemBody, callback);
		}else{
			callback();
		}
	}else{
		callback();
	}
}


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

		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&contactsAttr="+contactsAttr+"&contactsField="+contactsField;

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
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});

					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var contactsAttr=quItemBody.find("input[name='contactsAttr']").val();
		var contactsField=quItemBody.find("input[name='contactsField']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&contactsAttr="+contactsAttr+"&contactsField="+contactsField;
		
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
			
			//设置逻辑的id
			var quLogicId=$(this).find("input[name='quLogicId']").val();
			
			//设置选择的选型id
			var cgQuItemId=$(this).find("input[name='cgQuItemId']").val();
			
			
			//要跳转的题的ID
			var skQuId=$(this).find("input[name='skQuId']").val();
			
			//是否需要保存的标识
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			
			//是否显示的标识
			var visibility=$(this).find("input[name='visibility']").val();
			
			//是跳转还是显示的标识
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
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&paramInt01="+paramInt01+"&paramInt02="+paramInt02;
		
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
			var skQuId=$(this).find("input[name='skQuId']").val();
			var logicSaveTag=$(this).find("input[name='logicSaveTag']").val();
			var visibility=$(this).find("input[name='visibility']").val();
			
			var geLe=$(this).find("input[name='geLe']").val();
			var scoreNum=$(this).find("input[name='scoreNum']").val();
			var logicType=$(this).find("input[name='logicType']").val();
			
			var itemIndex=thClass;
			if(logicSaveTag==0){
				data+="&quLogicId_"+itemIndex+"="+quLogicId;
				data+="&cgQuItemId_"+itemIndex+"="+cgQuItemId;
				data+="&skQuId_"+itemIndex+"="+skQuId;
				data+="&visibility_"+itemIndex+"="+visibility;
				data+="&geLe_"+itemIndex+"="+geLe;
				data+="&scoreNum_"+itemIndex+"="+scoreNum;
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
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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
		var randOrder=quItemBody.find("input[name='randOrder']").val();
		var cellCount=quItemBody.find("input[name='cellCount']").val();
		var paramInt01=quItemBody.find("input[name='paramInt01']").val();
		var paramInt02=quItemBody.find("input[name='paramInt02']").val();
		
		var data="belongId="+questionBelongId+"&orderById="+orderById+"&tag="+svTag+"&quType="+quType+"&quId="+quId;
		data+="&isRequired="+isRequired+"&hv="+hv+"&randOrder="+randOrder+"&cellCount="+cellCount;
		data+="&paramInt01="+paramInt01+"&paramInt02="+paramInt02;
		
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
					var quItems=jsons.quItems;
					$.each(quItems,function(i,item){
						var quItemOption=quItemBody.find(".quOption_"+item.title);
						quItemOption.find("input[name='quItemId']").val(item.id);
						quItemOption.find(".quItemInputCase input[name='quItemSaveTag']").val(1);
					});
					
					//同步logic Id信息
					var quLogics=jsons.quLogics;
					$.each(quLogics,function(i,item){
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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

/** 矩阵单选题 **/
/**
** 新保存矩阵单选题
**/
function saveChen(quItemBody,callback){
	var saveTag=quItemBody.find("input[name='saveTag']").val();
	if(saveTag==0){
		var url=ctx+"/design/qu-chen!ajaxSave.action";
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
						var logicItem=quItemBody.find(".quLogicItem_"+item.title);
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