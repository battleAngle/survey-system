package com.key.dwsurvey.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.pdf.hyphenation.TernaryTree.Iterator;
import com.key.dwsurvey.service.SurveyDirectoryManager;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.struts2.convention.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;

import com.key.common.base.action.CrudActionSupport;
import com.key.common.base.entity.User;
import com.key.common.base.service.AccountManager;
import com.key.common.utils.web.Struts2Utils;
import com.key.dwsurvey.entity.SurveyDirectory;

/**
 * 我的问卷 action
 * @author KeYuan(keyuan258@gmail.com)
 *
 * https://github.com/wkeyuan/DWSurvey
 * http://dwsurvey.net
 *
 */
@Namespace("/design")
@InterceptorRefs({ @InterceptorRef("paramsPrepareParamsStack")})
@Results({
    @Result(name=MySurveyAction.SUCCESS,location="/WEB-INF/page/content/diaowen-design/list.jsp",type=Struts2Utils.DISPATCHER),
    @Result(name="design",location="/design/my-survey-design.action?surveyId=${id}",type=Struts2Utils.REDIRECT),
})
@AllowedMethods({"surveyState","attrs","exportsurvey","tonewSurvey"})
public class MySurveyAction extends CrudActionSupport<SurveyDirectory, String>{
	
	@Autowired
	private SurveyDirectoryManager surveyDirectoryManager;
	@Autowired
	private AccountManager accountManager;

	@Override
	public String list() throws Exception {
		HttpServletRequest request=Struts2Utils.getRequest();
		String surveyState = request.getParameter("surveyState");
		String surveyName_param = request.getParameter("surveyName");
		if(surveyState==null||"".equals(surveyState)){
			entity.setSurveyState(null);
		}
		
		if(surveyName_param == null || "".equals(surveyName_param)){
			entity.setSurveyName(null);
		}
	    page=surveyDirectoryManager.findByUser(page,entity);
	    List<SurveyDirectory> SurveyDirectorys=page.getResult();
	    Pattern pattern=Pattern.compile("<\\/?.+?\\/?>");
	    //判断时间是否过期
	    for(SurveyDirectory surveyDirectory : SurveyDirectorys){
	    	
	    	/*if(surveyDirectory.getSurveyDetail().getEndTime() != null){
	    		
	    		if(surveyDirectory.getSurveyDetail().getEndTime().before(new Date())){
	    			surveyDirectoryManager.save(surveyDirectory);
	    		}
	    	}*/
	    	
	       if(surveyDirectory.getSurveyDetail() != null){
	    	   if(surveyDirectory.getSurveyDetail().getEndTime() != null){
	    		   if(surveyDirectory.getSurveyDetail().getEndTime().before(new Date())){
		    			surveyDirectoryManager.save(surveyDirectory);
		    		} 
	    	   }
	       }
	    }
	    
	    
	    //去掉名称的样式   -- 解决html标签也会被选出来的问题
	    for (SurveyDirectory surveyDirectory : SurveyDirectorys) {
	    	String surveyName=surveyDirectory.getSurveyName();
			Matcher match=pattern.matcher(surveyName);
			surveyName=match.replaceAll("");
			surveyDirectory.setSurveyName(surveyName);
			
		}
	    java.util.Iterator<SurveyDirectory> it = SurveyDirectorys.iterator();
	    while(it.hasNext()){
	    	SurveyDirectory  s=it.next();
	    	String sname=s.getSurveyName();
	    	if(!sname.contains(entity.getSurveyName() == null ? "" : entity.getSurveyName())){
	    		it.remove();
	    	}
	    	
	    }
	    page.setResult(SurveyDirectorys);
	    return SUCCESS;
	}
	
	public String delete() throws Exception {
	    HttpServletResponse response=Struts2Utils.getResponse();
	    String result="false";
	    try{
		User user = accountManager.getCurUser();
		if(user!=null){
		    String userId=user.getId();
		    SurveyDirectory surveyDirectory=surveyDirectoryManager.getSurveyByUser(id,userId);
		    if(surveyDirectory!=null){
		    	surveyDirectoryManager.delete(id);
		    	result="true";
		    }
		}
	    }catch (Exception e) {
			result="false";
	    }
	    response.getWriter().write(result);
	    return null;
	}
	
	//问卷壮态设置
	public String surveyState() throws Exception{
		HttpServletResponse resp=Struts2Utils.getResponse();
		String result="";
		try{
			User user= accountManager.getCurUser();
			if(user!=null){
				String userId=user.getId();
				SurveyDirectory surveyDirectory=surveyDirectoryManager.getSurveyByUser(id, userId);
				if(surveyDirectory!=null){
					int surveyState=entity.getSurveyState();
					surveyDirectory.setSurveyState(surveyState);
				}
			}
			result="true";
		}catch(Exception e){
			e.printStackTrace();
			result="error";
		}
		resp.getWriter().write(result);
		return null;
	}
	


	public String attrs() throws Exception {
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		try{
			SurveyDirectory survey=surveyDirectoryManager.getSurvey(id);
			JsonConfig cfg = new JsonConfig();
			cfg.setExcludes(new String[]{"handler","hibernateLazyInitializer"});
			JSONObject jsonObject=JSONObject.fromObject(survey,cfg);
			response.getWriter().write(jsonObject.toString());
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	public String exportsurvey() throws Exception{
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		
		try{
			
			SurveyDirectory survey=surveyDirectoryManager.getSurvey(id);
			String contextPath=request.getContextPath().replace("/", File.separator);
			String savePath = request.getSession().getServletContext().getRealPath("/").replace(contextPath,"");
			System.out.println(savePath);
			savePath=exportpath(savePath,survey);
			response.setHeader("content-disposition", "attachment;filename="+URLEncoder.encode(request.getContextPath()+savePath,"UTF-8"));
			response.sendRedirect(savePath);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return null;
	}
	
	public String tonewSurvey() throws Exception{
		HttpServletRequest request=Struts2Utils.getRequest();
		HttpServletResponse response=Struts2Utils.getResponse();
		String basepath = "export";
		String urlPath = "/file/" + basepath + "/";// 下载所用的地址
		String path = urlPath.replace("/", File.separator);// 文件系统路径
		String filename=request.getParameter("filename");
		String contextPath=request.getContextPath().replace("/", File.separator);
		String savePath = request.getSession().getServletContext().getRealPath("/").replace(contextPath, "");
		
		savePath = savePath + path;
		File file = new File(savePath);
		if (!file.exists()){file.mkdirs();};
		savePath=savePath+filename;
		File file2=new File(savePath);
		if(file2.exists()){
			FileInputStream fileio=new FileInputStream(file2);
			ObjectInputStream ioin=new ObjectInputStream(fileio);
			Object obj=null;  
			SurveyDirectory surveyDirectory=null;
			if((obj=ioin.readObject())!=null){
				 surveyDirectory=(SurveyDirectory) obj;
				 response.getWriter().write(surveyDirectory.getId()); 
				 ioin.close();
			 }
		}else{
			response.getWriter().write("error"); 
		}
	
		 return null;
	}
	
	public String exportpath(String savepath,SurveyDirectory surveyDirectory) throws Exception{
		String basepath = "export";
		String urlPath = "/file/" + basepath + "/";// 下载所用的地址
		String path = urlPath.replace("/", File.separator);// 文件系统路径
		String filename=UUID.randomUUID().toString().replace("-", "")+".txt";
		savepath = savepath + path;
		File file = new File(savepath);
		if (!file.exists()){file.mkdirs();};
		savepath=savepath+filename;
		File file2=new File(savepath);
		FileOutputStream fileio=new FileOutputStream(savepath);
		ObjectOutputStream  outio=new ObjectOutputStream(fileio);
		outio.writeObject(surveyDirectory);
		outio.writeObject(null);
		fileio.close();
		outio.close();
        
		return  urlPath+filename;
	}
	
	
	@Override
	protected void prepareModel() throws Exception {
		entity=surveyDirectoryManager.getModel(id);
	}
	
	public void prepareSurveyState() throws Exception {
		prepareModel();
	}

	public void prepareExecute() throws Exception {
		prepareModel();
	}
	
}
