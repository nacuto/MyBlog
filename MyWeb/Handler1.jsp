<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%@ page import="java.io.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>

<%
response.setHeader("Cache-Control","no-cache"); 
response.setHeader("Pragma","no-cache"); 
response.setDateHeader ("Expires", -1); 
%>
<%
	request.setCharacterEncoding("utf-8");
	String msg = "";
	String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
                        + "?autoReconnect=true&useUnicode=true"
                        + "&characterEncoding=UTF-8&&useSSL=false";
    Class.forName("com.mysql.jdbc.Driver");
    Connection con=DriverManager.getConnection(connectString, "user", "123");
	    Statement stmt=con.createStatement();

    String mode= request.getParameter("mode");					//修改还是新增
    String user_name = request.getParameter("userId");			//用户名
	String article_id = request.getParameter("articleId");		//文章ID
	String title = request.getParameter("title");				//标题
	String content = request.getParameter("content");			//内容
	String belong = request.getParameter("article_type");		//类别
	/*
	Date date=new Date(); 
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String current_time=formatter.format(date); 				//修改时间
	*/
	java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");    
    java.util.Date currentTime = new java.util.Date();    
    String current_time = simpleDateFormat.format(currentTime).toString();
    
	//String current_time="unknow";
	switch(belong){
		case "1":belong = "学习";break;
		case "2":belong = "随笔";break;
		case "3":belong = "科普";break;
		case "4":belong = "美食";break;
	}
	out.println(mode);out.println("</br>");
	out.println(user_name);out.println("</br>");
	out.println(article_id);out.println("</br>");
	out.println(title);out.println("</br>");
	out.println(content);out.println("</br>");
	out.println(belong);out.println("</br>");

	if(mode.equals("1")){
		try{
			String fmt="insert into article(userId,content,count,Time,belong,title,love_count) values('%s','%s','%d','%s','%s', '%s','%d')";
			String sql = String.format(fmt,user_name,content,0,current_time,belong,title,0);
			int cnt = stmt.executeUpdate(sql);
			if(cnt>0)msg = "保存成功!";
			sql = "select * from article where userId =\'" + user_name +"\' and title=\'" +title+"\' and Time=\'" +current_time+"\'";
			ResultSet rs=stmt.executeQuery(sql);
			while(rs.next()){
				article_id = rs.getString("articleId");
			}
			out.println(article_id);
			stmt.close();
			con.close();
		}catch(Exception e){
			msg = e.getMessage();
		}
	}
	//out.println(mode);
	if(mode.equals("2")){
		String update = "UPDATE article SET content=\'"+ content +"\', title=\'" +title + "\', Time=\'" +current_time +"\', belong=\'" +belong +"\' WHERE articleId=" + article_id;
		//out.println(update);
		try{
			int cnt = stmt.executeUpdate(update);
			if(cnt>0) msg = "修改成功!";
			stmt.close();
			con.close();
		}catch(Exception e){
			msg = e.getMessage();
		}
	}
	response.sendRedirect("report.jsp?userId="+user_name+"&articleId="+article_id+""); 
%>