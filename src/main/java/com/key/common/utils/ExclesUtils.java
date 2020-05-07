package com.key.common.utils;


import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;


public class ExclesUtils {
	public static void saveExcles(List<ArrayList<Object[]>> dataLists,HttpServletResponse res,String[] rowName,Date startDate,Date endDate){
		try { 
			OutputStream os = res.getOutputStream();
			// 导出到excel
			String fileName = "人员导出("+DateUtils.chineseFormat.format(new Date())+").xls";
			HSSFWorkbook wb = new HSSFWorkbook();
			int index = dataLists.size();
			for(int k=0;k<index;k++){
				ArrayList<Object[]> dataList = dataLists.get(k);
				String sheetName = null;
				if(startDate !=null && endDate !=null){
					sheetName = "日志导出("+DateUtils.chineseFormat.format(new Date())+"-"+DateUtils.chineseFormat.format(new Date())+")-"+(k+1)+".xls";	
				}else{
					sheetName = "日志导出"+"-"+(k+1)+".xls";
				}
				HSSFSheet sheet = wb.createSheet(sheetName);
				sheet.setColumnWidth(0,10000);
				sheet.setColumnWidth(1,5000);
				sheet.setColumnWidth(2,5000);
		        sheet.setColumnWidth(3,42300); 
		        sheet.setColumnWidth(4,5000);
		        sheet.setColumnWidth(5,5000);
		    	HSSFCellStyle cellStyle = wb.createCellStyle();
				// 设置这些样式
				cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
				cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
				cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
				cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
				cellStyle.setWrapText(true);
				
				
				HSSFCellStyle headStyle = wb.createCellStyle();
				headStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
				headStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
				headStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
				headStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
				headStyle.setWrapText(true);
		        HSSFFont font=wb.createFont();
		        font.setFontHeightInPoints((short)14);
		        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		        headStyle.setFont(font);
	            // 构建标题
				HSSFRow headRow=sheet.createRow(0);
				headRow.setHeight((short) 500); 
	            for(int i=0;i<rowName.length;i++){
	            	HSSFCell cell=headRow.createCell(i);
	                cell.setCellStyle(headStyle);
	                cell.setCellValue(rowName[i].toString());
	            }
	            if (dataList!= null ){
	                for( int i=0;i<dataList.size();i++){
	                    Object[] obj = dataList.get(i);//遍历每个对象
	                    HSSFRow bodyRow = sheet.createRow(i+1);
	                    for(int j=0;j<obj.length;j++){
	                    	HSSFCell cell= bodyRow.createCell(j);
	                        cell.setCellStyle(cellStyle);
	                        if( !"".equals(obj[j]) && obj[j]!=null) {
	                            cell.setCellValue(obj[j].toString());
	                        }
	                    }
	                }
	            }
			}
			res.setContentType("application/msexcel;charset=UTF-8");
			//res.setHeader("Content-Disposition", "attachment;filename="  + new String(fileName.getBytes(),"iso-8859-1"));  
			res.addHeader("Content-Disposition", "attachment;filename=\"" + new String((fileName).getBytes("GBK"),"ISO8859_1") + "\"");
			wb.write(os);
			os.close();
			if (os != null) {
				try {
					os.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
     }catch(Exception e ){
    	 e.printStackTrace();
      }
	   System.out.println("Excel文件生成成功..."); 
   }

}
