<%@ page language="java" import="java.util.*,java.sql.*" 
		contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!doctype html>
<html lang="zh">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="css/login.css">
	<title>登录界面</title>
</head>
<%
	
	// 设置编码格式
	request.setCharacterEncoding("utf-8");
	// 连接数据库
	String connectString = "jdbc:mysql://172.18.187.234:53306/15352013_21_project"
				+ "?autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&&useSSL=false";
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection(connectString, "user", "123");
	Statement statement = conn.createStatement() ;

	String userId = request.getParameter("userId") ;
	String pass = request.getParameter("pass") ;
	boolean userIdHint = false,passHint=false ;

		
	// 如果是登录
	if ( request.getParameter("login")!=null ) {
		if ( userId.equals("admin") && pass.equals("123") )
			response.sendRedirect("root.jsp"); 
		String sql="SELECT* FROM user WHERE userId=\'"+userId+"\'" ;
		ResultSet rs=statement.executeQuery(sql) ;
		rs.last() ;
		if ( rs.getRow()==0 ){
			userIdHint = true ;
			%>
				<style  type="text/css">
					#userId::-webkit-input-placeholder{color: red;font-weight: 1000;}
					#userId:-moz-placeholder{color: red;font-weight: 1000;}
					#userId::-moz-placeholder{color: red;font-weight: 1000;}
					#userId:-ms-input-placeholder{color: red;font-weight: 1000;}

				</style>
			<%
		}else {
			rs.first() ;
			if ( !pass.equals(rs.getString("password")) ){
				passHint = true;
				%>
					<style  type="text/css">
						#pass::-webkit-input-placeholder{color: red;font-weight: 1000;}
						#pass:-moz-placeholder{color: red;font-weight: 1000;}
						#pass::-moz-placeholder{color: red;font-weight: 1000;}
						#pass:-ms-input-placeholder{color: red;font-weight: 1000;}
					</style>
				<%
			}
			else{
				String name = java.net.URLEncoder.encode(userId,"utf-8") ;
				String url="home.jsp?user_name=" + name ;
				response.sendRedirect(url);
			} 
		}
	}
	// 如果是注册
	if (request.getParameter("register")!=null){
		response.sendRedirect("register.jsp"); 
	}

%>
<body>
	<div class="htmleaf-container">
		<div class="wrapper">
			<div class="container">
				<h1>学习汇</h1>
				
				<form class="form" name="form" action="index.jsp" method="post">
					<input type="text" id="userId" placeholder=
							<%=userIdHint==true?"用户不存在" : "请输入用户名"%> 
							name="userId" onkeyup="value=value.replace(/[^\w\.\/]/ig,'')"
					>
					<input type="password" id="pass" placeholder=
							<%=passHint==true?"密码错误" : "请输入密码"%>
							name="pass"
					>
					<button type="submit" id="login-button" name="login">登录</button>
					<button type="submit" id="register-button" name="register">注册</button>
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