<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%
    request.setCharacterEncoding("utf-8");
    String mode = request.getParameter("mode");
    String is_like = request.getParameter("is_like");
    String articleId_tmp = request.getParameter("articleId");
    int articleId = Integer.parseInt(articleId_tmp); 
    String userId = request.getParameter("userId");
    String comment = request.getParameter("text");
    

    //管理点赞表
    String fmt1="Insert into love(articleId, userId) Values('%d','%s')"  ;
    String Command1 = String.format(fmt1,articleId,userId,articleId);
    String fmt1_x="Update article Set love_count=love_count+1 Where articleId='%d'";
    String Command1_x = String.format(fmt1_x,articleId);

    String fmt2="Delete From love where articleId='%d' and userId='%s'";
    String Command2 = String.format(fmt2,articleId,userId,articleId);
    String fmt2_x="Update article Set love_count=love_count-1 Where articleId='%d'";
    String Command2_x = String.format(fmt2_x,articleId);


    //删除文章
    String fmt3="Delete From love where articleId='%d'";
    String Command3 = String.format(fmt3,articleId,articleId,articleId);
    String fmt3_x="Delete From comment where articleId='%d'";
    String Command3_x = String.format(fmt3_x,articleId);
    String fmt3_y="Delete From article where articleId='%d'";
    String Command3_y = String.format(fmt3_y,articleId);


    String fmt4="Insert into comment(articleId,userId,content) Values('%d','%s','%s')";
    String Command4 = String.format(fmt4,articleId,userId,comment);


    Connection conn =null;
    boolean flag_connect=false;
      String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
            + "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
      try {
         Class.forName("com.mysql.jdbc.Driver");
         conn = DriverManager.getConnection(connectString, "user", "123");
         flag_connect=true;
      } catch (Exception e) {
         System.out.println(e.getMessage());
      }
    
    //执行指令
    if(flag_connect){
        Statement stat;
        stat = conn.createStatement();
        
        if(mode.equals("zan")){
          if(is_like.equals("yes")){
            stat.executeUpdate(Command2);
            stat.executeUpdate(Command2_x);
          }
          else{
            stat.executeUpdate(Command1);
            stat.executeUpdate(Command1_x);
          }
        }
        else if(mode.equals("delete")){
            stat.executeUpdate(Command3);
            stat.executeUpdate(Command3_x);
            stat.executeUpdate(Command3_y);
        }
        else if(mode.equals("comment")){
            stat.executeUpdate(Command4);
        }

        if(mode.equals("delete")){
          response.sendRedirect("home.jsp?user_name="+userId);
        }else response.sendRedirect("report.jsp?articleId="+articleId+"&userId="+userId+"&mode=-1");
    }
    else out.println("没连接上数据库");
    
%>