package com.key.common.utils;


import java.io.*;
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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;


public class ExclesUtils {

	private final static String xls = "xls";
	private final static String xlsx = "xlsx";

	public static List<String[]> readExcel(File file) throws IOException{
		//获得Workbook工作薄对象
		Workbook workbook = getWorkBook(file);
		//创建返回对象，把每行中的值作为一个数组，所有行作为一个集合返回
		List<String[]> list = new ArrayList<String[]>();
		if(workbook != null){
			for(int sheetNum = 0;sheetNum < workbook.getNumberOfSheets();sheetNum++){
				//获得当前sheet工作表
				Sheet sheet = workbook.getSheetAt(sheetNum);
				if(sheet == null){
					continue;
				}
				//获得当前sheet的开始行
				int firstRowNum  = sheet.getFirstRowNum();
				//获得当前sheet的结束行
				int lastRowNum = sheet.getLastRowNum();
				//循环除了第一行的所有行
				for(int rowNum = firstRowNum+1;rowNum <= lastRowNum;rowNum++){
					//获得当前行
					Row row = sheet.getRow(rowNum);
					if(row == null){
						continue;
					}
					//获得当前行的开始列
					int firstCellNum = row.getFirstCellNum();
					//获得当前行的列数
					int lastCellNum = row.getPhysicalNumberOfCells();
					String[] cells = new String[row.getPhysicalNumberOfCells()];
					//循环当前行
					for(int cellNum = firstCellNum; cellNum < lastCellNum;cellNum++){
						Cell cell = row.getCell(cellNum);
						cells[cellNum] = getCellValue(cell);
					}
					list.add(cells);
				}
			}
		}
		return list;
	}

	public static Workbook getWorkBook(File file) {
		//获得文件名
		String fileName = file.getName();
		//创建Workbook工作薄对象，表示整个excel
		Workbook workbook = null;
		try {
			//获取excel文件的io流
			InputStream is = new FileInputStream(file);
			//根据文件后缀名不同(xls和xlsx)获得不同的Workbook实现类对象
			workbook = new HSSFWorkbook(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return workbook;
	}
	public static String getCellValue(Cell cell){
		String cellValue = "";
		if(cell == null){
			return cellValue;
		}
		//把数字当成String来读，避免出现1读成1.0的情况
		if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC){
			cell.setCellType(Cell.CELL_TYPE_STRING);
		}
		//判断数据的类型
		switch (cell.getCellType()){
			case Cell.CELL_TYPE_NUMERIC: //数字
				cellValue = String.valueOf(cell.getNumericCellValue());
				break;
			case Cell.CELL_TYPE_STRING: //字符串
				cellValue = String.valueOf(cell.getStringCellValue());
				break;
			case Cell.CELL_TYPE_BOOLEAN: //Boolean
				cellValue = String.valueOf(cell.getBooleanCellValue());
				break;
			case Cell.CELL_TYPE_FORMULA: //公式
				cellValue = String.valueOf(cell.getCellFormula());
				break;
			case Cell.CELL_TYPE_BLANK: //空值
				cellValue = "";
				break;
			case Cell.CELL_TYPE_ERROR: //故障
				cellValue = "非法字符";
				break;
			default:
				cellValue = "未知类型";
				break;
		}
		return cellValue;
	}

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
