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
	String user_name = request.getParameter("userId");			//用户名
	String article_id="";
	//String article_id = request.getParameter("articleId");		//文章ID
	String mode = request.getParameter("mode");					//修改还是新增
	/***************默认为这个，当作测试*********/
	if(user_name==null){
		user_name = "15352013";
	}
	if(article_id==null){
		article_id = "17";
	}
	if(mode==null){
		mode = "1";
	}

	String belong="";											//文章类别
	String name = "";											//博客名
	String picture = "";										//头像url
	String title="";											//文章标题
	String content="";											//文章内容
	String msg ="";												//异常信息
    String sql = "";											//数据库查询语句
	

		String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
                            + "?autoReconnect=true&useUnicode=true"
                            + "&characterEncoding=UTF-8&&useSSL=false";
	    Class.forName("com.mysql.jdbc.Driver");
	    Connection con=DriverManager.getConnection(connectString, "user", "123");
	    Statement stmt=con.createStatement();

    /****************获取用户信息********************/
    sql="select * from user where userId='"+user_name+"'";
    ResultSet rs=stmt.executeQuery(sql);
    while(rs.next()){
        name=rs.getString("nickname");							//获取博客名
        picture=rs.getString("picture");						//用于判断是否已经上传过头像
    }
    rs.close();
    if(picture==null){
        picture="images/默认.jpg";
    }else{
        picture="files/"+user_name+".jpg";
    }
    con.close();
    stmt.close();

    /********************获取文章内容*********************/
    /*
    sql = "select * from article where articleId='"+article_id+"'";
    ResultSet rs1=stmt.executeQuery(sql);
    while(rs1.next()){
        title=rs1.getString("title");							//获取标题
        content=rs1.getString("content");						//获取文章内容
        belong=rs1.getString("belong");							//获取文章类别
    }
    rs1.close();
    */
%>

<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="css/Edit.css"/>
<style type="text/css">
	<%
		if(mode.equals("1")){
			out.print("#a1{color: white;}#li1{background-color: #7a4f1b;}");
		}else{
			out.print("#a2{color: white;}#li2{background-color: #7a4f1b;}");
		}
	%>
</style>
<head>
	<title>Blog Editor</title>
</head>
<body>
	<div class="top">
		<div class="top_img"></div>
	</div>
	<div class="user_info">
		<img src="<%=picture%>">
		<span><%=name%>的博客</span>
	</div>
	<form class="format" action="Handler1.jsp" method="post" >
		<input type="hidden" name="userId" value="<%=user_name%>">
		<input type="hidden" name="articleId" value="<%=article_id%>">
		<input type="hidden" name="mode" value="<%=mode%>">
		<ul class="tabs">
			<li id="li1"><a  id="a1">发表文章</a></li>
			<li id="li2"><a  id="a2">修改文章</a></li>
			<li style="float:right;"><a href="home.jsp?user_name=<%=user_name%>"><span>返回主页</span></a></li>
			<div style="clear: both;"></div>
		</ul>
		<p>文章分类</p>
		<input type="radio" name="article_type" value="1"  >学习
		<input type="radio" name="article_type" value="2" checked>随笔
		<input type="radio" name="article_type" value="3"  >科普
		<input type="radio" name="article_type" value="4"  >美食
		<p>文章标题</p>
		<div>
			<input id="txtTitle" name="title" maxlength="100" value="<%=title%>">
		</div>
		<p>文章内容</p>
		<div>
			<textarea id="editor" name="content" rows="30" style="width:96.5%;"><%=content%></textarea>
		</div>
		<div class="btn_area">
			<input class="btn" type="submit" name="submit1" value="提交">
			<div class="btn"><a href="home.jsp?user_name=<%=user_name%>" >返回</a></div>
		</div>
	</form>
</body>
</html>