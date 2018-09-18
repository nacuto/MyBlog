<%@ page language="java" import="java.util.*,java.sql.*" 
		contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="zh">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="css/register.css">
	<title>注册界面</title>
</head>

<%
	
	// 设置编码格式
	request.setCharacterEncoding("utf-8");
	
	String userId = request.getParameter("userId") ;
	String pass = request.getParameter("pass") ;
	String nickname = request.getParameter("nickname") ;
	boolean userIdHint = false ;
	
	if ( request.getParameter("register")!=null ){
		// 连接数据库
		String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
					+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(connectString, "user", "123");
		Statement statement = conn.createStatement() ;
		String fmt="insert into user(userId,password,nickname) values('%s','%s','%s')" ;
	 	String sql=String.format(fmt,userId,pass,nickname) ;
	 	try{
	 		int cnt = statement.executeUpdate(sql);
	 	}catch(Exception e){
	 		userIdHint = true ;
	 		%>
				<style  type="text/css">
					#userId::-webkit-input-placeholder{color: red;font-weight: 1000;}
					#userId:-moz-placeholder{color: red;font-weight: 1000;}
					#userId::-moz-placeholder{color: red;font-weight: 1000;}
					#userId:-ms-input-placeholder{color: red;font-weight: 1000;}
				</style>
			<%
	 	}
		if( !userIdHint ) {
			String name = java.net.URLEncoder.encode(userId,"utf-8")  ;
			response.sendRedirect("home.jsp?user_name="+name) ;
		}
	}
	else if ( request.getParameter("return")!=null )
		response.sendRedirect("index.jsp") ;
%>

<body>
	<div class="htmleaf-container">
		<div class="wrapper">
			<div class="container">
				<h1>博客注册</h1>
				<form class="form" action="register.jsp" method="post">
					<input type="text" id="userId" placeholder=
							<%=userIdHint==true?"用户名已存在" : "请输入用户名（非中文）"%> 
							name="userId" onkeyup="value=value.replace(/[^\w\.\/]/ig,'')" >
					<input type="password" id="pass" placeholder="请输入密码" name="pass" >
					<input type="text" id="pass" placeholder="请输入博客昵称" name="nickname" >
					<button type="submit" id="return" name="return">返回</button>
					<button type="submit" id="register" name="register">注册</button>
				</form>
			</div>
			<ul class="bg-bubbles">
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
			</ul>
		</div>
	</div>
</body>
</html>