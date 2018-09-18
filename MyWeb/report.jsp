<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*, java.util.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ page import="java.sql.*"%>

<%
   Connection conn =null;

   java.util.Date tt= new java.util.Date();
   SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
   String time = ft.format(tt).toString();
   

   //单纯显示文章的时候要用到的变量
   int articleId=20;
   String articleids=request.getParameter("articleId");
   if(articleids!=null){
   	  articleId = Integer.parseInt(articleids);
   }
   String now_content="";//当前文章内容
   String now_userId=request.getParameter("userId");//当前用户
   if(now_userId==null)now_userId="15352020";
   String mode=request.getParameter("mode");
   String picture="";//头像
   String nickname="";//昵称
   int num_content=0;//已发表文章数

   String content_title="";
   String content_time="";
   String content_userId="";//当前文章作者
   String content_belong="";//文章类别
   int love_count=0;//点赞数
   int count=0;
   
   String is_like=request.getParameter("is_like");
   if(is_like==null)
         is_like="";

   StringBuilder op_img=new StringBuilder("");
   StringBuilder articles_name=new StringBuilder("");
   StringBuilder comment_main=new StringBuilder("");
   //建立连接
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

   //建立连接后执行插入指令。将文章放入article表中
   if(flag_connect){//显示，编辑
   	  Statement stat;
      ResultSet rs=null;
      stat = conn.createStatement();
      Statement stat2=conn.createStatement();
      //根据articleId显示文章
      String fmt2="Select * From article where articleId='%d'";
      String Command2 = String.format(fmt2,articleId);
      //执行指令
      try{
         rs = stat.executeQuery(Command2);
      }catch(Exception e){}
      while(rs.next()){
            content_title=rs.getString("title");
            now_content=rs.getString("content");//文章
            content_userId=rs.getString("userId");//文章作者
            content_time=rs.getString("Time");//发表时间
            content_belong=rs.getString("belong");
            count=rs.getInt("count");
            love_count=rs.getInt("love_count");
      }
      //增加访问次数
   	  if(!now_userId.equals(content_userId)&&mode==null){
   	  	String sql="Update article set count = count + 1 where articleId='"+articleId+"'";
   	    stat.executeUpdate(sql);
   	    count++;
   	  }
      //显示人物信息
      String fmt3="Select * From user where userId='%s'";
      String Command3 = String.format(fmt3,now_userId);
      rs=null;
      try{
         rs = stat.executeQuery(Command3);
      }catch(Exception e){
      }
      while(rs.next()){
            picture = rs.getString("picture");
            if(picture==null){
                 picture="images/默认.jpg";
             }else{
                 picture="files/"+now_userId+".jpg";
             }
            nickname = rs.getString("nickname");
      }

      String fmt3_x = "Select * From article where userId ='%s'";
      String Command3_x =  String.format(fmt3_x,now_userId);
      rs=null;
      try{
         rs = stat.executeQuery(Command3_x);
      }catch(Exception e){}
      while(rs.next()){
            num_content++;
      }

      //点赞表
      String fmt4="Select * From love where articleId='%d' and userId='%s'";
      String Command4 = String.format(fmt4,articleId,now_userId);
      //执行指令
      rs=null;
      try{
         rs = stat.executeQuery(Command4);
      }catch(Exception e){
  
      }
    
      int is_like_count=0;
      while(rs.next()){
        is_like_count=1;
      }
      
      if(is_like_count>0){
        is_like="yes";
      }else{
        is_like="no";
      }

      
      //显示编辑，删除，点赞图标
      if(now_userId.equals(content_userId)){
         op_img.append("#main_left #operation #op_img3{display: normal;}");
      }else op_img.append("#main_left #operation #op_img3{display:none;}");

      if(is_like.equals("yes")){
        op_img.append("#main_left #operation #op_img1{display: none;}");
        op_img.append("#main_left #operation #op_img2{display: normal;}");
      }else{
        op_img.append("#main_left #operation #op_img1{display: normal;}");
        op_img.append("#main_left #operation #op_img2{display: none;}");
      }
      String sql="select * from article where userId='"+now_userId+"'";
      rs=null;
      try{
         rs=stat.executeQuery(sql);
         int cnt=0;
         while(rs.next()){
            if(cnt<10){
               articles_name.append("<li><a href='report.jsp?userId="+rs.getString("userId")+"&articleId="+rs.getInt("articleId")+"'>"+rs.getString("title")+"</a></li>");
            }else if(cnt<11){
               articles_name.append("<li>...</li>");
            }
            cnt++;
         }
      }catch(Exception e){}
      //显示评论
      String sql_fmt="Select * From comment where articleId ='%d'";
      String sql_comment=String.format(sql_fmt,articleId);
      rs=null;
      ResultSet rs2=null;
      try{
         rs=stat.executeQuery(sql_comment);
         while(rs.next()){
            rs2=null;
            String comment_user = rs.getString("userId");
            String comment_text = rs.getString("content");
            String Command5 = String.format(fmt3,comment_user);
            comment_main.append("<div id=\"comment\"><div id=\"comment_img_box\"><img id=\"comment_img\" src=\"");
            rs2=stat2.executeQuery(Command5);
            while(rs2.next()){
               String comment_user_nickname = rs2.getString("nickname");
               String comment_picture = rs2.getString("picture");
               if(comment_picture==null){
                    comment_picture="images/默认.jpg";
                }else{
                    comment_picture="files/"+comment_user+".jpg";
                }
               comment_main.append(comment_picture);
               comment_main.append("\" /> </div><div id=\"comment_user\">");
               comment_main.append(comment_user_nickname);
            }
            comment_main.append(": </div><div id=\"comment_content\">");
            comment_main.append(comment_text);
            comment_main.append("</div> <hr></div>");
         }
      }catch(Exception e){}
   }
   else out.print("连接数据库失败<br>");
%>


<!DOCTYPE  html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="css/report.css"/>
    <style>
       <%out.print(op_img);%>
    </style>
    <script>

    </script>
</head>

<body>
    <div id="main">
        <div id="head">
            <h1><%=content_title%></h1>
            <div id="info1">类别:<%=content_belong%> &nbsp;&nbsp; 浏览次数:<%=count%>&nbsp;&nbsp;点赞数:<%=love_count%></div>
            <div id="info2">发表时间:<%=content_time%></div>
            <div class="clearer"></div>
        </div>
        <hr>
        <div id="main_left">
            <div id="operation">
                <a href="handler-show.jsp?userId=<%=now_userId%>&articleId=<%=articleId%>&is_like=<%=is_like%>&mode=zan"><img  id="op_img1" src="images/zan1.png"/></a>
                <a href="handler-show.jsp?userId=<%=now_userId%>&articleId=<%=articleId%>&is_like=<%=is_like%>&mode=zan"><img  id="op_img2" src="images/zan2.png"/></a>
                <a href="Edit.jsp?userId=<%=now_userId%>&articleId=<%=articleId%>"><img id="op_img3" src="images/write.png"/></a> 
                <a href="handler-show.jsp?userId=<%=now_userId%>&articleId=<%=articleId%>&is_like=<%=is_like%>&mode=delete"><img id="op_img3" src="images/delete.png"/></a>

            </div>
            <div class="clearer"></div>
            <div id="content_box">
                <pre id="content"><%=now_content%></pre>
            </div>
        </div>
        <div id="main_right">
            <div id="picture_box">
                <img src=<%=picture%> />
                <div><a href="home.jsp?user_name=<%=now_userId%>"><%=nickname%></a></div>
                <div id="num_article">已发表文章数：<%=num_content%></div>
            </div>
            <h2>我的文章:</h2>
         <ul>
            <%=articles_name%>
         </ul>
        </div>
        <div class="clearer"></div>
        <div id="comment_box">
            <div id="input_comment">
                <form class="form" action="handler-show.jsp?articleId=<%=articleId%>&userId=<%=now_userId%>&mode=comment" method="post">
                    <textarea id="text" name="text" placeholder="请输入内容"></textarea>
                    <div id="judge_box">
                        <input type="submit" id="judge" name="judge" value="评论">
                    </div>
                </form>
            </div>

            <%=comment_main%>          
        </div>
    </div>

</body>
</html>