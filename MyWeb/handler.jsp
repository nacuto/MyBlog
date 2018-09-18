<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%@ page import="java.io.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%
    request.setCharacterEncoding("utf-8");
    String mode=request.getParameter("mode");
    if(mode==null){
        mode="1";
    }
    String articleId=request.getParameter("articleId");
    String user_name = request.getParameter("user_name");
    if(user_name!=null){
        user_name = java.net.URLDecoder.decode(user_name,"utf-8");
    }
    String picture="";//头像是否存在
    String name="";//博客名
    String new_name;//新的博客名

    String sql = "";//数据库查询语句
    //这里连接数据库
    String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
                            + "?autoReconnect=true&useUnicode=true"
                            + "&characterEncoding=UTF-8&&useSSL=false"; 
    Class.forName("com.mysql.jdbc.Driver");
    Connection con=DriverManager.getConnection(connectString, "user", "123");
    Statement stmt=con.createStatement();
    //处理修改了个人信息的数据
    //修改了头像提交的
    if(ServletFileUpload.isMultipartContent(request)){
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List items = upload.parseRequest(request);
        for(int i = 0; i < items.size(); i++) {
            FileItem fi = (FileItem) items.get(i);
            if(fi.isFormField()) {
                if(i==0) user_name = fi.getString("utf-8");
            }
            else{
                DiskFileItem dfi = (DiskFileItem) fi;
                if(!dfi.getName().trim().equals("")) {
                    String extension = FilenameUtils.getExtension(dfi.getName());
                    String fileName=application.getRealPath("/files")
                                + System.getProperty("file.separator")
                                + user_name+".jpg";
                    dfi.write(new File(fileName));
                }//if
            } //if
        } //for
        sql = "update user set picture ='1' where userId ='"+user_name+"'";
        stmt.executeUpdate(sql);
        stmt.close();
    	con.close();
        response.sendRedirect("home.jsp?mode=1&user_name="+user_name);
    }else if(mode.equals("3")&&request.getMethod().equalsIgnoreCase("post")){ //修改博客名
        new_name = request.getParameter("new_name");
        sql = "update user set nickname ='"+new_name+"' where userId ='"+user_name+"'";
        stmt.executeUpdate(sql);
        stmt.close();
    	con.close();
        response.sendRedirect("home.jsp?mode=1&user_name="+user_name);
    }else if (mode.equals("-2")) {
    	sql = "delete from comment where articleId = '"+articleId+"'";
    	stmt.executeUpdate(sql);
    	sql = "delete from love where articleId = '"+articleId+"'";
    	stmt.executeUpdate(sql);
    	sql = "delete from article where articleId = '"+articleId+"'";
    	stmt.executeUpdate(sql);
    	stmt.close();
    	con.close();
        response.sendRedirect("home.jsp?mode=1&user_name="+user_name);
    }
%>

<!DOCTYPE html>
<html>
<head></head>
<body>
	<%=sql%>
</body>