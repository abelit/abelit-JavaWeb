<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>  
<!DOCTYPE html> 
<html>   
    <head>   
    <title>连接oracle11g的测试页面</title>   
    </head>   
  <body>   
  	
  	<%! 
  		//声明一个共享连接对象
  		Connection conn = null; 
  	%>
    <%  
    	Statement stmt = null;
    	ResultSet rs = null;
    	
    	String url="jdbc:oracle:thin:@172.28.1.221:1521:gzgszxk1";   
        String user="abelit";   
        String password="cy123"; 
        
        String sql="select * from all_users order by username";
        
        //第一个用户负责建立连接
    	if (conn == null) {
    		try{  
                Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();  
                
                conn = DriverManager.getConnection(url,user,password);
                
                stmt = conn.createStatement();  
                rs = stmt.executeQuery(sql);   
				
                out.print("Connect to Oracle firstly.");
                out.print("Current User: "+conn.getSchema());
                out.print("<br />");
                /* 
                rs.close();   
                stmt.close();   
                conn.close();
                */
            }catch(SQLException e){  
                out.print(e.getMessage());  
            }  
    	} else {
    		//后面的用户通过共享模块操作数据库
    		synchronized(conn) {
    			try {
    				stmt = conn.createStatement(); 
                    rs = stmt.executeQuery(sql); 
                    
                    out.print("Using Oracle by connection which exists.");
                    out.print("Current User: "+conn.getSchema());
                    out.print("<br />");
    			} catch(SQLException e) {
    				out.print(e.getMessage());
    			}
    		}
    	}
        out.print("<Table Border>");
    	out.print("<TR>");
		out.print("<TH width=20>"+"ID");
		out.print("<TH width=50>"+"NAME");
		out.print("</TR>");
    	
    	while(rs.next())   
        { 
    		out.print("<TR>");
    		out.print("<TD>");
            out.print(rs.getString(2));
            out.print("</TD>");
            out.print("<TD>");
            out.print(rs.getString(1));
            out.print("</TD>");
            out.print("</TR>");
        }  
        
    %>   
      
  </body>   
</html> 